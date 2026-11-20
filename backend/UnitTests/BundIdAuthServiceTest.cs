using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.BundId;
using API.Features.Auth.RefreshTokens;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using NodaTime;
using NodaTime.Testing;

namespace IntegrationTests;

[Collection("Api Tests")]
public class BundIdAuthServiceTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private FakeKeycloakTokenValidator TokenValidator =>
        Factory.Services.GetRequiredService<FakeKeycloakTokenValidator>();

    private static async Task<Buerger> VerifyAsync(DomainContext db, Guid buergerId) {
        var tracked = await db.Buerger.AsTracking().SingleAsync(b => b.Id == buergerId);
        tracked.Phone = "+4915113" + Random.Shared.Next(100000, 999999);
        tracked.PhoneVerified = true;
        tracked.IsRegistered = true;
        await db.SaveChangesAsync();
        return tracked;
    }

    [Theory]
    [InlineData(false, BundIdExchangeResult.Success)]
    [InlineData(true, BundIdExchangeResult.AccountAlreadyVerified)]
    public async Task Exchange_NeueVerknuepfungEinesBestaetigtenKontos_WirdAbgelehnt(
        bool verified, BundIdExchangeResult expected) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        if (verified) {
            await VerifyAsync(db, buerger.Id);
        }
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var accessToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"subject-{buerger.Id}"));

        var result = await service.ExchangeAsync(buerger.Id, accessToken);

        Assert.Equal(expected, result.Result);
        Assert.Equal(expected == BundIdExchangeResult.Success,
            await db.ExternalIdentities.AnyAsync(e => e.BuergerId == buerger.Id));
    }

    [Fact]
    public async Task Exchange_GleicheBundIdErneut_GehtAuchBeiBestaetigtemKonto() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var subject = $"subject-{buerger.Id}";
        await service.ExchangeAsync(buerger.Id, TokenValidator.Register(BundIdTestPrincipal.Create(subject: subject)));
        await VerifyAsync(db, buerger.Id);

        var again = await service.ExchangeAsync(
            buerger.Id, TokenValidator.Register(BundIdTestPrincipal.Create(subject: subject)));

        Assert.Equal(BundIdExchangeResult.Success, again.Result);
    }

    [Fact]
    public async Task Exchange_GeloeschtesKonto_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var tracked = await db.Buerger.AsTracking().SingleAsync(b => b.Id == buerger.Id);
        tracked.IsDeleted = true;
        await db.SaveChangesAsync();
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();

        var result = await service.ExchangeAsync(
            buerger.Id, TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"subject-{buerger.Id}")));

        Assert.Equal(BundIdExchangeResult.AccountUnavailable, result.Result);
        Assert.False(await db.ExternalIdentities.AnyAsync(e => e.BuergerId == buerger.Id));
    }

    [Fact]
    public async Task Exchange_NeueVerknuepfung_BeendetSmsSitzungenDesKontos() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var now = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();
        var (smsSession, _) = RefreshToken.Create(buerger.Id, RefreshTokenProvider.Sms, null, now, 30);
        db.RefreshTokens.Add(smsSession);
        await db.SaveChangesAsync();
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();

        var result = await service.ExchangeAsync(
            buerger.Id, TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"subject-{buerger.Id}")));

        Assert.Equal(BundIdExchangeResult.Success, result.Result);
        var row = await db.RefreshTokens.AsNoTracking().SingleAsync(t => t.Id == smsSession.Id);
        Assert.Equal(RefreshTokenRevokedReason.AccountInvalid, row.RevokedReason);
    }

    [Fact]
    public async Task Exchange_Neuregistrierung_LegtVerknuepfungUndProfilAnOhneSmsPflicht() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var accessToken = TokenValidator.Register(BundIdTestPrincipal.Create(
            subject: $"subject-{buerger.Id}",
            vorname: "Erika",
            nachname: "Musterfrau",
            email: "erika@example.com",
            acr: "STORK-QAA-Level-2"));

        var result = await service.ExchangeAsync(buerger.Id, accessToken);

        Assert.Equal(BundIdExchangeResult.Success, result.Result);
        Assert.True(result.IsNewRegistration);
        Assert.NotNull(result.Token);
        Assert.NotNull(result.RefreshToken);

        await db.Entry(buerger).ReloadAsync();
        Assert.True(buerger.IsRegistered);
        Assert.Equal("Erika", buerger.Vorname);
        Assert.Equal("Musterfrau", buerger.Nachname);
        Assert.Equal("erika@example.com", buerger.EmailAddress);

        var externalIdentity = await db.ExternalIdentities.SingleAsync(e => e.BuergerId == buerger.Id);
        Assert.Equal("bundid", externalIdentity.Provider);
        Assert.Equal("STORK-QAA-Level-2", externalIdentity.AssuranceLevel);
    }

    [Fact]
    public async Task Exchange_SubjektBereitsAnAnderenBuergerGebunden_WirdAbgelehntUndAendertNichts() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (ownerBuerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var (attackerBuerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var sharedSubject = $"subject-{ownerBuerger.Id}";

        // ownerBuerger verknüpft das Subject zuerst, legitim.
        var ownerToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: sharedSubject));
        var ownerResult = await service.ExchangeAsync(ownerBuerger.Id, ownerToken);
        Assert.Equal(BundIdExchangeResult.Success, ownerResult.Result);

        var ownerIdentityBefore = await db.ExternalIdentities.AsNoTracking()
            .SingleAsync(e => e.BuergerId == ownerBuerger.Id);

        // attackerBuerger versucht, dasselbe Subject (z.B. abgefangenes Access-Token) an sein
        // eigenes, unabhängiges Konto zu binden - muss abgelehnt werden, sonst Kontoübernahme.
        var attackerToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: sharedSubject));
        var attackerResult = await service.ExchangeAsync(attackerBuerger.Id, attackerToken);

        Assert.Equal(BundIdExchangeResult.AlreadyLinkedToAnotherAccount, attackerResult.Result);
        Assert.Null(attackerResult.Token);

        await db.Entry(attackerBuerger).ReloadAsync();
        Assert.False(attackerBuerger.IsRegistered);
        Assert.False(await db.ExternalIdentities.AnyAsync(e => e.BuergerId == attackerBuerger.Id));

        var ownerIdentityAfter = await db.ExternalIdentities.AsNoTracking()
            .SingleAsync(e => e.BuergerId == ownerBuerger.Id);
        Assert.Equal(ownerIdentityBefore.LastAuthenticatedAt, ownerIdentityAfter.LastAuthenticatedAt);
    }

    [Fact]
    public async Task Exchange_BuergerHatBereitsAndereBundId_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();

        var firstToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"first-{buerger.Id}"));
        var firstResult = await service.ExchangeAsync(buerger.Id, firstToken);
        Assert.Equal(BundIdExchangeResult.Success, firstResult.Result);

        var secondToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"second-{buerger.Id}"));
        var secondResult = await service.ExchangeAsync(buerger.Id, secondToken);

        Assert.Equal(BundIdExchangeResult.AccountAlreadyHasDifferentBundId, secondResult.Result);
        Assert.Null(secondResult.Token);

        var identity = await db.ExternalIdentities.AsNoTracking().SingleAsync(e => e.BuergerId == buerger.Id);
        var expectedFirstSubjectHash = scope.ServiceProvider.GetRequiredService<IBundIdSubjectHasher>()
            .ComputeHash(scope.ServiceProvider.GetRequiredService<API.Options.BundIdOptions>().KeycloakAuthority, $"first-{buerger.Id}");
        Assert.Equal(expectedFirstSubjectHash, identity.SubjectHash);
    }

    [Fact]
    public async Task Exchange_TelefonnummerKollision_WirdNichtUebernommenKontoAberTrotzdemAngelegt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var sharedPhoneNumber = RandomPhoneNumber();
        var (existingOwner, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        existingOwner.Phone = sharedPhoneNumber;
        await db.SaveChangesAsync();

        var (newBuerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var accessToken = TokenValidator.Register(BundIdTestPrincipal.Create(
            subject: $"subject-{newBuerger.Id}",
            telephoneNumber: sharedPhoneNumber));

        var result = await service.ExchangeAsync(newBuerger.Id, accessToken);

        Assert.Equal(BundIdExchangeResult.Success, result.Result);
        Assert.True(result.PhoneNumberCollision);

        await db.Entry(newBuerger).ReloadAsync();
        Assert.True(newBuerger.IsRegistered);
        Assert.Null(newBuerger.Phone);

        await db.Entry(existingOwner).ReloadAsync();
        Assert.Equal(sharedPhoneNumber, existingOwner.Phone);
    }

    [Fact]
    public async Task Login_UnbekanntesSubjekt_LiefertRegistrationRequiredOhneKontoAnzulegen() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var identityCountBefore = await db.ExternalIdentities.CountAsync();
        var accessToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"unbekannt-{Guid.NewGuid()}"));

        var result = await service.LoginAsync(accessToken);

        Assert.Equal(BundIdLoginResult.RegistrationRequired, result.Result);
        Assert.Null(result.Token);
        Assert.Equal(identityCountBefore, await db.ExternalIdentities.CountAsync());
    }

    [Fact]
    public async Task Login_BekanntesSubjekt_AktualisiertAssuranceLevelUndLetzteAnmeldung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var subject = $"subject-{buerger.Id}";

        var exchangeToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: subject, acr: "STORK-QAA-Level-1"));
        await service.ExchangeAsync(buerger.Id, exchangeToken);
        var linkedAt = (await db.ExternalIdentities.AsNoTracking().SingleAsync(e => e.BuergerId == buerger.Id)).LinkedAt;

        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;
        try {
            clock.AutoAdvance = Duration.Zero;
            clock.Advance(Duration.FromMinutes(5));

            var loginToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: subject, acr: "STORK-QAA-Level-2"));
            var loginResult = await service.LoginAsync(loginToken);

            Assert.Equal(BundIdLoginResult.Success, loginResult.Result);
            Assert.NotNull(loginResult.Token);

            var identity = await db.ExternalIdentities.AsNoTracking().SingleAsync(e => e.BuergerId == buerger.Id);
            Assert.Equal("STORK-QAA-Level-2", identity.AssuranceLevel);
            Assert.Equal(linkedAt, identity.LinkedAt);
            Assert.True(identity.LastAuthenticatedAt > linkedAt);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task Refresh_RotiertToken_WiederverwendungDesAltenTokensSchlaegtFehl() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var refreshTokens = scope.ServiceProvider.GetRequiredService<RefreshTokenService>();

        var accessToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"subject-{buerger.Id}"));
        var exchangeResult = await service.ExchangeAsync(buerger.Id, accessToken);
        var firstRefreshToken = exchangeResult.RefreshToken!;

        var firstRefreshResult = await refreshTokens.RefreshAsync(firstRefreshToken);
        Assert.Equal(RefreshTokenResult.Success, firstRefreshResult.Result);
        Assert.NotEqual(firstRefreshToken, firstRefreshResult.RefreshToken);

        var secondRefreshResult = await refreshTokens.RefreshAsync(firstRefreshResult.RefreshToken!);
        Assert.Equal(RefreshTokenResult.Success, secondRefreshResult.Result);

        // Diebstahlschutz: ein bereits rotierter (verwendeter) Refresh-Token darf kein zweites Mal
        // funktionieren, auch wenn er formal noch nicht abgelaufen ist.
        var reuseResult = await refreshTokens.RefreshAsync(firstRefreshToken);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, reuseResult.Result);
        Assert.Null(reuseResult.Token);
        // Die Wiederverwendung sperrt auch den aktuell gültigen Nachfolger, ein Dieb behält keine Sitzung.
        Assert.Equal(RefreshTokenResult.InvalidOrExpired,
            (await refreshTokens.RefreshAsync(secondRefreshResult.RefreshToken!)).Result);
    }

    [Fact]
    public async Task Refresh_AbgelaufenerToken_LiefertInvalidOrExpired() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var refreshTokens = scope.ServiceProvider.GetRequiredService<RefreshTokenService>();
        var sessionOptions = scope.ServiceProvider.GetRequiredService<API.Options.AuthSessionOptions>();

        var accessToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"subject-{buerger.Id}"));
        var exchangeResult = await service.ExchangeAsync(buerger.Id, accessToken);

        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;
        try {
            clock.AutoAdvance = Duration.Zero;
            clock.Advance(Duration.FromDays(sessionOptions.RefreshTokenLifetimeDays + 1));

            var refreshResult = await refreshTokens.RefreshAsync(exchangeResult.RefreshToken!);

            Assert.Equal(RefreshTokenResult.InvalidOrExpired, refreshResult.Result);
            Assert.Null(refreshResult.Token);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task RevokeRefreshToken_MachtTokenFuerFolgendenRefreshUnbrauchbar() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var refreshTokens = scope.ServiceProvider.GetRequiredService<RefreshTokenService>();

        var accessToken = TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"subject-{buerger.Id}"));
        var exchangeResult = await service.ExchangeAsync(buerger.Id, accessToken);

        await refreshTokens.RevokeAsync(exchangeResult.RefreshToken!);

        var refreshResult = await refreshTokens.RefreshAsync(exchangeResult.RefreshToken!);
        Assert.Equal(RefreshTokenResult.InvalidOrExpired, refreshResult.Result);
    }

    private static string RandomPhoneNumber() {
        var randomNumber = System.Security.Cryptography.RandomNumberGenerator.GetInt32(100000, 1000000).ToString();
        return $"+49 1234 {randomNumber}";
    }

    [Fact]
    public async Task Login_GeloeschtesKonto_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        var subject = $"subject-{buerger.Id}";
        await service.ExchangeAsync(buerger.Id, TokenValidator.Register(BundIdTestPrincipal.Create(subject: subject)));
        var tracked = await db.Buerger.AsTracking().SingleAsync(b => b.Id == buerger.Id);
        tracked.IsDeleted = true;
        await db.SaveChangesAsync();

        var result = await service.LoginAsync(TokenValidator.Register(BundIdTestPrincipal.Create(subject: subject)));

        Assert.Equal(BundIdLoginResult.AccountUnavailable, result.Result);
        Assert.Null(result.RefreshToken);
    }

    [Fact]
    public async Task Exchange_FehlerBeimSpeichern_LaesstSmsSitzungenBestehen() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var now = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();
        var (smsSession, _) = RefreshToken.Create(buerger.Id, RefreshTokenProvider.Sms, null, now, 30);
        db.RefreshTokens.Add(smsSession);
        await db.SaveChangesAsync();
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();
        await db.Database.ExecuteSqlRawAsync("""
            CREATE OR REPLACE FUNCTION test_failing_refresh_token_insert() RETURNS trigger AS $$
            BEGIN RAISE EXCEPTION 'insert blocked by test'; END $$ LANGUAGE plpgsql;
            CREATE TRIGGER test_failing_refresh_token_insert BEFORE INSERT ON "RefreshTokens"
                FOR EACH ROW EXECUTE FUNCTION test_failing_refresh_token_insert();
            """);
        try {
            await Assert.ThrowsAnyAsync<Exception>(() => service.ExchangeAsync(
                buerger.Id, TokenValidator.Register(BundIdTestPrincipal.Create(subject: $"subject-{buerger.Id}"))));
        } finally {
            await db.Database.ExecuteSqlRawAsync("""
                DROP TRIGGER IF EXISTS test_failing_refresh_token_insert ON "RefreshTokens";
                DROP FUNCTION IF EXISTS test_failing_refresh_token_insert();
                """);
        }

        await using var checkScope = Factory.Services.CreateAsyncScope();
        var check = checkScope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.Null((await check.RefreshTokens.AsNoTracking().SingleAsync(t => t.Id == smsSession.Id)).RevokedAt);
        Assert.False(await check.ExternalIdentities.AnyAsync(e => e.BuergerId == buerger.Id));
    }

    private static readonly Instant AllSessionsEnded = Instant.FromUtc(2026, 11, 11, 12, 0);

    // Durch den echten Token-Handler, damit die Claim-Zuordnung von auth_time mitgeprüft wird.
    private static ClaimsPrincipal KeycloakPrincipal(string subject, int? authTimeOffset, int issuedAtOffset) {
        var key = new SymmetricSecurityKey(RandomNumberGenerator.GetBytes(32));
        var claims = new List<Claim> {
            new("preferred_username", subject),
            new(JwtRegisteredClaimNames.Iat, UnixSeconds(issuedAtOffset), ClaimValueTypes.Integer64)
        };
        if (authTimeOffset is { } offset) {
            claims.Add(new Claim(JwtRegisteredClaimNames.AuthTime, UnixSeconds(offset), ClaimValueTypes.Integer64));
        }

        var handler = new JwtSecurityTokenHandler();
        var token = handler.WriteToken(new JwtSecurityToken(claims: claims, expires: DateTime.UtcNow.AddMinutes(5),
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256)));
        return handler.ValidateToken(token, new TokenValidationParameters {
            ValidateIssuer = false,
            ValidateAudience = false,
            IssuerSigningKey = key
        }, out _);

        static string UnixSeconds(int offset) =>
            AllSessionsEnded.Plus(Duration.FromSeconds(offset)).ToUnixTimeSeconds().ToString();
    }

    private async Task<(Buerger Buerger, string Subject)> LinkedBuergerAsync(
        IServiceProvider services, DomainContext db, bool sessionsEnded) {
        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, services);
        var subject = $"subject-{buerger.Id}";
        await services.GetRequiredService<BundIdAuthService>()
            .ExchangeAsync(buerger.Id, TokenValidator.Register(BundIdTestPrincipal.Create(subject: subject)));
        if (sessionsEnded) {
            var tracked = await db.Buerger.AsTracking().SingleAsync(b => b.Id == buerger.Id);
            tracked.SessionsEndedAt = AllSessionsEnded;
            await db.SaveChangesAsync();
        }
        return (buerger, subject);
    }

    [Theory]
    [InlineData(true, -60, 60, BundIdLoginResult.AuthenticationOutdated)]
    [InlineData(true, 0, 60, BundIdLoginResult.AuthenticationOutdated)]
    [InlineData(true, 1, 1, BundIdLoginResult.Success)]
    [InlineData(true, null, -60, BundIdLoginResult.AuthenticationOutdated)]
    [InlineData(true, null, 1, BundIdLoginResult.Success)]
    [InlineData(false, -60, -60, BundIdLoginResult.Success)]
    public async Task Login_AnmeldungAusDerZeitVorDemBeendenAllerSitzungen_WirdAbgelehnt(
        bool sessionsEnded, int? authTimeOffset, int issuedAtOffset, BundIdLoginResult expected) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (_, subject) = await LinkedBuergerAsync(scope.ServiceProvider, db, sessionsEnded);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();

        var result = await service.LoginAsync(
            TokenValidator.Register(KeycloakPrincipal(subject, authTimeOffset, issuedAtOffset)));

        Assert.Equal(expected, result.Result);
        Assert.Equal(expected == BundIdLoginResult.Success, result.RefreshToken is not null);
    }

    [Theory]
    [InlineData(-60, BundIdExchangeResult.AuthenticationOutdated)]
    [InlineData(1, BundIdExchangeResult.Success)]
    public async Task Exchange_AnmeldungAusDerZeitVorDemBeendenAllerSitzungen_WirdAbgelehnt(
        int authTimeOffset, BundIdExchangeResult expected) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, subject) = await LinkedBuergerAsync(scope.ServiceProvider, db, sessionsEnded: true);
        var service = scope.ServiceProvider.GetRequiredService<BundIdAuthService>();

        var result = await service.ExchangeAsync(
            buerger.Id, TokenValidator.Register(KeycloakPrincipal(subject, authTimeOffset, authTimeOffset)));

        Assert.Equal(expected, result.Result);
        Assert.Equal(expected == BundIdExchangeResult.Success, result.RefreshToken is not null);
    }
}
