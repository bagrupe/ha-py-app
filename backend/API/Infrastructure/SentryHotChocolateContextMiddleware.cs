using HotChocolate.Execution;
using Sentry;
using RequestDelegate = HotChocolate.Execution.RequestDelegate;

namespace API.Infrastructure;

/// <summary>Middleware zur Anreicherung des Sentry-Kontexts mit HotChocolate-Anfragedaten, sofern keine vertraulichen Informationen enthalten sind.</summary>
public class SentryHotChocolateContextMiddleware {
    private readonly RequestDelegate _next;

    /// <summary>Initialisiert die Middleware mit dem nächsten RequestDelegate.</summary>
    /// <param name="next">Der nächste Middleware-Schritt im Pipeline-Verlauf.</param>
    public SentryHotChocolateContextMiddleware(RequestDelegate next) {
        _next = next;
    }

    /// <summary>Fügt dem Sentry-Kontext HotChocolate-spezifische Daten hinzu, wenn keine vertraulichen Variablen erkannt werden, und ruft den nächsten Middleware-Schritt auf.</summary>
    /// <param name="context">Der Kontext der aktuellen HotChocolate-Anfrage.</param>
    public async Task InvokeAsync(IRequestContext context) {
        var variableNames = context.Request.VariableValues?.Keys ?? Enumerable.Empty<string>();
        var stringifiedQuery = context.Request.Query?.ToString() ?? "";
        var isConfidential = IsConfidential(variableNames, stringifiedQuery);

        if (!isConfidential) {
            SentrySdk.ConfigureScope(s => {
                s.Contexts["HotChocolate"] = new {
                    context.Request.VariableValues,
                    Query = stringifiedQuery
                };
            });
        }

        await _next.Invoke(context);
    }

    private static readonly string[] ConfidentialKeywords =
        ["auth", "password", "token", "login", "secret", "privatekey", "keyescrow", "sms", "phone"];

    public static bool IsConfidential(IEnumerable<string> variableNames, string query) =>
        variableNames.Append(query)
            .Select(x => x.ToLowerInvariant())
            .Any(text => ConfidentialKeywords.Any(text.Contains));
}
