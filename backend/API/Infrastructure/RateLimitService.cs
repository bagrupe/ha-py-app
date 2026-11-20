using System.Collections.Concurrent;
using System.ComponentModel.DataAnnotations;
using System.Threading.RateLimiting;
using API.Features.Auth;
using API.Infrastructure.Exceptions;
using NetEscapades.Configuration.Validation;

namespace API.Infrastructure;

/// <summary>Verwaltet die Rate-Limiting-Logik mit Token-Bucket-Mechanismus und periodischer Auffüllung.</summary>
public class RateLimitService : IDisposable, IAsyncDisposable {
    private readonly ConcurrentDictionary<LimiterKey, TokenBucketRateLimiter> _limiters = new();
    private readonly ILogger<RateLimitService> _logger;
    private readonly Timer _timer;
    private readonly RateLimitOptions _options;

    /// <summary>Initialisiert den Dienst mit Logger und Konfigurationsoptionen.</summary>
    public RateLimitService(ILogger<RateLimitService> logger, RateLimitOptions options) {
        _logger = logger;
        _options = options;
        _timer = new Timer(Replenish, this, TimeSpan.FromSeconds(5), TimeSpan.FromSeconds(5));
    }

    /// <summary>Füllt die Token-Buckets periodisch auf und entfernt volle Buckets.</summary>
    private void Replenish(object? _) {
        foreach (var kvp in _limiters) {
            kvp.Value.TryReplenish();
            if (kvp.Value.GetStatistics()?.CurrentAvailablePermits == kvp.Key.MaxTokens) {
                _limiters.TryRemove(kvp.Key, out var _);
            }
        }
    }

    /// <summary>Prüft und erzwingt die Rate-Limits anhand der übergebenen Schlüssel.</summary>
    /// <param name="ct">Abbruch-Token für die Operation.</param>
    /// <param name="limiterKeys">Array von Limitierungsschlüsseln.</param>
    public void Limit(CancellationToken ct, LimiterKey[] limiterKeys) {
        if (_options.IgnoreRateLimit) {
            return;
        }

        foreach (var limiterKey in limiterKeys) {
            var bucket = _limiters.GetOrAdd(limiterKey, CreateBucket);
            var lease = bucket.AttemptAcquire();
            if (!lease.IsAcquired) {
                _logger.Log(LogLevel.Information, "Rate limit reached {Name}", limiterKey);

                var hasNextTry = lease.TryGetMetadata(MetadataName.RetryAfter, out var nextTry);
                if (hasNextTry) {
                    throw new RateLimitException(nextTry);
                }

                throw new RateLimitException(null);
            }
        }
    }

    /// <summary>Erzeugt einen neuen Token-Bucket-RateLimiter für den angegebenen Schlüssel.</summary>
    /// <param name="limiterKey">Der Schlüssel mit Limit-Parametern.</param>
    /// <returns>Ein konfigurierter TokenBucketRateLimiter.</returns>
    private TokenBucketRateLimiter CreateBucket(LimiterKey limiterKey) {
        return new TokenBucketRateLimiter(new TokenBucketRateLimiterOptions {
            TokenLimit = limiterKey.MaxTokens,
            QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
            AutoReplenishment = false,
            ReplenishmentPeriod = limiterKey.TimeSpan,
            TokensPerPeriod = 1,
        });
    }

    /// <summary>Repräsentiert einen Schlüssel für die Limitierung mit Abhängigkeit, Maximaltokens und Zeitraum.</summary>
    /// <param name="Dependant">Abhängiger Bezeichner (z.B. IP oder User).</param>
    /// <param name="MaxTokens">Maximale Anzahl Tokens im Bucket.</param>
    /// <param name="TimeSpan">Zeitraum für die Token-Auffüllung.</param>
    public record LimiterKey(string Dependant, int MaxTokens, TimeSpan TimeSpan);

    /// <summary>Gibt Ressourcen frei.</summary>
    public void Dispose() {
        _timer.Dispose();
    }

    /// <summary>Gibt asynchron Ressourcen frei.</summary>
    public async ValueTask DisposeAsync() {
        await _timer.DisposeAsync();
    }
}

/// <summary>Stellt eine Schnittstelle zur Anwendung von Rate-Limits basierend auf IP oder Benutzer bereit.</summary>
public class RateLimit {
    private readonly CurrentUserAccessor _currentUserAccessor;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly RateLimitService _service;

    /// <summary>Initialisiert die RateLimit-Instanz mit den benötigten Abhängigkeiten.</summary>
    public RateLimit(RateLimitService service, IHttpContextAccessor httpContextAccessor,
        CurrentUserAccessor currentUserAccessor) {
        _service = service;
        _httpContextAccessor = httpContextAccessor;
        _currentUserAccessor = currentUserAccessor;
    }

    /// <summary>Wendet die Limitierung auf die angegebenen Definitionen an.</summary>
    /// <param name="ct">Abbruch-Token für die Operation.</param>
    /// <param name="limitDefinitions">Limit-Definitionen, z.B. IP- oder Benutzerlimits.</param>
    public async Task Limit(CancellationToken ct, params ILimitDefinition[] limitDefinitions) {
        var limiterKeys = new RateLimitService.LimiterKey[limitDefinitions.Length];

        for (var i = 0; i < limitDefinitions.Length; i++) {
            limiterKeys[i] = await ToLimiterKey(limitDefinitions[i]);
        }

        _service.Limit(ct, limiterKeys);
    }

    /// <summary>Konvertiert eine Limit-Definition in einen LimiterKey.</summary>
    /// <param name="limitDefinition">Die Limit-Definition.</param>
    /// <returns>Den entsprechenden LimiterKey.</returns>
    private ValueTask<RateLimitService.LimiterKey> ToLimiterKey(ILimitDefinition limitDefinition) {
        if (limitDefinition is IpLimit ipLimit) {
            return ValueTask.FromResult(new RateLimitService.LimiterKey(
                $"IP_{ipLimit.Name}_{_httpContextAccessor.HttpContext?.Connection.RemoteIpAddress}",
                ipLimit.MaxTokens, ipLimit.TimeSpan));
        }

        if (limitDefinition is UserLimit userLimit) {
            return ValueTask.FromResult(new RateLimitService.LimiterKey($"User_{userLimit.Name}_{_currentUserAccessor.UserId()}",
                userLimit.MaxTokens,
                userLimit.TimeSpan));
        }

        if (limitDefinition is KeyLimit keyLimit) {
            return ValueTask.FromResult(new RateLimitService.LimiterKey(
                $"Key_{keyLimit.Name}_{keyLimit.Key}", keyLimit.MaxTokens, keyLimit.TimeSpan));
        }

        throw new NotImplementedException();
    }

    /// <summary>Markiert eine Limit-Definition.</summary>
    public interface ILimitDefinition {
    }

    /// <summary>Limit-Definition für IP-Adressen.</summary>
    /// <param name="Name">Name des Limits.</param>
    /// <param name="MaxTokens">Maximale Tokenanzahl.</param>
    /// <param name="TimeSpan">Zeitraum für Token-Auffüllung.</param>
    public record IpLimit(string Name, int MaxTokens, TimeSpan TimeSpan) : ILimitDefinition;

    /// <summary>Limit-Definition für Benutzer.</summary>
    /// <param name="Name">Name des Limits.</param>
    /// <param name="MaxTokens">Maximale Tokenanzahl.</param>
    /// <param name="TimeSpan">Zeitraum für Token-Auffüllung.</param>
    public record UserLimit(string Name, int MaxTokens, TimeSpan TimeSpan) : ILimitDefinition;

    /// <summary>Limit für einen bereits datenschutzgerecht abgeleiteten Schlüssel.</summary>
    public record KeyLimit(string Name, string Key, int MaxTokens, TimeSpan TimeSpan) : ILimitDefinition;
}

/// <summary>Optionen zur Konfiguration des Rate-Limit-Verhaltens.</summary>
public class RateLimitOptions : IValidatable {
    /// <summary>Deaktiviert die Rate-Limitierung, wenn true.</summary>
    public bool IgnoreRateLimit { get; set; } = false;

    public int SmsRequestWindowMinutes { get; set; } = 30;

    [Range(1, int.MaxValue)]
    public int SmsMaxRequestsPerWindow { get; set; } = 3;

    public TimeSpan SmsRequestTokenRefill => TimeSpan.FromMinutes(SmsRequestWindowMinutes) / SmsMaxRequestsPerWindow;

    public int SmsValidationWindowMinutes { get; set; } = 15;

    public int SmsMaxFailedAttempts { get; set; } = 5;

    public int SmsValidationMaxCalls => Math.Max(1, SmsMaxRequestsPerWindow) * Math.Max(1, SmsMaxFailedAttempts);

    public TimeSpan SmsValidationTokenRefill => TimeSpan.FromMinutes(SmsValidationWindowMinutes) / SmsValidationMaxCalls;

    public int SmsVerificationLockMinutes { get; set; } = 15;

    public int SmsResendCooldownSeconds { get; set; } = 30;

    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
