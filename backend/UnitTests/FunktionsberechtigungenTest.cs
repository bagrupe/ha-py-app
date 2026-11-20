using API.Features.Auth;
using API.Features.Funktionsberechtigungen;

namespace UnitTests;

public class FunktionsBerechtigungenTest {
    [Fact]
    public void AntraegeNotImplicit() {
        var metadata = FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege.GetMetadata();
        Assert.False(metadata.Implizit);
        Assert.Equal(BackofficeNutzerArt.Dienstleister, metadata.NutzerArtMindestens);
    }
}
