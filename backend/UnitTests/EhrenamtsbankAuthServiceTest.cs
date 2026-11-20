using API.Features;
using API.Features.Auth;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankAuthServiceTest(BackendApiFactory factory) : GraphQLTests(factory) {

    [Fact]
    public async Task MoveDataToUserSimple() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (prozessVersionId, startSchritt, endeSchritt) = await testSeeder.CreateMinimalProzess(db);
        var (anonymerBuerger, anonymerPrincipal) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);
        anonymerBuerger.PushNotificationTokens = ["anonymous-push-token"];

        var input = new Dictionary<string, object?> {
            ["prozessVersionId"] = prozessVersionId,
            ["sharedKeyEncryptedForBuerger"] = "foo",
            ["sharedKeyEncryptedForKommune"] = "bar",
            ["bearbeitungen"] = new List<Dictionary<string, object?>>(),
        };

        var result = await ExecuteQuery(anonymerPrincipal, AusfuehrungPushNotificationsTest.AusfuehrungErstellenMutation, input);
        Assert.Null(result.Errors);

        var aufuehrungCreateResult = result.Data!["ausfuehrungCreate"] as IReadOnlyDictionary<string, object>;
        var ausfuehrungResult = aufuehrungCreateResult!["ausfuehrungResult"] as IReadOnlyDictionary<string, object>;
        var ausfuehrung = ausfuehrungResult!["ausfuehrung"] as IReadOnlyDictionary<string, object>;
        var ausfuehrungId = Guid.Parse(ausfuehrung!["id"]!.ToString()!);

        var followedAusfuehrung = await db.Ausfuehrungen.AsTracking().SingleAsync(a => a.Id == ausfuehrungId);
        anonymerBuerger.GefolgteAusfuehrungen.Add(followedAusfuehrung);
        await db.SaveChangesAsync();

        Assert.Equal(anonymerBuerger.Id, await db.Ausfuehrungen.Where(a => a.Id == ausfuehrungId).Select(a => a.UserId).SingleAsync());

        var (verifiedBuerger, verifiedPrincipal) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);
        verifiedBuerger.Phone = "123";
        verifiedBuerger.IsRegistered = true;
        verifiedBuerger.PushNotificationTokens = ["registered-push-token"];
        await db.SaveChangesAsync();

        var ehrenamtsbankAuthService = Factory.Services.GetRequiredService<EhrenamtsbankAuthService>();
        await ehrenamtsbankAuthService.MoveDataToUser(db, anonymerBuerger, verifiedBuerger);
        await db.SaveChangesAsync();

        var transferredAusfuehrung = await db.Ausfuehrungen.SingleAsync(a => a.Id == ausfuehrungId);
        Assert.Equal(verifiedBuerger.Id, transferredAusfuehrung.UserId);
        Assert.False(await db.Ausfuehrungen.AnyAsync(a => a.UserId == anonymerBuerger.Id));

        await db.Entry(anonymerBuerger).ReloadAsync();
        Assert.True(anonymerBuerger.IsDeleted);
        Assert.Empty(anonymerBuerger.GefolgteAusfuehrungen);

        var reloadedVerifiedBuerger = await db.Buerger.AsNoTracking()
            .Include(b => b.GefolgteAusfuehrungen)
            .SingleAsync(b => b.Id == verifiedBuerger.Id);
        Assert.Contains("anonymous-push-token", reloadedVerifiedBuerger.PushNotificationTokens);
        Assert.Contains("registered-push-token", reloadedVerifiedBuerger.PushNotificationTokens);
        Assert.Contains(reloadedVerifiedBuerger.GefolgteAusfuehrungen, a => a.Id == ausfuehrungId);
    }

    [Fact]
    public async Task MoveDataToUser_EntferntDieHinterlegungDesStillgelegtenKontos() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (quelle, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);
        var (ziel, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);
        var jetzt = NodaTime.SystemClock.Instance.GetCurrentInstant();
        foreach (var buerger in new[] { quelle, ziel }) {
            db.BuergerKeyEscrows.Add(new API.Features.Auth.KeyEscrow.BuergerKeyEscrow {
                BuergerId = buerger.Id,
                EncryptedPrivateKey = [1],
                KeyVersion = 1,
                CreatedAt = jetzt,
                UpdatedAt = jetzt
            });
        }
        await db.SaveChangesAsync();

        var service = Factory.Services.GetRequiredService<EhrenamtsbankAuthService>();
        await service.MoveDataToUser(db, quelle, ziel);
        await db.SaveChangesAsync();

        Assert.False(await db.BuergerKeyEscrows.AnyAsync(e => e.BuergerId == quelle.Id));
        Assert.True(await db.BuergerKeyEscrows.AnyAsync(e => e.BuergerId == ziel.Id));
    }

    [Fact]
    public async Task MoveDataToUser_RollsBackAllChangesWhenSaveFails() {
        Guid sourceId;
        Guid targetId;
        Guid ausfuehrungId;

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            await testSeeder.EnsureSeedOrganisationseinheitExists();
            var (prozessVersionId, _, _) = await testSeeder.CreateMinimalProzess(db);
            var (source, sourcePrincipal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);
            var (target, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);
            sourceId = source.Id;
            targetId = target.Id;

            var createResult = await ExecuteQuery(sourcePrincipal,
                AusfuehrungPushNotificationsTest.AusfuehrungErstellenMutation,
                new Dictionary<string, object?> {
                    ["prozessVersionId"] = prozessVersionId,
                    ["sharedKeyEncryptedForBuerger"] = "foo",
                    ["sharedKeyEncryptedForKommune"] = "bar",
                    ["bearbeitungen"] = new List<Dictionary<string, object?>>(),
                });
            Assert.Null(createResult.Errors);
            var createPayload = createResult.Data!["ausfuehrungCreate"] as IReadOnlyDictionary<string, object>;
            var resultPayload = createPayload!["ausfuehrungResult"] as IReadOnlyDictionary<string, object>;
            var ausfuehrung = resultPayload!["ausfuehrung"] as IReadOnlyDictionary<string, object>;
            ausfuehrungId = Guid.Parse(ausfuehrung!["id"]!.ToString()!);

            await db.Database.ExecuteSqlRawAsync(
                """
                CREATE FUNCTION fail_sms_merge_user_update() RETURNS trigger
                LANGUAGE plpgsql AS $$
                BEGIN
                    RAISE EXCEPTION 'forced merge failure';
                END;
                $$;
                CREATE TRIGGER fail_sms_merge_user_update_trigger
                BEFORE UPDATE ON "Users"
                FOR EACH ROW EXECUTE FUNCTION fail_sms_merge_user_update();
                """);

            try {
                var service = Factory.Services.GetRequiredService<EhrenamtsbankAuthService>();
                await Assert.ThrowsAsync<DbUpdateException>(() =>
                    service.MoveDataToUser(db, source, target));
            } finally {
                await using var cleanupScope = Factory.Services.CreateAsyncScope();
                var cleanupDb = cleanupScope.ServiceProvider.GetRequiredService<DomainContext>();
                await cleanupDb.Database.ExecuteSqlRawAsync(
                    """
                    DROP TRIGGER IF EXISTS fail_sms_merge_user_update_trigger ON "Users";
                    DROP FUNCTION IF EXISTS fail_sms_merge_user_update();
                    """);
            }
        }

        await using var assertScope = Factory.Services.CreateAsyncScope();
        var assertDb = assertScope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.Equal(sourceId, await assertDb.Ausfuehrungen
            .Where(a => a.Id == ausfuehrungId)
            .Select(a => a.UserId)
            .SingleAsync());
        Assert.False(await assertDb.Buerger
            .Where(b => b.Id == sourceId)
            .Select(b => b.IsDeleted)
            .SingleAsync());
        Assert.True(await assertDb.Buerger.AnyAsync(b => b.Id == targetId));
    }

}
