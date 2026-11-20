using System.Linq.Expressions;
using System.Reflection;
using HotChocolate.Data.Filters;
using HotChocolate.Data.Filters.Expressions;
using HotChocolate.Language;

namespace API.Infrastructure;

/// <summary>Definiert benutzerdefinierte Filteroperationen für HotChocolate.</summary>
public static class CustomOperations {
    // HotChocolate claims values up to 1024
    public const int IContains = 1025;
}

/// <summary>Erweitert die Filterkonvention um eine case-insensitive Contains-Operation.</summary>
public static class CustomerFilterConventionExtensions {
    /// <summary>Fügt der Filterkonvention die Operation "icontains" hinzu.</summary>
    /// <param name="conventionDescriptor">Die Filterkonvention, die erweitert wird.</param>
    /// <returns>Die erweiterte Filterkonvention.</returns>
    public static IFilterConventionDescriptor AddInvariantComparison(this IFilterConventionDescriptor conventionDescriptor) {
        conventionDescriptor.Operation(CustomOperations.IContains).Name("icontains");

        return conventionDescriptor
            .Configure<StringOperationFilterInputType>(
                x => x.Operation(CustomOperations.IContains).Type<StringType>()
            );
    }
}

/// <summary>Behandelt die case-insensitive Contains-Filteroperation für Abfragen.</summary>
public class QueryableStringInvariantContainsHandler : QueryableStringOperationHandler {
    /// <summary>Initialisiert eine neue Instanz mit dem angegebenen InputParser.</summary>
    /// <param name="inputParser">Der Parser für Eingabewerte.</param>
    public QueryableStringInvariantContainsHandler(InputParser inputParser) : base(inputParser) {
    }

    private static readonly MethodInfo ToLower = typeof(string)
        .GetMethods()
        .Single(
            x => x.Name == nameof(string.ToLower) &&
                 x.GetParameters().Length == 0);

    private static readonly MethodInfo Contains = typeof(string)
        .GetMethods()
        .Single(x => x.Name == nameof(string.Contains)
                     && x.GetParameters().Length == 1
                     && x.GetParameters().Single().ParameterType == typeof(string));

    /// <inheritdoc />
    protected override int Operation => CustomOperations.IContains;

    /// <summary>Erzeugt einen Ausdruck für die case-insensitive Contains-Operation.</summary>
    /// <param name="context">Der Kontext der Abfrage.</param>
    /// <param name="field">Das Filterfeld der Operation.</param>
    /// <param name="value">Der Wertsknoten aus der Abfrage.</param>
    /// <param name="parsedValue">Der geparste Wert.</param>
    /// <returns>Den Ausdruck für die Filteroperation.</returns>
    public override Expression HandleOperation(
        QueryableFilterContext context,
        IFilterOperationField field,
        IValueNode value,
        object? parsedValue) {
        Expression property = context.GetInstance();

        if (parsedValue is string str) {
            return Expression.Call(
                Expression.Call(property, ToLower),
                Contains,
                Expression.Constant(str.ToLower()));
        }

        throw new InvalidOperationException();
    }
}
