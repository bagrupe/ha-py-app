using API.Features.Auth.BundId;
using API.Options;

namespace UnitTests;

public class BundIdSubjectHasherTests {
    private static BundIdSubjectHasher CreateHasher(string key = "test-jwt-key") =>
        new(new JWTOptions { Key = key, Issuer = "Kommunal App" });

    [Fact]
    public void ComputeHash_ist_deterministisch() {
        var hasher = CreateHasher();

        var hash1 = hasher.ComputeHash("https://keycloak.example/realms/kommunalapp", "subject-123");
        var hash2 = hasher.ComputeHash("https://keycloak.example/realms/kommunalapp", "subject-123");

        Assert.Equal(hash1, hash2);
    }

    [Fact]
    public void ComputeHash_unterscheidet_verschiedene_Subjects() {
        var hasher = CreateHasher();

        var hash1 = hasher.ComputeHash("https://keycloak.example/realms/kommunalapp", "subject-123");
        var hash2 = hasher.ComputeHash("https://keycloak.example/realms/kommunalapp", "subject-456");

        Assert.NotEqual(hash1, hash2);
    }

    [Fact]
    public void ComputeHash_unterscheidet_verschiedene_Issuer() {
        var hasher = CreateHasher();

        var hash1 = hasher.ComputeHash("https://keycloak.example/realms/kommunalapp", "subject-123");
        var hash2 = hasher.ComputeHash("https://andere-instanz.example/realms/kommunalapp", "subject-123");

        Assert.NotEqual(hash1, hash2);
    }

    [Fact]
    public void ComputeHash_ist_domaengetrennt_von_unterschiedlichen_Schluesseln() {
        var hasher1 = CreateHasher("schluessel-a");
        var hasher2 = CreateHasher("schluessel-b");

        var hash1 = hasher1.ComputeHash("https://keycloak.example/realms/kommunalapp", "subject-123");
        var hash2 = hasher2.ComputeHash("https://keycloak.example/realms/kommunalapp", "subject-123");

        Assert.NotEqual(hash1, hash2);
    }

    [Theory]
    [InlineData("", "subject")]
    [InlineData("issuer", "")]
    public void ComputeHash_wirft_bei_leeren_Werten(string issuer, string subject) {
        var hasher = CreateHasher();

        Assert.Throws<ArgumentException>(() => hasher.ComputeHash(issuer, subject));
    }
}
