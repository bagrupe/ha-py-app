using System.Collections.Immutable;
using System.Diagnostics;
using System.Text.Json;
using HotChocolate.Execution;
using HotChocolate.Execution.Processing;
using HotChocolate.Language;
using HotChocolate.Resolvers;
using Path = HotChocolate.Path;

namespace API.Infrastructure;

/// <summary>
/// Fügt einen benutzerdefinierten Middleware-Kontext in Hot Chocolate ein.
/// </summary>
public class StitchingFieldResolverHelperMiddleware {
    private readonly FieldDelegate _next;

    /// <summary>
    /// Initialisiert die Middleware mit dem nächsten Delegaten.
    /// </summary>
    /// <param name="next">Der nächste Middleware-Delegat.</param>
    public StitchingFieldResolverHelperMiddleware(FieldDelegate next) {
        _next = next;
    }

    /// <summary>
    /// Führt die Middleware asynchron aus und übergibt den angepassten Kontext.
    /// </summary>
    /// <param name="context">Der aktuelle Middleware-Kontext.</param>
    public async Task InvokeAsync(IMiddlewareContext context) {
        await _next(new StitchingFieldResolverHelperMiddlewareContext(context));
    }
}

/// <summary>
/// Stellt eine tiefe Deserialisierung von JsonElement in Dictionary oder andere Objekte sicher.
/// </summary>
static class DeepDeserializeToDictionary {
    internal static object? DeepDeserialize(this JsonElement jsonElement) {
        return jsonElement.ValueKind switch {
            JsonValueKind.Undefined => null,
            JsonValueKind.Object => jsonElement.EnumerateObject().Select(prop => new { prop.Name, Value = DeepDeserialize(prop.Value) }).ToDictionary(p => p.Name, p => p.Value),
            JsonValueKind.Array => jsonElement.EnumerateArray().Select(DeepDeserialize).ToList(),
            JsonValueKind.String => jsonElement.GetString(),
            JsonValueKind.Number => jsonElement.GetDouble(),
            JsonValueKind.True => true,
            JsonValueKind.False => false,
            JsonValueKind.Null => null,
            _ => throw new ArgumentOutOfRangeException()
        };
    }
}

/// <summary>
/// Benutzerdefinierter Middleware-Kontext, der eine eigene Implementierung von Parent&lt;T&gt; bereitstellt.
/// Alle anderen Aufrufe und Eigenschaften werden an den übergebenen Delegaten weitergeleitet.
/// </summary>
public class StitchingFieldResolverHelperMiddlewareContext : IMiddlewareContext {
    private readonly IMiddlewareContext _delegate;

    /// <summary>
    /// Initialisiert den Kontext mit einem bestehenden Middleware-Kontext als Delegaten.
    /// </summary>
    /// <param name="delegate">Der zu delegierende Middleware-Kontext.</param>
    public StitchingFieldResolverHelperMiddlewareContext(IMiddlewareContext @delegate) {
        _delegate = @delegate;
    }

    /// <summary>
    /// Überschreibt die Parent-Methode, um bei speziellen Aufrufern das Parent-Objekt in ein Dictionary zu serialisieren.
    /// </summary>
    /// <typeparam name="T">Der erwartete Typ des Parent-Objekts.</typeparam>
    /// <returns>Das Parent-Objekt oder eine serialisierte Dictionary-Darstellung.</returns>
    public T Parent<T>() {
        var stacktrace = new StackTrace();
        var callerFrame = stacktrace.GetFrame(1);

        var parent = _delegate.Parent<T>();

        const string fieldScopedVariableResolverName =
            "HotChocolate.Stitching.Delegation.ScopedVariables.FieldScopedVariableResolver";

        if (callerFrame is null
            || callerFrame.GetMethod()?.DeclaringType?.FullName != fieldScopedVariableResolverName
            || typeof(T) != typeof(object)) return parent;

        if (parent is Dictionary<string, object> dict) {
            foreach (var key in dict.Keys) {
                var value = dict[key];
                if (value is IValueNode valueNode) {
                    dict[key] = valueNode.Value!;
                }
            }
        }

        if (typeof(T) == typeof(object)) {
            var json = JsonSerializer.SerializeToElement(parent,
                new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase });

            return (T)json.DeepDeserialize()!;
        }

        return parent!;
    }

    #region delegation
    public IDictionary<string, object?> ContextData { get => _delegate.ContextData; }
    public T ArgumentValue<T>(string name) => _delegate.ArgumentValue<T>(name);
    public TValueNode ArgumentLiteral<TValueNode>(string name) where TValueNode : IValueNode => _delegate.ArgumentLiteral<TValueNode>(name);
    public Optional<T> ArgumentOptional<T>(string name) => _delegate.ArgumentOptional<T>(name);
    public ValueKind ArgumentKind(string name) => _delegate.ArgumentKind(name);
    public T Service<T>() where T : notnull {
        return _delegate.Service<T>();
    }
    public T? Service<T>(object key) where T : notnull {
        return _delegate.Service<T>(key);
    }

    public T Resolver<T>() => _delegate.Resolver<T>();
    public ISchema Schema { get => _delegate.Schema; }
    public IObjectType ObjectType { get => _delegate.ObjectType; }
    public IOperation Operation { get => _delegate.Operation; }
    public ISelection Selection { get => _delegate.Selection; }
    public IVariableValueCollection Variables { get => _delegate.Variables; }
    public Path Path { get => _delegate.Path; }
    public IImmutableDictionary<string, object?> ScopedContextData { get => _delegate.ScopedContextData; set => _delegate.ScopedContextData = value; }
    public IImmutableDictionary<string, object?> LocalContextData { get => _delegate.LocalContextData; set => _delegate.LocalContextData = value; }
    public CancellationToken RequestAborted { get => _delegate.RequestAborted; }
    public object Service(Type service) => _delegate.Service(service);
    public void ReportError(string errorMessage) => _delegate.ReportError(errorMessage);
    public void ReportError(IError error) => _delegate.ReportError(error);
    public void ReportError(Exception exception, Action<IErrorBuilder>? configure = null) => _delegate.ReportError(exception, configure);
    public IReadOnlyList<ISelection> GetSelections(IObjectType typeContext, ISelection? selection = null, bool allowInternals = false) => _delegate.GetSelections(typeContext, selection, allowInternals);
    public T GetQueryRoot<T>() => _delegate.GetQueryRoot<T>();
    public IMiddlewareContext Clone() => _delegate.Clone();
    public IType? ValueType { get => _delegate.ValueType; set => _delegate.ValueType = value; }
    public object? Result { get => _delegate.Result; set => _delegate.Result = value; }
    public bool IsResultModified { get => _delegate.IsResultModified; }
    public IOperationResultBuilder OperationResult { get => _delegate.OperationResult; }
    public ValueTask<T> ResolveAsync<T>() => _delegate.ResolveAsync<T>();
    public void RegisterForCleanup(Func<ValueTask> action, CleanAfter cleanAfter = CleanAfter.Resolver) => _delegate.RegisterForCleanup(action, cleanAfter);
    public IReadOnlyDictionary<string, ArgumentValue> ReplaceArguments(IReadOnlyDictionary<string, ArgumentValue> newArgumentValues) => _delegate.ReplaceArguments(newArgumentValues);
    public IReadOnlyDictionary<string, ArgumentValue> ReplaceArguments(ReplaceArguments replace) => _delegate.ReplaceArguments(replace);
    public ArgumentValue ReplaceArgument(string argumentName, ArgumentValue newArgumentValue) => _delegate.ReplaceArgument(argumentName, newArgumentValue);
    IResolverContext IResolverContext.Clone() => Clone();
    public IServiceProvider Services { get => _delegate.Services; set => _delegate.Services = value; }
    public IServiceProvider RequestServices { get => _delegate.RequestServices; }
    public string ResponseName { get => _delegate.ResponseName; }
    public bool HasErrors { get => _delegate.HasErrors; }
    IReadOnlyDictionary<string, object?> IPureResolverContext.ScopedContextData { get => _delegate.ScopedContextData; }
    #endregion
}
