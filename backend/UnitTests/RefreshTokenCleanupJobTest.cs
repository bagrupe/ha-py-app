using API.Features;
using API.Features.Auth;
using API.Features.Auth.RefreshTokens;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using NodaTime;
using NodaTime.Testing;

namespace IntegrationTests;

[Collection("Api Tests")]
public class RefreshTokenCleanupJobTest(BackendApiFactory factory) : GraphQLTests(factory) {
    [Fact]
    public async Task Execute_LoeschtNurAbgelaufeneTokens() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = new Buerger { PushNotificationTokens = [], PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        await db.SaveChangesAsync();

        var now = Instant.FromUtc(2026, 11, 10, 12, 0);
        RefreshToken Row(Instant expiresAt, Instant? revokedAt) {
            var (entity, _) = RefreshToken.Create(buerger.Id, "sms", null, now - Duration.FromDays(40), 30);
            return new RefreshToken {
                Id = entity.Id,
                BuergerId = entity.BuergerId,
                TokenHash = entity.TokenHash,
                Provider = entity.Provider,
                CreatedAt = entity.CreatedAt,
                ExpiresAt = expiresAt,
                RevokedAt = revokedAt,
            };
        }

        var expired = Row(now - Duration.FromMinutes(1), null);
        var expiredRevoked = Row(now - Duration.FromDays(2), now - Duration.FromDays(20));
        var revokedButValid = Row(now + Duration.FromDays(3), now - Duration.FromDays(1));
        var live = Row(now + Duration.FromDays(29), null);
        db.RefreshTokens.AddRange(expired, expiredRevoked, revokedButValid, live);
        await db.SaveChangesAsync();

        var job = new RefreshTokenCleanupJob(
            scope.ServiceProvider.GetRequiredService<IDbContextFactory<DomainContext>>(),
            new FakeClock(now),
            NullLogger<RefreshTokenCleanupJob>.Instance);
        await job.Execute(JobExecutionContextTestHelper.Create(nameof(RefreshTokenCleanupJob)));

        var remaining = await db.RefreshTokens.AsNoTracking()
            .Where(t => t.BuergerId == buerger.Id).Select(t => t.Id).ToListAsync();
        Assert.Equal(
            new[] { revokedButValid.Id, live.Id }.Order(),
            remaining.Order());
    }
}
