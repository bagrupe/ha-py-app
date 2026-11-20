namespace API.Features.BereichB;

/// <summary>
/// Basisklasse für die Synchronisation von Entitäten mit Bereich B.
/// </summary>
/// <typeparam name="TOperationResult">Der Typ des Operationsergebnisses.</typeparam>
/// <typeparam name="TEntity">Der Typ der zu synchronisierenden Entität.</typeparam>
public abstract class BereichBSynchronizer<TOperationResult, TEntity> {
    /// <summary>
    /// Synchronisiert eine Entität basierend auf der angegebenen ID.
    /// </summary>
    /// <param name="guid">Die ID der zu synchronisierenden Entität.</param>
    /// <returns>Gibt an, ob die Synchronisation erfolgreich war.</returns>
    public abstract Task<bool> Synchronize(Guid guid);

    /// <summary>
    /// Führt CRUD-Operationen für die Synchronisation aus.
    /// </summary>
    /// <param name="operationResult">Das Ergebnis der Operation.</param>
    /// <param name="entity">Die zu synchronisierende Entität.</param>
    /// <returns>Gibt an, ob die Operation erfolgreich war.</returns>
    protected abstract Task<bool> Crud(TOperationResult operationResult, TEntity entity);

    /// <summary>
    /// Erstellt eine neue Entität in Bereich B.
    /// </summary>
    /// <param name="entity">Die zu erstellende Entität.</param>
    /// <returns>Gibt an, ob die Erstellung erfolgreich war.</returns>
    protected abstract Task<bool> Create(TEntity entity);

    /// <summary>
    /// Aktualisiert eine bestehende Entität in Bereich B.
    /// </summary>
    /// <param name="entity">Die zu aktualisierende Entität.</param>
    /// <returns>Gibt an, ob die Aktualisierung erfolgreich war.</returns>
    protected abstract Task<bool> Update(TEntity entity);

    /// <summary>
    /// Löscht eine bestehende Entität in Bereich B.
    /// </summary>
    /// <param name="entity">Die zu löschende Entität.</param>
    /// <returns>Gibt an, ob die Löschung erfolgreich war.</returns>
    protected abstract Task<bool> Delete(TEntity entity);
}
