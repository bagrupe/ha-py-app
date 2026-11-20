using System.ComponentModel.DataAnnotations;
using API.Options;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

public class AuthSessionOptionsTest {
    private static AuthSessionOptions Resolve(Dictionary<string, string?> settings) {
        var configuration = new ConfigurationBuilder().AddInMemoryCollection(settings).Build();
        return new ServiceCollection().AddAuthSessionOptions(configuration).BuildServiceProvider()
            .GetRequiredService<AuthSessionOptions>();
    }

    [Fact]
    public void OhneKonfiguration_GeltenDieStandardwerte() {
        var options = Resolve([]);

        Assert.Equal(15, options.StrongTokenLifetimeMinutes);
        Assert.Equal(30, options.RefreshTokenLifetimeDays);
    }

    [Fact]
    public void AlteSchluesselUnterBundId_GeltenWeiter() {
        var options = Resolve(new() {
            ["BundId:StrongTokenLifetimeMinutes"] = "7",
            ["BundId:RefreshTokenLifetimeDays"] = "3",
        });

        Assert.Equal(7, options.StrongTokenLifetimeMinutes);
        Assert.Equal(3, options.RefreshTokenLifetimeDays);
    }

    [Fact]
    public void NeueSchluesselUnterAuthSession_HabenVorrang() {
        var options = Resolve(new() {
            ["BundId:StrongTokenLifetimeMinutes"] = "7",
            ["AuthSession:StrongTokenLifetimeMinutes"] = "9",
        });

        Assert.Equal(9, options.StrongTokenLifetimeMinutes);
        Assert.Equal(30, options.RefreshTokenLifetimeDays);
    }

    [Theory]
    [InlineData("AuthSession:StrongTokenLifetimeMinutes", "0")]
    [InlineData("AuthSession:RefreshTokenLifetimeDays", "-1")]
    [InlineData("BundId:StrongTokenLifetimeMinutes", "0")]
    public void UngueltigeLaufzeit_WirdAbgelehnt(string key, string value) {
        var options = Resolve(new() { [key] = value });

        Assert.Throws<ValidationException>(options.Validate);
    }
}
