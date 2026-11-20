using System.Linq.Expressions;
using System.Reflection;
using API.Seeders.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace API.Seeders.Base;

/// <summary>Ermöglicht das Einfügen oder Aktualisieren einer Entität im DbSet basierend auf einem Schlüssel.</summary>
/// <typeparam name="TEntity">Typ der zu seedeneden Entität.</typeparam>
public class SeedEntityBuilder<TEntity> where TEntity : class {
    public delegate void OnCreateDelegate(TEntity created);
    public delegate Task OnCreateAsyncDelegate(TEntity created);
    public delegate void OnUpdateDelegate(TEntity current, TEntity next);
    public delegate Task OnUpdateAsyncDelegate(TEntity current, TEntity next);

    private readonly DbSet<TEntity> _dbSet;
    private readonly TEntity _entity;
    private readonly IEntityType _entityType;
    private Expression<Func<TEntity, bool>>? _predicate;
    private OnCreateDelegate? _onCreate;
    private OnCreateAsyncDelegate? _onCreateAsync;
    private OnUpdateDelegate? _onUpdate;
    private OnUpdateAsyncDelegate? _onUpdateAsync;

    /// <summary>Initialisiert den Builder mit DbSet, EntityType und der zu seedeneden Entität.</summary>
    public SeedEntityBuilder(DbSet<TEntity> dbSet, IEntityType entityType, TEntity entity) {
        _dbSet = dbSet;
        _entity = entity;
        _entityType = entityType;
    }

    /// <summary>Fügt die Entität ein oder aktualisiert sie asynchron basierend auf dem Schlüssel.</summary>
    /// <param name="cancellationToken">Token zum Abbrechen der Operation.</param>
    /// <returns>Die eingefügte oder aktualisierte Entität.</returns>
    public async Task<TEntity> SeedAsync(CancellationToken cancellationToken = default) {
        var predicate = _predicate ?? GeneratePrimaryKeyPredicate();
        var count = await _dbSet.CountAsync(predicate, cancellationToken);
        switch (count) {
            case > 1:
                throw new InvalidOperationException($"Found more than one matching {typeof(TEntity).Name} (non-unique key)");
            case 1:
                var existing = await _dbSet.IncludeAll().AsSplitQuery().AsTracking().FirstAsync(predicate, cancellationToken);
                _onUpdate?.Invoke(existing, _entity);
                if (_onUpdateAsync != null) {
                    await _onUpdateAsync(existing, _entity);
                }
                return existing;
            default:
                _dbSet.Add(_entity);
                _onCreate?.Invoke(_entity);
                if (_onCreateAsync != null) {
                    await _onCreateAsync(_entity);
                }
                return _entity;
        }
    }

    /// <summary>Legt den Schlüssel für die Entität fest, der zum Finden verwendet wird.</summary>
    /// <typeparam name="TKey">Typ des Schlüssels.</typeparam>
    /// <param name="keySelector">Ausdruck, der den Schlüssel auswählt.</param>
    /// <returns>Den Builder zur weiteren Konfiguration.</returns>
    public SeedEntityBuilder<TEntity> WithKey<TKey>(Expression<Func<TEntity, TKey>> keySelector) {

        switch (keySelector.Body) {
            case MemberExpression { Member: PropertyInfo propertyInfo }: {
                    _predicate = GeneratePredicate(new[] { propertyInfo });
                    break;
                }
            case NewExpression newExpression: {
                    _predicate = GeneratePredicate(newExpression.Arguments.Select(arg => {
                        if (arg is not MemberExpression { Member: PropertyInfo propertyInfo } innerMemberExpression ||
                            innerMemberExpression.Expression?.Type != typeof(TEntity))
                            throw new ArgumentException(
                                $"Invalid key selector: {arg}");
                        return propertyInfo;
                    }));
                    break;
                }
            default:
                throw new ArgumentException("Invalid keySelector");
        }
        return this;
    }

    /// <summary>Setzt eine Aktion, die beim Erstellen der Entität ausgeführt wird.</summary>
    /// <param name="onCreate">Aktion bei Erstellung.</param>
    /// <returns>Den Builder zur weiteren Konfiguration.</returns>
    public SeedEntityBuilder<TEntity> OnCreate(OnCreateDelegate onCreate) {
        this._onCreate = onCreate;
        return this;
    }

    /// <summary>Setzt eine asynchrone Aktion, die beim Erstellen der Entität ausgeführt wird.</summary>
    /// <param name="onCreateAsync">Asynchrone Aktion bei Erstellung.</param>
    /// <returns>Den Builder zur weiteren Konfiguration.</returns>
    public SeedEntityBuilder<TEntity> OnCreateAsync(OnCreateAsyncDelegate onCreateAsync) {
        this._onCreateAsync = onCreateAsync;
        return this;
    }

    /// <summary>Setzt eine Aktion, die beim Aktualisieren der Entität ausgeführt wird.</summary>
    /// <param name="onUpdate">Aktion bei Aktualisierung.</param>
    /// <returns>Den Builder zur weiteren Konfiguration.</returns>
    public SeedEntityBuilder<TEntity> OnUpdate(OnUpdateDelegate onUpdate) {
        this._onUpdate = onUpdate;
        return this;
    }

    /// <summary>Setzt eine asynchrone Aktion, die beim Aktualisieren der Entität ausgeführt wird.</summary>
    /// <param name="onUpdateAsync">Asynchrone Aktion bei Aktualisierung.</param>
    /// <returns>Den Builder zur weiteren Konfiguration.</returns>
    public SeedEntityBuilder<TEntity> OnUpdateAsync(OnUpdateAsyncDelegate onUpdateAsync) {
        this._onUpdateAsync = onUpdateAsync;
        return this;
    }

    /// <summary>Erzeugt einen Prädikat-Ausdruck basierend auf dem Primärschlüssel der Entität.</summary>
    /// <returns>Prädikat zum Finden der Entität.</returns>
    private Expression<Func<TEntity, bool>> GeneratePrimaryKeyPredicate() {
        var primaryKey = _entityType.FindPrimaryKey();
        if (primaryKey == null) {
            throw new InvalidOperationException(
                $"No primary key defined for {typeof(TEntity).Name}; {nameof(WithKey)} is required here");
        }

        var properties = primaryKey.Properties.Select(property => {
            if (property.PropertyInfo is null) {
                throw new InvalidOperationException($"Shadow properties are not supported: {property.Name})");
            }
            return property.PropertyInfo;
        });

        return GeneratePredicate(properties);
    }

    /// <summary>Erzeugt einen Prädikat-Ausdruck für die angegebenen Eigenschaften und deren Werte.</summary>
    /// <param name="properties">Eigenschaften, die im Prädikat verwendet werden.</param>
    /// <returns>Prädikat zum Finden der Entität.</returns>
    private Expression<Func<TEntity, bool>> GeneratePredicate(IEnumerable<PropertyInfo> properties) {
        var parameter = Expression.Parameter(typeof(TEntity), "entity");

        Expression? predicateBody = null;

        foreach (var propertyInfo in properties) {
            var propertyExpression = Expression.Property(parameter, propertyInfo);
            var keyValueConstant = Expression.Constant(propertyInfo.GetValue(_entity));
            var equalExpression = Expression.Equal(propertyExpression, keyValueConstant);
            predicateBody = predicateBody is null
                ? equalExpression
                : Expression.AndAlso(predicateBody, equalExpression);
        }

        if (predicateBody is null) {
            throw new InvalidOperationException("Predicate is empty");
        }

        return Expression.Lambda<Func<TEntity, bool>>(predicateBody, parameter);
    }
}
