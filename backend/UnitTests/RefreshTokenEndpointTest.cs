using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.RefreshTokens;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class RefreshTokenEndpointTest(BackendApiFactory factory) : GraphQLTests(factory) {
    [Theory]
    [InlineData("/api/auth/session/refresh", HttpStatusCode.Unauthorized)]
    [InlineData("/api/auth/session/revoke", HttpStatusCode.BadRequest)]
    [InlineData("/api/auth/bundid/refresh", HttpStatusCode.Unauthorized)]
    [InlineData("/api/auth/bundid/revoke", HttpStatusCode.BadRequest)]
    public async Task ZuLangesToken_WirdAbgelehnt(string path, HttpStatusCode expected) {
        var response = await Factory.CreateClient()
            .PostAsJsonAsync(path, new { refreshToken = new string('a', 65) });

        Assert.Equal(expected, response.StatusCode);
    }

    [Theory]
    [InlineData("/api/auth/session")]
    [InlineData("/api/auth/bundid")]
    public async Task ErneuernUndAbmelden_GehenUeberNeuenUndAltenPfad(string basePath) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = new Buerger { PushNotificationTokens = [], PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        var now = scope.ServiceProvider.GetRequiredService<IClock>().GetCurrentInstant();
        var (entity, raw) = RefreshToken.Create(buerger.Id, RefreshTokenProvider.BundId, null, now, 30);
        db.RefreshTokens.Add(entity);
        await db.SaveChangesAsync();
        var client = Factory.CreateClient();

        var refreshed = await client.PostAsJsonAsync($"{basePath}/refresh", new { refreshToken = raw });
        Assert.Equal(HttpStatusCode.OK, refreshed.StatusCode);
        var successor = (await refreshed.Content.ReadFromJsonAsync<JsonElement>())
            .GetProperty("refreshToken").GetString();

        var revoked = await client.PostAsJsonAsync($"{basePath}/revoke", new { refreshToken = successor });
        Assert.Equal(HttpStatusCode.NoContent, revoked.StatusCode);
        var afterRevoke = await client.PostAsJsonAsync($"{basePath}/refresh", new { refreshToken = successor });
        Assert.Equal(HttpStatusCode.Unauthorized, afterRevoke.StatusCode);
    }
}

[Collection("Api Tests")]
public class RefreshTokenRateLimitTest(RateLimitedApiFactory factory)
    : GraphQLTests(factory), IClassFixture<RateLimitedApiFactory> {
    [Fact]
    public async Task VieleRefreshesEinesKontos_WerdenGebremst() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = new Buerger { PushNotificationTokens = [], PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        var now = scope.ServiceProvider.GetRequiredService<IClock>().GetCurrentInstant();
        var (entity, raw) = RefreshToken.Create(buerger.Id, RefreshTokenProvider.BundId, null, now, 30);
        db.RefreshTokens.Add(entity);
        await db.SaveChangesAsync();
        var client = Factory.CreateClient();

        var statuses = new List<HttpStatusCode>();
        for (var i = 0; i < 25; i++) {
            var response = await client.PostAsJsonAsync("/api/auth/session/refresh", new { refreshToken = raw });
            statuses.Add(response.StatusCode);
            if (response.StatusCode != HttpStatusCode.OK) break;
            raw = (await response.Content.ReadFromJsonAsync<JsonElement>()).GetProperty("refreshToken").GetString()!;
        }

        Assert.Equal(Enumerable.Repeat(HttpStatusCode.OK, 20).Append(HttpStatusCode.TooManyRequests), statuses);
    }

    [Fact]
    public async Task TotesToken_VerbrauchtDasLimitDesKontosNicht() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = new Buerger { PushNotificationTokens = [], PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        var now = scope.ServiceProvider.GetRequiredService<IClock>().GetCurrentInstant();
        var (live, liveRaw) = RefreshToken.Create(buerger.Id, RefreshTokenProvider.BundId, null, now, 30);
        var (dead, deadRaw) = RefreshToken.Create(buerger.Id, RefreshTokenProvider.BundId, null, now, 30);
        db.RefreshTokens.AddRange(live, dead);
        await db.SaveChangesAsync();
        await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RevokeAsync(deadRaw);
        var client = Factory.CreateClient();

        for (var i = 0; i < 25; i++) {
            var rejected = await client.PostAsJsonAsync("/api/auth/session/refresh", new { refreshToken = deadRaw });
            Assert.Equal(HttpStatusCode.Unauthorized, rejected.StatusCode);
        }

        var response = await client.PostAsJsonAsync("/api/auth/session/refresh", new { refreshToken = liveRaw });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task RotiertesSmsTokenEinesBundIdKontos_VerbrauchtDasLimitNichtDauerhaft() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = new Buerger {
            PushNotificationTokens = [],
            PersonalDataKeyEncryptedForBuerger = "foo",
            Phone = "+4915114" + Random.Shared.Next(100000, 999999),
            PhoneVerified = true
        };
        db.Users.Add(buerger);
        var now = scope.ServiceProvider.GetRequiredService<IClock>().GetCurrentInstant();
        var (sms, smsRaw) = RefreshToken.Create(buerger.Id, RefreshTokenProvider.Sms, null, now, 30);
        var (bundId, bundIdRaw) = RefreshToken.Create(buerger.Id, RefreshTokenProvider.BundId, null, now, 30);
        db.RefreshTokens.AddRange(sms, bundId);
        await db.SaveChangesAsync();
        var client = Factory.CreateClient();
        var rotated = await client.PostAsJsonAsync("/api/auth/session/refresh", new { refreshToken = smsRaw });
        Assert.Equal(HttpStatusCode.OK, rotated.StatusCode);
        db.ExternalIdentities.Add(new API.Features.Auth.BundId.ExternalIdentity {
            Id = Guid.NewGuid(),
            BuergerId = buerger.Id,
            Provider = "bundid",
            Issuer = "test",
            SubjectHash = Guid.NewGuid().ToString("N"),
            AssuranceLevel = "test",
            LinkedAt = now,
            LastAuthenticatedAt = now
        });
        await db.SaveChangesAsync();

        for (var i = 0; i < 25; i++) {
            var rejected = await client.PostAsJsonAsync("/api/auth/session/refresh", new { refreshToken = smsRaw });
            Assert.Equal(HttpStatusCode.Unauthorized, rejected.StatusCode);
        }

        var response = await client.PostAsJsonAsync("/api/auth/session/refresh", new { refreshToken = bundIdRaw });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }
}
