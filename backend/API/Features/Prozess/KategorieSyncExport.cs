using System.Text.RegularExpressions;
using API.Features.Expressions;
using API.Features.Prozess.Mutations;
using API.Features.Prozess.ProgrammatischeSchritte;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Prozess;

/// <summary>
/// Generiert die Kategorie-Formularfelder im Mängelmelder-Formular neu aus dem aktuellen Kategoriebaum und
/// veröffentlicht das Ergebnis als neue Prozessversion - läuft synchron am Ende jeder
/// Kategorie-Speichern-Mutation (kein Polling-Job, siehe <see cref="Mutations.KategorieMutations"/>).
/// Es darf zu jedem Zeitpunkt höchstens ein Prozess pro Kommune das Tag <see cref="ProzessTagName"/> tragen -
/// sonst wirft <see cref="RunAsync"/> bewusst statt einen der Prozesse stillschweigend auszuwählen.
/// </summary>
public class KategorieSyncExport(
    IDbContextFactory<DomainContext> dbContextFactory,
    IClock clock
) {
    // Nicht im DI-Container registriert (HotChocolate löst ihre Abhängigkeiten sonst per Methodenparameter auf) - direkt instanziiert.
    private readonly NeueProzessVersionErstellenMutation _publishMutation = new();
    public const string ProzessTagName = "Mängelmelder";
    public const string AdresseSlotName = KategorieOrtZustaendigkeitSchritt.AdresseSlotName;
    public const string KategorieSlotNamePrefix = KategorieOrtZustaendigkeitSchritt.KategorieSlotNamePrefix;

    private static readonly Regex KategorieSlotNameRegex = new($"^{KategorieSlotNamePrefix}(_\\d+__.*)?$");

    /// <summary>
    /// Wie <see cref="RunAsync(DomainContext,Guid,CancellationToken)"/>, öffnet dafür aber selbst einen neuen,
    /// unabhängigen Kontext aus der Factory - für Aufrufer ohne eigenen laufenden <see cref="DomainContext"/>
    /// (z.B. ein künftiger Job, der eine Prozessversion wiederherstellt).
    /// </summary>
    public async Task RunAsync(Guid kommuneId, CancellationToken ct = default) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        await RunAsync(db, kommuneId, ct);
    }

    /// <summary>
    /// Baut die Kategorie-Formularfelder aus dem aktuellen Baum neu und veröffentlicht eine neue Version des
    /// Prozesses, der mit <see cref="ProzessTagName"/> getaggt ist. Macht nichts, wenn kein solcher Prozess
    /// existiert - z.B. lokal, bevor er einmal im Prozesseditor angelegt/getaggt wurde, oder in Tests, die
    /// ihn nicht seeden.
    ///
    /// Nutzt den übergebenen Kontext statt einen eigenen zu öffnen, damit Aufrufer (siehe
    /// <see cref="Mutations.KategorieMutations"/>) ihre eigenen Änderungen und diesen Export in einer
    /// gemeinsamen Transaction atomar machen können.
    /// </summary>
    public async Task RunAsync(DomainContext db, Guid kommuneId, CancellationToken ct = default) {
        var prozess = await db.Prozesse
            .Where(p => p.KommuneId == kommuneId && p.Tags.Any(t => t.Tag == ProzessTagName))
            .SingleOrDefaultAsync(ct);
        if (prozess is null) return;

        var version = await db.ProzessVersionen
            .Include(v => v.Schritte).ThenInclude(s => s.Verbindungen)
            .Where(v => v.ProzessId == prozess.Id && v.PublishedAt != null)
            .OrderByDescending(v => v.PublishedAt)
            .AsSplitQuery()
            .FirstOrDefaultAsync(ct);
        if (version is null) return;

        var (schritte, verbindungen, rollen) = ProzessGraphReader.ReadCurrentGraph(version);

        var bestehendeDurchsuchbarWerte = ExtrahiereBestehendeDurchsuchbarWerte(schritte);
        var neueKategorieFelder = await BuildKategorieFelderAsync(db, kommuneId, bestehendeDurchsuchbarWerte, ct);
        var gepatchteSchritte = schritte.Select(s => PatchSchrittFalls(s, neueKategorieFelder)).ToList();

        await _publishMutation.PublishNewVersionAsync(db, prozess.Id, kommuneId, gepatchteSchritte, verbindungen, rollen, veroeffentlichen: true, clock, ct);
    }

    /// <summary>
    /// Liefert pro Kategorie-Slot den bestehenden Durchsuchbar-Wert, damit <see cref="BuildFeld"/> ihn beim
    /// Sync übernimmt statt zurückzusetzen (#439). Scope wie <see cref="PatchSchrittFalls"/>; bei doppeltem
    /// Slotnamen über mehrere Schritte gewinnt true statt eines ToDictionary-Crashes.
    /// </summary>
    private static Dictionary<string, bool> ExtrahiereBestehendeDurchsuchbarWerte(List<SchrittInput> schritte) =>
        schritte
            .Where(s => s.FormularSchrittInput is { } formularSchritt
                && formularSchritt.Felder.Any(f => f.Feld.SlotName == AdresseSlotName))
            .SelectMany(s => s.FormularSchrittInput!.Felder)
            .Where(f => KategorieSlotNameRegex.IsMatch(f.Feld.SlotName) && f.StringFormularFeldInput is not null)
            .GroupBy(f => f.Feld.SlotName)
            .ToDictionary(g => g.Key, g => g.Any(f => f.StringFormularFeldInput!.Durchsuchbar));

    /// <summary>
    /// Ersetzt in genau dem FormularSchritt, der das "adresse"-Feld enthält (Anker statt Titel-Vergleich,
    /// damit eine Umbenennung des Schritts den Export nicht bricht), die komplette bisherige Kategorie-
    /// Feldkette durch die neu generierte. Alle anderen Felder und ihre relative Reihenfolge bleiben
    /// unverändert; die neuen Felder werden an der Stelle eingefügt, an der die alten standen (oder direkt
    /// nach "adresse", falls noch keine Kategorie-Felder existierten), danach wird die Order neu durchnummeriert.
    /// </summary>
    private static SchrittInput PatchSchrittFalls(SchrittInput schritt, List<FormularFeldInput> neueKategorieFelder) {
        if (schritt.FormularSchrittInput is not { } formularSchritt) return schritt;
        if (!formularSchritt.Felder.Any(f => f.Feld.SlotName == AdresseSlotName)) return schritt;

        var alteFelder = formularSchritt.Felder;
        var behalteneFelder = alteFelder.Where(f => !KategorieSlotNameRegex.IsMatch(f.Feld.SlotName)).ToList();

        var vorgaengerSlotName = alteFelder
            .TakeWhile(f => !KategorieSlotNameRegex.IsMatch(f.Feld.SlotName))
            .LastOrDefault()?.Feld.SlotName ?? AdresseSlotName;
        var einfuegeIndex = behalteneFelder.FindIndex(f => f.Feld.SlotName == vorgaengerSlotName) + 1;

        var neueFelderListe = behalteneFelder.Take(einfuegeIndex)
            .Concat(neueKategorieFelder)
            .Concat(behalteneFelder.Skip(einfuegeIndex))
            .Select((f, order) => WithOrder(f, order))
            .ToList();

        return schritt with { FormularSchrittInput = formularSchritt with { Felder = neueFelderListe } };
    }

    private static FormularFeldInput WithOrder(FormularFeldInput feld, int order) => feld.Feld switch {
        StringFormularFeldInput s => feld with { StringFormularFeldInput = s with { Order = order } },
        LocationFormularFeldInput l => feld with { LocationFormularFeldInput = l with { Order = order } },
        UploadFormularFeldInput u => feld with { UploadFormularFeldInput = u with { Order = order } },
        CheckboxListFormularFeldInput c => feld with { CheckboxListFormularFeldInput = c with { Order = order } },
        DateFormularFeldInput d => feld with { DateFormularFeldInput = d with { Order = order } },
        SignatureFormularFeldInput sig => feld with { SignatureFormularFeldInput = sig with { Order = order } },
        TimeFormularFeldInput t => feld with { TimeFormularFeldInput = t with { Order = order } },
        AnzeigeTextBlockFormularFeldInput a => feld with { AnzeigeTextBlockFormularFeldInput = a with { Order = order } },
        _ => throw new NotSupportedException(
            $"Feld-Typ '{feld.Feld.GetType().Name}' wird vom Kategoriebaum-Sync-Export nicht unterstützt (siehe {nameof(ProzessGraphReader)}).")
    };

    private async Task<List<FormularFeldInput>> BuildKategorieFelderAsync(
        DomainContext db, Guid kommuneId, Dictionary<string, bool> bestehendeDurchsuchbarWerte, CancellationToken ct
    ) {
        var rohListe = await db.Kategorien.Where(k => k.KommuneId == kommuneId && !k.IstWurzel).ToListAsync(ct);

        // Zwillinge geteilter Kategorien müssen hier ausgeschlossen werden, sonst entstehen doppelte
        // Options mit identischem Namen - die App crasht darauf mit einem DropdownButton-Assertion-Fehler.
        var geteilteNamenByParent = rohListe
            .Where(k => k.UntereinheitId == null)
            .Select(k => (k.ParentId, k.Name))
            .ToHashSet();
        var alle = rohListe
            .Where(k => k.UntereinheitId == null || !geteilteNamenByParent.Contains((k.ParentId, k.Name)))
            .ToList();

        var untereinheitNamenById = await db.Untereinheit
            .Where(u => u.KommuneId == kommuneId)
            .ToDictionaryAsync(u => u.Id, u => u.Name, ct);
        var kategorieIds = alle.Select(k => k.Id).ToList();
        var ausblendendeUntereinheitenByKategorieId = (await db.KategorieAusblendungen
                .Where(a => kategorieIds.Contains(a.KategorieId))
                .ToListAsync(ct))
            .GroupBy(a => a.KategorieId)
            .ToDictionary(g => g.Key, g => g.Select(a => a.UntereinheitId).ToList());

        var context = new KategorieFelderContext(alle, untereinheitNamenById, ausblendendeUntereinheitenByKategorieId, bestehendeDurchsuchbarWerte);
        var ergebnis = new List<FormularFeldInput>();
        GenerateFelderRekursiv(
            alle.Where(k => k.ParentId is null).ToList(),
            elternSlotName: null, elternName: null, slugPfad: [], ebene: 1,
            context, ergebnis);
        return ergebnis;
    }

    /// <summary>Baut das Feld für eine Ebene und steigt für jeden Knoten mit eigenen Kindern eine weitere Ebene ab.</summary>
    private static void GenerateFelderRekursiv(
        List<Kategorie> knotenAufDieserEbene, string? elternSlotName, string? elternName, List<string> slugPfad, int ebene,
        KategorieFelderContext context, List<FormularFeldInput> ergebnis
    ) {
        if (knotenAufDieserEbene.Count == 0) return;

        var slotName = ebene == 1 ? KategorieSlotNamePrefix : $"{KategorieSlotNamePrefix}_{ebene}__{string.Join("__", slugPfad)}";
        var istRelevant = ebene == 1
            ? (BoolExpression)true
            : new BoolExpression($"slot('{elternSlotName}') == '{EscapeForExpression(elternName!)}'");

        ergebnis.Add(BuildFeld(slotName, ebene, istRelevant, knotenAufDieserEbene, context));

        foreach (var knoten in knotenAufDieserEbene) {
            var kinder = context.Alle.Where(k => k.ParentId == knoten.Id).ToList();
            if (kinder.Count == 0) continue;

            var kindSlugPfad = new List<string>(slugPfad) { KategorieOrtZustaendigkeitSchritt.Slug(knoten.Name) };
            GenerateFelderRekursiv(kinder, slotName, knoten.Name, kindSlugPfad, ebene + 1, context, ergebnis);
        }
    }

    private static FormularFeldInput BuildFeld(
        string slotName, int ebene, BoolExpression istRelevant, List<Kategorie> knoten, KategorieFelderContext context
    ) {
        var options = knoten.Select(k => new StringFormularFeldOption(
            k.Name, k.Name, BuildOptionIstRelevant(k, context))
        ).ToArray();

        return new FormularFeldInput(
            CheckboxListFormularFeldInput: null,
            StringFormularFeldInput: new StringFormularFeldInput(
                Guid.NewGuid(), slotName, ebene switch { 1 => "Hauptkategorie", 2 => "Unterkategorie", _ => "Spezifizierung" },
                Anweisung: null, Order: 0, Encrypted: false, InhaltsTag: null, IstRelevant: istRelevant, Pflichtfeld: ebene == 1,
                Multiline: false, Options: options, OeffentlichSichtbar: ebene == 1,
                Durchsuchbar: context.BestehendeDurchsuchbarWerte.GetValueOrDefault(slotName)),
            UploadFormularFeldInput: null, LocationFormularFeldInput: null, DateFormularFeldInput: null,
            SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null);
    }

    /// <summary>
    /// Untereinheit-eigene Kategorie: nur sichtbar innerhalb ihrer Geofläche. Geteilte Kategorie mit
    /// Ausblendungen: unsichtbar innerhalb der Geoflächen der ausblendenden Untereinheiten. Geteilte
    /// Kategorie ohne Ausblendung: immer sichtbar (kein Ausdruck nötig).
    /// </summary>
    private static BoolExpression? BuildOptionIstRelevant(Kategorie kategorie, KategorieFelderContext context) {
        if (kategorie.UntereinheitId is { } eigeneId) {
            return new BoolExpression($"isInside('{context.GeoflaecheFuer(eigeneId)}', slot('{AdresseSlotName}')) == true");
        }

        if (!context.AusblendendeUntereinheitenByKategorieId.TryGetValue(kategorie.Id, out var ausblendende) || ausblendende.Count == 0) {
            return null;
        }

        var teilAusdruecke = ausblendende.Select(id => $"isInside('{context.GeoflaecheFuer(id)}', slot('{AdresseSlotName}')) == false");
        return new BoolExpression(string.Join(" && ", teilAusdruecke));
    }

    private static string EscapeForExpression(string value) => value.Replace("\\", "\\\\").Replace("'", "\\'");

    private record KategorieFelderContext(
        List<Kategorie> Alle,
        Dictionary<Guid, string> UntereinheitNamenById,
        Dictionary<Guid, List<Guid>> AusblendendeUntereinheitenByKategorieId,
        Dictionary<string, bool> BestehendeDurchsuchbarWerte
    ) {
        public string GeoflaecheFuer(Guid untereinheitId) {
            var name = UntereinheitNamenById.GetValueOrDefault(untereinheitId)
                ?? throw new NotAllowedException($"Untereinheit {untereinheitId} wurde nicht gefunden.");
            return UntereinheitGeoflaeche.NameByUntereinheitName.GetValueOrDefault(name)
                ?? throw new NotAllowedException(
                    $"Für die Untereinheit '{name}' ist keine Geofläche hinterlegt. Eigene (nicht geteilte) " +
                    "Kategorien können für diese Untereinheit nicht angelegt oder ausgeblendet werden.");
        }
    }
}
