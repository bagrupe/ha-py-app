using System.Collections.Immutable;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess.Queries;
using API.Infrastructure;
using Moq;

namespace UnitTests;

/// <summary>
/// <see cref="AusfuehrungQueries.GetAusfuehrungen"/> delegates the Anträge gate to
/// <see cref="BackofficeUserFunktionsberechtigungenHelpers.InBeliebigerOrganisationseinheit"/> + <see cref="Berechtigungsstatus.Fordern"/>.
/// These tests pin that contract without PostgreSQL or <see cref="WebApplicationFactory{TEntryPoint}"/>.
/// </summary>
public class GetAusfuehrungenBackofficeAntraegeTests {
    [Fact]
    public async Task GetAuftraegeThrowsIfNotAllowed() {
        var user = NeuerBackofficeNutzer();
        var helpers = new BackofficeUserFunktionsberechtigungenHelpers(user, []);
        var accessor = MockAccessor(user, helpers);

        await Assert.ThrowsAsync<NotAllowedException>(() =>
            NeuerQuery().GetAusfuehrungen(null!, accessor.Object, null!, null, null, null, null!, null!));
    }

    [Fact]
    public async Task
        GetAuftraegeThrowsForInhaltspflegeOnly() {
        var user = NeuerBackofficeNutzer();
        var oeNurInhaltspflege = new ResolvedBackofficeUserOrganisationseinheit {
            Zugehoerig = true,
            OrganisationseinheitId = Guid.NewGuid(),
            NutzerspezifischeFunktionsberechtigungen = [
                FunktionsberechtigungInOrganisationseinheit.InhaltspflegeNewsArtikel,
            ],
            GeerbteFunktionsberechtigungen = [],
            AlleFunktionsberechtigungen =
                [FunktionsberechtigungInOrganisationseinheit.InhaltspflegeNewsArtikel],
        };
        var helpers = new BackofficeUserFunktionsberechtigungenHelpers(user, [oeNurInhaltspflege]);
        var accessor = MockAccessor(user, helpers);

        await Assert.ThrowsAsync<NotAllowedException>(() =>
            NeuerQuery().GetAusfuehrungen(null!, accessor.Object, null!, null, null, null, null!, null!));
    }

    [Fact]
    public void SuperAdminIsAllowed() {
        var superadmin = new BackofficeUser {
            Id = Guid.NewGuid(),
            Art = BackofficeNutzerArt.Superadmin,
            KommuneId = Guid.NewGuid(),
            UntereinheitPermissions = [],
        };
        var helpers = new BackofficeUserFunktionsberechtigungenHelpers(superadmin, []);

        var act = () => helpers
            .InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
            .Fordern();

        Assert.Null(Record.Exception(act));
    }

    [Fact]
    public void AllowedIfBackofficeAntraegeIsSet() {
        var user = NeuerBackofficeNutzer();
        var oeMitAntraege = new ResolvedBackofficeUserOrganisationseinheit {
            Zugehoerig = true,
            OrganisationseinheitId = Guid.NewGuid(),
            NutzerspezifischeFunktionsberechtigungen = new HashSet<FunktionsberechtigungInOrganisationseinheit> {
                FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
            },
            GeerbteFunktionsberechtigungen = [],
            AlleFunktionsberechtigungen = [FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege, FunktionsberechtigungInOrganisationseinheit.Backoffice],
        };
        var helpers = new BackofficeUserFunktionsberechtigungenHelpers(user, [oeMitAntraege]);

        var act = () => helpers
            .InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
            .Fordern();

        Assert.Null(Record.Exception(act));
    }

    private static AusfuehrungQueries NeuerQuery() => new();

    private static BackofficeUser NeuerBackofficeNutzer() => new() {
        Id = Guid.NewGuid(),
        Art = BackofficeNutzerArt.Nutzer,
        KommuneId = Guid.NewGuid(),
        UntereinheitPermissions = [],
    };

    private static Mock<ICurrentUserAccessor> MockAccessor(BackofficeUser user,
        BackofficeUserFunktionsberechtigungenHelpers helpers) {
        var accessor = new Mock<ICurrentUserAccessor>();
        accessor.Setup(a => a.EnsureBackofficeUser(It.IsAny<BackofficeNutzerArt>())).ReturnsAsync((user, helpers));
        return accessor;
    }
}
