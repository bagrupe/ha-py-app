using API.Infrastructure;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage.Queries;

[QueryType]
public static class LageMeldungQueries {
    [Authorize]
    public static async Task<IReadOnlyList<LageKontakt>> GetLageKontakte(Guid lageId, bool? offeneRueckrufe, DomainContext db,
        CurrentUserAccessor currentUserAccessor, CancellationToken ct) {
        var (user, rechte) = await currentUserAccessor.EnsureBackofficeUser();
        rechte.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();
        if (!LageMeldungen.IstLeitstelle(user)) throw new NotAllowedException("Nur für die Leitstelle.");
        return await db.LageKontakte.Where(k => k.LageId == lageId && k.Lage.Untereinheit.KommuneId == user.KommuneId)
            .Where(k => offeneRueckrufe != true || (k.Rueckruf && k.Erledigt == null))
            .OrderBy(k => k.Erstellt).ToListAsync(ct);
    }

    [Authorize]
    [GraphQLDescription(
        "Meldungen einer Lage, älteste zuerst. Leitstelle (Admin, Superadmin) sieht alle, eine Einsatzleitung nur " +
        "die ihrer Gruppen. offen: true = nur nicht abgeschlossene, false = nur abgeschlossene, null = alle.")]
    public static async Task<IReadOnlyList<Ausfuehrung>> GetLageMeldungen(Guid lageId, bool? offen,
        DomainContext db, CurrentUserAccessor currentUserAccessor, CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var query = LageMeldungen.SichtbarFuer(db, user).Where(a => a.LageGebiet!.LageId == lageId);
        query = offen switch {
            true => query.Where(a => a.Status != AusfuehrungStatus.Abgeschlossen),
            false => query.Where(a => a.Status == AusfuehrungStatus.Abgeschlossen),
            null => query,
        };
        return await query.OrderBy(a => a.CreatedAt).ToListAsync(ct);
    }

    [Authorize]
    [GraphQLDescription("Einheiten der Kommune, optional nur die einer Einsatzleitung (Mitarbeitergruppe).")]
    public static async Task<IReadOnlyList<Einheit>> GetEinheiten(Guid? mitarbeiterGruppeId, DomainContext db,
        CurrentUserAccessor currentUserAccessor, CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        return await db.Einheiten
            .Where(e => e.MitarbeiterGruppe.KommuneId == user.KommuneId)
            .Where(e => mitarbeiterGruppeId == null || e.MitarbeiterGruppeId == mitarbeiterGruppeId)
            .OrderBy(e => e.Name)
            .ToListAsync(ct);
    }
}

[ExtendObjectType<Ausfuehrung>]
public class AusfuehrungLageMeldungExtensions {
    [GraphQLDescription("Stand der Meldung für Leitstelle und Einsatzleitung. Null außerhalb des LageHelfers.")]
    public async Task<EreignisStatus?> GetEreignisStatus([Parent] Ausfuehrung ausfuehrung,
        IEreignisStatusByAusfuehrungIdDataLoader loader, CancellationToken ct) =>
        ausfuehrung.LageGebietId is null ? null : await loader.LoadAsync(ausfuehrung.Id, ct);

    [GraphQLDescription("Einheit, der die Einsatzleitung die Meldung zugewiesen hat.")]
    public async Task<Einheit?> GetEinheit([Parent] Ausfuehrung ausfuehrung, IEinheitByIdDataLoader loader,
        CancellationToken ct) =>
        ausfuehrung.EinheitId is { } einheitId ? await loader.LoadAsync(einheitId, ct) : null;

    [GraphQLDescription("Bestätigungen (\"+1 · Sehe ich auch\") weiterer Personen, älteste zuerst.")]
    public async Task<MeldungBestaetigung[]> GetBestaetigungen([Parent] Ausfuehrung ausfuehrung,
        IBestaetigungenByAusfuehrungIdDataLoader loader, CancellationToken ct) =>
        await loader.LoadAsync(ausfuehrung.Id, ct) ?? [];

    [GraphQLDescription("Anzahl der Bestätigungen (\"+1\").")]
    public async Task<int> GetAnzahlBestaetigungen([Parent] Ausfuehrung ausfuehrung,
        IBestaetigungenByAusfuehrungIdDataLoader loader, CancellationToken ct) =>
        (await loader.LoadAsync(ausfuehrung.Id, ct))?.Length ?? 0;

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, EreignisStatus>> GetEreignisStatusByAusfuehrungId(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return await LageMeldungen.ErmittleStatus(db, keys, ct);
    }

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Einheit>> GetEinheitById(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return await db.Einheiten.Where(e => keys.Contains(e.Id)).ToDictionaryAsync(e => e.Id, ct);
    }

    [DataLoader]
    internal static async Task<ILookup<Guid, MeldungBestaetigung>> GetBestaetigungenByAusfuehrungId(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return (await db.MeldungBestaetigungen
                .Where(b => keys.Contains(b.AusfuehrungId))
                .OrderBy(b => b.CreatedAt)
                .ToListAsync(ct))
            .ToLookup(b => b.AusfuehrungId);
    }
}
