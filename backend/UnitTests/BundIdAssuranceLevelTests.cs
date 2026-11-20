using System.Security.Claims;
using API.Features.Auth.BundId;

namespace UnitTests;

public class BundIdAssuranceLevelTests {
    private static ClaimsPrincipal PrincipalWithClaims(params (string Type, string Value)[] claims) =>
        new(new ClaimsIdentity(claims.Select(c => new Claim(c.Type, c.Value)), "test"));

    [Fact]
    public void Extract_bevorzugt_acr_Claim_wenn_vorhanden() {
        var principal = PrincipalWithClaims(
            ("acr", "1"),
            (BundIdAssuranceLevel.Bpk2VerifiedLevelClaim, "STORK-QAA-Level-4"));

        var result = BundIdAssuranceLevel.Extract(principal);

        Assert.Equal("1", result);
    }

    [Fact]
    public void Extract_faellt_auf_bpk2VerifiedLevel_Claim_zurueck_wenn_acr_fehlt() {
        var principal = PrincipalWithClaims(
            (BundIdAssuranceLevel.Bpk2VerifiedLevelClaim, "STORK-QAA-Level-4"));

        var result = BundIdAssuranceLevel.Extract(principal);

        Assert.Equal("STORK-QAA-Level-4", result);
    }

    [Fact]
    public void Extract_liefert_null_wenn_keine_der_beiden_Claims_vorhanden_ist() {
        var principal = PrincipalWithClaims(("sub", "irgendein-subject"));

        var result = BundIdAssuranceLevel.Extract(principal);

        Assert.Null(result);
    }
}
