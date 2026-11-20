using System.Security.Claims;
using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.KeyEscrow;
using API.Features.Auth.Mutations;
using API.Features.Auth.RefreshTokens;
using API.Infrastructure.Exceptions;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using NodaTime.Testing;

namespace IntegrationTests;

[Collection("Api Tests")]
public class KeyEscrowServiceTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly ClaimsPrincipal WeakPrincipal = new(new ClaimsIdentity([], "jwt"));

    private static async Task<ClaimsPrincipal> SessionAsync(
        DomainContext db, Guid buergerId, string provider = RefreshTokenProvider.Sms) {
        var (session, _) = RefreshToken.Create(
            buergerId, provider, null, NodaTime.Instant.FromUtc(2026, 11, 4, 11, 0), 30);
        db.RefreshTokens.Add(session);
        await db.SaveChangesAsync();
        return new ClaimsPrincipal(new ClaimsIdentity([
            new Claim(StrongSessionClaims.AuthProvider, provider),
            new Claim(StrongSessionClaims.Session, session.Id.ToString())
        ], "jwt"));
    }

    private static async Task LinkBundIdAsync(DomainContext db, Guid buergerId) {
        db.ExternalIdentities.Add(new API.Features.Auth.BundId.ExternalIdentity {
            Id = Guid.NewGuid(),
            BuergerId = buergerId,
            Provider = "bundid",
            Issuer = "test",
            SubjectHash = Guid.NewGuid().ToString("N"),
            AssuranceLevel = "test",
            LinkedAt = NodaTime.Instant.FromUtc(2026, 11, 4, 12, 0),
            LastAuthenticatedAt = NodaTime.Instant.FromUtc(2026, 11, 4, 12, 0)
        });
        await db.SaveChangesAsync();
    }

    private static KeyEscrowOptions Options(int currentVersion = 1, int maxRetrievals = 10) => new() {
        CurrentVersion = currentVersion,
        MaxRetrievalsPerHour = maxRetrievals,
        Keys = new Dictionary<int, string> {
            [1] = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)),
            [2] = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32))
        }
    };

    private static KeyEscrowService CreateService(
        DomainContext db, KeyEscrowOptions options, int minutesLater = 0) =>
        new(db, options, new FakeClock(NodaTime.Instant.FromUtc(2026, 11, 4, 12, 0).Plus(
                NodaTime.Duration.FromMinutes(minutesLater))),
            NullLogger<KeyEscrowService>.Instance);

    private static async Task<(Buerger Buerger, string PrivateKey)> CreateBuergerAsync(
        DomainContext db, bool phoneVerified = true) {
        using var rsa = RSA.Create(2048);
        var buerger = new Buerger {
            PushNotificationTokens = ["bar"],
            PersonalDataKeyEncryptedForBuerger = "foo",
            PublicKey = Convert.ToBase64String(rsa.ExportSubjectPublicKeyInfo()),
            PhoneVerified = phoneVerified
        };
        await db.Users.AddAsync(buerger);
        await db.SaveChangesAsync();
        return (buerger, Convert.ToBase64String(rsa.ExportRSAPrivateKey()));
    }

    [Fact]
    public async Task Retrieve_SmsSitzungEinesBundIdKontos_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        await service.StoreAsync(buerger.Id, privateKey, default);
        await LinkBundIdAsync(db, buerger.Id);

        await Assert.ThrowsAsync<KeyEscrowRequiresStrongSessionException>(
            async () => await service.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default));
        Assert.Equal(privateKey, await service.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id, RefreshTokenProvider.BundId), default));
    }

    [Fact]
    public async Task Store_UndRetrieve_LiefertDenHinterlegtenSchluesselZurueck() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, privateKey) = await CreateBuergerAsync(db);

        await service.StoreAsync(buerger.Id, privateKey, default);

        Assert.True(await service.ExistsAsync(buerger.Id, default));
        Assert.Equal(privateKey, await service.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default));
    }

    [Fact]
    public async Task Store_SchluesselIstNichtImKlartextGespeichert() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, privateKey) = await CreateBuergerAsync(db);

        await service.StoreAsync(buerger.Id, privateKey, default);

        var stored = await db.BuergerKeyEscrows.SingleAsync(e => e.BuergerId == buerger.Id);
        Assert.False(stored.EncryptedPrivateKey.AsSpan().IndexOf(Convert.FromBase64String(privateKey)[..32]) >= 0);
    }

    [Fact]
    public async Task Store_NichtVerifiziertesKonto_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, privateKey) = await CreateBuergerAsync(db, phoneVerified: false);

        await Assert.ThrowsAsync<KeyEscrowAccountNotVerifiedException>(
            () => service.StoreAsync(buerger.Id, privateKey, default));
        Assert.False(await service.ExistsAsync(buerger.Id, default));
    }

    [Fact]
    public async Task Store_SchluesselPasstNichtZumOeffentlichenSchluessel_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, _) = await CreateBuergerAsync(db);
        using var other = RSA.Create(2048);

        await Assert.ThrowsAsync<KeyEscrowKeyMismatchException>(() => service.StoreAsync(
            buerger.Id, Convert.ToBase64String(other.ExportRSAPrivateKey()), default));
    }

    [Fact]
    public async Task Retrieve_MitWeakLoginToken_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        await service.StoreAsync(buerger.Id, privateKey, default);

        await Assert.ThrowsAsync<KeyEscrowRequiresStrongSessionException>(
            () => service.RetrieveAsync(buerger.Id, WeakPrincipal, default));
    }

    [Fact]
    public async Task Retrieve_OhneHinterlegung_LiefertNull() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, _) = await CreateBuergerAsync(db);

        Assert.Null(await service.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default));
    }

    [Fact]
    public async Task Retrieve_UeberschreitetDasLimit_WirdBegrenzt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options(maxRetrievals: 2));
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        await service.StoreAsync(buerger.Id, privateKey, default);

        await service.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default);
        await service.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default);

        await Assert.ThrowsAsync<RateLimitException>(
            async () => await service.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default));
    }

    [Fact]
    public async Task Rotation_AlteVersionBleibtLesbar_NeuesSpeichernNutztDieAktuelleVersion() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var keys = Options();
        var (buerger, privateKey) = await CreateBuergerAsync(db);

        await CreateService(db, keys).StoreAsync(buerger.Id, privateKey, default);

        var rotated = new KeyEscrowOptions { CurrentVersion = 2, Keys = keys.Keys, MaxRetrievalsPerHour = 10 };
        var rotatedService = CreateService(db, rotated, minutesLater: 5);
        Assert.Equal(privateKey, await rotatedService.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default));

        await rotatedService.StoreAsync(buerger.Id, privateKey, default);
        var stored = await db.BuergerKeyEscrows.AsNoTracking().SingleAsync(e => e.BuergerId == buerger.Id);
        Assert.Equal(2, stored.KeyVersion);
        Assert.Equal(privateKey, await rotatedService.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default));
    }

    [Fact]
    public async Task Umschluesseln_HebtAlleEintraegeAufDieAktuelleVersion_UndLaesstSieLesbar() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var keys = Options();
        var (first, firstKey) = await CreateBuergerAsync(db);
        var (second, secondKey) = await CreateBuergerAsync(db);
        var oldService = CreateService(db, keys);
        await oldService.StoreAsync(first.Id, firstKey, default);
        await oldService.StoreAsync(second.Id, secondKey, default);

        var rotated = new KeyEscrowOptions { CurrentVersion = 2, Keys = keys.Keys, MaxRetrievalsPerHour = 10 };
        var rotatedService = CreateService(db, rotated);
        var result = await rotatedService.ReencryptToCurrentVersionAsync(default);

        Assert.True(result.Reencrypted >= 2);
        var versions = await db.BuergerKeyEscrows.AsNoTracking()
            .Where(e => e.BuergerId == first.Id || e.BuergerId == second.Id)
            .Select(e => e.KeyVersion).ToListAsync();
        Assert.All(versions, v => Assert.Equal(2, v));

        var onlyNewKey = new KeyEscrowOptions {
            CurrentVersion = 2,
            Keys = new Dictionary<int, string> { [2] = keys.Keys[2] },
            MaxRetrievalsPerHour = 10
        };
        var onlyNewService = CreateService(db, onlyNewKey);
        Assert.Equal(firstKey, await onlyNewService.RetrieveAsync(first.Id, await SessionAsync(db, first.Id), default));
        Assert.Equal(secondKey, await onlyNewService.RetrieveAsync(second.Id, await SessionAsync(db, second.Id), default));
    }

    [Fact]
    public async Task Umschluesseln_MeldetEintraegeOhneKonfiguriertenAltSchluesselAlsFehler() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var keys = Options();
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        await CreateService(db, keys).StoreAsync(buerger.Id, privateKey, default);

        var withoutOldKey = new KeyEscrowOptions {
            CurrentVersion = 2,
            Keys = new Dictionary<int, string> { [2] = keys.Keys[2] },
            MaxRetrievalsPerHour = 10
        };
        var service = CreateService(db, withoutOldKey);

        Assert.Contains(1, await service.GetMissingKeyVersionsAsync(default));
        var result = await service.ReencryptToCurrentVersionAsync(default);
        Assert.Equal(0, result.Reencrypted);
        Assert.True(result.Failed >= 1);
    }


    [Fact]
    public async Task Umschluesseln_ZaehltEinenBeschaedigtenEintragAlsFehlerUndLaeuftWeiter() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var keys = Options();
        var (beschaedigt, _) = await CreateBuergerAsync(db);
        var (intakt, intaktKey) = await CreateBuergerAsync(db);
        var jetzt = NodaTime.Instant.FromUtc(2026, 11, 4, 12, 0);
        db.BuergerKeyEscrows.Add(new BuergerKeyEscrow {
            BuergerId = beschaedigt.Id,
            EncryptedPrivateKey = [1],
            KeyVersion = 1,
            CreatedAt = jetzt,
            UpdatedAt = jetzt
        });
        await db.SaveChangesAsync();
        await CreateService(db, keys).StoreAsync(intakt.Id, intaktKey, default);

        var rotated = new KeyEscrowOptions { CurrentVersion = 2, Keys = keys.Keys, MaxRetrievalsPerHour = 10 };
        var result = await CreateService(db, rotated).ReencryptToCurrentVersionAsync(default);

        Assert.True(result.Failed >= 1);
        var version = await db.BuergerKeyEscrows.AsNoTracking()
            .Where(e => e.BuergerId == intakt.Id).Select(e => e.KeyVersion).SingleAsync();
        Assert.Equal(2, version);
    }

    private static async Task<ClaimsPrincipal> PrincipalAsync(
        DomainContext db, Buerger buerger, IServiceProvider services, bool strong) {
        var options = services.GetRequiredService<JWTOptions>();
        var claims = buerger.GetToken(options).Claims;
        return strong
            ? new ClaimsPrincipal(new ClaimsIdentity(claims.Concat((await SessionAsync(db, buerger.Id)).Claims), "jwt"))
            : new ClaimsPrincipal(new ClaimsIdentity(claims, "jwt"));
    }

    [Fact]
    public async Task GraphQL_AbrufMitWeakToken_WirdAbgelehnt_MitStarkerSitzungGeliefert() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        await CreateService(db, scope.ServiceProvider.GetRequiredService<KeyEscrowOptions>())
            .StoreAsync(buerger.Id, privateKey, default);

        var schwach = await ExecuteQuery(
            await PrincipalAsync(db, buerger, Factory.Services, strong: false), "query { keyEscrow }", null);
        Assert.NotNull(schwach.Errors);
        Assert.Contains(schwach.Errors!, e => e.Exception is KeyEscrowRequiresStrongSessionException
            || e.Message.Contains("BundID or SMS session"));

        var stark = await ExecuteQuery(
            await PrincipalAsync(db, buerger, Factory.Services, strong: true), "query { keyEscrow }", null);
        Assert.Null(stark.Errors);
        Assert.Equal(privateKey, stark.Data!["keyEscrow"]);
    }

    [Fact]
    public async Task Store_SchluesselMitPassendemOeffentlichenTeilAberOhneBesitz_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        using var echt = RSA.Create();
        echt.ImportRSAPrivateKey(Convert.FromBase64String(privateKey), out _);
        var teile = echt.ExportParameters(true);

        byte[] Zufall(byte[] vorlage) {
            var bytes = RandomNumberGenerator.GetBytes(vorlage.Length);
            bytes[0] |= 0x80;
            bytes[^1] |= 1;
            return bytes;
        }

        var writer = new System.Formats.Asn1.AsnWriter(System.Formats.Asn1.AsnEncodingRules.DER);
        using (writer.PushSequence()) {
            writer.WriteInteger(0);
            foreach (var teil in new[] {
                teile.Modulus!, teile.Exponent!, Zufall(teile.D!), Zufall(teile.P!), Zufall(teile.Q!),
                Zufall(teile.DP!), Zufall(teile.DQ!), Zufall(teile.InverseQ!)
            }) {
                writer.WriteIntegerUnsigned(teil);
            }
        }

        await Assert.ThrowsAsync<KeyEscrowKeyMismatchException>(() => service.StoreAsync(
            buerger.Id, Convert.ToBase64String(writer.Encode()), default));
    }

    [Fact]
    public async Task Retrieve_ChiffretextEinesAnderenKontos_LaesstSichNichtEntschluesseln() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var keys = Options();
        var service = CreateService(db, keys);
        var (opfer, opferKey) = await CreateBuergerAsync(db);
        var (angreifer, angreiferKey) = await CreateBuergerAsync(db);
        await service.StoreAsync(opfer.Id, opferKey, default);
        await service.StoreAsync(angreifer.Id, angreiferKey, default);

        var fremd = await db.BuergerKeyEscrows.AsNoTracking().SingleAsync(e => e.BuergerId == opfer.Id);
        var eigener = await db.BuergerKeyEscrows.AsTracking().SingleAsync(e => e.BuergerId == angreifer.Id);
        eigener.EncryptedPrivateKey = fremd.EncryptedPrivateKey;
        await db.SaveChangesAsync();

        await Assert.ThrowsAnyAsync<CryptographicException>(
            async () => await service.RetrieveAsync(angreifer.Id, await SessionAsync(db, angreifer.Id), default));
    }

    [Fact]
    public async Task Store_BundIdKontoOhneBestaetigteNummer_IstErlaubt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, privateKey) = await CreateBuergerAsync(db, phoneVerified: false);
        db.ExternalIdentities.Add(new API.Features.Auth.BundId.ExternalIdentity {
            Id = Guid.NewGuid(),
            BuergerId = buerger.Id,
            Provider = "bundid",
            Issuer = "test",
            SubjectHash = Guid.NewGuid().ToString("N"),
            AssuranceLevel = "test",
            LinkedAt = NodaTime.Instant.FromUtc(2026, 11, 4, 12, 0),
            LastAuthenticatedAt = NodaTime.Instant.FromUtc(2026, 11, 4, 12, 0)
        });
        await db.SaveChangesAsync();

        await service.StoreAsync(buerger.Id, privateKey, default);

        Assert.True(await service.ExistsAsync(buerger.Id, default));
    }

    [Fact]
    public async Task SmsCodePruefung_TokenTraegtDenClaimFuerDenSchluesselabruf() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await CreateBuergerAsync(db, phoneVerified: false);
        var nummer = "+4915112" + Random.Shared.Next(100000, 999999);
        var tracked = await db.Buerger.AsTracking().SingleAsync(b => b.Id == buerger.Id);
        tracked.VerificationCode = "654321";
        tracked.VerificationCodeValidUntil = NodaTime.SystemClock.Instance.GetCurrentInstant()
            .Plus(NodaTime.Duration.FromMinutes(5));
        tracked.VerificationPhoneHash = PhoneHashingService.ComputeHash(nummer);
        await db.SaveChangesAsync();

        var service = scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>();
        var ergebnis = await service.ValidateSmsCode(db, tracked, nummer, "654321");

        var token = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler().ReadJwtToken(ergebnis.Token);
        Assert.Contains(token.Claims, c => c.Type == StrongSessionClaims.AuthProvider && c.Value == "sms");
    }

    [Fact]
    public async Task GesperrtesKontoOhneStarkeSitzung_BekommtDieSperrAntwortStattEinerAblehnung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await CreateBuergerAsync(db);
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var tracked = await db.Buerger.AsTracking().SingleAsync(b => b.Id == buerger.Id);
        tracked.VerificationCodeLockedUntil = clock.GetCurrentInstant().Plus(NodaTime.Duration.FromMinutes(15));
        await db.SaveChangesAsync();

        var result = await ExecuteQuery(
            await PrincipalAsync(db, buerger, Factory.Services, strong: false),
            """
            mutation ValidateSmsCode($input: ValidateSmsCodeInput!) {
                validateSmsCode(input: $input) { result retryAfterSeconds }
            }
            """,
            new Dictionary<string, object?> { ["telephoneNumber"] = "+4915100000001", ["validationCode"] = "111111" });

        Assert.Null(result.Errors);
        var payload = (IReadOnlyDictionary<string, object?>)result.Data!["validateSmsCode"]!;
        Assert.Equal("CODE_LOCKED", payload["result"]!.ToString());
    }

    [Theory]
    [InlineData(true, false, "weak", true)]
    [InlineData(false, true, "weak", true)]
    [InlineData(false, false, "weak", false)]
    [InlineData(true, false, "sms", false)]
    [InlineData(false, true, "sms", true)]
    [InlineData(false, true, "bundid", false)]
    [InlineData(true, true, "bundid", false)]
    public async Task Nummernwechsel_VerifiziertesKontoBrauchtEineStarkeSitzung(
        bool phoneVerified, bool hasBundId, string session, bool wirdAbgelehnt) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await CreateBuergerAsync(db, phoneVerified);
        if (hasBundId) {
            await LinkBundIdAsync(db, buerger.Id);
        }

        var service = scope.ServiceProvider.GetRequiredService<EhrenamtsbankAuthService>();
        var principal = session switch {
            "weak" => WeakPrincipal,
            "sms" => await SessionAsync(db, buerger.Id),
            _ => await SessionAsync(db, buerger.Id, RefreshTokenProvider.BundId)
        };
        var pruefung = () => service.EnsureStrongSessionForPhoneChange(
            db, buerger, "+4915100000000", principal, default);

        if (wirdAbgelehnt) {
            await Assert.ThrowsAsync<API.Infrastructure.NotAllowedException>(pruefung);
        } else {
            await pruefung();
        }
    }

    [Fact]
    public async Task ExistsAsync_NichtLesbarerEintrag_GiltAlsFehlend_UndKannSofortErsetztWerden() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var keys = Options();
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        await CreateService(db, keys).StoreAsync(buerger.Id, privateKey, default);

        var withoutOldKey = new KeyEscrowOptions {
            CurrentVersion = 2,
            Keys = new Dictionary<int, string> { [2] = keys.Keys[2] },
            MaxRetrievalsPerHour = 10
        };
        var service = CreateService(db, withoutOldKey);
        Assert.False(await service.ExistsAsync(buerger.Id, default));

        await service.StoreAsync(buerger.Id, privateKey, default);

        Assert.True(await service.ExistsAsync(buerger.Id, default));
        Assert.Equal(privateKey, await service.RetrieveAsync(buerger.Id, await SessionAsync(db, buerger.Id), default));
    }

    [Fact]
    public async Task Store_ZweiteSchreibungInnerhalbEinerMinute_WirdBegrenzt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var keys = Options();
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        await CreateService(db, keys).StoreAsync(buerger.Id, privateKey, default);

        await Assert.ThrowsAsync<RateLimitException>(
            () => CreateService(db, keys, minutesLater: 0).StoreAsync(buerger.Id, privateKey, default));

        await CreateService(db, keys, minutesLater: 2).StoreAsync(buerger.Id, privateKey, default);
    }

    [Fact]
    public async Task Store_UngueltigeOderZuGrosseEingabe_WirdAlsFalscherSchluesselAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (buerger, _) = await CreateBuergerAsync(db);

        await Assert.ThrowsAsync<KeyEscrowKeyMismatchException>(
            () => service.StoreAsync(buerger.Id, "das ist kein base64!", default));
        await Assert.ThrowsAsync<KeyEscrowKeyMismatchException>(
            () => service.StoreAsync(buerger.Id, new string('A', 20_000), default));
    }

    [Fact]
    public async Task Token_EnthaeltDieKontoIdImFeldDasDieAppLiest() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, _) = await CreateBuergerAsync(db);
        var options = scope.ServiceProvider.GetRequiredService<JWTOptions>();

        var token = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler()
            .WriteToken(buerger.GetToken(options));
        var payload = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler().ReadJwtToken(token).Payload;

        Assert.Equal(buerger.Id.ToString(), payload["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"]);
    }

    [Fact]
    public void MasterCode_IstInDerBasisKonfigurationAus() {
        var basis = new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile("appsettings.json")
            .Build();

        Assert.Equal("False", basis["Ehrenamtsbank:ACCEPT_MASTER_CODE"], ignoreCase: true);
    }

    [Theory]
    [InlineData("input", "mutation StoreKeyEscrow($input: StoreKeyEscrowInput!) { storeKeyEscrow(input: $input) { boolean } }", true)]
    [InlineData("input", "mutation WeakLogin($input: LoginBuergerWeakInput!) { loginBuergerWeak(input: $input) { token } }", true)]
    [InlineData("password", "query Foo { bar }", true)]
    [InlineData("input", "mutation RequestSmsCode($input: RequestSmsCodeInput!) { requestSmsCode(input: $input) { result } }", true)]
    [InlineData("id", "query Antraege($id: ID!) { antrag(id: $id) { name } }", false)]
    public void SentryMiddleware_ErkenntVertraulicheOperationen(string variableName, string query, bool expected) =>
        Assert.Equal(expected, API.Infrastructure.SentryHotChocolateContextMiddleware.IsConfidential([variableName], query));

    [Fact]
    public async Task Hinterlegung_KannNichtMitFremdemSchluesselAnderesKontoLesen() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var service = CreateService(db, Options());
        var (owner, privateKey) = await CreateBuergerAsync(db);
        var (other, _) = await CreateBuergerAsync(db);
        await service.StoreAsync(owner.Id, privateKey, default);

        Assert.Null(await service.RetrieveAsync(other.Id, await SessionAsync(db, other.Id), default));
    }

    [Fact]
    public async Task Retrieve_AusBeendeterSitzung_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, privateKey) = await CreateBuergerAsync(db);
        var service = CreateService(db, Options());
        await service.StoreAsync(buerger.Id, privateKey, default);
        var principal = await SessionAsync(db, buerger.Id);
        await db.RefreshTokens.Where(t => t.BuergerId == buerger.Id).ExecuteUpdateAsync(t => t
            .SetProperty(r => r.RevokedAt, NodaTime.Instant.FromUtc(2026, 11, 4, 11, 55))
            .SetProperty(r => r.RevokedReason, RefreshTokenRevokedReason.LoggedOut));

        await Assert.ThrowsAsync<KeyEscrowRequiresStrongSessionException>(
            () => service.RetrieveAsync(buerger.Id, principal, default));
    }
}
