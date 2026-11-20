using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;

namespace API.Seeders.Extensions;

/// <summary>Erweitert DbSet um Methoden zum vollständigen Einbinden von Navigationseigenschaften.</summary>
public static class DbSetExtensions {
    /// <summary>Lädt alle Navigationseigenschaften bis zu einer bestimmten Tiefe beim Abruf der Entitäten vor.</summary>
    /// <param name="dbSet">Das DbSet, dessen Entitäten geladen werden.</param>
    /// <param name="maxDepth">Maximale Tiefe der Navigationseigenschaften, die eingebunden werden sollen.</param>
    /// <returns>Ein IQueryable mit allen eingebundenen Navigationseigenschaften.</returns>
    internal static IQueryable<TEntity> IncludeAll<TEntity>(
        this DbSet<TEntity> dbSet,
        int maxDepth = int.MaxValue) where TEntity : class {
        IQueryable<TEntity> result = dbSet;
        var context = dbSet.GetService<ICurrentDbContext>().Context;
        var includePaths = GetIncludePaths<TEntity>(context, maxDepth);

        foreach (var includePath in includePaths) {
            result = result.Include(includePath);
        }

        return result;
    }

    /// <remarks>
    /// Adapted from https://stackoverflow.com/a/64614824
    /// </remarks>
    private static IEnumerable<string> GetIncludePaths<T>(DbContext context, int maxDepth = int.MaxValue) {
        if (maxDepth < 0)
            throw new ArgumentOutOfRangeException(nameof(maxDepth));

        var entityType = context.Model.FindEntityType(typeof(T));
        var includedNavigations = new HashSet<INavigation>();
        var stack = new Stack<IEnumerator<INavigation>>();

        while (true) {
            var entityNavigations = new List<INavigation>();

            if (stack.Count <= maxDepth) {
                foreach (var navigation in entityType!.GetNavigations()) {
                    if (includedNavigations.Add(navigation))
                        entityNavigations.Add((INavigation)navigation);
                }
            }

            if (entityNavigations.Count == 0) {
                if (stack.Count > 0)
                    yield return string.Join(".", stack.Reverse().Select(e => e.Current!.Name));
            } else {
                foreach (var navigation in entityNavigations) {
                    var inverseNavigation = navigation.Inverse;
                    if (inverseNavigation != null)
                        includedNavigations.Add(inverseNavigation);
                }

                stack.Push(entityNavigations.GetEnumerator());
            }

            while (stack.Count > 0 && !stack.Peek().MoveNext())
                stack.Pop();

            if (stack.Count == 0)
                break;

            entityType = stack.Peek().Current.TargetEntityType;
        }
    }
}
