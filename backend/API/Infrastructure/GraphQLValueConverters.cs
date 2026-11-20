using System.Collections.Immutable;
using HotChocolate.Utilities;

namespace API.Infrastructure;

/// <summary>Stellt einen Konverter bereit, der eine Liste in ein ImmutableHashSet umwandelt.</summary>
public class ListToImmutableHashSetConverter : IChangeTypeProvider {
    /// <summary>Versucht, einen Konverter von einer Quell- zu einer Zieltyp zu erstellen.</summary>
    /// <param name="source">Der Quelltyp, der konvertiert werden soll.</param>
    /// <param name="target">Der Zieltyp, in den konvertiert werden soll.</param>
    /// <param name="root">Der übergeordnete ChangeTypeProvider.</param>
    /// <param name="converter">Der erzeugte Konverter, falls erfolgreich.</param>
    /// <returns>True, wenn ein passender Konverter erstellt wurde, sonst false.</returns>
    public bool TryCreateConverter(Type source, Type target, ChangeTypeProvider root, out ChangeType converter) {
        if (source.IsGenericType && source.GetGenericTypeDefinition() == typeof(List<>) &&
            target.IsGenericType && target.GetGenericTypeDefinition() == typeof(ImmutableHashSet<>)) {
            converter = input => {
                var elementType = target.GetGenericArguments()[0];
                var list = (IEnumerable<object>)input!;
                var method = typeof(ImmutableHashSet).GetMethod(nameof(ImmutableHashSet.Create))!.MakeGenericMethod(elementType);
                return method.Invoke(null, new object[] { list });
            };
            return true;
        }

        converter = null!;
        return false;
    }
}
