using System.Security.Cryptography;
using API.Features;
using API.Features.Aufbewahrung;
using API.Features.Aufbewahrung.Jobs;
using API.Features.Auth;
using API.Features.Prozess;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// Deckt Loics generellen Review-Hinweis ab ("jede neue Query/Mutation sollte mindestens einen
/// Test haben") für <see cref="AntragHardDeleteJob"/>, der zuvor ungetestet war. Verifiziert
/// zugleich den TODO-Kommentar im Job ("Sollten weitere abhängige Datensätze mit restriktivem FK
/// existieren... hier explizit entfernen"): VerlaufsEintrag hängt per Cascade-Delete an der
/// Ausführung, das Entfernen darf also NICHT mit einer FK-Verletzung fehlschlagen.
/// </summary>
[Collection("Api Tests")]
public class AntragHardDeleteJobTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid TestProzessId = new("a2c817e5-4a2d-4000-8000-000000000001");
    private static readonly Guid TestVersionId = new("a2c817e5-4a2d-4000-8000-000000000002");
    private static readonly Guid TestEndeSchrittId = new("a2c817e5-4a2d-4000-8000-000000000003");

    [Fact]
    public async Task Execute_loescht_faelligen_Antrag_endgueltig_inkl_abhaengiger_VerlaufsEintraege() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        await EnsureHardDeleteAktiv();

        var buergerId = Guid.NewGuid();
        var faelligId = Guid.NewGuid();
        var nichtFaelligId = Guid.NewGuid();
        var now = SystemClock.Instance.GetCurrentInstant();

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            db.Users.Add(new Buerger { Id = buergerId, PersonalDataKeyEncryptedForBuerger = "foo" });

            db.Ausfuehrungen.Add(CreateAusfuehrung(faelligId, versionId, buergerId, schrittId,
                geloeschtAm: now - Duration.FromDays(400)));
            // Erst kürzlich soft-gelöscht - Karenzzeit noch nicht abgelaufen, darf nicht angefasst werden.
            db.Ausfuehrungen.Add(CreateAusfuehrung(nichtFaelligId, versionId, buergerId, schrittId,
                geloeschtAm: now));
            await db.SaveChangesAsync();

            db.VerlaufsEintraege.Add(new VerlaufsEintrag {
                Id = Guid.NewGuid(),
                AusfuehrungId = faelligId,
                CreatedAt = now - Duration.FromDays(400),
                Art = VerlaufsEreignisArt.Eingang,
            });
            await db.SaveChangesAsync();
        }

        await using (var jobScope = Factory.Services.CreateAsyncScope()) {
            var job = new AntragHardDeleteJob(
                jobScope.ServiceProvider.GetRequiredService<IDbContextFactory<DomainContext>>(),
                SystemClock.Instance,
                NullLogger<AntragHardDeleteJob>.Instance);
            await job.Execute(JobExecutionContextTestHelper.Create(nameof(AntragHardDeleteJob)));
        }

        await using (var verifyScope = Factory.Services.CreateAsyncScope()) {
            var db = verifyScope.ServiceProvider.GetRequiredService<DomainContext>();
            Assert.False(await db.Ausfuehrungen.AnyAsync(a => a.Id == faelligId));
            Assert.True(await db.Ausfuehrungen.AnyAsync(a => a.Id == nichtFaelligId));
            Assert.True(await db.AntragLoeschProtokolle.AnyAsync(
                p => p.AusfuehrungId == faelligId && p.Ereignis == AntragLoeschEreignis.EndgueltigGeloescht));
        }
    }

    [Fact]
    public async Task Execute_loescht_Antrag_nicht_wenn_zwischen_Auswahl_und_Loeschung_wiederhergestellt() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        await EnsureHardDeleteAktiv();

        var buergerId = Guid.NewGuid();
        var faelligId = Guid.NewGuid();
        var now = SystemClock.Instance.GetCurrentInstant();

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            db.Users.Add(new Buerger { Id = buergerId, PersonalDataKeyEncryptedForBuerger = "foo" });
            db.Ausfuehrungen.Add(CreateAusfuehrung(faelligId, versionId, buergerId, schrittId,
                geloeschtAm: now - Duration.FromDays(400)));
            await db.SaveChangesAsync();
        }

        // Simuliert eine parallele AntragWiederherstellen-Mutation, die zwischen der Batch-Auswahl
        // des Jobs und seiner endgültigen Löschung committet: Zeilen-Lock nehmen (echtes Postgres
        // Row-Locking, kein Sleep/Timing - deterministisch statt flaky), Job parallel starten (er
        // blockiert beim konditionalen Delete auf diesem Lock, da seine Auswahl-Query den Antrag
        // noch als fällig sieht), erst danach wiederherstellen und committen.
        await using var lockScope = Factory.Services.CreateAsyncScope();
        var lockDb = lockScope.ServiceProvider.GetRequiredService<DomainContext>();
        await using var lockTx = await lockDb.Database.BeginTransactionAsync();
        await lockDb.Ausfuehrungen
            .Where(a => a.Id == faelligId)
            .ExecuteUpdateAsync(s => s.SetProperty(a => a.GeloeschtAm, (Instant?)null));

        var jobTask = Task.Run(async () => {
            await using var jobScope = Factory.Services.CreateAsyncScope();
            var job = new AntragHardDeleteJob(
                jobScope.ServiceProvider.GetRequiredService<IDbContextFactory<DomainContext>>(),
                SystemClock.Instance,
                NullLogger<AntragHardDeleteJob>.Instance);
            await job.Execute(JobExecutionContextTestHelper.Create(nameof(AntragHardDeleteJob)));
        });

        await lockTx.CommitAsync();
        await jobTask;

        await using var verifyScope = Factory.Services.CreateAsyncScope();
        var verifyDb = verifyScope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.True(await verifyDb.Ausfuehrungen.AnyAsync(a => a.Id == faelligId));
        Assert.False(await verifyDb.AntragLoeschProtokolle.AnyAsync(
            p => p.AusfuehrungId == faelligId && p.Ereignis == AntragLoeschEreignis.EndgueltigGeloescht));
    }

    private async Task EnsureHardDeleteAktiv() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var einstellungen = await db.AufbewahrungsEinstellungen.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == AufbewahrungsEinstellungen.SingletonId);
        if (einstellungen is null) {
            db.AufbewahrungsEinstellungen.Add(new AufbewahrungsEinstellungen { HardDeleteAktiv = true });
        } else {
            einstellungen.HardDeleteAktiv = true;
        }
        await db.SaveChangesAsync();
    }

    private static Ausfuehrung CreateAusfuehrung(Guid id, Guid prozessVersionId, Guid buergerUserId,
        Guid schrittId, Instant geloeschtAm) {
        var sharedKey = RandomNumberGenerator.GetBytes(32);
        return new Ausfuehrung {
            Id = id,
            ProzessVersionId = prozessVersionId,
            UserId = buergerUserId,
            CreatedAt = geloeschtAm,
            Status = AusfuehrungStatus.BearbeitungDurchBuerger,
            GeloeschtAm = geloeschtAm,
            SchrittId = schrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            Followers = [],
            Bearbeitungen = [],
        };
    }

    /// <summary>
    /// <see cref="Program"/> disables <see cref="API.Seeders.Prozesse.ProzesseSeeder"/> in the Testing
    /// environment, so integration tests that need a <see cref="ProzessVersion"/> must create a minimal one.
    /// </summary>
    private async Task<(Guid prozessId, Guid versionId, Guid schrittId)> EnsureTestProzessVersionUndSchritt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        if (await db.ProzessVersionen.AnyAsync(pv => pv.Id == TestVersionId)) {
            return (TestProzessId, TestVersionId, TestEndeSchrittId);
        }

        var instant = Instant.FromUtc(2020, 1, 1, 0, 0, 0);
        var prozess = new Prozess {
            Id = TestProzessId,
            Name = "AntragHardDeleteJobTest (minimal)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        var ende = new EndeSchritt {
            Id = TestEndeSchrittId,
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var version = new ProzessVersion {
            Id = TestVersionId,
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = "test",
            Schritte = [ende],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();

        version.StartId = TestEndeSchrittId;
        await db.SaveChangesAsync();
        return (TestProzessId, TestVersionId, TestEndeSchrittId);
    }
}
