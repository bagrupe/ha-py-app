using System.Security.Cryptography;
using API.Features;
using HotChocolate.Execution;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using NodaTime.Testing;

namespace IntegrationTests;

public class RateLimitedApiFactory : BackendApiFactory {
    protected override IReadOnlyDictionary<string, string?> ConfigurationOverrides =>
        new Dictionary<string, string?> { ["RateLimit:IgnoreRateLimit"] = "false" };

    protected override bool ResetsTestDatabase => false;
}

[Collection("Api Tests")]
public class EhrenamtsbankSmsRateLimitTest(RateLimitedApiFactory factory)
    : GraphQLTests(factory), IClassFixture<RateLimitedApiFactory> {
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
                retryAfterSeconds
            }
        }
        """;

    [Fact]
    public async Task RequestSmsCode_RejectedAttemptDoesNotConsumeRateLimitToken() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (_, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var input = new Dictionary<string, object?> {
                ["telephoneNumber"] = $"+49 1234 {RandomNumberGenerator.GetInt32(100000, 1000000)}",
            };

            var first = await ExecuteQuery(principal, RequestSmsMutation, input);
            var rejectedByCooldown = await ExecuteQuery(principal, RequestSmsMutation, input);
            clock.Advance(Duration.FromSeconds(31));
            var second = await ExecuteQuery(principal, RequestSmsMutation, input);
            clock.Advance(Duration.FromSeconds(31));
            var third = await ExecuteQuery(principal, RequestSmsMutation, input);
            clock.Advance(Duration.FromSeconds(31));
            var rejectedByBucket = await ExecuteQuery(principal, RequestSmsMutation, input);

            Assert.Null(first.Errors);
            Assert.Contains(rejectedByCooldown.Errors!, error => error.Code == "RATE_LIMIT");
            Assert.Null(second.Errors);
            Assert.Null(third.Errors);
            Assert.Contains(rejectedByBucket.Errors!, error => error.Code == "RATE_LIMIT");
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task ValidateSmsCode_ClicksWhileLockedKeepReportingTheLockTime() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (_, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = $"+49 1234 {RandomNumberGenerator.GetInt32(100000, 1000000)}";
            await ExecuteQuery(principal, RequestSmsMutation,
                new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber });

            IQueryResult? last = null;
            for (var attempt = 1; attempt <= 9; attempt++) {
                last = await ExecuteQuery(principal, ValidateSmsMutation,
                    new Dictionary<string, object?> {
                        ["telephoneNumber"] = telephoneNumber,
                        ["validationCode"] = "000000",
                    });
                Assert.Null(last.Errors);
            }

            var payload = (IReadOnlyDictionary<string, object?>)last!.Data!["validateSmsCode"]!;
            Assert.Equal("CODE_LOCKED", payload["result"]!.ToString());
            Assert.Equal(15 * 60, payload["retryAfterSeconds"]);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    [Fact]
    public async Task ValidateSmsCode_WrongCodesAcrossNewCodesReachTheLockBeforeTheRateLimit() {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;

        try {
            clock.AutoAdvance = Duration.Zero;
            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var (_, principal) =
                await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
            var telephoneNumber = $"+49 1234 {RandomNumberGenerator.GetInt32(100000, 1000000)}";

            for (var code = 0; code < 3; code++) {
                var request = await ExecuteQuery(principal, RequestSmsMutation,
                    new Dictionary<string, object?> { ["telephoneNumber"] = telephoneNumber });
                Assert.Null(request.Errors);

                for (var attempt = 1; attempt <= 4; attempt++) {
                    var result = await ExecuteQuery(principal, ValidateSmsMutation,
                        new Dictionary<string, object?> {
                            ["telephoneNumber"] = telephoneNumber,
                            ["validationCode"] = "000000",
                        });
                    Assert.Null(result.Errors);
                    var payload = (IReadOnlyDictionary<string, object?>)result.Data!["validateSmsCode"]!;
                    Assert.Equal("INVALID_CODE", payload["result"]!.ToString());
                }

                clock.Advance(Duration.FromSeconds(31));
            }
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }
}
