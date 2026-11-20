using API.Features.Auth;
using API.Infrastructure.Exceptions;
using Sentry;

namespace API.Infrastructure;

/// <summary>Filtert und verarbeitet GraphQL-Fehler für das Backend.</summary>
public class GraphQLErrorFilter : IErrorFilter {
    private readonly ILogger<GraphQLErrorFilter> _logger;

    /// <summary>Initialisiert eine neue Instanz des GraphQLErrorFilter mit einem Logger.</summary>
    /// <param name="logger">Logger zur Protokollierung von Fehlern.</param>
    public GraphQLErrorFilter(ILogger<GraphQLErrorFilter> logger) {
        _logger = logger;
    }

    /// <summary>Verarbeitet einen GraphQL-Fehler und gibt eine angepasste Fehlerinstanz zurück.</summary>
    /// <param name="error">Der ursprüngliche Fehler.</param>
    /// <returns>Ein angepasster Fehler mit möglichem Fehlercode und Nachricht.</returns>
    public IError OnError(IError error) {
        if (error.Exception != null &&
            error.Exception is not (CurrentUserAccessor.Unauthenticated or NotAllowedException)) {
            SentrySdk.CaptureException(error.Exception);
            _logger.LogWarning(error.Exception, "Error in GraphQL: {Error}", error);
        }

        // If the error already has a code (i.e. from Hot Chocolate Authentication,
        // we want to re-use it.
        if (!string.IsNullOrEmpty(error.Code)) {
            return error;
        }

        return error.Exception switch {
            DomainException e => WithRetryAfter(CreateError(
                error,
                ErrorCodeType.ExceptionTypeNameToGraphQLCode(e.GetType()),
                e.Message
            ), e),
#if DEBUG
            _ => CreateError(error, "UNKNOWN", error.Message)
#else
            _ => CreateError(error, "UNKNOWN", "Unknown Error")
#endif
        };
    }

    /// <summary>Erstellt einen neuen Fehler mit spezifischer Nachricht und Fehlercode.</summary>
    /// <param name="error">Der ursprüngliche Fehler.</param>
    /// <param name="code">Der Fehlercode als String.</param>
    /// <param name="message">Die Fehlermeldung.</param>
    /// <returns>Ein modifizierter Fehler mit Nachricht und Code.</returns>
    private static IError CreateError(IError error, string code, string message) {
        return error
            .WithMessage(message)
            .WithCode(code);
    }

    private static IError WithRetryAfter(IError error, DomainException exception) {
        return exception is RateLimitException { RetryAfter: { } retryAfter }
            ? error.SetExtension("retryAfterSeconds", (int)Math.Ceiling(retryAfter.TotalSeconds))
            : error;
    }
}
