
namespace API.Infrastructure.Exceptions;

/// <summary>Repräsentiert eine Ausnahme, die ausgelöst wird, wenn das Rate Limit überschritten wurde.</summary>
/// <param name="nextTry">Optionaler Zeitraum, nach dem ein erneuter Versuch erlaubt ist.</param>
public class RateLimitException(TimeSpan? nextTry) : DomainException("Rate Limit exceeded") {
    public TimeSpan? RetryAfter { get; } = nextTry;
}
