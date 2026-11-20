using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Dienstleistungen;
using API.Features.Funktionsberechtigungen;
using API.Features.Kommune;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using Npgsql;

namespace IntegrationTests;

/// <summary>
/// Integration tests for <see cref="AusfuehrungZustaendigkeitService"/> covering
/// department-scoped visibility (Abteilung vs. OE fallback).
/// </summary>
[Collection("Api Tests")]
public class AusfuehrungZustaendigkeitServiceTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid TestProzessId = new("c1c0ffee-0000-4000-8000-000000000001");
    private static readonly Guid TestVersionId = new("c1c0ffee-0000-4000-8000-000000000002");
    private static readonly Guid TestEndeSchrittId = new("c1c0ffee-0000-4000-8000-000000000003");
    private static readonly Guid GruppeAId = new("c1c0ffee-0000-4000-8000-000000000010");
    private static readonly Guid GruppeBId = new("c1c0ffee-0000-4000-8000-000000000011");

    private const string PlainPassword = "123456";

    [Fact]
    public async Task Abteilungsmatch_ist_sichtbar() {
        await PrepareTestData();
        var nutzerId = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);
        var ausfuehrungId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeAId));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nutzer = await LoadBackofficeUser(db, nutzerId);
        var ausfuehrung = await LoadAusfuehrung(db, ausfuehrungId);

        Assert.True(await service.IstZustaendigFuerAusfuehrung(nutzer, ausfuehrung));
    }

    [Fact]
    public async Task Abteilungsmatch_ohne_Funktionsberechtigung_ist_nicht_sichtbar() {
        await PrepareTestData();
        var nutzerId = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);
        var ausfuehrungId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeAId));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nutzer = await LoadBackofficeUser(db, nutzerId);
        nutzer.UntereinheitPermissions.RemoveAll(a => true);
        nutzer.UntereinheitPermissions.Add(new UntereinheitPermissions {
            UntereinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            Funktionsberechtigungen = [
                FunktionsberechtigungInOrganisationseinheit.Backoffice,
            ],
        });
        await db.SaveChangesAsync();
        var ausfuehrung = await LoadAusfuehrung(db, ausfuehrungId);

        Assert.False(await service.IstZustaendigFuerAusfuehrung(nutzer, ausfuehrung));

    }

    [Fact]
    public async Task OE_Match_ohne_Abteilungsmatch_ist_nicht_sichtbar() {
        await PrepareTestData();
        var nutzerId = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);
        var ausfuehrungId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeBId));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nutzer = await LoadBackofficeUser(db, nutzerId);
        var ausfuehrung = await LoadAusfuehrung(db, ausfuehrungId);

        Assert.False(await service.IstZustaendigFuerAusfuehrung(nutzer, ausfuehrung));
    }

    [Fact]
    public async Task OE_Fallback_ohne_Abteilung_am_Antrag_ist_in_Filter_sichtbar() {
        await PrepareTestData();
        var nutzerId = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);
        var ausfuehrungId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: null));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var funktionsberechtigungenService = scope.ServiceProvider.GetRequiredService<FunktionsberechtigungenService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nutzer = await LoadBackofficeUser(db, nutzerId);
        var organisationseinheitenIds = (await funktionsberechtigungenService.GetOrganisationseinheitenForUser(nutzer))
            .Select(o => o.OrganisationseinheitId)
            .ToList();
        var mitarbeiterGruppenIds = nutzer.Gruppen.Select(g => g.Id).ToList();

        var result = service.FilterSichtbareAusfuehrungen(
                db.Ausfuehrungen.Where(a => a.Id == ausfuehrungId),
                nutzer,
                organisationseinheitenIds,
                mitarbeiterGruppenIds)
            .ToList();

        Assert.Single(result);
    }

    [Fact]
    public async Task Persoenliche_Zuweisung_bleibt_sichtbar() {
        await PrepareTestData();
        var nutzerId = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);
        var ausfuehrungId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeBId, zugewiesenePersonId: nutzerId));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nutzer = await LoadBackofficeUser(db, nutzerId);
        var ausfuehrung = await LoadAusfuehrung(db, ausfuehrungId);

        Assert.True(await service.IstZustaendigFuerAusfuehrung(nutzer, ausfuehrung));
    }

    [Fact]
    public async Task Superadmin_sieht_uneingeschraenkt() {
        await PrepareTestData();
        var ausfuehrungId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeBId));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var superadmin = await db.BackofficeUser
            .AsSplitQuery()
            .Include(u => u.Gruppen)
            .FirstAsync(u => u.EMail == SuperAdminEmail);
        var ausfuehrung = await LoadAusfuehrung(db, ausfuehrungId);

        Assert.True(await service.IstZustaendigFuerAusfuehrung(superadmin, ausfuehrung));
    }


    [Fact]
    public async Task Zustaendiger_Dienstleister_bleibt_sichtbar() {
        await PrepareTestData();
        var (dienstleisterId, nutzerId) = await CreateDienstleisterNutzerAsync();
        var ausfuehrungId = await SeedAusfuehrung(MitDienstleisterZustaendigkeit(dienstleisterId));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nutzer = await LoadBackofficeUser(db, nutzerId);
        var ausfuehrung = await LoadAusfuehrung(db, ausfuehrungId);

        Assert.True(await service.IstZustaendigFuerAusfuehrung(nutzer, ausfuehrung));
    }

    [Fact]
    public async Task Nicht_zustaendiger_Dienstleister_bleibt_unsichtbar() {
        await PrepareTestData();
        var zustaendigerDienstleisterId = await SeedDienstleisterAsync();
        var (_, fremderNutzerId) = await CreateDienstleisterNutzerAsync();
        var ausfuehrungId = await SeedAusfuehrung(MitDienstleisterZustaendigkeit(zustaendigerDienstleisterId));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nutzer = await LoadBackofficeUser(db, fremderNutzerId);
        var ausfuehrung = await LoadAusfuehrung(db, ausfuehrungId);

        Assert.False(await service.IstZustaendigFuerAusfuehrung(nutzer, ausfuehrung));
    }

    [Fact]
    public async Task FilterSichtbareAusfuehrungen_OE_ohne_Abteilungsmatch_filtert_raus() {
        await PrepareTestData();
        var nutzerId = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);
        var sichtbarId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeAId));
        var unsichtbarId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeBId));

        await using var scope = Factory.Services.CreateAsyncScope();
        var service = scope.ServiceProvider.GetRequiredService<AusfuehrungZustaendigkeitService>();
        var funktionsberechtigungenService = scope.ServiceProvider.GetRequiredService<FunktionsberechtigungenService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nutzer = await LoadBackofficeUser(db, nutzerId);
        var organisationseinheitenIds = (await funktionsberechtigungenService.GetOrganisationseinheitenForUser(nutzer))
            .Select(o => o.OrganisationseinheitId)
            .ToList();
        var mitarbeiterGruppenIds = nutzer.Gruppen.Select(g => g.Id).ToList();

        var result = service.FilterSichtbareAusfuehrungen(
                db.Ausfuehrungen.Where(a => a.Id == sichtbarId || a.Id == unsichtbarId),
                nutzer,
                organisationseinheitenIds,
                mitarbeiterGruppenIds)
            .ToList();

        Assert.Single(result);
        Assert.Equal(sichtbarId, result[0].Id);
    }

    private async Task PrepareTestData() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await EnsureTestGruppenExist();
        await EnsureTestProzessVersionUndSchritt();
    }

    private static async Task<BackofficeUser> LoadBackofficeUser(DomainContext db, Guid userId) =>
        await db.BackofficeUser
            .AsSplitQuery()
            .AsTracking()
            .Include(u => u.Gruppen)
            .FirstAsync(u => u.Id == userId);

    private static async Task<Ausfuehrung> LoadAusfuehrung(DomainContext db, Guid ausfuehrungId) =>
        await db.Ausfuehrungen.FirstAsync(a => a.Id == ausfuehrungId);

    private async Task<Guid> CreateNutzerMitGruppeUndOeAsync(Guid gruppeId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        var requestedGruppen = await db.MitarbeiterGruppen
            .AsTracking()
            .Where(g => g.Id == gruppeId)
            .ToListAsync();
        Assert.Single(requestedGruppen);
        var email = $"zustaendigkeit-{Guid.NewGuid():N}@test.local";

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = email,
            Vorname = "Zustaendigkeit",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
            Gruppen = requestedGruppen,
            UntereinheitPermissions = [],
        };
        TestUserCrypto.InitializeMitarbeiterCrypto(user, PlainPassword,
            KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);
        user.UntereinheitPermissions.Add(new UntereinheitPermissions {
            UntereinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            Funktionsberechtigungen = [
                FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                FunktionsberechtigungInOrganisationseinheit.Backoffice,
            ],
        });
        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();
        return user.Id;
    }

    private async Task<(Guid DienstleisterId, Guid NutzerId)> CreateDienstleisterNutzerAsync() {
        var dienstleisterId = await SeedDienstleisterAsync();

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        var email = $"zustaendigkeit-dl-{Guid.NewGuid():N}@test.local";

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = email,
            Vorname = "DL",
            Nachname = "ZustaendigkeitTest",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Dienstleister,
            DienstleisterId = dienstleisterId,
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        TestUserCrypto.InitializeMitarbeiterCrypto(user, PlainPassword,
            KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);
        user.UntereinheitPermissions.Add(new UntereinheitPermissions {
            UntereinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            Funktionsberechtigungen = [
                FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                FunktionsberechtigungInOrganisationseinheit.Backoffice,
            ],
        });
        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();
        return (dienstleisterId, user.Id);
    }

    private async Task<Guid> SeedDienstleisterAsync() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var id = Guid.NewGuid();
        db.Dienstleister.Add(new Dienstleister {
            Id = id,
            Name = $"Zustaendigkeit DL {id:N}",
            EMailAdressen = [$"dl-entity-{id:N}@test.local"],
            MandantId = KommuneSeeder.LandkreisHaPy.Id,
        });
        await db.SaveChangesAsync();
        return id;
    }

    private static Zustaendigkeit MitZustaendigkeit(Guid? gruppeId, Guid? zugewiesenePersonId = null) => new() {
        Art = ZustaendigkeitArt.Organisationseinheit,
        OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
        MitarbeiterGruppeId = gruppeId,
        ZugewiesenePersonId = zugewiesenePersonId,
    };

    private static Zustaendigkeit MitDienstleisterZustaendigkeit(Guid dienstleisterId) => new() {
        Art = ZustaendigkeitArt.Dienstleister,
        DienstleisterId = dienstleisterId,
    };

    private async Task<Guid> SeedAusfuehrung(Zustaendigkeit istZustaendigkeit) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var id = Guid.NewGuid();
        var sharedKey = RandomNumberGenerator.GetBytes(32);
        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = id,
            ProzessVersionId = TestVersionId,
            UserId = SystemUser.UserId,
            CreatedAt = SystemClock.Instance.GetCurrentInstant(),
            Status = AusfuehrungStatus.BearbeitungDurchBuerger,
            SchrittId = TestEndeSchrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = istZustaendigkeit,
            Followers = [],
            Bearbeitungen = [],
        });
        await db.SaveChangesAsync();
        return id;
    }

    private async Task EnsureTestGruppenExist() {
        await EnsureGruppeExists(GruppeAId, "Zustaendigkeit Test Gruppe A");
        await EnsureGruppeExists(GruppeBId, "Zustaendigkeit Test Gruppe B");
    }

    private async Task EnsureGruppeExists(Guid gruppeId, string name) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.MitarbeiterGruppen.AnyAsync(g => g.Id == gruppeId)) {
            return;
        }

        var ordinal = await db.MitarbeiterGruppen.CountAsync(g => g.KommuneId == KommuneSeeder.LandkreisHaPy.Id);
        db.MitarbeiterGruppen.Add(new MitarbeiterGruppe {
            Id = gruppeId,
            Name = name,
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Ordinal = ordinal,
        });
        try {
            await db.SaveChangesAsync();
        } catch (DbUpdateException ex) when (ex.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation }) {
            // Parallel test run may have created the group first.
        }
    }

    private async Task EnsureTestProzessVersionUndSchritt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.ProzessVersionen.AnyAsync(pv => pv.Id == TestVersionId)) {
            return;
        }

        var instant = Instant.FromUtc(2020, 1, 1, 0, 0, 0);
        var prozess = new Prozess {
            Id = TestProzessId,
            Name = "AusfuehrungZustaendigkeitServiceTests (minimal)",
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
    }
}
