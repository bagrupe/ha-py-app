using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Queries;

/// <summary>Erweitert den Typ FormularSchritt um Abfragen zu Formularfeldern und Slots.</summary>
[ExtendObjectType<FormularSchritt>]
public class FormularSchrittQueries {
    /// <summary>Liefert alle Formularfelder zu einem gegebenen Formularschritt.</summary>
    /// <param name="dataLoader">DataLoader zum Laden der Formularfelder.</param>
    /// <param name="schritt">Der Formularschritt, dessen Felder abgefragt werden.</param>
    /// <returns>Eine Auflistung der zugehörigen Formularfelder.</returns>
    [GraphQLDescription("Liefert alle Formularfelder, die zu diesem Formularschritt gehören.")]
    public async Task<IEnumerable<FormularFeld>> Felder(IFormularFelderBySchrittIdDataLoader dataLoader, [Parent] FormularSchritt schritt) {
        return await dataLoader.LoadAsync(schritt.Id);
    }

    /// <summary>Lädt Formularfelder für mehrere Formularschritte anhand ihrer Ids.</summary>
    /// <param name="ids">Liste der Formularschritt-Ids.</param>
    /// <param name="domainContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Lookup mit Formularschritt-Id als Schlüssel und zugehörigen Formularfeldern als Werte.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, FormularFeld>> GetFormularFelderBySchrittId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        return await domainContext.FormularFelder.Where(f => ids.Contains(f.Schritt.Id))
            .OrderBy(f => f.Order)
            .ToLookupAsync(f => f.SchrittId, ct);
    }

    /// <summary>Liefert alle Slots zu einem gegebenen Formularschritt.</summary>
    /// <param name="dataLoader">DataLoader zum Laden der Slots.</param>
    /// <param name="schritt">Der Formularschritt, dessen Slots abgefragt werden.</param>
    /// <returns>Eine Auflistung der zugehörigen Slots.</returns>
    [GraphQLDescription("Liefert alle Slots dieses Formularschritts.")]
    public async Task<IEnumerable<Slot>> Slots(ISlotsBySchrittIdDataLoader dataLoader, [Parent] FormularSchritt schritt) {
        return await dataLoader.LoadAsync(schritt.Id);
    }

    /// <summary>Lädt Slots für mehrere Formularschritte anhand ihrer Ids.</summary>
    /// <param name="ids">Liste der Formularschritt-Ids.</param>
    /// <param name="domainContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Lookup mit Formularschritt-Id als Schlüssel und zugehörigen Slots als Werte.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Slot>> GetSlotsBySchrittId(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var db = await domainContextFactory.CreateDbContextAsync(ct);

        var schrittToSlots = await db.Schritte
            .Where(s => ids.Contains(s.Id))
            .ToDictionaryAsync(s => s.Id, s => s.Slots, ct);

        return schrittToSlots
            .SelectMany(p => p.Value.Select(x => new { p.Key, Value = x }))
            .ToLookup(p => p.Key, p => p.Value);
    }
}
