using Microsoft.EntityFrameworkCore;

namespace API.Infrastructure;

/// <summary>Erweitert IQueryable um asynchrone Methoden zur Erstellung von ILookup-Strukturen.</summary>
internal static class QueryableExtensions {
    /// <summary>Erstellt asynchron ein ILookup aus der Quelle anhand eines Schlüsselselektors.</summary>
    /// <param name="source">Die Abfragequelle.</param>
    /// <param name="keySelector">Funktion zur Auswahl des Schlüssels.</param>
    /// <param name="cancellationToken">Token zum Abbrechen der Operation.</param>
    /// <typeparam name="TSource">Der Typ der Elemente in der Quelle.</typeparam>
    /// <typeparam name="TKey">Der Typ des Schlüssels.</typeparam>
    /// <returns>Ein ILookup mit den gruppierten Elementen.</returns>
    public static async Task<ILookup<TKey, TSource>> ToLookupAsync<TSource, TKey>(
        this IQueryable<TSource> source,
        Func<TSource, TKey> keySelector,
        CancellationToken cancellationToken = default)
        where TKey : notnull {
        return (await source.ToListAsync(cancellationToken)).ToLookup(keySelector);
    }

    /// <summary>Erstellt asynchron ein ILookup aus der Quelle anhand eines Schlüssels und eines Elementselektors.</summary>
    /// <param name="source">Die Abfragequelle.</param>
    /// <param name="keySelector">Funktion zur Auswahl des Schlüssels.</param>
    /// <param name="elementSelector">Funktion zur Auswahl der Elemente.</param>
    /// <param name="cancellationToken">Token zum Abbrechen der Operation.</param>
    /// <typeparam name="TSource">Der Typ der Elemente in der Quelle.</typeparam>
    /// <typeparam name="TKey">Der Typ des Schlüssels.</typeparam>
    /// <typeparam name="TElement">Der Typ der Elemente im Lookup.</typeparam>
    /// <returns>Ein ILookup mit den gruppierten Elementen.</returns>
    public static async Task<ILookup<TKey, TElement>> ToLookupAsync<TSource, TKey, TElement>(
        this IQueryable<TSource> source,
        Func<TSource, TKey> keySelector,
        Func<TSource, TElement> elementSelector,
        CancellationToken cancellationToken = default)
        where TKey : notnull {
        return (await source.ToListAsync(cancellationToken)).ToLookup(keySelector, elementSelector);
    }

    /// <summary>Erstellt asynchron ein ILookup aus der Quelle anhand eines Schlüssels, eines Elementselektors und eines Vergleichers.</summary>
    /// <param name="source">Die Abfragequelle.</param>
    /// <param name="keySelector">Funktion zur Auswahl des Schlüssels.</param>
    /// <param name="elementSelector">Funktion zur Auswahl der Elemente.</param>
    /// <param name="comparer">Vergleichsobjekt für die Schlüssel.</param>
    /// <param name="cancellationToken">Token zum Abbrechen der Operation.</param>
    /// <typeparam name="TSource">Der Typ der Elemente in der Quelle.</typeparam>
    /// <typeparam name="TKey">Der Typ des Schlüssels.</typeparam>
    /// <typeparam name="TElement">Der Typ der Elemente im Lookup.</typeparam>
    /// <returns>Ein ILookup mit den gruppierten Elementen.</returns>
    public static async Task<ILookup<TKey, TElement>> ToLookupAsync<TSource, TKey, TElement>(
        this IQueryable<TSource> source,
        Func<TSource, TKey> keySelector,
        Func<TSource, TElement> elementSelector,
        IEqualityComparer<TKey> comparer,
        CancellationToken cancellationToken = default)
        where TKey : notnull {
        return (await source.ToListAsync(cancellationToken)).ToLookup(keySelector, elementSelector, comparer);
    }
}
