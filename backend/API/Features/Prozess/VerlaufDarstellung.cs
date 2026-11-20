namespace API.Features.Prozess;

/// <summary>
/// Rendert die Anzeige-Texte (kurze Statusänderung + längere Beschreibung) eines
/// Verlaufsereignisses.
/// </summary>
public static class VerlaufDarstellung {
    /// <summary>Liefert (StatusAenderung, Beschreibung) für ein Verlaufsereignis.</summary>
    public static (string StatusAenderung, string Beschreibung) Render(
        VerlaufsEreignisArt art, string? benutzerName, string? ziel) {
        return art switch {
            VerlaufsEreignisArt.Eingang => ("Antrag eingegangen", ""),
            VerlaufsEreignisArt.Uebernahme => ("Vorgang übernommen",
                benutzerName is null
                    ? "Vorgang wurde übernommen"
                    : $"Vorgang wurde von {benutzerName} übernommen"),
            VerlaufsEreignisArt.WeiterleitungAnsicht => ("Weiterleitung zur Ansicht",
                $"Vorgang zur Ansicht an {ziel} weitergeleitet"),
            VerlaufsEreignisArt.WeiterleitungAbgabe => ("Weiterleitung zur Abgabe",
                $"Vorgang zur Bearbeitung an {ziel} weitergeleitet"),
            VerlaufsEreignisArt.WeiterleitungDienstleister => ("Weiterleitung an Dienstleister",
                $"Vorgang an Dienstleister {ziel} übergeben"),
            VerlaufsEreignisArt.WeiterleitungOrganisationseinheit => ("Weiterleitung an Organisationseinheit",
                $"Vorgang an Organisationseinheit {ziel} übergeben"),
            VerlaufsEreignisArt.Zustaendigkeitswechsel => ("Zuständigkeitswechsel",
                ziel is null ? "Zuständigkeit geändert" : $"Zuständigkeit geändert zu {ziel}"),
            VerlaufsEreignisArt.Abschluss => ("Vorgang abgeschlossen", "Der Vorgang wurde abgeschlossen."),
            VerlaufsEreignisArt.BuergerKommunikation => ("Bürger Kommunikation",
                benutzerName is null
                    ? "Nachricht an die einreichende Person gesendet"
                    : $"Nachricht von {benutzerName} an die einreichende Person gesendet"),
            _ => (art.ToString(), ""),
        };
    }
}
