using API.Infrastructure;
using API.Infrastructure.Exceptions;
using Microsoft.Extensions.Logging.Abstractions;

namespace IntegrationTests;

public class RateLimitServiceTest {
    [Fact]
    public void Limit_TracksPhoneHashesIndependently() {
        using var service = new RateLimitService(
            NullLogger<RateLimitService>.Instance,
            new RateLimitOptions { IgnoreRateLimit = false });
        var phoneA = new RateLimitService.LimiterKey("SMS_phone-a-hash", 3, TimeSpan.FromHours(1));
        var phoneB = new RateLimitService.LimiterKey("SMS_phone-b-hash", 3, TimeSpan.FromHours(1));

        service.Limit(default, [phoneA]);
        service.Limit(default, [phoneA]);
        service.Limit(default, [phoneA]);

        Assert.Throws<RateLimitException>(() => service.Limit(default, [phoneA]));
        service.Limit(default, [phoneB]);
    }

    [Theory]
    [InlineData(30, 3, 10)]
    [InlineData(60, 4, 15)]
    [InlineData(1, 3, 0.3333333)]
    public void SmsRequestTokenRefill_DividesWindowByMaxRequests(int windowMinutes, int maxRequests, double expectedMinutes) {
        var options = new RateLimitOptions {
            SmsRequestWindowMinutes = windowMinutes,
            SmsMaxRequestsPerWindow = maxRequests,
        };

        Assert.Equal(expectedMinutes, options.SmsRequestTokenRefill.TotalMinutes, 5);
    }

    [Fact]
    public void Validate_RejectsZeroMaxRequests() {
        var options = new RateLimitOptions { SmsMaxRequestsPerWindow = 0 };

        Assert.Throws<System.ComponentModel.DataAnnotations.ValidationException>(options.Validate);
    }

    [Theory]
    [InlineData(15, 5, 3, 15, 1)]
    [InlineData(10, 4, 2, 8, 1.25)]
    public void SmsValidationLimit_CoversAllCodesOfOneRequestWindow(
        int windowMinutes, int maxAttempts, int maxRequests, int expectedCalls, double expectedRefillMinutes) {
        var options = new RateLimitOptions {
            SmsValidationWindowMinutes = windowMinutes,
            SmsMaxFailedAttempts = maxAttempts,
            SmsMaxRequestsPerWindow = maxRequests,
        };

        Assert.Equal(expectedCalls, options.SmsValidationMaxCalls);
        Assert.Equal(expectedRefillMinutes, options.SmsValidationTokenRefill.TotalMinutes, 5);
    }
}
