using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Text.Json;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.BundId;
using API.Features.Auth.KeyEscrow;
using API.Features.Auth.Mutations;
using API.Features.Auth.RefreshTokens;
using API.Options;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using NodaTime.Testing;

namespace IntegrationTests;

[Collection("Api Tests")]
public class SmsSessionRefreshTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string RequestSmsMutation =
        """
        mutation RequestSmsCode($input: RequestSmsCodeInput!) {
            requestSmsCode(input: $input) { requestSmsResult }
        }
        """;

    private const string ValidateSmsMutation =
        """
        mutation ValidateSmsCode($input: ValidateSmsCodeInput!) {
            validateSmsCode(input: $input) { result token refreshToken }
        }
        """;

    private static string RandomNumber() => "+4915112" + Random.Shared.Next(100000, 999999);

    private async Task<Buerger> CreateBuergerAsync(DomainContext db, string? verifiedPhone = null) {
        var buerger = new Buerger {
            PushNotificationTokens = ["bar"],
            PersonalDataKeyEncryptedForBuerger = "foo",
        };
        if (verifiedPhone is not null) {
            buerger.Phone = verifiedPhone;
            buerger.PhoneVerified = true;
            buerger.IsRegistered = true;
        }

        await db.Users.AddAsync(buerger);
        await db.SaveChangesAsync();
        return buerger;
    }

    private async Task<Buerger> WithChallengeAsync(DomainContext db, Guid buergerId, string number) {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var tracked = await db.Buerger.AsTracking().SingleAsync(b => b.Id == buergerId);
        tracked.VerificationCode = "654321";
        tracked.VerificationCodeValidUntil = clock.GetCurrentInstant().Plus(Duration.FromMinutes(5));
        tracked.VerificationPhoneHash = PhoneHashingService.ComputeHash(number);
        await db.SaveChangesAsync();
        return tracked;
    }

    private ClaimsPrincipal Principal(Buerger buerger, bool strong) {
        var options = Factory.Services.GetRequiredService<JWTOptions>();
        var claims = buerger.GetToken(options).Claims
            .Concat(strong ? [new Claim(StrongSessionClaims.AuthProvider, "sms")] : Array.Empty<Claim>());
        return new ClaimsPrincipal(new ClaimsIdentity(claims, "jwt"));
    }

    private static async Task LinkBundIdAsync(DomainContext db, Guid buergerId) {
        db.ExternalIdentities.Add(new ExternalIdentity {
            Id = Guid.NewGuid(),
            BuergerId = buergerId,
            Provider = "bundid",
            Issuer = "test",
            SubjectHash = Guid.NewGuid().ToString("N"),
            AssuranceLevel = "test",
            LinkedAt = Instant.FromUtc(2026, 11, 9, 12, 0),
            LastAuthenticatedAt = Instant.FromUtc(2026, 11, 9, 12, 0)
        });
        await db.SaveChangesAsync();
    }

    private async Task<IReadOnlyDictionary<string, object?>> ValidateViaGraphQlAsync(
        ClaimsPrincipal principal, string number) {
        var result = await ExecuteQuery(principal, ValidateSmsMutation, new Dictionary<string, object?> {
            ["telephoneNumber"] = number,
            ["validationCode"] = "654321"
        });
        Assert.Null(result.Errors);
        return (IReadOnlyDictionary<string, object?>)result.Data!["validateSmsCode"]!;
    }

    private static JwtSecurityToken Read(string token) => new JwtSecurityTokenHandler().ReadJwtToken(token);

    private static ClaimsPrincipal PrincipalOf(string token) => new(new ClaimsIdentity(Read(token).Claims, "jwt"));

    private async Task<(ClaimsPrincipal Principal, string RefreshToken)> LiveSessionAsync(
        DomainContext db, Buerger buerger, string provider, string? level = null) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var now = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();
        var (token, refreshToken) = scope.ServiceProvider.GetRequiredService<RefreshTokenService>()
            .Issue(db, buerger, provider, level, now);
        await db.SaveChangesAsync();
        return (PrincipalOf(token), refreshToken);
    }

    private async Task LogoutEverywhereAsync(ClaimsPrincipal session) {
        var result = await ExecuteQuery(session, LogoutAllDevicesMutation, new Dictionary<string, object?>());
        Assert.Null(result.Errors);
    }

    private static string? Claim(JwtSecurityToken token, string type) =>
        token.Claims.FirstOrDefault(c => c.Type == type)?.Value;

    [Fact]
    public async Task SmsCodePruefung_LiefertRefreshToken_DasEinenSmsTokenAusstellt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, number);

        var validated = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, buerger, number, "654321");

        Assert.Equal(ValidateCodeResult.Success, validated.Result);
        Assert.NotNull(validated.RefreshToken);

        var refreshed = await scope.ServiceProvider.GetRequiredService<RefreshTokenService>()
            .RefreshAsync(validated.RefreshToken!);

        Assert.Equal(RefreshTokenResult.Success, refreshed.Result);
        Assert.NotEqual(validated.RefreshToken, refreshed.RefreshToken);
        var original = Read(validated.Token!);
        var token = Read(refreshed.Token!);
        Assert.Equal(buerger.Id.ToString(), Claim(token, ClaimTypes.NameIdentifier));
        Assert.Equal("sms", Claim(token, StrongSessionClaims.AuthProvider));
        Assert.Null(Claim(token, "auth_level"));
        Assert.InRange(token.ValidTo - original.ValidTo, TimeSpan.FromMinutes(-1), TimeSpan.FromMinutes(1));
    }

    [Fact]
    public async Task SmsCodePruefung_TokenLebtSoKurzWieEinBundIdToken() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, number);

        var validated = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, buerger, number, "654321");

        var token = Read(validated.Token!);
        Assert.Equal("sms", Claim(token, StrongSessionClaims.AuthProvider));
        var lifetime = scope.ServiceProvider.GetRequiredService<AuthSessionOptions>().StrongTokenLifetimeMinutes;
        Assert.InRange(token.ValidTo - DateTime.UtcNow, TimeSpan.Zero, TimeSpan.FromMinutes(lifetime + 1));
    }

    [Fact]
    public async Task SmsCodePruefung_VorhandenesKonto_RefreshTokenGehoertZumUebernommenenKonto() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var existing = await CreateBuergerAsync(db, number);
        var device = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, number);

        var validated = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, device, number, "654321");

        Assert.Equal(ValidateCodeResult.Success, validated.Result);
        var refreshed = await scope.ServiceProvider.GetRequiredService<RefreshTokenService>()
            .RefreshAsync(validated.RefreshToken!);
        Assert.Equal(RefreshTokenResult.Success, refreshed.Result);
        Assert.Equal(existing.Id.ToString(), Claim(Read(refreshed.Token!), ClaimTypes.NameIdentifier));
    }

    [Theory]
    [InlineData(true, false)]
    [InlineData(false, true)]
    public async Task Refresh_GeloeschtesOderNichtMehrBestaetigtesKonto_WirdAbgelehnt(bool deleted, bool unverified) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, number);
        var validated = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, buerger, number, "654321");

        buerger.IsDeleted = deleted;
        buerger.PhoneVerified = !unverified;
        await db.SaveChangesAsync();

        var refreshed = await scope.ServiceProvider.GetRequiredService<RefreshTokenService>()
            .RefreshAsync(validated.RefreshToken!);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, refreshed.Result);
        Assert.Null(refreshed.Token);
    }

    private async Task<string> InsertBundIdRowAsync(DomainContext db, Guid buergerId) {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var raw = RefreshToken.GenerateRawToken();
        await db.Database.ExecuteSqlInterpolatedAsync($"""
            INSERT INTO "RefreshTokens" ("Id", "BuergerId", "TokenHash", "AssuranceLevel", "Provider", "CreatedAt", "ExpiresAt")
            VALUES ({Guid.NewGuid()}, {buergerId}, {RefreshToken.HashRawToken(raw)}, {"STORK-QAA-Level-3"}, {"bundid"},
                    {clock.GetCurrentInstant()}, {clock.GetCurrentInstant().Plus(Duration.FromDays(1))})
            """);
        return raw;
    }

    [Fact]
    public async Task Refresh_VorhandeneBundIdZeile_StelltWeiterEinBundIdTokenAus() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db);
        var raw = await InsertBundIdRowAsync(db, buerger.Id);

        var refreshed = await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RefreshAsync(raw);

        Assert.Equal(RefreshTokenResult.Success, refreshed.Result);
        var token = Read(refreshed.Token!);
        Assert.Equal("bundid", Claim(token, StrongSessionClaims.AuthProvider));
        Assert.Equal("STORK-QAA-Level-3", Claim(token, "auth_level"));
        Assert.True(token.ValidTo - DateTime.UtcNow <= TimeSpan.FromMinutes(16));
    }

    [Fact]
    public async Task Refresh_GeloeschtesBundIdKonto_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db);
        var raw = await InsertBundIdRowAsync(db, buerger.Id);
        buerger.IsDeleted = true;
        await db.SaveChangesAsync();

        var refreshed = await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RefreshAsync(raw);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, refreshed.Result);
        Assert.Null(refreshed.Token);
    }

    [Fact]
    public async Task Refresh_GleichzeitigMitDemselbenToken_HinterlaesstHoechstensEineGueltigeSitzung() {
        for (var round = 0; round < 5; round++) {
            string raw;
            Guid buergerId;
            await using (var setup = Factory.Services.CreateAsyncScope()) {
                var db = setup.ServiceProvider.GetRequiredService<DomainContext>();
                buergerId = (await CreateBuergerAsync(db)).Id;
                raw = await InsertBundIdRowAsync(db, buergerId);
            }

            async Task<RefreshTokenPayload> RefreshInOwnScope() {
                await using var scope = Factory.Services.CreateAsyncScope();
                return await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RefreshAsync(raw);
            }

            await Task.WhenAll(RefreshInOwnScope(), RefreshInOwnScope(), RefreshInOwnScope());

            await using var check = Factory.Services.CreateAsyncScope();
            var live = await check.ServiceProvider.GetRequiredService<DomainContext>().RefreshTokens
                .CountAsync(t => t.BuergerId == buergerId && t.RevokedAt == null);
            Assert.True(live <= 1, $"{live} live refresh tokens after parallel refreshes");
        }
    }

    private async Task<T> AtFixedTimeAsync<T>(Func<FakeClock, Task<T>> body) {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;
        clock.AutoAdvance = Duration.Zero;
        try {
            return await body(clock);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    private async Task<RefreshTokenPayload> RefreshAsync(string raw) {
        await using var scope = Factory.Services.CreateAsyncScope();
        return await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RefreshAsync(raw);
    }

    [Fact]
    public async Task Refresh_VerloreneAntwort_KurzDanachErneutEinloesbar() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var first = await InsertBundIdRowAsync(db, (await CreateBuergerAsync(db)).Id);

        var retried = await AtFixedTimeAsync(async clock => {
            await RefreshAsync(first);
            clock.Advance(Duration.FromSeconds(90));
            return await RefreshAsync(first);
        });

        Assert.Equal(RefreshTokenResult.Success, retried.Result);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(retried.RefreshToken!)).Result);
    }

    [Fact]
    public async Task Refresh_AlterTokenNachAblaufDerKulanz_SperrtDieKette() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var first = await InsertBundIdRowAsync(db, (await CreateBuergerAsync(db)).Id);

        var (current, reused) = await AtFixedTimeAsync(async clock => {
            var current = await RefreshAsync(first);
            clock.Advance(Duration.FromMinutes(20));
            return (current, await RefreshAsync(first));
        });

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, reused.Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(current.RefreshToken!)).Result);
    }

    [Fact]
    public async Task Refresh_AlterTokenNachWeiterBenutzterKette_SperrtDieKette() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var first = await InsertBundIdRowAsync(db, (await CreateBuergerAsync(db)).Id);

        var second = await RefreshAsync(first);
        var third = await RefreshAsync(second.RefreshToken!);
        var reused = await RefreshAsync(first);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, reused.Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(third.RefreshToken!)).Result);
    }

    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public async Task Refresh_GestohlenerTokenInDerKulanz_NaechsterEchterRefreshSperrtAuchDenAngreifer(
        bool attackerRefreshesFirst) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buergerId = (await CreateBuergerAsync(db)).Id;
        var stolen = await InsertBundIdRowAsync(db, buergerId);
        var otherDevice = await InsertBundIdRowAsync(db, buergerId);

        var (app, attacker) = await AtFixedTimeAsync(async clock => {
            var app = await RefreshAsync(stolen);
            clock.Advance(Duration.FromSeconds(30));
            return (app, await RefreshAsync(stolen));
        });
        Assert.Equal(RefreshTokenResult.Success, attacker.Result);
        var attackerToken = attacker.RefreshToken!;
        if (attackerRefreshesFirst) {
            attackerToken = (await RefreshAsync(attackerToken)).RefreshToken!;
        }

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(app.RefreshToken!)).Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(attackerToken)).Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(otherDevice)).Result);
    }

    [Fact]
    public async Task Refresh_AbgefangeneAntwort_SperrtDieKetteWennSieVorgelegtWird() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var first = await InsertBundIdRowAsync(db, (await CreateBuergerAsync(db)).Id);

        var (intercepted, app) = await AtFixedTimeAsync(async clock => {
            var intercepted = await RefreshAsync(first);
            clock.Advance(Duration.FromSeconds(30));
            return (intercepted, await RefreshAsync(first));
        });

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(intercepted.RefreshToken!)).Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(app.RefreshToken!)).Result);
    }

    [Fact]
    public async Task Refresh_GeloeschtesKonto_HinterlaesstKeinenVerweisAufEinenNachfolger() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db);
        var raw = await InsertBundIdRowAsync(db, buerger.Id);
        buerger.IsDeleted = true;
        await db.SaveChangesAsync();

        await RefreshAsync(raw);

        var hash = RefreshToken.HashRawToken(raw);
        var row = await db.RefreshTokens.AsNoTracking().SingleAsync(t => t.TokenHash == hash);
        Assert.NotNull(row.RevokedAt);
        Assert.Equal(RefreshTokenRevokedReason.AccountInvalid, row.RevokedReason);
        Assert.Null(row.ReplacedById);
        Assert.Equal(1, await db.RefreshTokens.CountAsync(t => t.BuergerId == buerger.Id));
    }

    private async Task<RefreshToken> RowAsync(DomainContext db, string raw) {
        var hash = RefreshToken.HashRawToken(raw);
        return await db.RefreshTokens.AsNoTracking().SingleAsync(t => t.TokenHash == hash);
    }

    [Fact]
    public async Task Refresh_HaeltDenGrundJedesWiderrufsFest() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buergerId = (await CreateBuergerAsync(db)).Id;
        var first = await InsertBundIdRowAsync(db, buergerId);
        var loggedOut = await InsertBundIdRowAsync(db, buergerId);

        var (lost, retried) = await AtFixedTimeAsync(async clock => {
            var lost = await RefreshAsync(first);
            clock.Advance(Duration.FromSeconds(30));
            return (lost, await RefreshAsync(first));
        });
        await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RevokeAsync(loggedOut);

        var firstRow = await RowAsync(db, first);
        var lostRow = await RowAsync(db, lost.RefreshToken!);
        var retriedRow = await RowAsync(db, retried.RefreshToken!);
        Assert.Equal(RefreshTokenRevokedReason.Rotated, firstRow.RevokedReason);
        Assert.Equal(retriedRow.Id, firstRow.ReplacedById);
        Assert.Equal(RefreshTokenRevokedReason.SupersededByRetry, lostRow.RevokedReason);
        Assert.Equal(retriedRow.Id, lostRow.ReplacedById);
        Assert.Null(retriedRow.RevokedAt);
        Assert.Equal(RefreshTokenRevokedReason.LoggedOut, (await RowAsync(db, loggedOut)).RevokedReason);

        await RefreshAsync(lost.RefreshToken!);

        Assert.Equal(RefreshTokenRevokedReason.ReuseDetected, (await RowAsync(db, retried.RefreshToken!)).RevokedReason);
        Assert.Equal(RefreshTokenRevokedReason.LoggedOut, (await RowAsync(db, loggedOut)).RevokedReason);
    }

    [Fact]
    public async Task Refresh_AbgemeldetesTokenInnerhalbDerKulanz_BleibtAbgelehntOhneKettensperre() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buergerId = (await CreateBuergerAsync(db)).Id;
        var token = await InsertBundIdRowAsync(db, buergerId);
        var otherDevice = await InsertBundIdRowAsync(db, buergerId);
        await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RevokeAsync(token);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(token)).Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(token)).Result);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(otherDevice)).Result);
    }

    [Fact]
    public async Task Refresh_VerloreneAntwort_NachZehnMinutenNochEinloesbar() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var first = await InsertBundIdRowAsync(db, (await CreateBuergerAsync(db)).Id);

        var retried = await AtFixedTimeAsync(async clock => {
            await RefreshAsync(first);
            clock.Advance(Duration.FromMinutes(10));
            return await RefreshAsync(first);
        });

        Assert.Equal(RefreshTokenResult.Success, retried.Result);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(retried.RefreshToken!)).Result);
    }

    [Fact]
    public async Task Refresh_AlterTokenNachBenutztemNachfolger_BeendetAlleSitzungenDesKontos() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buergerId = (await CreateBuergerAsync(db)).Id;
        var device = await InsertBundIdRowAsync(db, buergerId);
        var otherDevice = await InsertBundIdRowAsync(db, buergerId);
        var current = await RefreshAsync(device);
        var next = await RefreshAsync(current.RefreshToken!);

        var reused = await RefreshAsync(device);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, reused.Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(next.RefreshToken!)).Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(otherDevice)).Result);
    }

    [Fact]
    public async Task Refresh_SpaeteWiederholungMitUnbenutztemNachfolger_MeldetNurDiesesGeraetAb() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buergerId = (await CreateBuergerAsync(db)).Id;
        var device = await InsertBundIdRowAsync(db, buergerId);
        var otherDevice = await InsertBundIdRowAsync(db, buergerId);

        var (lost, late) = await AtFixedTimeAsync(async clock => {
            var lost = await RefreshAsync(device);
            clock.Advance(Duration.FromMinutes(20));
            return (lost, await RefreshAsync(device));
        });

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, late.Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(lost.RefreshToken!)).Result);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(otherDevice)).Result);
    }

    [Fact]
    public async Task Abmelden_MitVerdraengtemToken_BeendetAuchDieSitzungDesDiebs() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var stolen = await InsertBundIdRowAsync(db, (await CreateBuergerAsync(db)).Id);
        var (app, attacker) = await AtFixedTimeAsync(async clock => {
            var app = await RefreshAsync(stolen);
            clock.Advance(Duration.FromSeconds(30));
            return (app, await RefreshAsync(stolen));
        });

        await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RevokeAsync(app.RefreshToken!);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(attacker.RefreshToken!)).Result);
    }

    [Fact]
    public async Task Abmelden_NachVerlorenerAntwort_SperrtDenVerwaistenNachfolger() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var first = await InsertBundIdRowAsync(db, (await CreateBuergerAsync(db)).Id);
        var lost = await RefreshAsync(first);

        await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RevokeAsync(first);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(lost.RefreshToken!)).Result);
    }

    private async Task<T> WithSlowRefreshTokenInsertsAsync<T>(Func<Task<T>> body) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await db.Database.ExecuteSqlRawAsync("""
            CREATE OR REPLACE FUNCTION test_slow_refresh_token_insert() RETURNS trigger AS $$
            BEGIN PERFORM pg_sleep(0.5); RETURN NEW; END $$ LANGUAGE plpgsql;
            CREATE TRIGGER test_slow_refresh_token_insert BEFORE INSERT ON "RefreshTokens"
                FOR EACH ROW EXECUTE FUNCTION test_slow_refresh_token_insert();
            """);
        try {
            return await body();
        } finally {
            await db.Database.ExecuteSqlRawAsync("""
                DROP TRIGGER IF EXISTS test_slow_refresh_token_insert ON "RefreshTokens";
                DROP FUNCTION IF EXISTS test_slow_refresh_token_insert();
                """);
        }
    }

    [Fact]
    public async Task Refresh_GleichzeitigeRotationDesDiebs_EntkommtDerSperreNicht() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buergerId = (await CreateBuergerAsync(db)).Id;
        var stolen = await InsertBundIdRowAsync(db, buergerId);
        var (app, attacker) = await AtFixedTimeAsync(async clock => {
            var app = await RefreshAsync(stolen);
            clock.Advance(Duration.FromSeconds(30));
            return (app, await RefreshAsync(stolen));
        });

        await WithSlowRefreshTokenInsertsAsync(async () => {
            var attackerRotation = RefreshAsync(attacker.RefreshToken!);
            await Task.Delay(200);
            await RefreshAsync(app.RefreshToken!);
            return await attackerRotation;
        });

        Assert.Equal(0, await db.RefreshTokens.CountAsync(t => t.BuergerId == buergerId && t.RevokedAt == null));
    }

    [Fact]
    public async Task Refresh_AbgemeldetesGeraet_BeruehrtAndereGeraeteNicht() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buergerId = (await CreateBuergerAsync(db)).Id;
        var loggedOut = await InsertBundIdRowAsync(db, buergerId);
        var otherDevice = await InsertBundIdRowAsync(db, buergerId);
        await scope.ServiceProvider.GetRequiredService<RefreshTokenService>().RevokeAsync(loggedOut);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(loggedOut)).Result);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(otherDevice)).Result);
    }

    [Fact]
    public async Task SmsCodePruefung_NummerEinesZusammengefuehrtenKontos_LandetNichtImGeloeschtenKonto() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>();
        var ownNumber = RandomNumber();
        var otherNumber = RandomNumber();
        var source = await CreateBuergerAsync(db, ownNumber);
        await CreateBuergerAsync(db, otherNumber);
        await service.ValidateSmsCode(db, await WithChallengeAsync(db, source.Id, otherNumber), otherNumber, "654321");

        var newDevice = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, ownNumber);
        var validated = await service.ValidateSmsCode(db, newDevice, ownNumber, "654321");

        Assert.Equal(ValidateCodeResult.Success, validated.Result);
        Assert.Equal(newDevice.Id.ToString(), Claim(Read(validated.Token!), ClaimTypes.NameIdentifier));
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(validated.RefreshToken!)).Result);
    }

    private async Task<ClaimsPrincipal> SessionPrincipalAsync(DomainContext db, Buerger buerger, string session) {
        switch (session) {
            case "weak":
                return Principal(buerger, strong: false);
            case "sms":
                return (await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms)).Principal;
            case "bundid":
                return (await LiveSessionAsync(db, buerger, RefreshTokenProvider.BundId, "STORK-QAA-Level-3")).Principal;
            default:
                var (ended, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.BundId, "STORK-QAA-Level-3");
                await LogoutEverywhereAsync(ended);
                return ended;
        }
    }

    [Theory]
    [InlineData("weak", false, true, "SUCCESS")]
    [InlineData("sms", false, true, "SAME_AS_CURRENT_PHONE_NUMBER")]
    [InlineData("bundid", true, true, "SAME_AS_CURRENT_PHONE_NUMBER")]
    [InlineData("sms", true, true, "BUND_ID_LOGIN_REQUIRED")]
    [InlineData("weak", true, true, "BUND_ID_LOGIN_REQUIRED")]
    [InlineData("weak", true, false, "BUND_ID_LOGIN_REQUIRED")]
    [InlineData("sms", true, false, "BUND_ID_LOGIN_REQUIRED")]
    [InlineData("bundid", true, false, "SUCCESS")]
    [InlineData("bundid-beendet", true, true, "BUND_ID_LOGIN_REQUIRED")]
    [InlineData("bundid-beendet", true, false, "BUND_ID_LOGIN_REQUIRED")]
    public async Task RequestSmsCode_EigeneBestaetigteNummer(
        string session, bool hasBundId, bool ownNumber, string expected) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var ownedNumber = RandomNumber();
        var number = ownNumber ? ownedNumber : RandomNumber();
        var buerger = await CreateBuergerAsync(db, ownedNumber);
        if (hasBundId) {
            await LinkBundIdAsync(db, buerger.Id);
        }
        var principal = await SessionPrincipalAsync(db, buerger, session);

        var result = await ExecuteQuery(principal, RequestSmsMutation,
            new Dictionary<string, object?> { ["telephoneNumber"] = number });

        Assert.Null(result.Errors);
        var payload = (IReadOnlyDictionary<string, object?>)result.Data!["requestSmsCode"]!;
        Assert.Equal(expected, payload["requestSmsResult"]!.ToString());
        var sms = Factory.Services.GetRequiredService<RecordingSmsService>();
        Assert.Equal(expected == "SUCCESS", sms.SentSms.Any(s => s.telephoneNumber == number));
    }

    [Fact]
    public async Task SmsSchritt_InBundIdSitzung_BleibtBundIdSitzungMitNiveau() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await CreateBuergerAsync(db);
        await LinkBundIdAsync(db, buerger.Id);
        var (session, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.BundId, "STORK-QAA-Level-3");
        await WithChallengeAsync(db, buerger.Id, number);

        var payload = await ValidateViaGraphQlAsync(session, number);

        Assert.Equal("SUCCESS", payload["result"]!.ToString());
        var token = Read(payload["token"]!.ToString()!);
        Assert.Equal("bundid", Claim(token, StrongSessionClaims.AuthProvider));
        Assert.Equal("STORK-QAA-Level-3", Claim(token, "auth_level"));
        var refreshed = await RefreshAsync(payload["refreshToken"]!.ToString()!);
        Assert.Equal(RefreshTokenResult.Success, refreshed.Result);
        Assert.Equal("bundid", Claim(Read(refreshed.Token!), StrongSessionClaims.AuthProvider));
        Assert.Equal("STORK-QAA-Level-3", Claim(Read(refreshed.Token!), "auth_level"));
    }

    [Fact]
    public async Task SmsSchritt_InBundIdSitzungMitZusammenfuehrung_BleibtBundIdSitzungDesZielkontos() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var target = await CreateBuergerAsync(db, number);
        var source = await CreateBuergerAsync(db);
        await LinkBundIdAsync(db, source.Id);
        var (session, _) = await LiveSessionAsync(db, source, RefreshTokenProvider.BundId, "STORK-QAA-Level-3");
        await WithChallengeAsync(db, source.Id, number);

        var payload = await ValidateViaGraphQlAsync(session, number);

        Assert.Equal("SUCCESS", payload["result"]!.ToString());
        var token = Read(payload["token"]!.ToString()!);
        Assert.Equal(target.Id.ToString(), Claim(token, ClaimTypes.NameIdentifier));
        Assert.Equal("bundid", Claim(token, StrongSessionClaims.AuthProvider));
        Assert.Equal("STORK-QAA-Level-3", Claim(token, "auth_level"));
        Assert.True(await db.ExternalIdentities.AnyAsync(e => e.BuergerId == target.Id && e.Provider == "bundid"));
    }

    [Fact]
    public async Task SmsSchritt_InSmsSitzung_BleibtSmsSitzung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await CreateBuergerAsync(db);
        await WithChallengeAsync(db, buerger.Id, number);

        var payload = await ValidateViaGraphQlAsync(Principal(buerger, strong: true), number);

        Assert.Equal("SUCCESS", payload["result"]!.ToString());
        var token = Read(payload["token"]!.ToString()!);
        Assert.Equal("sms", Claim(token, StrongSessionClaims.AuthProvider));
        Assert.Null(Claim(token, "auth_level"));
    }

    [Fact]
    public async Task SmsSchritt_InSmsSitzungEinesBundIdKontos_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await CreateBuergerAsync(db);
        await LinkBundIdAsync(db, buerger.Id);
        await WithChallengeAsync(db, buerger.Id, number);

        var result = await ExecuteQuery(Principal(buerger, strong: true), ValidateSmsMutation,
            new Dictionary<string, object?> { ["telephoneNumber"] = number, ["validationCode"] = "654321" });

        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors!).Code);
    }

    [Fact]
    public async Task Refresh_SmsSitzungEinesInzwischenMitBundIdVerknuepftenKontos_WirdBeendet() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, number);
        var validated = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, buerger, number, "654321");
        await LinkBundIdAsync(db, buerger.Id);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(validated.RefreshToken!)).Result);
        Assert.Equal(RefreshTokenRevokedReason.AccountInvalid, (await RowAsync(db, validated.RefreshToken!)).RevokedReason);
    }

    [Fact]
    public async Task SmsSchritt_InBundIdSitzungMitZusammenfuehrung_BeendetSmsSitzungenDesZielkontos() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var target = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, number);
        var targetSms = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, target, number, "654321");
        var source = await CreateBuergerAsync(db);
        await LinkBundIdAsync(db, source.Id);
        var (session, _) = await LiveSessionAsync(db, source, RefreshTokenProvider.BundId, "STORK-QAA-Level-3");
        await WithChallengeAsync(db, source.Id, number);

        var payload = await ValidateViaGraphQlAsync(session, number);

        Assert.Equal("SUCCESS", payload["result"]!.ToString());
        Assert.NotNull((await RowAsync(db, targetSms.RefreshToken!)).RevokedAt);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(payload["refreshToken"]!.ToString()!)).Result);
    }

    [Fact]
    public async Task Nummernwechsel_BeendetDieUebrigenSitzungenDesKontos() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var oldNumber = RandomNumber();
        var newNumber = RandomNumber();
        var buerger = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, oldNumber);
        var otherDevice = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, buerger, oldNumber, "654321");
        var (thisDevice, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms);
        await WithChallengeAsync(db, buerger.Id, newNumber);

        var payload = await ValidateViaGraphQlAsync(thisDevice, newNumber);

        Assert.Equal("SUCCESS", payload["result"]!.ToString());
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(otherDevice.RefreshToken!)).Result);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(payload["refreshToken"]!.ToString()!)).Result);
    }

    [Fact]
    public async Task Nummernwechsel_BeendetZugangstokensAndererGeraeteSofort() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var oldNumber = RandomNumber();
        var newNumber = RandomNumber();
        var buerger = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, oldNumber);
        var otherDevice = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, buerger, oldNumber, "654321");
        var (thisDevice, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms);
        await WithChallengeAsync(db, buerger.Id, newNumber);
        Assert.True(await IsAcceptedAsync(otherDevice.Token!));

        var payload = await ValidateViaGraphQlAsync(thisDevice, newNumber);

        Assert.False(await IsAcceptedAsync(otherDevice.Token!));
        Assert.True(await IsAcceptedAsync(payload["token"]!.ToString()!));
        Assert.NotNull((await db.Buerger.AsNoTracking().SingleAsync(b => b.Id == buerger.Id)).SessionsEndedAt);
    }

    [Fact]
    public async Task Nummernwechsel_NachGleichzeitigemAbmelden_SperrtAuchDazwischenAusgestellteTokens() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>();
        var oldNumber = RandomNumber();
        var newNumber = RandomNumber();
        var buerger = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, oldNumber);
        await service.ValidateSmsCode(db, buerger, oldNumber, "654321");
        await WithChallengeAsync(db, buerger.Id, newNumber);
        await using var otherScope = Factory.Services.CreateAsyncScope();
        var other = otherScope.ServiceProvider.GetRequiredService<DomainContext>();
        // Ein anderes Gerät meldet überall ab, nachdem dieser Nummernwechsel das Konto schon geladen hat.
        await other.Buerger.Where(b => b.Id == buerger.Id)
            .ExecuteUpdateAsync(s => s.SetProperty(b => b.SessionStamp, b => b.SessionStamp + 1));
        var issuedInBetween = AccessToken(await other.Buerger.AsNoTracking().SingleAsync(b => b.Id == buerger.Id));
        Assert.True(await IsAcceptedAsync(issuedInBetween));

        var validated = await service.ValidateSmsCode(db, buerger, newNumber, "654321");

        Assert.Equal(ValidateCodeResult.Success, validated.Result);
        Assert.False(await IsAcceptedAsync(issuedInBetween));
        Assert.True(await IsAcceptedAsync(validated.Token!));
    }

    [Fact]
    public async Task ErsteNummer_BeendetKeineAnderenSitzungen() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await CreateBuergerAsync(db);
        await LinkBundIdAsync(db, buerger.Id);
        var otherDevice = await InsertBundIdRowAsync(db, buerger.Id);
        var (session, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.BundId, "STORK-QAA-Level-3");
        await WithChallengeAsync(db, buerger.Id, number);

        var payload = await ValidateViaGraphQlAsync(session, number);

        Assert.Equal("SUCCESS", payload["result"]!.ToString());
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(otherDevice)).Result);
        Assert.Null((await db.Buerger.AsNoTracking().SingleAsync(b => b.Id == buerger.Id)).SessionsEndedAt);
    }

    [Fact]
    public async Task Refresh_WiederholteWiederverwendung_BeendetSpaetereAnmeldungenNicht() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buergerId = (await CreateBuergerAsync(db)).Id;
        var device = await InsertBundIdRowAsync(db, buergerId);
        var current = await RefreshAsync(device);
        await RefreshAsync(current.RefreshToken!);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(device)).Result);
        var freshLogin = await InsertBundIdRowAsync(db, buergerId);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(device)).Result);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(freshLogin)).Result);
    }

    private const string LogoutAllDevicesMutation = "mutation { logoutAllDevices { logoutAllDevicesResult } }";

    [Fact]
    public async Task AufAllenGeraetenAbmelden_BeendetAlleSitzungenNurDiesesKontos() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db, RandomNumber());
        var (session, thisDevice) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms);
        var otherDevice = await InsertBundIdRowAsync(db, buerger.Id);
        var otherAccount = await InsertBundIdRowAsync(db, (await CreateBuergerAsync(db)).Id);

        var result = await ExecuteQuery(session, LogoutAllDevicesMutation, new Dictionary<string, object?>());

        Assert.Null(result.Errors);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(thisDevice)).Result);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(otherDevice)).Result);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(otherAccount)).Result);
    }

    [Fact]
    public async Task AufAllenGeraetenAbmelden_OhneStarkeSitzung_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db, RandomNumber());
        var device = await InsertBundIdRowAsync(db, buerger.Id);

        var result = await ExecuteQuery(Principal(buerger, strong: false), LogoutAllDevicesMutation,
            new Dictionary<string, object?>());

        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors!).Code);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(device)).Result);
    }

    [Fact]
    public async Task AbgelaufeneSmsSitzung_ErneuteAnmeldungMitEigenerNummer_BehaeltDasKonto() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var number = RandomNumber();
        var buerger = await CreateBuergerAsync(db, number);
        var registeredAt = Instant.FromUtc(2026, 1, 15, 9, 0);
        buerger.RegisteredAt = registeredAt;
        await db.SaveChangesAsync();
        var weak = Principal(buerger, strong: false);
        var accountsBefore = await db.Buerger.CountAsync(b => b.PhoneHash == buerger.PhoneHash);

        var requested = await ExecuteQuery(weak, RequestSmsMutation,
            new Dictionary<string, object?> { ["telephoneNumber"] = number });
        Assert.Null(requested.Errors);
        var code = await db.Buerger.AsNoTracking().Where(b => b.Id == buerger.Id)
            .Select(b => b.VerificationCode).SingleAsync();

        var validated = await ExecuteQuery(weak, ValidateSmsMutation, new Dictionary<string, object?> {
            ["telephoneNumber"] = number,
            ["validationCode"] = code
        });

        Assert.Null(validated.Errors);
        var payload = (IReadOnlyDictionary<string, object?>)validated.Data!["validateSmsCode"]!;
        Assert.Equal("SUCCESS", payload["result"]!.ToString());
        Assert.Equal(buerger.Id.ToString(), Claim(Read(payload["token"]!.ToString()!), ClaimTypes.NameIdentifier));
        Assert.NotNull(payload["refreshToken"]);

        var reloaded = await db.Buerger.AsNoTracking().SingleAsync(b => b.Id == buerger.Id);
        Assert.True(reloaded.PhoneVerified);
        Assert.False(reloaded.IsDeleted);
        Assert.Equal(number, reloaded.Phone);
        Assert.Equal(registeredAt, reloaded.RegisteredAt);
        Assert.Equal(accountsBefore, await db.Buerger.CountAsync(b => b.PhoneHash == buerger.PhoneHash));
    }

    [Fact]
    public async Task Zugangstoken_VerweistAufSeineSitzung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db, RandomNumber());

        var (principal, refreshToken) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms);

        Assert.Equal((await RowAsync(db, refreshToken)).Id.ToString(), principal.FindFirstValue(StrongSessionClaims.Session));
    }

    [Fact]
    public async Task Nummernwechsel_AusBeendeterSitzung_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var oldNumber = RandomNumber();
        var buerger = await WithChallengeAsync(db, (await CreateBuergerAsync(db)).Id, oldNumber);
        var session = await scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>()
            .ValidateSmsCode(db, buerger, oldNumber, "654321");
        await LogoutEverywhereAsync(PrincipalOf(session.Token!));
        var newNumber = RandomNumber();
        await WithChallengeAsync(db, buerger.Id, newNumber);

        var result = await ExecuteQuery(PrincipalOf(session.Token!), ValidateSmsMutation,
            new Dictionary<string, object?> { ["telephoneNumber"] = newNumber, ["validationCode"] = "654321" });

        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors ?? []).Code);
    }

    [Fact]
    public async Task SmsSchritt_InBeendeterBundIdSitzung_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db);
        await LinkBundIdAsync(db, buerger.Id);
        var (principal, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.BundId, "STORK-QAA-Level-3");
        await LogoutEverywhereAsync(principal);
        var number = RandomNumber();
        await WithChallengeAsync(db, buerger.Id, number);

        var result = await ExecuteQuery(principal, ValidateSmsMutation,
            new Dictionary<string, object?> { ["telephoneNumber"] = number, ["validationCode"] = "654321" });

        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors ?? []).Code);
    }

    [Fact]
    public async Task AufAllenGeraetenAbmelden_AusBeendeterSitzung_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db, RandomNumber());
        var (principal, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms);
        await LogoutEverywhereAsync(principal);
        var laterLogin = await InsertBundIdRowAsync(db, buerger.Id);

        var result = await ExecuteQuery(principal, LogoutAllDevicesMutation, new Dictionary<string, object?>());

        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors ?? []).Code);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(laterLogin)).Result);
    }

    private string AccessToken(Buerger buerger) =>
        new JwtSecurityTokenHandler().WriteToken(buerger.GetToken(Factory.Services.GetRequiredService<JWTOptions>()));

    private string AccessTokenWithoutStamp(Buerger buerger) {
        var token = buerger.GetToken(Factory.Services.GetRequiredService<JWTOptions>());
        var claims = token.Claims.Where(c => c.Type is not (AccessTokenRevocation.SessionStampClaim
            or JwtRegisteredClaimNames.Exp or JwtRegisteredClaimNames.Iss or JwtRegisteredClaimNames.Aud));
        return new JwtSecurityTokenHandler().WriteToken(new JwtSecurityToken(
            token.Issuer, token.Audiences.Single(), claims, expires: token.ValidTo,
            signingCredentials: token.SigningCredentials));
    }

    private async Task<JsonElement> GraphQlViaHttpAsync(string token, string query) {
        var client = Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        var response = await client.PostAsJsonAsync("/graphql", new { query });
        return JsonDocument.Parse(await response.Content.ReadAsStringAsync()).RootElement.Clone();
    }

    private async Task<bool> IsAcceptedAsync(string token) {
        var body = await GraphQlViaHttpAsync(token, "{ my { id } }");
        return body.TryGetProperty("data", out var data) && data.ValueKind == JsonValueKind.Object
            && data.TryGetProperty("my", out var my) && my.ValueKind == JsonValueKind.Object;
    }

    [Fact]
    public void Zugangstoken_TraegtSitzungsstand() {
        var buerger = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo", SessionStamp = 3 };

        var token = Read(AccessToken(buerger));

        Assert.Equal("3", Claim(token, AccessTokenRevocation.SessionStampClaim));
    }

    [Fact]
    public async Task AufAllenGeraetenAbmelden_SperrtAeltereZugangstokensDesKontosSofort() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var buerger = await CreateBuergerAsync(db, RandomNumber());
        var otherAccount = await CreateBuergerAsync(db, RandomNumber());
        var (strongToken, _) = scope.ServiceProvider.GetRequiredService<RefreshTokenService>()
            .Issue(db, buerger, RefreshTokenProvider.Sms, null, clock.GetCurrentInstant());
        await db.SaveChangesAsync();
        var deviceLogin = AccessToken(buerger);
        var otherAccountToken = AccessToken(otherAccount);
        Assert.True(await IsAcceptedAsync(strongToken));
        Assert.True(await IsAcceptedAsync(deviceLogin));

        var logout = await GraphQlViaHttpAsync(strongToken, LogoutAllDevicesMutation);

        Assert.False(logout.TryGetProperty("errors", out _));
        // Zugangs-Tokens lassen sich nicht widerrufen, nur der Zählerstand am Konto beendet sie vor ihrem Ablauf.
        Assert.False(await IsAcceptedAsync(strongToken));
        Assert.False(await IsAcceptedAsync(deviceLogin));
        Assert.True(await IsAcceptedAsync(otherAccountToken));
        var afterLogout = await db.Buerger.AsNoTracking().SingleAsync(b => b.Id == buerger.Id);
        Assert.True(await IsAcceptedAsync(AccessToken(afterLogout)));
        Assert.NotNull(afterLogout.SessionsEndedAt);
    }

    [Fact]
    public async Task AufAllenGeraetenAbmelden_TokenAusVorherGelesenemKonto_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db, RandomNumber());
        var (session, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms);
        var readBeforeLogout = await db.Buerger.AsNoTracking().SingleAsync(b => b.Id == buerger.Id);

        await LogoutEverywhereAsync(session);

        // Ein Login, der das Konto noch vor dem Abmelden gelesen hat, darf danach kein gültiges Token ausstellen.
        Assert.False(await IsAcceptedAsync(AccessToken(readBeforeLogout)));
    }

    [Fact]
    public async Task Zugangstoken_OhneSitzungsstand_GiltBisZumAbmeldenAufAllenGeraeten() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db, RandomNumber());
        var (session, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms);
        var issuedBeforeThisRelease = AccessTokenWithoutStamp(buerger);
        Assert.True(await IsAcceptedAsync(issuedBeforeThisRelease));

        await LogoutEverywhereAsync(session);

        Assert.False(await IsAcceptedAsync(issuedBeforeThisRelease));
    }

    [Fact]
    public async Task Diebstahl_BeendetAuchDieZugangstokensSofort() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = await CreateBuergerAsync(db, RandomNumber());
        var (stolen, refreshToken) = scope.ServiceProvider.GetRequiredService<RefreshTokenService>()
            .Issue(db, buerger, RefreshTokenProvider.Sms, null, Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant());
        await db.SaveChangesAsync();
        var rotated = await RefreshAsync(refreshToken);
        Assert.Equal(RefreshTokenResult.Success, (await RefreshAsync(rotated.RefreshToken!)).Result);

        Assert.Equal(RefreshTokenResult.InvalidOrExpired, (await RefreshAsync(refreshToken)).Result);

        // Nach erkanntem Diebstahl darf auch das zuletzt ausgegebene Zugangs-Token nicht weiter gelten.
        Assert.False(await IsAcceptedAsync(stolen));
        Assert.False(await IsAcceptedAsync(rotated.Token!));
        Assert.NotNull((await db.Buerger.AsNoTracking().SingleAsync(b => b.Id == buerger.Id)).SessionsEndedAt);
    }

    [Theory]
    [InlineData(1, "LOGGED_OUT")]
    [InlineData(null, "DEVICE_LOGIN_KEPT")]
    [InlineData(999, "DEVICE_LOGIN_KEPT")]
    public async Task AufAllenGeraetenAbmelden_SperrtGeraeteloginNurMitEntschluesselbarerHinterlegung(
        int? escrowKeyVersion, string expected) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        var now = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();
        var buerger = await CreateBuergerAsync(db, RandomNumber());
        var tracked = await db.Buerger.AsTracking().SingleAsync(b => b.Id == buerger.Id);
        tracked.Password = hasher.HashPassword(tracked, "geraete-passwort");
        if (escrowKeyVersion is { } keyVersion) {
            db.BuergerKeyEscrows.Add(new BuergerKeyEscrow {
                BuergerId = buerger.Id,
                EncryptedPrivateKey = [1, 2, 3],
                KeyVersion = keyVersion,
                CreatedAt = now,
                UpdatedAt = now
            });
        }
        await db.SaveChangesAsync();
        var (session, _) = await LiveSessionAsync(db, buerger, RefreshTokenProvider.Sms);

        var result = await ExecuteQuery(session, LogoutAllDevicesMutation, new Dictionary<string, object?>());

        Assert.Null(result.Errors);
        var payload = (IReadOnlyDictionary<string, object?>)result.Data!["logoutAllDevices"]!;
        Assert.Equal(expected, payload["logoutAllDevicesResult"]!.ToString());
        await db.Entry(tracked).ReloadAsync();
        // Ohne Hinterlegung liegt der private Schlüssel nur auf dem Erstgerät, eine Sperre dort wäre Datenverlust.
        Assert.Equal(expected == "LOGGED_OUT",
            hasher.VerifyHashedPassword(tracked, tracked.Password, "geraete-passwort") == PasswordVerificationResult.Failed);
    }
}
