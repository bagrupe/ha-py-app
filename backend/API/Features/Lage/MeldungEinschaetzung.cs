using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage;

[GraphQLDescription("Klasse einer Meldung nach dem Eisenhower-Schema.")]
public enum MeldungKlasse {
    [GraphQLDescription("Dringend und wichtig.")]
    A,

    [GraphQLDescription("Wichtig, nicht dringend.")]
    B,

    [GraphQLDescription("Dringend, nicht wichtig.")]
    C,

    [GraphQLDescription("Weder dringend noch wichtig.")]
    D,
}

public record Einschaetzung(MeldungKlasse Klasse, List<string> BenoetigteAusruestung, bool MoeglicherNotfall);

/// <summary>
/// Rule-based first assessment of a report from its category and description. A human corrects it in the
/// dashboard; there is deliberately no LLM in the prototype.
/// </summary>
public static partial class MeldungEinschaetzung {
    public const string Motorkettensaege = "Motorkettensäge";
    public const string Drehleiter = "Drehleiter";
    public const string Pumpe = "Pumpe";
    public const string Absperrung = "Absperrung";
    public const string Radlader = "Radlader";
    public const string Seilwinde = "Seilwinde";

    private static readonly (Regex Muster, string Ausruestung)[] AusruestungsRegeln = [
        (BaumMuster(), Motorkettensaege),
        (DachMuster(), Drehleiter),
        (WasserMuster(), Pumpe),
        (AbsperrungMuster(), Absperrung),
        (RadladerMuster(), Radlader),
    ];

    /// <summary>Assesses the given reports from their stored category and description and saves the result.</summary>
    public static async Task EinschaetzenUndSpeichern(DomainContext db, IReadOnlyCollection<Guid> ausfuehrungIds,
        CancellationToken ct) {
        if (ausfuehrungIds.Count == 0) return;
        var texte = (await db.PlainSlotValues
                .Where(sv => ausfuehrungIds.Contains(sv.Bearbeitung.AusfuehrungId)
                    && (sv.SlotName == OpenMeldungen.KategorieSlot || sv.SlotName == OpenMeldungen.BeschreibungSlot))
                .Select(sv => new { sv.Bearbeitung.AusfuehrungId, sv.Bearbeitung.CreatedAt, sv.SlotName, sv.Value })
                .ToListAsync(ct))
            .GroupBy(sv => (sv.AusfuehrungId, sv.SlotName))
            .ToDictionary(g => g.Key, g => g.MaxBy(sv => sv.CreatedAt)!.Value is { ValueKind: JsonValueKind.String } v
                ? v.GetString()
                : null);

        var meldungen = await db.Ausfuehrungen.AsTracking().Where(a => ausfuehrungIds.Contains(a.Id)).ToListAsync(ct);
        foreach (var meldung in meldungen) {
            var einschaetzung = Einschaetzen(texte.GetValueOrDefault((meldung.Id, OpenMeldungen.KategorieSlot)),
                texte.GetValueOrDefault((meldung.Id, OpenMeldungen.BeschreibungSlot)));
            meldung.Klasse = einschaetzung.Klasse;
            meldung.BenoetigteAusruestung = einschaetzung.BenoetigteAusruestung;
            meldung.MoeglicherNotfall = einschaetzung.MoeglicherNotfall;
        }
        await db.SaveChangesAsync(ct);
    }

    /// <summary>Catches up reports created before the assessment existed.</summary>
    public static async Task Nachholen(DomainContext db, CancellationToken ct) {
        var ids = await db.Ausfuehrungen
            .Where(a => a.LageGebietId != null && a.Klasse == null)
            .Select(a => a.Id)
            .ToListAsync(ct);
        await EinschaetzenUndSpeichern(db, ids, ct);
    }

    public static Einschaetzung Einschaetzen(string? kategorie, string? beschreibung) {
        var text = $"{kategorie} {beschreibung}".ToLowerInvariant();
        var notfall = Trifft(NotfallMuster(), text);
        var ausruestung = AusruestungsRegeln
            .Where(r => Trifft(r.Muster, text))
            .Select(r => r.Ausruestung)
            .Distinct()
            .ToList();
        var dringend = notfall || Trifft(DringendMuster(), text);
        var wichtig = notfall || Trifft(WichtigMuster(), text);
        var klasse = (dringend, wichtig) switch {
            (true, true) => MeldungKlasse.A,
            (false, true) => MeldungKlasse.B,
            (true, false) => MeldungKlasse.C,
            _ => MeldungKlasse.D,
        };
        return new Einschaetzung(klasse, ausruestung, notfall);
    }

    /// <summary>
    /// True if a match is not negated by "kein", "nicht", "ohne", … in the three words before it within the same
    /// clause. Doubt after the negation ("nicht sicher, ob jemand verletzt") keeps the match, because a missed
    /// emergency costs more than a false alarm.
    /// </summary>
    private static bool Trifft(Regex muster, string text) =>
        muster.Matches(text).Any(m => !Verneint(text[..m.Index]));

    private static bool Verneint(string davor) {
        var satzteil = SatzteilGrenze().Split(davor)[^1];
        var woerter = satzteil.Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries).TakeLast(3).ToList();
        var verneinung = woerter.FindLastIndex(w => Verneinungen.Contains(w));
        return verneinung >= 0 && !woerter.Skip(verneinung + 1).Any(Zweifel.Contains);
    }

    private static readonly HashSet<string> Verneinungen =
        ["kein", "keine", "keiner", "keinen", "keinem", "nicht", "ohne", "niemand", "nichts", "nie"];

    private static readonly HashSet<string> Zweifel =
        ["ob", "vielleicht", "eventuell", "evtl.", "evtl", "möglicherweise", "unklar", "sicher", "wohl"];

    [GeneratedRegex(@"[.,;:!?\n]|\b(?:und|aber|sondern|doch|oder)\b")]
    private static partial Regex SatzteilGrenze();

    [GeneratedRegex(@"eingeklemmt|eingeschlossen|verletzt|bewusstlos|nicht ansprechbar|reagiert nicht|noch drin|atmet nicht|blutet|lebensgefahr|brennt|flammen|\brauch\b|stromleitung|strom liegt")]
    private static partial Regex NotfallMuster();

    [GeneratedRegex(@"baum|bäume|\bast\b|\bäste|stamm")]
    private static partial Regex BaumMuster();

    [GeneratedRegex(@"dach|ziegel|schornstein|giebel|fassade|aufs haus|auf das haus")]
    private static partial Regex DachMuster();

    [GeneratedRegex(@"keller|überflut|überschwemm|vollgelaufen|gully|wasser|hochwasser|unterführung")]
    private static partial Regex WasserMuster();

    [GeneratedRegex(@"gehweg|unterführung|straße überflutet|gully|bauzaun|lose|herab|fallen")]
    private static partial Regex AbsperrungMuster();

    [GeneratedRegex(@"mehrere bäume|waldweg|geröll|schlamm|erdrutsch|radlader")]
    private static partial Regex RadladerMuster();

    [GeneratedRegex(@"quer|blockiert|kommt nicht durch|kein durchkommen|läuft über|vollgelaufen|steigt|überflut|lose|fallen|droht")]
    private static partial Regex DringendMuster();

    [GeneratedRegex(@"fahrbahn|straße|bundesstraße|gehweg|spielplatz|schule|kita|haus|dach|ziegel|pkw|auto|gemeindehaus|krankenhaus|stromleitung")]
    private static partial Regex WichtigMuster();
}

/// <summary>Typical equipment by vehicle type, taken from the leading abbreviation of the unit name.</summary>
public static class Fahrzeugausstattung {
    private static readonly Dictionary<string, string[]> NachTyp = new(StringComparer.OrdinalIgnoreCase) {
        ["HLF"] = [MeldungEinschaetzung.Motorkettensaege, MeldungEinschaetzung.Pumpe, MeldungEinschaetzung.Absperrung],
        ["LF"] = [MeldungEinschaetzung.Motorkettensaege, MeldungEinschaetzung.Pumpe, MeldungEinschaetzung.Absperrung],
        ["TLF"] = [MeldungEinschaetzung.Pumpe, MeldungEinschaetzung.Absperrung],
        ["DLK"] = [MeldungEinschaetzung.Drehleiter, MeldungEinschaetzung.Motorkettensaege, MeldungEinschaetzung.Absperrung],
        ["RW"] = [MeldungEinschaetzung.Motorkettensaege, MeldungEinschaetzung.Seilwinde, MeldungEinschaetzung.Pumpe],
        ["MTW"] = [MeldungEinschaetzung.Motorkettensaege],
        ["GW-L"] = [MeldungEinschaetzung.Pumpe, MeldungEinschaetzung.Absperrung],
        ["RL"] = [MeldungEinschaetzung.Radlader],
    };

    public static List<string> Standard(string einheitName) {
        var typ = einheitName.Split(' ', 2)[0];
        return NachTyp.TryGetValue(typ, out var ausruestung) ? [.. ausruestung] : [];
    }
}
