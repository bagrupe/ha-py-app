using API.Features.Auth;
using API.Features.Dienstleistungen;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Infrastructure;
using API.Seeders;
using Moq;
using NodaTime;

namespace UnitTests;

/// <summary>
/// <see cref="AusfuehrungZustaendigkeitService.EnsureZugriffAufAusfuehrung"/> is the shared access gate
/// behind the <c>ausfuehrung</c> query and the <c>bezahlenSchrittUrl</c> mutation. These tests pin it
/// without PostgreSQL.
/// </summary>
public class EnsureZugriffAufAusfuehrungTests {
    private static readonly Guid AntragstellerId = new("b0000000-0000-4000-8000-000000000001");
    private static readonly Guid FremderBuergerId = new("b0000000-0000-4000-8000-000000000002");
    private static readonly Guid DienstleisterId = new("d0000000-0000-4000-8000-000000000001");
    private static readonly Guid FremderDienstleisterId = new("d0000000-0000-4000-8000-000000000002");

    [Fact]
    public async Task Antragsteller_hat_Zugriff() {
        var ausfuehrung = NeueAusfuehrung();
        var accessor = MockBuerger(AntragstellerId);

        await NeuerService().EnsureZugriffAufAusfuehrung(ausfuehrung, accessor.Object);
    }

    [Fact]
    public async Task FremderBuerger_hat_keinen_Zugriff() {
        var ausfuehrung = NeueAusfuehrung();
        var accessor = MockBuerger(FremderBuergerId);

        await Assert.ThrowsAsync<NotAllowedException>(() =>
            NeuerService().EnsureZugriffAufAusfuehrung(ausfuehrung, accessor.Object));
    }

    [Fact]
    public async Task Anonymer_Aufruf_hat_keinen_Zugriff() {
        var ausfuehrung = NeueAusfuehrung();
        var accessor = new Mock<ICurrentUserAccessor>();
        accessor.Setup(a => a.User()).ThrowsAsync(new CurrentUserAccessor.Unauthenticated());

        await Assert.ThrowsAsync<CurrentUserAccessor.Unauthenticated>(() =>
            NeuerService().EnsureZugriffAufAusfuehrung(ausfuehrung, accessor.Object));
    }

    [Fact]
    public async Task Superadmin_hat_Zugriff() {
        var ausfuehrung = NeueAusfuehrung();
        var superadmin = NeuerBackofficeNutzer(BackofficeNutzerArt.Superadmin);
        var accessor = MockBackofficeUser(superadmin, MitAntraegeBerechtigung(superadmin));

        await NeuerService().EnsureZugriffAufAusfuehrung(ausfuehrung, accessor.Object);
    }

    [Fact]
    public async Task BackofficeNutzer_ohne_Funktionsberechtigung_Antraege_hat_keinen_Zugriff() {
        var ausfuehrung = NeueAusfuehrung();
        var nutzer = NeuerBackofficeNutzer(BackofficeNutzerArt.Nutzer);
        var ohneBerechtigung = new BackofficeUserFunktionsberechtigungenHelpers(nutzer, []);
        var accessor = MockBackofficeUser(nutzer, ohneBerechtigung);

        await Assert.ThrowsAsync<NotAllowedException>(() =>
            NeuerService().EnsureZugriffAufAusfuehrung(ausfuehrung, accessor.Object));
    }

    [Fact]
    public async Task Zustaendiger_Dienstleister_hat_Zugriff() {
        var ausfuehrung = NeueAusfuehrung(DienstleisterId);
        var nutzer = NeuerBackofficeNutzer(BackofficeNutzerArt.Dienstleister, DienstleisterId);
        var accessor = MockBackofficeUser(nutzer, MitAntraegeBerechtigung(nutzer));

        await NeuerService().EnsureZugriffAufAusfuehrung(ausfuehrung, accessor.Object);
    }

    [Fact]
    public async Task Nicht_zustaendiger_Dienstleister_hat_keinen_Zugriff() {
        var ausfuehrung = NeueAusfuehrung(DienstleisterId);
        var nutzer = NeuerBackofficeNutzer(BackofficeNutzerArt.Dienstleister, FremderDienstleisterId);
        var accessor = MockBackofficeUser(nutzer, MitAntraegeBerechtigung(nutzer));

        await Assert.ThrowsAsync<NotAllowedException>(() =>
            NeuerService().EnsureZugriffAufAusfuehrung(ausfuehrung, accessor.Object));
    }

    private static AusfuehrungZustaendigkeitService NeuerService() => new(null!, null!);

    private static Ausfuehrung NeueAusfuehrung(Guid? zustaendigerDienstleisterId = null) => new() {
        Id = Guid.NewGuid(),
        UserId = AntragstellerId,
        CreatedAt = Instant.FromUtc(2026, 1, 1, 0, 0),
        Status = AusfuehrungStatus.BearbeitungDurchBuerger,
        SharedKeyEncryptedForBuerger = "foo",
        SharedKeyEncryptedForKommune = "foo",
        IstZustaendigkeit = zustaendigerDienstleisterId is null
            ? new Zustaendigkeit()
            : new Zustaendigkeit {
                Art = ZustaendigkeitArt.Dienstleister,
                DienstleisterId = zustaendigerDienstleisterId,
            },
        ProzessVersion = new ProzessVersion {
            Prozess = new Prozess {
                KommuneId = KommuneSeeder.LandkreisHaPy.Id,
                Name = "foo process"
            },
            Beschreibungstext = "foo"
        }
    };

    private static BackofficeUser NeuerBackofficeNutzer(BackofficeNutzerArt art, Guid? dienstleisterId = null) => new() {
        Id = Guid.NewGuid(),
        Art = art,
        KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        DienstleisterId = dienstleisterId,
        UntereinheitPermissions = [],
    };

    /// <summary>Superadmins bestehen <see cref="Berechtigungsstatus.Fordern"/> ohne zugewiesene Organisationseinheit.</summary>
    private static BackofficeUserFunktionsberechtigungenHelpers MitAntraegeBerechtigung(BackofficeUser user) =>
        user.Art == BackofficeNutzerArt.Superadmin
            ? new BackofficeUserFunktionsberechtigungenHelpers(user, [])
            : new BackofficeUserFunktionsberechtigungenHelpers(user, [
                new ResolvedBackofficeUserOrganisationseinheit {
                    Zugehoerig = true,
                    OrganisationseinheitId = Guid.NewGuid(),
                    NutzerspezifischeFunktionsberechtigungen = [FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege],
                    GeerbteFunktionsberechtigungen = [],
                    AlleFunktionsberechtigungen = [FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege],
                },
            ]);

    private static Mock<ICurrentUserAccessor> MockBuerger(Guid buergerId) {
        var accessor = new Mock<ICurrentUserAccessor>();
        accessor.Setup(a => a.User()).ReturnsAsync(new Buerger {
            Id = buergerId,
            PersonalDataKeyEncryptedForBuerger = "foo",
        });
        return accessor;
    }

    private static Mock<ICurrentUserAccessor> MockBackofficeUser(BackofficeUser user,
        BackofficeUserFunktionsberechtigungenHelpers helpers) {
        var accessor = new Mock<ICurrentUserAccessor>();
        accessor.Setup(a => a.User()).ReturnsAsync(user);
        accessor.Setup(a => a.EnsureBackofficeUser(It.IsAny<BackofficeNutzerArt>())).ReturnsAsync((user, helpers));
        return accessor;
    }
}
