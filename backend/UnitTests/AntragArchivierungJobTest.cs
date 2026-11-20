using System.Security.Cryptography;
using System.Text.Json;
using API.Features;
using API.Features.Aufbewahrung;
using API.Features.Aufbewahrung.Archive;
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
/// End-to-End-Regressionstest für das Datenverlust-Review-Feedback von Loic Ishimwe (MR 324):
/// <see cref="AntragArchivierungJob"/> entfernt die Ausführung per Cascade-Delete, was ohne den
/// Fix auch den VerlaufsEintrag unwiederbringlich gelöscht hätte. Prüft den echten Job (nicht nur
/// die DTO-Mapping-Funktion) gegen die Test-Datenbank.
/// </summary>
[Collection("Api Tests")]
public class AntragArchivierungJobTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid TestProzessId = new("a2c817e5-0000-4000-8000-000000000001");
    private static readonly Guid TestVersionId = new("a2c817e5-0000-4000-8000-000000000002");
    private static readonly Guid TestEndeSchrittId = new("a2c817e5-0000-4000-8000-000000000003");

    [Fact]
    public async Task Execute_archiviert_Ausfuehrung_mit_VerlaufsEintrag_ohne_Datenverlust() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        await EnsureArchivierungAktiv();

        var buergerId = Guid.NewGuid();
        var ausfuehrungId = Guid.NewGuid();
        var verlaufsEintragId = Guid.NewGuid();
        var now = SystemClock.Instance.GetCurrentInstant();

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

            db.Users.Add(new Buerger { Id = buergerId, PersonalDataKeyEncryptedForBuerger = "foo" });

            var sharedKey = RandomNumberGenerator.GetBytes(32);
            db.Ausfuehrungen.Add(new Ausfuehrung {
                Id = ausfuehrungId,
                ProzessVersionId = versionId,
                UserId = buergerId,
                CreatedAt = now - Duration.FromDays(400),
                Status = AusfuehrungStatus.Abgeschlossen,
                AbgeschlossenAm = now - Duration.FromDays(400),
                SchrittId = schrittId,
                SharedKeyEncryptedForBuerger =
                    Convert.ToBase64String(
                        BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
                SharedKeyEncryptedForKommune =
                    Convert.ToBase64String(
                        KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
                Followers = [],
                Bearbeitungen = [],
            });
            await db.SaveChangesAsync();

            db.VerlaufsEintraege.Add(new VerlaufsEintrag {
                Id = verlaufsEintragId,
                AusfuehrungId = ausfuehrungId,
                CreatedAt = now - Duration.FromDays(400),
                Art = VerlaufsEreignisArt.Eingang,
                BenutzerName = "Regressionstest",
            });
            await db.SaveChangesAsync();
        }

        await using (var jobScope = Factory.Services.CreateAsyncScope()) {
            var job = new AntragArchivierungJob(
                jobScope.ServiceProvider.GetRequiredService<IDbContextFactory<DomainContext>>(),
                jobScope.ServiceProvider.GetRequiredService<IDbContextFactory<ArchiveContext>>(),
                SystemClock.Instance,
                NullLogger<AntragArchivierungJob>.Instance);
            await job.Execute(JobExecutionContextTestHelper.Create(nameof(AntragArchivierungJob)));
        }

        await using (var verifyScope = Factory.Services.CreateAsyncScope()) {
            var db = verifyScope.ServiceProvider.GetRequiredService<DomainContext>();
            Assert.False(await db.Ausfuehrungen.AnyAsync(a => a.Id == ausfuehrungId));
            Assert.False(await db.VerlaufsEintraege.AnyAsync(v => v.Id == verlaufsEintragId));

            var archive = verifyScope.ServiceProvider.GetRequiredService<ArchiveContext>();
            var archiviert = await archive.ArchivierteAntraege.AsNoTracking()
                .FirstOrDefaultAsync(a => a.Id == ausfuehrungId);
            Assert.NotNull(archiviert);

            var dto = archiviert!.Inhalt.RootElement.Deserialize<AntragArchivDto>();
            var verlauf = Assert.Single(dto!.VerlaufsEintraege);
            Assert.Equal(verlaufsEintragId, verlauf.Id);
            Assert.Equal("Regressionstest", verlauf.BenutzerName);
        }
    }

    private async Task EnsureArchivierungAktiv() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var einstellungen = await db.AufbewahrungsEinstellungen.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == AufbewahrungsEinstellungen.SingletonId);
        if (einstellungen is null) {
            db.AufbewahrungsEinstellungen.Add(new AufbewahrungsEinstellungen { ArchivierungAktiv = true });
        } else {
            einstellungen.ArchivierungAktiv = true;
        }
        await db.SaveChangesAsync();
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
            Name = "AntragArchivierungJobTest (minimal)",
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
