using System.Data.Entity.Core;
using System.Text.Json;
using API.Clients.BereichBClient;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Untereinheit;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Sentry;
using StrawberryShake;

namespace API.Features.BereichB;

/// <summary>
/// Synchronisiert Backoffice-Nutzer mit Bereich B.
/// </summary>
public class BackofficeUserSynchronizer(
    IBereichBClient bereichBClient,
    [Service] IDbContextFactory<DomainContext> domainContextFactory,
    [Service] FunktionsberechtigungenService funktionsberechtigungenService,
    [Service] ILogger<BackofficeUserSynchronizer> logger)
    : BereichBSynchronizer<IOperationResult<IBackofficeByBereichAIdResult>, BackofficeUser> {

    /// <summary>
    /// Synchronisiert einen Backoffice-Nutzer basierend auf der angegebenen ID.
    /// </summary>
    /// <param name="guid">Die ID des zu synchronisierenden Nutzers.</param>
    /// <returns>Gibt an, ob die Synchronisation erfolgreich war.</returns>
    public override async Task<bool> Synchronize(Guid guid) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync();
        var entityToSync = await domainContext.BackofficeUser.AsTracking()
            .Include(u => u.UntereinheitPermissions)
            .ThenInclude(u => u.Untereinheit)
            .Include(u => u.Kommune)
            .FirstOrDefaultAsync(u => u.Id == guid);

        if (entityToSync is null) { throw new ObjectNotFoundException(); }

        var maybeBackofficeUserBereichB =
            await bereichBClient.BackofficeByBereichAId.ExecuteAsync(entityToSync.Id.ToString());

        bool success;

        if (!BackofficeNutzerArt.Nutzer.ErfuelltDurch(entityToSync.Art)) {
            success = true;
        } else {
            success = await Crud(maybeBackofficeUserBereichB, entityToSync);
        }

        entityToSync.IsSyncedToBereichB = success;
        await domainContext.SaveChangesAsync();
        return success;
    }

    /// <summary>
    /// Führt CRUD-Operationen für die Synchronisation aus.
    /// </summary>
    /// <param name="operationResult">Das Ergebnis der Bereich-B-Abfrage.</param>
    /// <param name="entityToSync">Der zu synchronisierende Nutzer.</param>
    /// <returns>Gibt an, ob die Operation erfolgreich war.</returns>
    protected override async Task<bool>
        Crud(IOperationResult<IBackofficeByBereichAIdResult>? operationResult, BackofficeUser entityToSync) =>
        (operationResult, entityToSync) switch { { operationResult.Errors.Count: 0 } and { operationResult.Data.Benutzers.Docs.Count: 0 } => await Create(entityToSync), { operationResult.Errors.Count: 0 } and { operationResult.Data.Benutzers.Docs.Count: 1 } and { entityToSync.IsDeleted: true } => await Delete(entityToSync), { operationResult.Errors.Count: 0 } and { operationResult.Data.Benutzers.Docs.Count: 1 } => await Update(entityToSync),
            _ => ReportSyncError(entityToSync, operationResult)
        };

    /// <summary>
    /// Meldet einen Synchronisationsfehler an Logger + Sentry, inkl. Nutzer-Kontext und Fehlschritt.
    /// </summary>
    /// <param name="entity">Der betroffene Nutzer.</param>
    /// <param name="step">Der Sync-Schritt, in dem der Fehler aufgetreten ist (create, update, delete, lookup-kommune, ...).</param>
    /// <param name="clientErrorMessage">Die Rohmeldung des BereichB-Clients, falls vorhanden.</param>
    /// <returns>Gibt immer false zurück.</returns>
    private bool ReportSyncError(BackofficeUser entity, string step, string? clientErrorMessage) {
        var message =
            $"{nameof(BackofficeUser)}: {entity.Id} ({entity.EMail}) could not be synchronized to bereich-b " +
            $"at step '{step}'. Client error: {clientErrorMessage ?? "<none>"}";

        logger.LogWarning(
            "BackofficeUser sync failed: id={BackofficeUserId} email={BackofficeUserEmail} step={SyncStep} clientError={ClientError}",
            entity.Id, entity.EMail, step, clientErrorMessage);

        SentrySdk.CaptureException(new SynchronizerException(message),
            scope => {
                scope.SetExtra(key: "BackofficeUserId", value: entity.Id);
                scope.SetExtra(key: "BackofficeUserEmail", value: entity.EMail);
                scope.SetExtra(key: "SyncStep", value: step);
                scope.SetExtra(key: "ClientError", value: clientErrorMessage ?? "<none>");
            });

        return false;
    }

    /// <summary>Legacy overload used from the Crud switch when the initial lookup is ambiguous.</summary>
    private bool ReportSyncError(BackofficeUser entity,
        IOperationResult<IBackofficeByBereichAIdResult>? operationResult) =>
        ReportSyncError(entity, step: "lookup-bereich-b-user",
            clientErrorMessage: operationResult?.Errors.FirstOrDefault()?.Message);

    /// <summary>
    /// Ausnahme für Synchronisationsfehler.
    /// </summary>
    private class SynchronizerException(string message) : Exception(message);

    /// <summary>
    /// Erstellt einen neuen Backoffice-Nutzer in Bereich B.
    /// </summary>
    /// <param name="backofficeUser">Der zu erstellende Nutzer.</param>
    /// <returns>Gibt an, ob die Erstellung erfolgreich war.</returns>
    protected override async Task<bool> Create(BackofficeUser backofficeUser) {
        var kommuneQueryResult =
            await bereichBClient.KommuneByBereichAId.ExecuteAsync(backofficeUser.KommuneId.ToString());
        if (kommuneQueryResult is not ({ Errors.Count: 0 } and { Data.KommuneByBereichAId: not null })) {
            return ReportSyncError(backofficeUser, step: "create/lookup-kommune",
                clientErrorMessage: kommuneQueryResult?.Errors.FirstOrDefault()?.Message
                    ?? $"KommuneByBereichAId returned no match for KommuneId={backofficeUser.KommuneId}");
        }

        var organsationseinheiten = await funktionsberechtigungenService.GetOrganisationseinheitenForUser(backofficeUser);
        var permissions = await UntereinheitPermissionsList(backofficeUser);
        var untereinheitenIds = permissions.Select(permission => permission.UntereinheitId.ToString()).ToArray();
        var maybeDocs = await TryGetUntereinheitenDocs(backofficeUser, step: "create/lookup-untereinheiten", untereinheitenIds);

        if (!maybeDocs.success) {
            return false;
        }

        var nextPermissions = organsationseinheiten.Where(
            oe => maybeDocs.docs.Any(doc => doc?.Id == oe.OrganisationseinheitId.ToString())).Select(
            oe => new mutationBenutzer_OrganisationseinheitenInput {
                Organisationseinheit = oe.OrganisationseinheitId.ToString(),
                Funktionsberechtigungen = JsonDocument.Parse(JsonSerializer.Serialize(oe.AlleFunktionsberechtigungen)).RootElement
            }
        );
        var rnd = new Random();
        var bytes = new Byte[128];
        rnd.NextBytes(bytes);
        var result = await bereichBClient.BackofficeUserCreate.ExecuteAsync(
            new mutationBenutzerInput {
                Email = backofficeUser.EMail,
                Vorname = backofficeUser.Vorname,
                Nachname = backofficeUser.Nachname,
                Password = Convert.ToHexString(bytes),
                BereichAId = backofficeUser.Id.ToString(),
                Kommune = kommuneQueryResult.Data.KommuneByBereichAId.Id,
                Organisationseinheiten = nextPermissions.ToList(),
                IsSuperAdmin = backofficeUser.Art == BackofficeNutzerArt.Superadmin
            });

        if (result.Errors.Count > 0) {
            return ReportSyncError(backofficeUser, step: "create/BackofficeUserCreate",
                clientErrorMessage: result.Errors.FirstOrDefault()?.Message);
        }
        return true;
    }

    /// <summary>
    /// Aktualisiert einen bestehenden Backoffice-Nutzer in Bereich B.
    /// </summary>
    /// <param name="backofficeUser">Der zu aktualisierende Nutzer.</param>
    /// <returns>Gibt an, ob die Aktualisierung erfolgreich war.</returns>
    protected override async Task<bool> Update(BackofficeUser backofficeUser) {
        var backofficeUserQueryResult =
            await bereichBClient.BackofficeByBereichAId.ExecuteAsync(backofficeUser.Id.ToString());
        if (backofficeUserQueryResult is { Errors.Count: > 0 } or { Data.Benutzers.Docs.Count: not 1 }) {
            return ReportSyncError(backofficeUser, step: "update/lookup-bereich-b-user",
                clientErrorMessage: backofficeUserQueryResult.Errors.FirstOrDefault()?.Message
                    ?? $"BackofficeByBereichAId returned {backofficeUserQueryResult.Data?.Benutzers?.Docs?.Count ?? 0} docs (expected 1)");
        }

        var bereichBUserId = backofficeUserQueryResult.Data?.Benutzers?.Docs?[0]?.Id;
        if (bereichBUserId is null) {
            return ReportSyncError(backofficeUser, step: "update/bereich-b-id-null",
                clientErrorMessage: "Matched doc had null Id");
        }

        var organisationseinheiten =
            await funktionsberechtigungenService.GetOrganisationseinheitenForUser(backofficeUser);
        var untereinheitenIds = organisationseinheiten.Select(oe => oe.OrganisationseinheitId.ToString()).ToArray();
        var maybeDocs = await TryGetUntereinheitenDocs(backofficeUser, step: "update/lookup-untereinheiten", untereinheitenIds);

        if (!maybeDocs.success) {
            return false;
        }

        var nextPermissions = organisationseinheiten.Where(
            oe => maybeDocs.docs.Any(doc => doc?.Id == oe.OrganisationseinheitId.ToString())).Select(
            oe => new mutationBenutzerUpdate_OrganisationseinheitenInput() {
                Organisationseinheit = maybeDocs.docs.First(doc => doc?.Id == oe.OrganisationseinheitId.ToString())?.Id,
                Funktionsberechtigungen = SerializeFunktionsberechtigungen(oe.AlleFunktionsberechtigungen)
            }
        );

        var result = await bereichBClient.BackofficeUserUpdate.ExecuteAsync(bereichBUserId,
            new mutationBenutzerUpdateInput {
                Organisationseinheiten = nextPermissions.ToList(),
                IsSuperAdmin = backofficeUser.Art == BackofficeNutzerArt.Superadmin
            });

        if (result.Errors.Count > 0) {
            return ReportSyncError(backofficeUser, step: "update/BackofficeUserUpdate",
                clientErrorMessage: result.Errors.FirstOrDefault()?.Message);
        }
        return true;
    }

    /// <summary>
    /// Ruft Dokumente zu Untereinheiten basierend auf deren IDs ab. Meldet Fehler inkl. Nutzer-Kontext.
    /// </summary>
    /// <param name="backofficeUser">Der Nutzer, für den synchronisiert wird (für Fehlerkontext).</param>
    /// <param name="step">Der aktuelle Sync-Schritt (für Fehlerkontext).</param>
    /// <param name="ids">Die IDs der Untereinheiten.</param>
    /// <returns>Ein Tupel aus Erfolg und den abgerufenen Dokumenten.</returns>
    private async Task<(bool success, IReadOnlyList<IUntereinheitenByBereichAIds_Untereinheits_Docs?> docs)>
        TryGetUntereinheitenDocs(BackofficeUser backofficeUser, string step, IReadOnlyList<string> ids) {
        var untereinheitenQueryResult =
            await bereichBClient.UntereinheitenByBereichAIds.ExecuteAsync(ids);

        if (untereinheitenQueryResult is { Errors.Count: > 0 }) {
            ReportSyncError(backofficeUser, step,
                clientErrorMessage: untereinheitenQueryResult.Errors.FirstOrDefault()?.Message);
            return (false, []);
        }

        var untereinheitenDocs = untereinheitenQueryResult.Data?.Untereinheits?.Docs ?? [];
        return (true, untereinheitenDocs);
    }

    /// <summary>
    /// Ruft die Berechtigungen für Untereinheiten eines Nutzers ab.
    /// </summary>
    /// <param name="backofficeUser">Der betroffene Nutzer.</param>
    /// <returns>Eine Liste der Berechtigungen.</returns>
    private async Task<List<UntereinheitPermissions>> UntereinheitPermissionsList(BackofficeUser backofficeUser) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync();

        var permissions = await domainContext.UntereinheitPermissions.Include(permission => permission.Untereinheit)
            .Where(permission => permission.BackofficeUserId == backofficeUser.Id).ToListAsync();
        return permissions;
    }

    /// <summary>
    /// Löscht einen Backoffice-Nutzer in Bereich B.
    /// </summary>
    /// <param name="entity">Der zu löschende Nutzer.</param>
    /// <returns>Gibt an, ob die Löschung erfolgreich war.</returns>
    protected override async Task<bool> Delete(BackofficeUser entity) {
        var backofficeUserQueryResult =
            await bereichBClient.BackofficeByBereichAId.ExecuteAsync(entity.Id.ToString());
        if (backofficeUserQueryResult is { Errors.Count: > 0 } or { Data.Benutzers.Docs.Count: not 1 }) {
            return ReportSyncError(entity, step: "delete/lookup-bereich-b-user",
                clientErrorMessage: backofficeUserQueryResult.Errors.FirstOrDefault()?.Message
                    ?? $"BackofficeByBereichAId returned {backofficeUserQueryResult.Data?.Benutzers?.Docs?.Count ?? 0} docs (expected 1)");
        }

        var bereichBUserId = backofficeUserQueryResult.Data?.Benutzers?.Docs?[0]?.Id;
        if (bereichBUserId is null) {
            return ReportSyncError(entity, step: "delete/bereich-b-id-null",
                clientErrorMessage: "Matched doc had null Id");
        }

        var result = await bereichBClient.BackofficeUserDelete.ExecuteAsync(bereichBUserId);
        if (result.Errors.Count > 0) {
            return ReportSyncError(entity, step: "delete/BackofficeUserDelete",
                clientErrorMessage: result.Errors.FirstOrDefault()?.Message);
        }
        return true;
    }

    /// <summary>
    /// Serialisiert Funktionsberechtigungen in ein JSON-Element.
    /// </summary>
    /// <param name="berechtigungen">Die zu serialisierenden Berechtigungen.</param>
    /// <returns>Das JSON-Element.</returns>
    private JsonElement SerializeFunktionsberechtigungen(IEnumerable<FunktionsberechtigungInOrganisationseinheit> berechtigungen) {
        return JsonDocument.Parse(JsonSerializer.Serialize(
            berechtigungen.Select(b => b.ToString())
        )).RootElement;
    }
}
