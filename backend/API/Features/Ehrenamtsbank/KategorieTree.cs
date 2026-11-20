namespace API.Features.Ehrenamtsbank;

public static class KategorieTree {
    /// <summary>
    /// Liefert aus einer flachen Liste nur die Kategorien, die ausgespielt werden dürfen:
    /// eine Kategorie ist nur dann effektiv aktiv, wenn sie selbst und jede ihrer Eltern
    /// bis zur Wurzel <see cref="EhrenamtsbankKategorie.Active"/> ist. Ein inaktiver Knoten
    /// blendet damit seinen gesamten Unterbaum aus. Die Eingabereihenfolge bleibt erhalten.
    /// </summary>
    public static IReadOnlyList<EhrenamtsbankKategorie> FilterEffectivelyActive(
        IReadOnlyList<EhrenamtsbankKategorie> all) {
        var byId = new Dictionary<Guid, EhrenamtsbankKategorie>();
        foreach (var kategorie in all) {
            byId[kategorie.Id] = kategorie;
        }

        return all.Where(kategorie => IsEffectivelyActive(kategorie, byId)).ToList();
    }

    /// <summary>
    /// Eine Kategorie erfordert effektiv ein Führungszeugnis, wenn sie selbst oder
    /// irgendeine ihrer Eltern bis zur Wurzel <see cref="EhrenamtsbankKategorie.RequiresClearance"/>
    /// gesetzt hat. Defekte Daten (Zyklen, fehlende Eltern) dürfen nicht hängen.
    /// </summary>
    public static bool RequiresEffectiveClearance(
        Guid kategorieId, IReadOnlyList<EhrenamtsbankKategorie> all) {
        var byId = new Dictionary<Guid, EhrenamtsbankKategorie>();
        foreach (var kategorie in all) {
            byId[kategorie.Id] = kategorie;
        }

        if (!byId.TryGetValue(kategorieId, out var current)) {
            return false;
        }

        var visited = new HashSet<Guid>();
        while (true) {
            if (current.RequiresClearance) {
                return true;
            }

            if (current.ParentId is not { } parentId || !visited.Add(current.Id)) {
                return false;
            }

            if (!byId.TryGetValue(parentId, out current!)) {
                return false;
            }
        }
    }

    private static bool IsEffectivelyActive(
        EhrenamtsbankKategorie node, IReadOnlyDictionary<Guid, EhrenamtsbankKategorie> byId) {
        var visited = new HashSet<Guid>();
        var current = node;
        while (true) {
            if (!current.Active) {
                return false;
            }

            if (current.ParentId is not { } parentId) {
                return true;
            }

            // Defekte Daten (Zyklus oder fehlende Eltern) dürfen nicht in eine Endlosschleife führen.
            if (!visited.Add(current.Id)) {
                return false;
            }

            if (!byId.TryGetValue(parentId, out var parent)) {
                return true;
            }

            current = parent;
        }
    }
}
