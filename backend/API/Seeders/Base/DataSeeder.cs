using FluentValidation;
using Microsoft.EntityFrameworkCore;
using NGuid;

namespace API.Seeders.Base;

/// <summary>Definiert die Schnittstelle für Daten-Seeder mit Ausführungslogik und Priorisierung.</summary>
public interface IDataSeeder {
    /// <summary>Gibt an, ob der Seeder vor Importen ausgeführt werden muss.</summary>
    public bool MustRunBeforeImports { get; }
    /// <summary>Führt die Seeder-Logik asynchron aus.</summary>
    /// <param name="ct">Abbruchtoken zur Steuerung der Ausführung.</param>
    public Task Execute(CancellationToken ct = default);
}

/// <summary>Abstrakte Basisklasse für Seeder, die Daten in einem DbContext einfügen oder aktualisieren.</summary>
/// <typeparam name="TContext">Typ des verwendeten DbContext.</typeparam>
public abstract class DataSeeder<TContext> : IDataSeeder where TContext : DbContext {
    private readonly TContext _dbContext;
    private readonly ILogger<DataSeeder<TContext>> _logger;
    private readonly IEnumerable<IValidator> _validators;

    /// <summary>Initialisiert den Seeder mit DbContext-Fabrik, Logger und Validierern.</summary>
    /// <param name="dbContextFactory">Fabrik zur Erzeugung des DbContext.</param>
    /// <param name="logger">Logger zur Ausgabe von Informationen.</param>
    /// <param name="validators">Sammlung von Validierern für Entitäten.</param>
    protected DataSeeder(
        IDbContextFactory<TContext> dbContextFactory, ILogger<DataSeeder<TContext>> logger,
        IEnumerable<IValidator> validators) {
        _logger = logger;
        _dbContext = dbContextFactory.CreateDbContext();
        _validators = validators;
    }

    /// <summary>DbContext used for seeding (same instance for reads and writes within one run).</summary>
    protected TContext DbContext => _dbContext;

    /// <summary>Gibt an, ob der Seeder vor Importen ausgeführt werden muss.</summary>
    public abstract bool MustRunBeforeImports { get; }

    /// <summary>Implementiert die eigentliche Seeder-Logik asynchron.</summary>
    /// <param name="cancellationToken">Abbruchtoken zur Steuerung der Ausführung.</param>
    protected abstract Task Run(CancellationToken cancellationToken = default);

    /// <summary>Führt die Seeder-Logik aus und speichert die Änderungen in der Datenbank.</summary>
    /// <param name="cancellationToken">Abbruchtoken zur Steuerung der Ausführung.</param>
    public async Task Execute(CancellationToken cancellationToken = default) {
        await this.Run(cancellationToken);
        await SaveChangesAsync(cancellationToken);
    }

    /// <summary>Erstellt einen Builder für das Seed-Entity und validiert die Entität.</summary>
    /// <typeparam name="TEntity">Typ der Entität.</typeparam>
    /// <param name="entity">Die zu seedenede Entität.</param>
    /// <returns>Builder zur weiteren Konfiguration des Seedings.</returns>
    protected SeedEntityBuilder<TEntity> Build<TEntity>(
        TEntity entity
    ) where TEntity : class {
        foreach (var validator in _validators.OfType<IValidator<TEntity>>()) {
            validator.ValidateAndThrow(entity);
        }

        var set = _dbContext.Set<TEntity>();
        var clrType = entity.GetType();
        var entityType = _dbContext.Model.FindEntityType(clrType);
        if (entityType?.ClrType != clrType) {
            throw new InvalidOperationException($"{_dbContext.GetType().Name} is missing DbSet for {clrType.Name}");
        }

        return new SeedEntityBuilder<TEntity>(set, entityType, entity);
    }

    /// <summary>Speichert alle Änderungen im DbContext asynchron und protokolliert die Änderungen.</summary>
    /// <param name="cancellationToken">Abbruchtoken zur Steuerung der Ausführung.</param>
    /// <returns>Anzahl der gespeicherten Änderungen.</returns>
    protected Task<int> SaveChangesAsync(CancellationToken cancellationToken = default) {
        var changeTracker = _dbContext.ChangeTracker;

        if (changeTracker.HasChanges()) {
            _logger.LogInformation("{}", changeTracker.DebugView.ShortView);
        }

        return _dbContext.SaveChangesAsync(cancellationToken);
    }

    /// <summary>Leitet eine deterministische Guid aus einem Namespace und einem String ab.</summary>
    /// <param name="namespaceId">Namespace-Guid.</param>
    /// <param name="source">Quellstring zur Ableitung.</param>
    /// <returns>Abgeleitete Guid.</returns>
    protected static Guid DeriveId(Guid namespaceId, string source) {
        return GuidHelpers.CreateFromName(namespaceId, source);
    }

    /// <summary>Leitet eine deterministische Guid aus einem Namespace und einem Integer ab.</summary>
    /// <param name="namespaceId">Namespace-Guid.</param>
    /// <param name="source">Quellinteger zur Ableitung.</param>
    /// <returns>Abgeleitete Guid.</returns>
    protected static Guid DeriveId(Guid namespaceId, int source) {
        return GuidHelpers.CreateFromName(namespaceId, source.ToString());
    }

    /// <summary>Leitet eine deterministische Guid aus einem Namespace und einer Guid ab.</summary>
    /// <param name="namespaceId">Namespace-Guid.</param>
    /// <param name="source">Quellguid zur Ableitung.</param>
    /// <returns>Abgeleitete Guid.</returns>
    protected static Guid DeriveId(Guid namespaceId, Guid source) {
        return GuidHelpers.CreateFromName(namespaceId, source.ToByteArray());
    }
}
