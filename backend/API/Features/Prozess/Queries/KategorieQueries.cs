using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Queries;

/// <summary>Vorschau der Auswirkungen, bevor eine Kategorie tatsächlich gelöscht wird.</summary>
/// <param name="AnzahlUnterkategorien">Anzahl der Unterkategorien, die mit gelöscht würden.</param>
/// <param name="IstGeteilt">Ob die Kategorie geteilt ist und sich das Löschen daher auf alle Untereinheiten auswirkt.</param>
/// <param name="BetroffeneUntereinheiten">
/// Bei einer geteilten Kategorie: Aufschlüsselung der mit gelöschten eigenen Unterkategorien nach Untereinheit.
/// Bei einer Untereinheit-eigenen Kategorie immer leer (die Nachfahren gehören ohnehin nur dieser einen
/// Untereinheit, s. <see cref="Mutations.KategorieMutations.KategorieCreate"/>).
/// </param>
public record KategorieLoeschVorschau(int AnzahlUnterkategorien, bool IstGeteilt, List<UntereinheitBetroffenheit> BetroffeneUntereinheiten);

/// <summary>Anzahl der eigenen Unterkategorien einer Untereinheit, die vom Löschen einer geteilten Kategorie mit betroffen wären.</summary>
public record UntereinheitBetroffenheit(string UntereinheitName, int AnzahlEigeneUnterkategorien);

/// <summary>Stellt Abfragen für den Mängelmelder-Kategoriebaum bereit.</summary>
[QueryType]
public class KategorieQueries {
    /// <summary>Schließt auch einen eigenen Zwilling einer ausgeblendeten geteilten Kategorie mit aus.</summary>
    [Authorize]
    public async Task<List<Kategorie>> GetKategorieBaum(DomainContext domainContext, Guid untereinheitId, CurrentUserAccessor currentUserAccessor) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.InOrganisationseinheit(untereinheitId, FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung).Fordern();

        await EnsureWurzelExists(domainContext, user.KommuneId, untereinheitId);

        var ausgeblendeteIds = await domainContext.KategorieAusblendungen
            .Where(a => a.UntereinheitId == untereinheitId)
            .Select(a => a.KategorieId)
            .ToListAsync();

        var sichtbar = await domainContext.Kategorien
            .Where(k => k.KommuneId == user.KommuneId && (k.UntereinheitId == null || k.UntereinheitId == untereinheitId))
            .ToListAsync();

        var ausgeblendeteGeteilteSchluessel = sichtbar
            .Where(k => k.UntereinheitId == null && ausgeblendeteIds.Contains(k.Id))
            .Select(k => (k.ParentId, k.Name))
            .ToHashSet();

        return sichtbar
            .Where(k => !ausgeblendeteIds.Contains(k.Id))
            .Where(k => k.UntereinheitId == null || !ausgeblendeteGeteilteSchluessel.Contains((k.ParentId, k.Name)))
            .ToList();
    }

    /// <summary>
    /// Liefert die geteilten Kategorien, die für eine Untereinheit ausgeblendet sind - <see cref="GetKategorieBaum"/>
    /// selbst lässt sie einfach weg, ohne diese Liste gäbe es also keine Möglichkeit, eine Ausblendung in der
    /// Oberfläche wieder aufzuheben.
    /// </summary>
    [Authorize]
    public async Task<List<Kategorie>> GetAusgeblendeteKategorien(DomainContext domainContext, Guid untereinheitId, CurrentUserAccessor currentUserAccessor) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.InOrganisationseinheit(untereinheitId, FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung).Fordern();

        var ausgeblendeteIds = await domainContext.KategorieAusblendungen
            .Where(a => a.UntereinheitId == untereinheitId)
            .Select(a => a.KategorieId)
            .ToListAsync();

        return await domainContext.Kategorien
            .Where(k => k.KommuneId == user.KommuneId && ausgeblendeteIds.Contains(k.Id))
            .ToListAsync();
    }

    /// <summary>Zeigt vor dem Löschen, wie viele Unterkategorien betroffen wären und ob es sich um eine geteilte Kategorie handelt.</summary>
    [Authorize]
    public async Task<KategorieLoeschVorschau> GetKategorieLoeschVorschau(DomainContext domainContext, Guid id, CurrentUserAccessor currentUserAccessor) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        var kategorie = await domainContext.Kategorien
            .Where(k => k.Id == id && k.KommuneId == user.KommuneId)
            .FirstOrDefaultAsync() ?? throw new NotAllowedException();

        if (kategorie.UntereinheitId is { } untereinheitId) {
            berechtigungen.InOrganisationseinheit(untereinheitId, FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung).Fordern();
        } else if (user.Art != BackofficeNutzerArt.Superadmin) {
            throw new NotAllowedException("Geteilte Kategorien können nur von Superadmins eingesehen werden.");
        }

        var alle = await domainContext.Kategorien
            .Where(k => k.KommuneId == user.KommuneId)
            .ToListAsync();

        var nachfahren = SammleNachfahren(alle, id);
        var istGeteilt = kategorie.UntereinheitId == null;
        var betroffeneUntereinheiten = istGeteilt
            ? await BuildBetroffeneUntereinheitenAsync(domainContext, nachfahren)
            : [];

        return new KategorieLoeschVorschau(nachfahren.Count, istGeteilt, betroffeneUntereinheiten);
    }

    private static List<Kategorie> SammleNachfahren(List<Kategorie> alle, Guid id) {
        var kinder = alle.Where(k => k.ParentId == id).ToList();
        return kinder.Concat(kinder.SelectMany(k => SammleNachfahren(alle, k.Id))).ToList();
    }

    /// <summary>
    /// Zählt, wie viele der Nachfahren einer geteilten Kategorie eigene Kategorien welcher Untereinheit sind
    /// - jeder eigene Nachfahre gehört (per Anlege-Validierung) nur einer einzigen Untereinheit, auch über
    /// mehrere Ebenen hinweg, daher reicht eine einfache Gruppierung nach UntereinheitId.
    /// </summary>
    private static async Task<List<UntereinheitBetroffenheit>> BuildBetroffeneUntereinheitenAsync(
        DomainContext domainContext, List<Kategorie> nachfahren
    ) {
        var eigeneNachfahren = nachfahren.Where(k => k.UntereinheitId is not null).ToList();
        if (eigeneNachfahren.Count == 0) return [];

        var untereinheitIds = eigeneNachfahren.Select(k => k.UntereinheitId!.Value).Distinct().ToList();
        var nameByUntereinheitId = await domainContext.Untereinheit
            .Where(u => untereinheitIds.Contains(u.Id))
            .ToDictionaryAsync(u => u.Id, u => u.Name);

        return eigeneNachfahren
            .GroupBy(k => k.UntereinheitId!.Value)
            .Select(g => new UntereinheitBetroffenheit(nameByUntereinheitId.GetValueOrDefault(g.Key, "?"), g.Count()))
            .OrderBy(b => b.UntereinheitName)
            .ToList();
    }

    /// <summary>Legt den Wurzel-Knoten einer Untereinheit an, falls er noch nicht existiert (idempotent, get-or-create).</summary>
    private static async Task EnsureWurzelExists(DomainContext domainContext, Guid kommuneId, Guid untereinheitId) {
        var existiertBereits = await domainContext.Kategorien
            .Where(k => k.UntereinheitId == untereinheitId && k.IstWurzel)
            .AnyAsync();
        if (existiertBereits) return;

        domainContext.Kategorien.Add(new Kategorie {
            Id = Guid.NewGuid(),
            KommuneId = kommuneId,
            UntereinheitId = untereinheitId,
            IstWurzel = true,
            Name = "Standard-Zuständigkeit",
        });

        try {
            await domainContext.SaveChangesAsync();
        } catch (DbUpdateException) {
            // Race mit einer gleichzeitigen Anfrage, die bereits einen Wurzel-Knoten angelegt hat - in Ordnung.
            domainContext.ChangeTracker.Clear();
        }
    }
}
