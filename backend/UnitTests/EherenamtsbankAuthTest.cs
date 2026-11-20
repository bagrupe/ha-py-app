using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Options;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;
using NodaTime.Testing;
namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankAuthTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string RequestSmsMutation =
        """
        mutation RequestSmsCode($input: RequestSmsCodeInput!) {
            requestSmsCode(input: $input) {
                requestSmsResult
            }
        }
        """;

    private const string ValidateSmsMutation =
        """
        mutation ValidateSmsCode($input: ValidateSmsCodeInput!) {
            validateSmsCode(input: $input) {
                result
                token
                remainingAttempts
                retryAfterSeconds
            }
        }
        """;

    private const string LoginBuergerWeakMutation =
        """
        mutation LoginBuergerWeak($input: LoginBuergerWeakInput!) {
            loginBuergerWeak(input: $input) {
                loginPayload {
                    result
                    token
                }
            }
        }
        """;

    [Fact]
    public async Task RequestSMSNeedsToken() {
        var input = new Dictionary<string, object?> {
            ["telephoneNumber"] = "+49 1234 122323",
        };
        var result = await ExecuteQuery(null, RequestSmsMutation, input);

        Assert.NotEmpty(result.Errors!);

    }

    [Fact]
    public async Task LoginBuergerWeak_UnregisteredUserTokenContainsFalseRegistrationClaim() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var passwordHasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        const string password = "derived-password";

        var (buerger, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        buerger.Password = passwordHasher.HashPassword(buerger, password);
        await db.SaveChangesAsync();

        var result = await ExecuteQuery(null, LoginBuergerWeakMutation, new Dictionary<string, object?> {
            ["buergerId"] = buerger.Id,
            ["password"] = password,
        });

        Assert.Null(result.Errors);
        var mutationPayload = result.Data!["loginBuergerWeak"] as IReadOnlyDictionary<string, object>;
        var payload = mutationPayload!["loginPayload"] as IReadOnlyDictionary<string, object>;
        Assert.Equal("SUCCESS", payload!["result"].ToString());

        var token = Assert.IsType<string>(payload["token"]);
        var actualToken = new JwtSecurityTokenHandler().ReadJwtToken(token);
        var isRegistered = actualToken.Claims.First(c => c.Type == "is_registered").Value;

        Assert.Equal("false", isRegistered);
    }

    [Fact]
    public async Task RequestSMS_NewUser() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;

            var (buergerEntity, buergerPrincipal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

            var telephoneNumber = RandomPhoneNumber();
            var input = new Dictionary<string, object?> {
                ["telephoneNumber"] = telephoneNumber,
            };
            var result = await ExecuteQuery(buergerPrincipal, RequestSmsMutation, input);

            Assert.Null(result.Errors);
            var payload = result.Data!["requestSmsCode"] as IReadOnlyDictionary<string, object>;
            var receivedStatus = payload!["requestSmsResult"]!.ToString()!;
            Assert.Equal("SUCCESS", receivedStatus);

            await db.Entry(buergerEntity).ReloadAsync();
            Assert.Null(buergerEntity.Phone);   // unverified number is not persisted until validation
            Assert.False(buergerEntity.IsRegistered);
            Assert.False(buergerEntity.PhoneVerified);
            Assert.Equal(6, buergerEntity.VerificationCode!.Length);

            Assert.Equal(clock.GetCurrentInstant().Plus(Duration.FromMinutes(10)), buergerEntity.VerificationCodeValidUntil);
            Assert.Equal(PhoneHashingService.ComputeHash(telephoneNumber), buergerEntity.VerificationPhoneHash);
            Assert.Equal(clock.GetCurrentInstant(), buergerEntity.VerificationCodeRequestedAt);
            Assert.Equal(0, buergerEntity.VerificationCodeFailedAttempts);

            var smsService = Factory.Services.GetRequiredService<RecordingSmsService>();
            var sms = smsService.SentSms.Last();
            Assert.NotNull(sms);
            Assert.Equal(telephoneNumber, sms.telephoneNumber);
            Assert.Equal($"Der Code für ihre Anmeldung lautet {buergerEntity.VerificationCode}", sms.text);

        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task RequestSMS_ExistingUser() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (buergerEntity, buergerPrincipal) =
            await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var (existingBuerger, existingBuergerPrincipal) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var telephoneNumber = RandomPhoneNumber();

        existingBuerger.Phone = telephoneNumber;
        existingBuerger.PhoneVerified = true;
        existingBuerger.IsRegistered = true;
        await db.SaveChangesAsync();

        var result = await ExecuteQuery(buergerPrincipal, RequestSmsMutation, new Dictionary<string, object?> {
            ["telephoneNumber"] = telephoneNumber,
        });
        var payload = result.Data!["requestSmsCode"] as IReadOnlyDictionary<string, object>;
        var receivedStatus = payload!["requestSmsResult"]!.ToString()!;
        Assert.Equal("SUCCESS", receivedStatus);

        await db.Entry(buergerEntity).ReloadAsync();
        Assert.Null(buergerEntity.Phone);     // we already have a user with this phone number
        Assert.False(buergerEntity.IsRegistered);
        Assert.False(buergerEntity.PhoneVerified);
        Assert.Equal(6, buergerEntity.VerificationCode!.Length);

        var validationInput = new Dictionary<string, object?> {
            ["telephoneNumber"] = telephoneNumber,
            ["validationCode"] = buergerEntity.VerificationCode
        };
        var validateResult = await ExecuteQuery(buergerPrincipal, ValidateSmsMutation, validationInput);
        Assert.Null(result.Errors);
        var validatePayload = validateResult.Data!["validateSmsCode"] as IReadOnlyDictionary<string, object>;
        var validateReceivedStatus = validatePayload!["result"]!.ToString();
        var validateReceivedToken = validatePayload!["token"];
        Assert.Equal("SUCCESS", validateReceivedStatus);

        await db.Entry(buergerEntity).ReloadAsync();
        await db.Entry(existingBuerger).ReloadAsync();

        Assert.Null(buergerEntity.VerificationCode);
        Assert.Null(buergerEntity.VerificationCodeValidUntil);

        var jwtOptions = Factory.Services.GetRequiredService<IOptions<JWTOptions>>().Value;
        var jwtToken = existingBuerger.GetToken(jwtOptions);
        var expectedToken = new JwtSecurityTokenHandler().WriteToken(jwtToken);

        var handler = new JwtSecurityTokenHandler();
        var actualToken = handler.ReadJwtToken(validateReceivedToken!.ToString());
        var tokenUserId = actualToken.Claims.First(c => c.Type == ClaimTypes.NameIdentifier).Value;
        var isRegistered = actualToken.Claims.First(c => c.Type == "is_registered").Value;

        Assert.Equal(existingBuerger.Id.ToString(), tokenUserId);
        Assert.Equal("true", isRegistered);
    }

    [Fact]
    public async Task RequestSmsCode_DoesNotChangeVerifiedPhoneBeforeValidation() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (buergerEntity, buergerPrincipal) =
            await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var verifiedNumber = RandomPhoneNumber();
        buergerEntity.Phone = verifiedNumber;
        buergerEntity.PhoneVerified = true;
        buergerEntity.IsRegistered = true;
        await db.SaveChangesAsync();

        var thirdPartyNumber = RandomPhoneNumber();
        var result = await ExecuteQuery(buergerPrincipal, RequestSmsMutation, new Dictionary<string, object?> {
            ["telephoneNumber"] = thirdPartyNumber,
        });

        Assert.Null(result.Errors);
        var payload = result.Data!["requestSmsCode"] as IReadOnlyDictionary<string, object>;
        Assert.Equal("SUCCESS", payload!["requestSmsResult"]!.ToString());

        await db.Entry(buergerEntity).ReloadAsync();
        Assert.Equal(verifiedNumber, buergerEntity.Phone);
        Assert.True(buergerEntity.PhoneVerified);
    }

    private static string RandomPhoneNumber() {
        var randomNumber = RandomNumberGenerator.GetInt32(100000, 1000000).ToString();
        var telephoneNumber = $"+49 1234 {randomNumber}";
        return telephoneNumber;
    }

    [Fact]
    public async Task RequestSMSInvalidNumber() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (buergerEntity, buergerPrincipal) =
            await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var input = new Dictionary<string, object?> {
            ["telephoneNumber"] = "0681 123456",
        };
        var result = await ExecuteQuery(buergerPrincipal, RequestSmsMutation, input);

        Assert.Null(result.Errors);
        var payload = result.Data!["requestSmsCode"] as IReadOnlyDictionary<string, object>;
        var receivedStatus = payload!["requestSmsResult"]!.ToString()!;
        Assert.Equal("INVALID_FORMAT", receivedStatus);
    }

    [Fact]
    public async Task ValidateSmsCode_HappyPath() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

            clock.AutoAdvance = Duration.Zero;

            var (buergerEntity, buergerPrincipal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

            var telephoneNumber = RandomPhoneNumber();
            var input = new Dictionary<string, object?> {
                ["telephoneNumber"] = telephoneNumber,
            };
            await ExecuteQuery(buergerPrincipal, RequestSmsMutation, input);

            await db.Entry(buergerEntity).ReloadAsync();

            var code = buergerEntity.VerificationCode;

            var validationInput = new Dictionary<string, object?> {
                ["telephoneNumber"] = telephoneNumber,
                ["validationCode"] = code
            };

            var result = await ExecuteQuery(buergerPrincipal, ValidateSmsMutation, validationInput);
            Assert.Null(result.Errors);
            var payload = result.Data!["validateSmsCode"] as IReadOnlyDictionary<string, object>;
            var receivedStatus = payload!["result"]!.ToString();
            var receivedToken = payload["token"]?.ToString();
            Assert.Equal("SUCCESS", receivedStatus);
            Assert.NotNull(receivedToken);

            var actualToken = new JwtSecurityTokenHandler().ReadJwtToken(receivedToken);
            var tokenUserId = actualToken.Claims.First(c => c.Type == ClaimTypes.NameIdentifier).Value;
            var isRegistered = actualToken.Claims.First(c => c.Type == "is_registered").Value;
            Assert.Equal(buergerEntity.Id.ToString(), tokenUserId);
            Assert.Equal("true", isRegistered);

            await db.Entry(buergerEntity).ReloadAsync();
            Assert.True(buergerEntity.IsRegistered);
            Assert.True(buergerEntity.PhoneVerified);
            Assert.Equal(telephoneNumber, buergerEntity.Phone);
            Assert.Equal(clock.GetCurrentInstant(), buergerEntity.RegisteredAt);
            Assert.Null(buergerEntity.VerificationCode);
            Assert.Null(buergerEntity.VerificationCodeValidUntil);

        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task ValidateSmsCode_MasterCode() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (buergerEntity, buergerPrincipal) =
            await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var telephoneNumber = RandomPhoneNumber();
        var input = new Dictionary<string, object?> {
            ["telephoneNumber"] = telephoneNumber,
        };
        await ExecuteQuery(buergerPrincipal, RequestSmsMutation, input);

        var result = await ExecuteQuery(buergerPrincipal, ValidateSmsMutation, new Dictionary<string, object?> {
            ["telephoneNumber"] = telephoneNumber,
            ["validationCode"] = "123456"
        });
        var payload = result.Data!["validateSmsCode"] as IReadOnlyDictionary<string, object>;
        var receivedStatus = payload!["result"]!.ToString();
        Assert.Equal("SUCCESS", receivedStatus);
    }

    [Fact]
    public async Task ValidateSmsCode_CannotUseCodeForDifferentPhoneNumber() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (requestingBuerger, requestingPrincipal) =
            await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var (existingBuerger, _) =
            await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var requestedPhoneNumber = RandomPhoneNumber();
        var existingPhoneNumber = RandomPhoneNumber();
        existingBuerger.Phone = existingPhoneNumber;
        existingBuerger.PhoneVerified = true;
        existingBuerger.IsRegistered = true;
        await db.SaveChangesAsync();

        await ExecuteQuery(requestingPrincipal, RequestSmsMutation, new Dictionary<string, object?> {
            ["telephoneNumber"] = requestedPhoneNumber,
        });
        await db.Entry(requestingBuerger).ReloadAsync();

        var result = await ExecuteQuery(requestingPrincipal, ValidateSmsMutation, new Dictionary<string, object?> {
            ["telephoneNumber"] = existingPhoneNumber,
            ["validationCode"] = requestingBuerger.VerificationCode,
        });

        Assert.Null(result.Errors);
        var payload = result.Data!["validateSmsCode"] as IReadOnlyDictionary<string, object>;
        Assert.NotEqual("SUCCESS", payload!["result"]!.ToString());
        Assert.Null(payload["token"]);

        await db.Entry(requestingBuerger).ReloadAsync();
        Assert.False(requestingBuerger.IsDeleted);
    }

    [Fact]
    public async Task ValidateSmsCode_ExpiredCodeIsInvalidated() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (buerger, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();

            await ExecuteQuery(principal, RequestSmsMutation, new Dictionary<string, object?> {
                ["telephoneNumber"] = telephoneNumber,
            });
            await db.Entry(buerger).ReloadAsync();
            var expiredCode = buerger.VerificationCode;
            clock.Advance(Duration.FromMinutes(11));

            var result = await ExecuteQuery(principal, ValidateSmsMutation, new Dictionary<string, object?> {
                ["telephoneNumber"] = telephoneNumber,
                ["validationCode"] = expiredCode,
            });

            Assert.Null(result.Errors);
            var payload = result.Data!["validateSmsCode"] as IReadOnlyDictionary<string, object>;
            Assert.Equal("CODE_EXPIRED", payload!["result"]!.ToString());

            await db.Entry(buerger).ReloadAsync();
            Assert.Null(buerger.VerificationCode);
            Assert.Null(buerger.VerificationCodeValidUntil);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task RequestSmsCode_EnforcesResendCooldown() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (_, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();
            var input = new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber };

            var firstResult = await ExecuteQuery(principal, RequestSmsMutation, input);
            var secondResult = await ExecuteQuery(principal, RequestSmsMutation, input);

            Assert.Null(firstResult.Errors);
            Assert.Contains(secondResult.Errors!, error => error.Code == "RATE_LIMIT");
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task RequestSmsCode_AfterCooldownInvalidatesPreviousCode() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (buerger, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();
            var input = new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber };

            await ExecuteQuery(principal, RequestSmsMutation, input);
            await db.Entry(buerger).ReloadAsync();
            var firstCode = buerger.VerificationCode;

            clock.Advance(Duration.FromSeconds(31));
            await ExecuteQuery(principal, RequestSmsMutation, input);

            var oldCodeResult = await ExecuteQuery(principal, ValidateSmsMutation,
                new Dictionary<string, object?> {
                    ["telephoneNumber"] = telephoneNumber,
                    ["validationCode"] = firstCode,
                });

            Assert.Null(oldCodeResult.Errors);
            var payload = oldCodeResult.Data!["validateSmsCode"] as IReadOnlyDictionary<string, object>;
            Assert.Equal("INVALID_CODE", payload!["result"]!.ToString());
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task RequestSmsCode_InvalidatesOpenCodeOfOtherAccountForSamePhone() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (buergerA, principalA) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var (_, principalB) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();
            var input = new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber };

            await ExecuteQuery(principalA, RequestSmsMutation, input);
            await db.Entry(buergerA).ReloadAsync();
            var codeA = buergerA.VerificationCode;

            var tooEarly = await ExecuteQuery(principalB, RequestSmsMutation, input);
            Assert.Contains(tooEarly.Errors!, error => error.Code == "RATE_LIMIT");

            clock.Advance(Duration.FromSeconds(31));
            var second = await ExecuteQuery(principalB, RequestSmsMutation, input);
            Assert.Null(second.Errors);

            var result = await ExecuteQuery(principalA, ValidateSmsMutation,
                new Dictionary<string, object?> {
                    ["telephoneNumber"] = telephoneNumber,
                    ["validationCode"] = codeA,
                });
            var payload = result.Data!["validateSmsCode"] as IReadOnlyDictionary<string, object>;
            Assert.Equal("NO_VERIFICATION_CODE_REQUESTED", payload!["result"]!.ToString());
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task RequestSmsCode_ConcurrentRequestsForSamePhoneLeaveOneValidCode() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (buergerA, principalA) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var (buergerB, principalB) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var input = new Dictionary<string, object?> { ["telephoneNumber"] = RandomPhoneNumber() };

            var results = await Task.WhenAll(
                ExecuteQuery(principalA, RequestSmsMutation, input),
                ExecuteQuery(principalB, RequestSmsMutation, input));

            Assert.Equal(1, results.Count(result => result.Errors is null));
            await db.Entry(buergerA).ReloadAsync();
            await db.Entry(buergerB).ReloadAsync();
            Assert.Equal(1, new[] { buergerA, buergerB }.Count(b => b.VerificationCode is not null));
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task ValidateSmsCode_FiveFailedAttemptsLockChallenge() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (buerger, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();

            await ExecuteQuery(principal, RequestSmsMutation,
                new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber });

            for (var attempt = 1; attempt <= 4; attempt++) {
                var payload = await ValidateWrongCode(principal, telephoneNumber);
                Assert.Equal("INVALID_CODE", payload["result"]!.ToString());
                Assert.Equal(5 - attempt, payload["remainingAttempts"]);
                Assert.Null(payload["retryAfterSeconds"]);
            }

            var lockingPayload = await ValidateWrongCode(principal, telephoneNumber);
            Assert.Equal("CODE_LOCKED", lockingPayload["result"]!.ToString());
            Assert.Equal(15 * 60, lockingPayload["retryAfterSeconds"]);

            await db.Entry(buerger).ReloadAsync();
            Assert.Null(buerger.VerificationCode);
            Assert.Null(buerger.VerificationPhoneHash);
            Assert.Equal(clock.GetCurrentInstant().Plus(Duration.FromMinutes(15)),
                buerger.VerificationCodeLockedUntil);

            var requestWhileLocked = await ExecuteQuery(principal, RequestSmsMutation,
                new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber });
            var rateLimitError = Assert.Single(requestWhileLocked.Errors!, error => error.Code == "RATE_LIMIT");
            Assert.Equal(15 * 60, rateLimitError.Extensions!["retryAfterSeconds"]);

            clock.Advance(Duration.FromMinutes(5));
            var whileLocked = await ValidateWrongCode(principal, telephoneNumber);
            Assert.Equal("CODE_LOCKED", whileLocked["result"]!.ToString());
            Assert.Equal(10 * 60, whileLocked["retryAfterSeconds"]);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task ValidateSmsCode_ParallelWrongCodesNeverExceedTheAttemptLimit() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (buerger, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();
            await ExecuteQuery(principal, RequestSmsMutation,
                new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber });

            var payloads = await Task.WhenAll(Enumerable.Range(0, 20)
                .Select(_ => ValidateWrongCode(principal, telephoneNumber)));

            var invalid = payloads.Count(p => p["result"]!.ToString() == "INVALID_CODE");
            var locked = payloads.Count(p => p["result"]!.ToString() == "CODE_LOCKED");
            Assert.InRange(invalid, 0, 4);
            Assert.Equal(20, invalid + locked);
            await db.Entry(buerger).ReloadAsync();
            Assert.Equal(5, buerger.VerificationCodeFailedAttempts);
            Assert.NotNull(buerger.VerificationCodeLockedUntil);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task ValidateSmsCode_AttemptBeyondTheLimitWithoutStoredLockPersistsTheLock() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (buerger, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();
            await ExecuteQuery(principal, RequestSmsMutation,
                new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber });
            await db.Buerger.Where(b => b.Id == buerger.Id)
                .ExecuteUpdateAsync(s => s.SetProperty(b => b.VerificationCodeFailedAttempts, 5));

            var payload = await ValidateWrongCode(principal, telephoneNumber);

            Assert.Equal("CODE_LOCKED", payload["result"]!.ToString());
            await db.Entry(buerger).ReloadAsync();
            Assert.Null(buerger.VerificationCode);
            Assert.Equal(clock.GetCurrentInstant().Plus(Duration.FromMinutes(15)),
                buerger.VerificationCodeLockedUntil);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task ValidateSmsCode_CorrectCodeAfterWrongAttemptsSucceedsAndResetsTheCounter() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (buerger, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();
            await ExecuteQuery(principal, RequestSmsMutation,
                new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber });
            await ValidateWrongCode(principal, telephoneNumber);
            await ValidateWrongCode(principal, telephoneNumber);
            await db.Entry(buerger).ReloadAsync();

            var result = await ExecuteQuery(principal, ValidateSmsMutation,
                new Dictionary<string, object?> {
                    ["telephoneNumber"] = telephoneNumber,
                    ["validationCode"] = buerger.VerificationCode,
                });

            Assert.Null(result.Errors);
            var payload = (IReadOnlyDictionary<string, object?>)result.Data!["validateSmsCode"]!;
            Assert.Equal("SUCCESS", payload["result"]!.ToString());
            await db.Entry(buerger).ReloadAsync();
            Assert.Equal(0, buerger.VerificationCodeFailedAttempts);
            Assert.Null(buerger.VerificationCode);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task RequestSmsCode_RejectedRequestsSendNoSms() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var smsService = Factory.Services.GetRequiredService<RecordingSmsService>();
            var (_, principalA) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var (_, principalB) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = RandomPhoneNumber();
            var input = new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber };
            var sentBefore = smsService.SentSms.Count;

            var first = await ExecuteQuery(principalA, RequestSmsMutation, input);
            var sameAccountWhileCooling = await ExecuteQuery(principalA, RequestSmsMutation, input);
            var otherAccountWhileCooling = await ExecuteQuery(principalB, RequestSmsMutation, input);

            Assert.Null(first.Errors);
            Assert.Contains(sameAccountWhileCooling.Errors!, error => error.Code == "RATE_LIMIT");
            Assert.Contains(otherAccountWhileCooling.Errors!, error => error.Code == "RATE_LIMIT");
            Assert.Equal(sentBefore + 1, smsService.SentSms.Count);

            for (var attempt = 0; attempt < 5; attempt++) {
                await ValidateWrongCode(principalA, telephoneNumber);
            }

            clock.Advance(Duration.FromSeconds(31));
            var whileLocked = await ExecuteQuery(principalA, RequestSmsMutation, input);

            Assert.Contains(whileLocked.Errors!, error => error.Code == "RATE_LIMIT");
            Assert.Equal(sentBefore + 1, smsService.SentSms.Count);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    private async Task<IReadOnlyDictionary<string, object?>> ValidateWrongCode(
        ClaimsPrincipal principal, string telephoneNumber) {
        var result = await ExecuteQuery(principal, ValidateSmsMutation,
            new Dictionary<string, object?> {
                ["telephoneNumber"] = telephoneNumber,
                ["validationCode"] = "000000",
            });
        Assert.Null(result.Errors);
        return (IReadOnlyDictionary<string, object?>)result.Data!["validateSmsCode"]!;
    }

}
