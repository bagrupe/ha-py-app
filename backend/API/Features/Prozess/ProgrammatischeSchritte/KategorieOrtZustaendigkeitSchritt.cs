using System.Text.Json;
using API.Features.Expressions;
using API.Features.Geo;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.ProgrammatischeSchritte;

/// <summary>
/// Ermittelt die Zuständigkeit für eine Meldung anhand ihres Standorts und ihres Kategorie-Pfads durch den
/// Mängelmelder-Kategoriebaum (<see cref="Kategorie"/>), ohne dass der Prozessgraph für jede Kombination aus
/// Kategorie und Ort eigene Schritte/Verbindungen braucht. Erwartet genau eine ausgehende Verbindung.
///
/// Erwartet in der Ausführung den Slot "adresse" (Standort) sowie die Kategorie als Kette von Slots: Ebene 1
/// immer im festen Slot "kategorie", jede weitere Ebene in einem Slot, dessen Name sich aus dem bisherigen
/// Pfad ergibt ("kategorie_2__spielplatz", "kategorie_3__spielplatz__x", ...) - beliebig tief, endend beim
/// ersten fehlenden Slot. Dasselbe kaskadierende Formularfeld-Muster erzeugt der Kategoriebaum-Sync-Export
/// beim Speichern einer Kategorie (siehe <see cref="Mutations.KategorieMutations"/>).
/// </summary>
[SchrittName("Zuständigkeit anhand Kategoriebaum und Ort ermitteln", LiefertZustaendigkeit = true)]
public class KategorieOrtZustaendigkeitSchritt(
    ILogger<KategorieOrtZustaendigkeitSchritt> logger,
    GeoService geoService,
    IDbContextFactory<DomainContext> dbContextFactory
) : ProgrammatischerSchrittExecutable {
    public const string AdresseSlotName = "adresse";
    public const string KategorieSlotNamePrefix = "kategorie";

    public async Task<ProgrammatischerSchrittResult> ExecuteAsync(Walker walker) {
        var kommuneId = walker.Prozess.KommuneId;
        var slotValues = walker.CurrentSlotValues();

        var kategoriePfad = BuildKategoriePfad(slotValues);
        var standort = GetLocationSlot(slotValues, AdresseSlotName);

        await using var db = await dbContextFactory.CreateDbContextAsync();

        var untereinheiten = await db.Untereinheit
            .Where(u => u.KommuneId == kommuneId && u.IsGemeinde)
            .ToListAsync();

        Untereinheit.Untereinheit? untereinheit = null;
        foreach (var kandidat in untereinheiten) {
            if (!UntereinheitGeoflaeche.NameByUntereinheitName.TryGetValue(kandidat.Name, out var geoflaechenName)) {
                continue;
            }
            if (await geoService.IsPointInGeoflaeche(kommuneId, geoflaechenName, standort)) {
                untereinheit = kandidat;
                break;
            }
        }

        if (untereinheit is null) {
            throw new InvalidOperationException(
                $"Konnte für den Standort keine zuständige Untereinheit ermitteln (Kommune {kommuneId}, Ausführung {walker.Ausfuehrung.Id}). " +
                "Es fehlt vermutlich eine Geofläche, die den Standort abdeckt.");
        }

        var ausgeblendeteIds = await db.KategorieAusblendungen
            .Where(a => a.UntereinheitId == untereinheit.Id)
            .Select(a => a.KategorieId)
            .ToListAsync();

        var sichtbarVorZwillingsfilter = await db.Kategorien
            .Where(k => k.KommuneId == kommuneId && (k.UntereinheitId == null || k.UntereinheitId == untereinheit.Id))
            .ToListAsync();

        var ausgeblendeteGeteilteSchluessel = sichtbarVorZwillingsfilter
            .Where(k => k.UntereinheitId == null && ausgeblendeteIds.Contains(k.Id))
            .Select(k => (k.ParentId, k.Name))
            .ToHashSet();

        var sichtbareKategorien = sichtbarVorZwillingsfilter
            .Where(k => !ausgeblendeteIds.Contains(k.Id))
            .Where(k => k.UntereinheitId == null || !ausgeblendeteGeteilteSchluessel.Contains((k.ParentId, k.Name)))
            .ToList();

        var wurzel = sichtbareKategorien.SingleOrDefault(k => k.UntereinheitId == untereinheit.Id && k.IstWurzel)
            ?? throw new InvalidOperationException(
                $"Untereinheit '{untereinheit.Name}' ({untereinheit.Id}) hat keinen Wurzel-Knoten im Kategoriebaum. " +
                $"Ausführung {walker.Ausfuehrung.Id}.");

        var tiefsterTreffer = ResolveTiefstenKnoten(sichtbareKategorien, kategoriePfad);

        var ziel = FindeVererbteZustaendigkeit(sichtbareKategorien, tiefsterTreffer, untereinheit.Id) ?? wurzel.Ziel
            ?? throw new InvalidOperationException(
                $"Wurzel-Knoten der Untereinheit '{untereinheit.Name}' ({untereinheit.Id}) hat keine " +
                $"Standard-Zuständigkeit gesetzt. Kategorie-Pfad '{string.Join(" / ", kategoriePfad)}', " +
                $"Ausführung {walker.Ausfuehrung.Id}.");

        logger.LogDebug(
            "Zuständigkeit für Kategorie-Pfad {Pfad} in {Untereinheit} ermittelt: {Art}",
            string.Join(" / ", kategoriePfad), untereinheit.Name, ziel.Art);

        var naechsteIstZustaendigkeit = new Zustaendigkeit {
            Art = ziel.Art,
            OrganisationseinheitId = ziel.OrganisationseinheitId,
            MitarbeiterGruppeId = ziel.MitarbeiterGruppeId,
            DienstleisterId = ziel.DienstleisterId,
        };

        return new ProgrammatischerSchrittResult(walker.CurrentVerbindungen[0].Id, naechsteIstZustaendigkeit);
    }

    /// <summary>
    /// Bevorzugt bei einem Zwilling (gleicher Name, gleiche ParentId) immer die geteilte Kategorie: nur sie
    /// trägt die Baumstruktur (Kinder), der Zwilling hat nie eigene Kinder.
    /// </summary>
    internal static Kategorie? ResolveTiefstenKnoten(List<Kategorie> sichtbareKategorien, List<string> kategoriePfad) {
        Kategorie? aktuell = null;
        foreach (var name in kategoriePfad) {
            var kandidaten = sichtbareKategorien.Where(k =>
                k.ParentId == aktuell?.Id && !k.IstWurzel && k.Name == name).ToList();
            var naechster = kandidaten.FirstOrDefault(k => k.UntereinheitId == null) ?? kandidaten.FirstOrDefault();
            if (naechster is null) break;
            aktuell = naechster;
        }
        return aktuell;
    }

    /// <summary>
    /// Eine geteilte Kategorie kann selbst nie ein eigenes Ziel tragen (siehe Mutations.KategorieMutations) -
    /// die für diese Untereinheit gesetzte Zuständigkeit steckt also, wenn vorhanden, im Zwilling.
    /// </summary>
    internal static Zustaendigkeit? FindeVererbteZustaendigkeit(
        List<Kategorie> sichtbareKategorien, Kategorie? knoten, Guid untereinheitId
    ) {
        var aktuell = knoten;
        while (aktuell is not null) {
            var eigenerZwilling = aktuell.UntereinheitId == untereinheitId
                ? aktuell
                : sichtbareKategorien.FirstOrDefault(k =>
                    k.UntereinheitId == untereinheitId && k.ParentId == aktuell.ParentId && k.Name == aktuell.Name);

            var ziel = eigenerZwilling?.Ziel ?? aktuell.Ziel;
            if (ziel is not null) return ziel;

            aktuell = aktuell.ParentId is { } parentId
                ? sichtbareKategorien.FirstOrDefault(k => k.Id == parentId)
                : null;
        }
        return null;
    }

    /// <summary>
    /// Ebene 1 liegt immer im festen Slot "kategorie". Jede weitere Ebene braucht ein eigenes Formularfeld mit
    /// eigenem Slot-Namen (sonst räumt die App-seitige Relevanz-Bereinigung den gerade gewählten Wert wieder
    /// weg, sobald eine andere Variante dieser Ebene als nicht mehr relevant erkannt wird).
    /// </summary>
    internal static List<string> BuildKategoriePfad(IReadOnlyDictionary<string, SlotValue> slotValues) {
        var ersteEbene = GetStringSlot(slotValues, KategorieSlotNamePrefix, required: true)!;
        var pfad = new List<string> { ersteEbene };
        var slugPfad = new List<string> { Slug(ersteEbene) };

        var ebene = 2;
        while (true) {
            var slotName = $"{KategorieSlotNamePrefix}_{ebene}__{string.Join("__", slugPfad)}";
            if (GetStringSlot(slotValues, slotName, required: false) is not { } wert) break;

            pfad.Add(wert);
            slugPfad.Add(Slug(wert));
            ebene++;
        }

        return pfad;
    }

    /// <summary>Wandelt einen Kategorienamen in einen URL-/Slot-sicheren Slug um.</summary>
    internal static string Slug(string wert) {
        var normalisiert = wert.ToLowerInvariant()
            .Replace("ä", "ae").Replace("ö", "oe").Replace("ü", "ue").Replace("ß", "ss");

        var sb = new System.Text.StringBuilder(normalisiert.Length);
        foreach (var zeichen in normalisiert) {
            sb.Append(char.IsAsciiLetterOrDigit(zeichen) ? zeichen : '_');
        }

        return sb.ToString().Trim('_');
    }

    private static string? GetStringSlot(IReadOnlyDictionary<string, SlotValue> slotValues, string slotName, bool required) {
        if (!slotValues.TryGetValue(slotName, out var slotValue)) {
            if (required) {
                throw new InvalidOperationException($"Slot '{slotName}' wird von diesem Schritt benötigt, wurde aber nicht gefunden.");
            }
            return null;
        }

        if (slotValue is not PlainSlotValue { Value.ValueKind: JsonValueKind.String } plainSlotValue) {
            if (!required) {
                return null;
            }

            throw new InvalidOperationException($"Slot '{slotName}' muss ein unverschlüsselter Text-Wert sein.");
        }

        return plainSlotValue.Value.GetString();
    }

    internal static EvaluatingVisitor.ParsedLocation GetLocationSlot(IReadOnlyDictionary<string, SlotValue> slotValues, string slotName) {
        if (!slotValues.TryGetValue(slotName, out var slotValue) ||
            slotValue is not PlainSlotValue { Value.ValueKind: JsonValueKind.Object } plainSlotValue) {
            throw new InvalidOperationException($"Slot '{slotName}' wird von diesem Schritt als Standort benötigt, wurde aber nicht gefunden oder hat ein falsches Format.");
        }

        return new EvaluatingVisitor.ParsedLocation(
            plainSlotValue.Value.GetProperty("coordinates")[0].GetDouble(),
            plainSlotValue.Value.GetProperty("coordinates")[1].GetDouble());
    }
}
