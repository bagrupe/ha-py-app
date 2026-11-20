using System.Data.Entity.Core;
using API.Clients.BereichBClient;
using Microsoft.EntityFrameworkCore;
using StrawberryShake;

namespace API.Features.BereichB;

/// <summary>
/// Synchronisiert Untereinheiten zwischen dem lokalen Datenkontext und dem BereichB-Service.
/// </summary>
/// <param name="bereichBClient">Client für BereichB-API-Aufrufe.</param>
/// <param name="domainContextFactory">Fabrik zur Erzeugung des Datenbankkontexts.</param>
public class UntereinheitenSynchronizer(
    IBereichBClient bereichBClient,
    [Service] IDbContextFactory<DomainContext> domainContextFactory)
    : BereichBSynchronizer<IOperationResult<IUntereinheitByBereichAIdResult>?, Untereinheit.Untereinheit> {
    /// <summary>
    /// Synchronisiert eine Untereinheit anhand ihrer ID.
    /// </summary>
    /// <param name="guid">ID der zu synchronisierenden Untereinheit.</param>
    /// <returns>Gibt zurück, ob die Synchronisation erfolgreich war.</returns>
    public override async Task<bool> Synchronize(Guid guid) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync();
        var entityToSync = await domainContext.Untereinheit.AsTracking().Include(ue => ue.Kommune)
            .FirstOrDefaultAsync(u => u.Id == guid);

        if (entityToSync is null) { throw new ObjectNotFoundException(); }

        var maybeBereichBUntereineheitId =
            await bereichBClient.UntereinheitByBereichAId.ExecuteAsync(entityToSync.Id.ToString());

        var success = await Crud(maybeBereichBUntereineheitId, entityToSync);
        entityToSync.IsSyncedToBereichB = success;
        await domainContext.SaveChangesAsync();
        return success;
    }

    /// <summary>
    /// Führt je nach Ergebnis der BereichB-Abfrage eine Create-, Update- oder Delete-Operation aus.
    /// </summary>
    /// <param name="operationResult">Ergebnis der BereichB-Abfrage.</param>
    /// <param name="untereinheit">Die lokale Untereinheit.</param>
    /// <returns>Gibt zurück, ob die Operation erfolgreich war.</returns>
    protected override async Task<bool> Crud(IOperationResult<IUntereinheitByBereichAIdResult>? operationResult,
        Untereinheit.Untereinheit untereinheit) => (operationResult, untereinheit) switch { { operationResult.Errors.Count: 0 } and
                                                                                                { operationResult.Data.Untereinheits.Docs.Count: 0 } => await Create(untereinheit), { operationResult.Errors.Count: 0 } and
                                                                                                                                                                                        { operationResult.Data.Untereinheits.Docs.Count: 1 } and
                                                                                                                                                                                        { untereinheit.MarkedForDelete: false } => await Update(untereinheit), { operationResult.Errors.Count: 0 } and
                                                                                                                                                                                                                                                                   { operationResult.Data.Untereinheits.Docs.Count: 1 } and
                                                                                                                                                                                                                                                                   { untereinheit.MarkedForDelete: true } => await Delete(untereinheit),
            _ => throw new ArgumentOutOfRangeException(nameof(untereinheit), untereinheit, null)
        };

    /// <summary>
    /// Legt eine neue Untereinheit im BereichB-System an.
    /// </summary>
    /// <param name="untereinheit">Die zu erstellende Untereinheit.</param>
    /// <returns>Gibt zurück, ob die Erstellung erfolgreich war.</returns>
    protected override async Task<bool> Create(Untereinheit.Untereinheit untereinheit) {
        var queryResult = await bereichBClient.KommuneByBereichAId.ExecuteAsync(untereinheit.KommuneId.ToString());
        if (queryResult.Data?.KommuneByBereichAId?.Id is null) {
            return false;
        }

        var result = await bereichBClient.UntereinheitCreate.ExecuteAsync(
            new mutationUntereinheitInput {
                Id = untereinheit.Id.ToString(),
                Name = untereinheit.Name,
                Kommune = queryResult.Data.KommuneByBereichAId.Id,
                IsGemeinde = untereinheit.IsGemeinde,
                Regionalschluessel = untereinheit.Regionalschluessel,
            });

        return result.Errors.Count <= 0;
    }

    /// <summary>
    /// Aktualisiert eine bestehende Untereinheit im BereichB-System.
    /// </summary>
    /// <param name="untereinheit">Die zu aktualisierende Untereinheit.</param>
    /// <returns>Gibt zurück, ob die Aktualisierung erfolgreich war.</returns>
    protected override async Task<bool> Update(Untereinheit.Untereinheit untereinheit) {
        var untereinheitDocs = await bereichBClient.UntereinheitByBereichAId.ExecuteAsync(untereinheit.Id.ToString());
        if (untereinheitDocs is not { Errors.Count: 0 }) {
            return false;
        }

        var maybeUntereinheitId = untereinheitDocs.Data?.Untereinheits?.Docs?[0]?.Id;
        if (maybeUntereinheitId is null) {
            return false;
        }

        var result = await bereichBClient.UntereinheitUpdate.ExecuteAsync(maybeUntereinheitId,
            new mutationUntereinheitUpdateInput { Name = untereinheit.Name });

        return result.Errors.Count <= 0;
    }

    /// <summary>
    /// Löscht eine Untereinheit im BereichB-System und entfernt sie lokal.
    /// </summary>
    /// <param name="untereinheit">Die zu löschende Untereinheit.</param>
    /// <returns>Gibt zurück, ob die Löschung erfolgreich war.</returns>
    protected override async Task<bool> Delete(Untereinheit.Untereinheit untereinheit) {
        var untereinheitDocs = await bereichBClient.UntereinheitByBereichAId.ExecuteAsync(untereinheit.Id.ToString());
        if (untereinheitDocs is not { Errors.Count: 0 }) {
            return false;
        }

        var maybeUntereinheitId = untereinheitDocs.Data?.Untereinheits?.Docs?[0]?.Id;
        if (maybeUntereinheitId is null) {
            return false;
        }

        var result = await bereichBClient.UntereinheitDelete.ExecuteAsync(maybeUntereinheitId);
        if (result.Errors.Count > 0) {
            return false;
        }

        await using var domainContext = await domainContextFactory.CreateDbContextAsync();
        domainContext.Untereinheit.Remove(untereinheit);
        await domainContext.SaveChangesAsync();
        return result.Errors.Count <= 0;
    }
}
