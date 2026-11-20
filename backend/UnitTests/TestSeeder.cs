using System.Security.Claims;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Ehrenamtsbank;
using API.Features.Expressions;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Options;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

public class TestSeeder(BackendApiFactory factory) {

    /// <summary>
    /// Ensures the Aerzen Untereinheit exists for the HaPy seed Kommune (same data as other API integration tests).
    /// </summary>
    public async Task EnsureSeedOrganisationseinheitExists() {
        await using var scope = factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var exists = await db.Untereinheit.AnyAsync(u => u.Id == KommuneSeeder.AerzenOrganisationseinheitId);
        if (exists) {
            return;
        }

        db.Untereinheit.Add(new Untereinheit {
            Id = KommuneSeeder.AerzenOrganisationseinheitId,
            Name = "Aerzen (Test)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = true,
            Regionalschluessel = "03252008",
        });
        await db.SaveChangesAsync();
    }

    /// <summary>
    /// Persists a <see cref="Buerger"/> with push token + personal data key and returns a principal for GraphQL as that user.
    /// </summary>
    public async Task<(Buerger Entity, ClaimsPrincipal Principal)> CreateBuergerWithPushPrincipalAsync(
        DomainContext db,
        IServiceProvider services) {
        var buergerEntity = new Buerger {
            PushNotificationTokens = ["bar"],
            PersonalDataKeyEncryptedForBuerger = "foo",
        };

        await db.Users.AddAsync(buergerEntity);
        await db.SaveChangesAsync();

        var jwtOptions = services.GetRequiredService<IOptions<JWTOptions>>().Value;
        var jwtToken = buergerEntity.GetToken(jwtOptions);
        var identity = new ClaimsIdentity(jwtToken.Claims, "jwt");
        var buergerPrincipal = new ClaimsPrincipal(identity);

        return (buergerEntity, buergerPrincipal);
    }

    public async Task<(Guid prozessVersionId, FormularSchritt startSchritt, Verbindung verbindung)> CreateProzess(DomainContext db, string statusAenderung) {
        var prozessVersionId = Guid.NewGuid();
        var prozessId = Guid.NewGuid();

        var prozess = new Prozess {
            Id = prozessId,
            Name = "Push notification test (nicht Mängelmelder)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        var prozessVersion = new ProzessVersion {
            Id = prozessVersionId,
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            Beschreibungstext = (StringExpression)"PushForOtherAntraege",
        };

        var startSchritt = new FormularSchritt {
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    SlotName = "foo",
                    Order = 0
                }
            }
        };

        var endeSchritt = new EndeSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            },
        };

        prozessVersion.Schritte.Add(startSchritt);
        prozessVersion.Schritte.Add(endeSchritt);

        var verbindung = new Verbindung {
            Von = startSchritt,
            Nach = endeSchritt,
            StatusAenderung = statusAenderung,
            StatusAenderungBeschreibung = "Status Änderung Beschreibung"
        };

        startSchritt.Verbindungen.Add(verbindung);
        await db.ProzessVersionen.AddAsync(prozessVersion);
        await db.SaveChangesAsync();

        prozessVersion.Start = startSchritt;
        await db.SaveChangesAsync();
        return (prozessVersionId, startSchritt, verbindung);
    }

    public async Task<(Guid prozessVersionId, FormularSchritt startSchritt, Verbindung verbindung)> CreateMinimalProzess(DomainContext db) {
        var prozessVersionId = Guid.NewGuid();
        var prozessId = Guid.NewGuid();

        var prozess = new Prozess {
            Id = prozessId,
            Name = "Push notification test (nicht Mängelmelder)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        var prozessVersion = new ProzessVersion {
            Id = prozessVersionId,
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            Beschreibungstext = (StringExpression)"PushForOtherAntraege",
        };

        var startSchritt = new FormularSchritt {
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    SlotName = "foo",
                    Order = 0
                }
            }
        };

        var endeSchritt = new EndeSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            },
        };

        prozessVersion.Schritte.Add(startSchritt);
        prozessVersion.Schritte.Add(endeSchritt);

        var verbindung = new Verbindung {
            Von = startSchritt,
            Nach = endeSchritt,
        };

        startSchritt.Verbindungen.Add(verbindung);
        await db.ProzessVersionen.AddAsync(prozessVersion);
        await db.SaveChangesAsync();

        prozessVersion.Start = startSchritt;
        await db.SaveChangesAsync();
        return (prozessVersionId, startSchritt, verbindung);
    }

    public async Task<EhrenamtsbankEintrag> CreateEintrag(
        DomainContext db,
        Guid ownerId, EhrenamtsbankEintragStatus status,
        EhrenamtsbankEintragTyp typ = EhrenamtsbankEintragTyp.Gesuch,
        Guid? kategorieId = null, Guid? untereinheitId = null,
        string title = "Hecken schneiden", string description = "Werkzeug ist vorhanden.",
        bool isDeleted = false, Instant? createdAt = null) {
        kategorieId ??= (await CreateKategorie(db)).Id;
        untereinheitId ??= await EnsureGemeinde();
        var now = SystemClock.Instance.GetCurrentInstant();
        var eintrag = new EhrenamtsbankEintrag {
            Id = Guid.NewGuid(),
            Typ = typ,
            OwnerId = ownerId,
            Title = title,
            Description = description,
            KategorieId = kategorieId.Value,
            UntereinheitId = untereinheitId.Value,
            Status = status,
            Urgency = typ == EhrenamtsbankEintragTyp.Gesuch ? EhrenamtsbankDringlichkeit.Mittel : null,
            EstimatedDurationMinutes = typ == EhrenamtsbankEintragTyp.Gesuch ? 90 : null,
            Availability = typ == EhrenamtsbankEintragTyp.Angebot ? "Wochentags flexibel" : null,
            Tags = ["Werkzeug vorhanden"],
            CreatedAt = createdAt ?? now,
            UpdatedAt = createdAt ?? now,
            IsDeleted = isDeleted,
        };
        db.EhrenamtsbankEintraege.Add(eintrag);
        await db.SaveChangesAsync();
        return eintrag;
    }

    public async Task<EhrenamtsbankKategorie> CreateKategorie(
        DomainContext db,
    bool clearance = false, Guid? parentId = null, bool active = true) {
        var kategorie = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = $"Test {Guid.NewGuid():N}",
            Active = active,
            RequiresClearance = clearance,
            ParentId = parentId,
        };
        db.EhrenamtsbankKategorien.Add(kategorie);
        await db.SaveChangesAsync();
        return kategorie;
    }

    public async Task<Guid> EnsureGemeinde() {
        await EnsureSeedOrganisationseinheitExists();
        return KommuneSeeder.AerzenOrganisationseinheitId;
    }

    public async Task<Buerger> CreateBuerger(
        DomainContext db,
        bool registered, bool clearance = false, string? phone = null, bool? phoneVerified = null) {
        var buerger = new Buerger {
            PersonalDataKeyEncryptedForBuerger = "test",
            IsRegistered = registered,
            RequiresClearanceVerified = clearance,
            Vorname = "Magdalena",
            Nachname = "Schmidt",
            Phone = phone,
            PhoneVerified = phoneVerified ?? phone != null,
        };
        db.Buerger.Add(buerger);
        await db.SaveChangesAsync();
        return buerger;
    }

    public async Task<ClaimsPrincipal> CreateBackofficeUserPrincipal(
        BackofficeNutzerArt art = BackofficeNutzerArt.Nutzer,
        List<GlobaleFunktionsberechtigung>? funktionsberechtigungen = null) {
        await using var scope = factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"backoffice-test-{Guid.NewGuid():N}@test.local",
            Vorname = "Backoffice",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = art,
            Funktionsberechtigungen = funktionsberechtigungen ?? [],
            Gruppen = [],
            UntereinheitPermissions = [],
        };

        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        TestUserCrypto.InitializeMitarbeiterCrypto(
            user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);

        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        return new ClaimsPrincipal(new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt"));
    }
}
