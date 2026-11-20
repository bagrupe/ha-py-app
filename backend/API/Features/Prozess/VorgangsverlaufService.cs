using API.Features.Auth;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Prozess;

/// <summary>
/// Zentrale Stelle zum Protokollieren von Lebenszyklus-Ereignissen einer Ausführung (Vorgang).
/// Legt append-only <see cref="VerlaufsEintrag"/>-Einträge im übergebenen Kontext an; der Aufrufer speichert.
/// </summary>
public class VorgangsverlaufService {
    private readonly IClock _clock;

    public VorgangsverlaufService(IClock clock) {
        _clock = clock;
    }

    /// <summary>
    /// Eingang eines neuen Antrags ("Antrag eingegangen").
    /// </summary>
    public void RecordEingang(DomainContext db, Guid ausfuehrungId, Instant eingegangenAm) =>
        Add(db, ausfuehrungId, VerlaufsEreignisArt.Eingang, benutzer: null, ziel: null, createdAt: eingegangenAm);

    /// <summary>Übernahme eines Vorgangs durch eine:n Sachbearbeiter:in.</summary>
    public void RecordUebernahme(DomainContext db, Guid ausfuehrungId, Mitarbeiter benutzer) =>
        Add(db, ausfuehrungId, VerlaufsEreignisArt.Uebernahme, benutzer, ziel: null);

    /// <summary>Weiterleitung (zur Ansicht, zur Abgabe, an Dienstleister oder Organisationseinheit).</summary>
    public void RecordWeiterleitung(DomainContext db, Guid ausfuehrungId, VerlaufsEreignisArt art,
        Mitarbeiter? benutzer, string? ziel, string? nachricht = null) =>
        Add(db, ausfuehrungId, art, benutzer, ziel, nachricht: nachricht);

    /// <summary>Wechsel der zuständigen Person bzw. Instanz.</summary>
    public void RecordZustaendigkeitswechsel(DomainContext db, Guid ausfuehrungId, Mitarbeiter? benutzer, string? ziel) =>
        Add(db, ausfuehrungId, VerlaufsEreignisArt.Zustaendigkeitswechsel, benutzer, ziel);

    /// <summary>Abschluss des Vorgangs (automatisch oder manuell).</summary>
    public void RecordAbschluss(DomainContext db, Guid ausfuehrungId, Mitarbeiter? benutzer) =>
        Add(db, ausfuehrungId, VerlaufsEreignisArt.Abschluss, benutzer, ziel: null);

    /// <summary>Freitextnachricht eines Nachricht-Schritts an die einreichende Person.</summary>
    public void RecordBuergerKommunikation(DomainContext db, Guid ausfuehrungId, Mitarbeiter? benutzer,
        string nachricht, Instant createdAt) =>
        Add(db, ausfuehrungId, VerlaufsEreignisArt.BuergerKommunikation, benutzer, ziel: null, createdAt, nachricht);

    /// <summary>Anzeigename eines Mitarbeiters für Ziel-/Benutzerangaben.</summary>
    public static string NameVon(Mitarbeiter mitarbeiter) => $"{mitarbeiter.Vorname} {mitarbeiter.Nachname}".Trim();

    /// <summary>
    /// Protokolliert den durch einen Prozessschritt bewirkten Zuständigkeitswechsel bzw. Abschluss.
    /// Der Aufrufer speichert.
    /// </summary>
    public async Task ProtokolliereZustaendigkeitswechsel(DomainContext db, Ausfuehrung ausfuehrung, Zustaendigkeit alt,
        Mitarbeiter? benutzer) {
        var neu = ausfuehrung.IstZustaendigkeit;

        if (ausfuehrung.Status == AusfuehrungStatus.Abgeschlossen) {
            RecordAbschluss(db, ausfuehrung.Id, benutzer);
            return;
        }

        var wechsel = alt.Art != neu.Art
                      || alt.DienstleisterId != neu.DienstleisterId
                      || alt.OrganisationseinheitId != neu.OrganisationseinheitId
                      || alt.MitarbeiterGruppeId != neu.MitarbeiterGruppeId
                      || alt.ZugewiesenePersonId != neu.ZugewiesenePersonId;
        if (!wechsel) return;

        var ziel = await BeschreibeZiel(db, neu);
        switch (neu.Art) {
            case ZustaendigkeitArt.Dienstleister:
                RecordWeiterleitung(db, ausfuehrung.Id, VerlaufsEreignisArt.WeiterleitungDienstleister, benutzer, ziel);
                break;
            case ZustaendigkeitArt.Organisationseinheit:
                RecordWeiterleitung(db, ausfuehrung.Id, VerlaufsEreignisArt.WeiterleitungOrganisationseinheit, benutzer,
                    ziel);
                break;
            default:
                RecordZustaendigkeitswechsel(db, ausfuehrung.Id, benutzer, ziel);
                break;
        }
    }

    /// <summary>Beschreibt die Zielperson bzw. Zielorganisation einer Zuständigkeit als Anzeigetext.</summary>
    private static async Task<string?> BeschreibeZiel(DomainContext db, Zustaendigkeit zustaendigkeit) {
        if (zustaendigkeit.ZugewiesenePersonId is { } personId) {
            var person = await db.Mitarbeiter.Where(m => m.Id == personId)
                .Select(m => new { m.Vorname, m.Nachname }).FirstOrDefaultAsync();
            return person is null ? null : $"{person.Vorname} {person.Nachname}".Trim();
        }

        if (zustaendigkeit.DienstleisterId is { } dienstleisterId) {
            return await db.Dienstleister.Where(d => d.Id == dienstleisterId).Select(d => d.Name)
                .FirstOrDefaultAsync();
        }

        if (zustaendigkeit.OrganisationseinheitId is { } organisationseinheitId) {
            return await db.Untereinheit.Where(u => u.Id == organisationseinheitId).Select(u => u.Name)
                .FirstOrDefaultAsync();
        }

        if (zustaendigkeit.MitarbeiterGruppeId is { } mitarbeiterGruppeId) {
            return await db.MitarbeiterGruppen.Where(g => g.Id == mitarbeiterGruppeId).Select(g => g.Name)
                .FirstOrDefaultAsync();
        }

        return null;
    }

    private void Add(DomainContext db, Guid ausfuehrungId, VerlaufsEreignisArt art, Mitarbeiter? benutzer, string? ziel,
        Instant? createdAt = null, string? nachricht = null) {
        db.VerlaufsEintraege.Add(new VerlaufsEintrag {
            AusfuehrungId = ausfuehrungId,
            CreatedAt = createdAt ?? _clock.GetCurrentInstant(),
            Art = art,
            BenutzerId = benutzer?.Id,
            BenutzerName = benutzer is null ? null : NameVon(benutzer),
            Zielbeschreibung = ziel,
            Nachricht = nachricht,
        });
    }
}
