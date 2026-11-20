using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Queries;

/// <summary>Erweitert den Typ Ausfuehrung um Abfragen zum Status-Verlauf.</summary>
/// <remarks>
/// Zwei getrennte Streams für zwei Zielgruppen:
/// <list type="bullet">
///   <item><c>historie</c> (Stream E) – bürgerseitiger Status-Feed aus den vom Prozess-Autor
///     vergebenen Kanten-Labels, Freitextnachrichten aus Nachricht-Schritten und dem
///     synthetischen manuellen Abschluss.</item>
///   <item><c>verlauf</c> (Stream P) – Backoffice-Audit aus den persistierten
///     <see cref="VerlaufsEintrag"/>-Ereignissen. Nur persistierte Zeilen, keine Rekonstruktion.</item>
/// </list>
/// Da jeder Stream aus genau einer Quelle stammt, entfällt jegliche Deduplizierung.
/// </remarks>
[ExtendObjectType<Ausfuehrung>]
public class HistorieQuery {
    /// <summary>
    /// Liefert die bürgerseitige Status-Historie eines Antrags (Ausführung): die vom Prozess-Autor
    /// vergebenen Kanten-Statusmeldungen im zeitlichen Verlauf plus den synthetischen manuellen Abschluss.
    /// </summary>
    /// <param name="loader">DataLoader zum Laden der Historie.</param>
    /// <param name="parent">Die Ausführung, deren Historie abgefragt wird.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Auflistung der Historieneinträge.</returns>
    [GraphQLDescription(
        "Bürgerseitige Status-Historie eines Antrags (Ausführung): die vom Prozess-Autor vergebenen " +
        "Kanten-Statusmeldungen im zeitlichen Verlauf.")]
    public async Task<IEnumerable<Historie>> GetHistorie(IAusfuehrungHistorieByIdDataLoader loader,
        [Service] ICurrentUserAccessor currentUserAccessor,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Parent] Ausfuehrung parent, CancellationToken ct) {
        var historie = (await loader.LoadAsync(parent.Id, ct)).ToList();
        if (historie.All(h => h.Nachricht is null) ||
            await CanReadMessage(currentUserAccessor, ausfuehrungZustaendigkeitService, parent)) {
            return historie;
        }

        return historie.Select(h => new Historie {
            Id = h.Id,
            CreatedAt = h.CreatedAt,
            StatusAenderung = h.StatusAenderung,
            StatusAenderungBeschreibung = h.StatusAenderungBeschreibung,
            Benutzer = h.Benutzer,
            Ziel = h.Ziel,
            Nachricht = null,
        });
    }

    private static async Task<bool> CanReadMessage(ICurrentUserAccessor currentUserAccessor,
        AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService, Ausfuehrung ausfuehrung) {
        if (currentUserAccessor.TryUserId() is null) return false;

        try {
            await ausfuehrungZustaendigkeitService.EnsureZugriffAufAusfuehrung(ausfuehrung, currentUserAccessor);
            return true;
        } catch (Exception e) when (e is CurrentUserAccessor.Unauthenticated or NotAllowedException) {
            return false;
        }
    }

    /// <summary>
    /// Liefert den Backoffice-Verlauf eines Antrags (Ausführung): die persistierten Lebenszyklus-Ereignisse
    /// (Eingang, Übernahme, Weiterleitung, Zuständigkeitswechsel, Abschluss) im zeitlichen Verlauf.
    /// </summary>
    /// <param name="loader">DataLoader zum Laden des Verlaufs.</param>
    /// <param name="parent">Die Ausführung, deren Verlauf abgefragt wird.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Auflistung der persistierten Verlaufseinträge (leer, falls keine vorhanden sind).</returns>
    [GraphQLDescription(
        "Backoffice-Verlauf eines Antrags (Ausführung): die persistierten Lebenszyklus-Ereignisse " +
        "(Eingang, Übernahme, Weiterleitung, Zuständigkeitswechsel, Abschluss) im zeitlichen Verlauf. " +
        "Für Anträge ohne persistierte Ereignisse (vor Einführung der Protokollierung) leer.")]
    public async Task<IEnumerable<Historie>> GetVerlauf(
        IAusfuehrungVerlaufByIdDataLoader loader,
        [Service] ICurrentUserAccessor currentUserAccessor,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Parent] Ausfuehrung parent,
        CancellationToken ct) {
        await ausfuehrungZustaendigkeitService.EnsureBackofficeZugriffAufAusfuehrung(parent, currentUserAccessor);

        return await loader.LoadAsync(parent.Id, ct);
    }

    /// <summary>
    /// Lädt die bürgerseitige Historie (Stream E) für mehrere Ausführungen: aus den Kanten-Labels
    /// der Bearbeitungen rekonstruiert, plus dem synthetischen manuellen Abschluss.
    /// </summary>
    /// <param name="keys">Liste der Ausführungs-Ids.</param>
    /// <param name="dbContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Lookup mit Ausführungs-Id als Schlüssel und Historieneinträgen als Werte.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Historie>> GetAusfuehrungHistorieById(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        // Leere/Whitespace-StatusAenderung ist kein anzeigbarer Status – ausfiltern, sonst entstehen leere Einträge.
        // Bearbeitungen eines Nachricht-Schritts zählen auch ohne Kanten-Label, damit die Nachricht nicht verloren geht.
        var bearbeitungen = (await db.Bearbeitungen
                .AsSingleQuery()
                .Where(b => keys.Contains(b.AusfuehrungId) &&
                            (!string.IsNullOrWhiteSpace(b.NextVerbindung.StatusAenderung) ||
                             (b.Schritt is NachrichtSchritt &&
                              b.SlotValues.Any(sv => sv.SlotName == NachrichtSchritt.NachrichtSlotName))))
                .OrderBy(b => b.CreatedAt)
                .Include(b => b.NextVerbindung).Include(b => b.User)
                .Include(b => b.Schritt).Include(b => b.SlotValues)
                .ToListAsync(ct))
            .ToLookup(b => b.AusfuehrungId);

        var abgabeNachrichtById = (await db.VerlaufsEintraege
                .Where(v => keys.Contains(v.AusfuehrungId) &&
                            v.Art == VerlaufsEreignisArt.WeiterleitungAbgabe && v.Nachricht != null)
                .OrderBy(v => v.CreatedAt)
                .Select(v => new { v.AusfuehrungId, v.Nachricht })
                .ToListAsync(ct))
            .GroupBy(v => v.AusfuehrungId)
            .ToDictionary(g => g.Key, g => g.Last().Nachricht);

        var manuellAbgeschlossenById = (await db.Ausfuehrungen
                .Where(a => keys.Contains(a.Id) && a.ManuellAbgeschlossen != null)
                .Select(a => new { a.Id, a.ManuellAbgeschlossen })
                .ToListAsync(ct))
            .ToDictionary(a => a.Id, a => a.ManuellAbgeschlossen!.Value);

        var eintraege = new List<(Guid AusfuehrungId, Historie Historie)>();

        foreach (var ausfuehrungId in keys.Distinct()) {
            var historien = new List<Historie>();

            foreach (var b in bearbeitungen[ausfuehrungId]) {
                var nachricht = NachrichtText(b);
                if (string.IsNullOrWhiteSpace(b.NextVerbindung.StatusAenderung) && nachricht == null) continue;

                historien.Add(new Historie {
                    Id = b.NextVerbindungId,
                    CreatedAt = b.CreatedAt,
                    StatusAenderung = b.NextVerbindung.StatusAenderung,
                    StatusAenderungBeschreibung = b.NextVerbindung.StatusAenderungBeschreibung,
                    Benutzer = b.User is Mitarbeiter m ? $"{m.Vorname} {m.Nachname}".Trim() : null,
                    Nachricht = nachricht,
                });
            }

            if (manuellAbgeschlossenById.TryGetValue(ausfuehrungId, out var abgeschlossenAm)) {
                historien.Add(new Historie {
                    Id = ausfuehrungId,
                    CreatedAt = abgeschlossenAm,
                    StatusAenderung =
                        "Der Prozess wurde manuell abgeschlossen. Es werden keine weiteren Statusmeldungen folgen.",
                    StatusAenderungBeschreibung = "",
                    Nachricht = abgabeNachrichtById.GetValueOrDefault(ausfuehrungId),
                });
            }

            foreach (var historie in historien.OrderBy(h => h.CreatedAt)) {
                eintraege.Add((ausfuehrungId, historie));
            }
        }

        return eintraege.ToLookup(e => e.AusfuehrungId, e => e.Historie);
    }

    private static string? NachrichtText(Bearbeitung bearbeitung) =>
        bearbeitung.Schritt is NachrichtSchritt ? NachrichtSchritt.NachrichtFrom(bearbeitung) : null;

    /// <summary>
    /// Lädt den Backoffice-Verlauf (Stream P) für mehrere Ausführungen: ausschließlich die persistierten
    /// <see cref="VerlaufsEintrag"/>-Ereignisse, zeitlich geordnet. Keine Rekonstruktion aus Kanten-Labels.
    /// </summary>
    /// <param name="keys">Liste der Ausführungs-Ids.</param>
    /// <param name="dbContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Lookup mit Ausführungs-Id als Schlüssel und Verlaufseinträgen als Werte.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Historie>> GetAusfuehrungVerlaufById(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        var persistierte = await db.VerlaufsEintraege
            .Where(v => keys.Contains(v.AusfuehrungId))
            .OrderBy(v => v.CreatedAt)
            .ToListAsync(ct);

        return persistierte
            .Select(v => {
                var (statusAenderung, beschreibung) =
                    VerlaufDarstellung.Render(v.Art, v.BenutzerName, v.Zielbeschreibung);
                return (v.AusfuehrungId, Historie: new Historie {
                    Id = v.Id,
                    CreatedAt = v.CreatedAt,
                    StatusAenderung = statusAenderung,
                    StatusAenderungBeschreibung = beschreibung,
                    Benutzer = v.BenutzerName,
                    Ziel = v.Zielbeschreibung,
                    Nachricht = v.Nachricht,
                });
            })
            .ToLookup(e => e.AusfuehrungId, e => e.Historie);
    }
}
