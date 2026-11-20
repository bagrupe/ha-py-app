using System.Text.Json;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using NodaTime.Text;

namespace API.Features.Aufbewahrung.Archive;

/// <summary>Listeneintrag eines archivierten Antrags (Metadaten).</summary>
public record ArchivierterAntragListItem(
    Guid Id,
    string? ProzessBezeichnung,
    AusfuehrungStatus Status,
    Instant? AbgeschlossenAm,
    Instant ArchiviertAm);

/// <summary>Verschlüsselter Wert eines Slots (cipher/nonce/tag), zur Entschlüsselung im Frontend.</summary>
public record ArchivEncryptedValue(string Cipher, string Nonce, string Tag);

/// <summary>Ein Slot-Wert eines archivierten Antrags – entweder verschlüsselt oder im Klartext.</summary>
public record ArchivSlotWert(
    string SlotName,
    bool? IstFreigegeben,
    bool Encrypted,
    ArchivEncryptedValue? EncryptedValue,
    string? PlainValue);

/// <summary>Ein Verlaufseintrag (Backoffice-Audit) eines archivierten Antrags, gerendert aus dem persistierten Ereignis.</summary>
public record ArchivVerlaufEintrag(
    Guid Id,
    Instant CreatedAt,
    string StatusAenderung,
    string StatusAenderungBeschreibung,
    string? Benutzer,
    string? Ziel,
    string? Nachricht);

/// <summary>Detail eines archivierten Antrags inkl. der (verschlüsselten) Slot-Werte und des Verlaufs.</summary>
public record ArchivierterAntragDetail(
    Guid Id,
    string? ProzessBezeichnung,
    AusfuehrungStatus Status,
    Instant CreatedAt,
    Instant? AbgeschlossenAm,
    Instant ArchiviertAm,
    string SharedKeyEncryptedForKommune,
    IReadOnlyList<ArchivSlotWert> SlotWerte,
    IReadOnlyList<ArchivVerlaufEintrag> Verlauf);

/// <summary>
/// Read-only-Abfragen auf das Archiv (separate Archiv-DB). Berechtigung 'Archiv' erforderlich,
/// mandantengetrennt (nur die eigene Kommune). Die Slot-Werte bleiben verschlüsselt und werden
/// im Frontend mit dem bestehenden Krypto-Weg (Kommune-Schlüssel) entschlüsselt.
/// </summary>
[QueryType]
public class ArchivQueries {
    [GraphQLDescription("Liste archivierter Anträge im eigenen Zuständigkeitsbereich (Metadaten). Berechtigung 'Archiv' erforderlich.")]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [Authorize]
    public async Task<IQueryable<ArchivierterAntragListItem>> GetArchivierteAntraege(
        [Service] CurrentUserAccessor currentUserAccessor,
        [Service] FunktionsberechtigungenService funktionsberechtigungenService,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        ArchiveContext archive,
        string? search) {
        // Berechtigung prüfen + Sichtbarkeit exakt wie in der Live-Antragsliste (nur eigene Zuständigkeit).
        var (_, query) = await SichtbareAntraege(
            currentUserAccessor, funktionsberechtigungenService, ausfuehrungZustaendigkeitService, archive);

        if (!string.IsNullOrWhiteSpace(search)) {
            var pattern = $"%{search}%";
            query = query.Where(a =>
                a.ProzessBezeichnung != null && EF.Functions.ILike(a.ProzessBezeichnung, pattern));
        }

        // Kein .Take(500)/.ToListAsync() mehr - [UseOffsetPaging] übernimmt Skip/Take direkt auf
        // dem IQueryable, das Archiv ist die eine Liste ohne natürliche Obergrenze (Review-Feedback).
        return query
            .OrderByDescending(a => a.ArchiviertAm)
            .Select(a => new ArchivierterAntragListItem(
                a.Id, a.ProzessBezeichnung, a.Status, a.AbgeschlossenAm, a.ArchiviertAm));
    }

    [GraphQLDescription("Einzelner archivierter Antrag inkl. (verschlüsselter) Slot-Werte und Verlauf. Berechtigung 'Archiv' + Zuständigkeit erforderlich.")]
    [Authorize]
    public async Task<ArchivierterAntragDetail?> GetArchivierterAntrag(
        [Service] CurrentUserAccessor currentUserAccessor,
        [Service] FunktionsberechtigungenService funktionsberechtigungenService,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        ArchiveContext archive,
        Guid id) {
        // Detail nur, wenn der Antrag im sichtbaren (zuständigen) Bereich des Nutzers liegt.
        var (_, query) = await SichtbareAntraege(
            currentUserAccessor, funktionsberechtigungenService, ausfuehrungZustaendigkeitService, archive);

        var a = await query.FirstOrDefaultAsync(x => x.Id == id);
        if (a is null) {
            return null;
        }

        var dto = a.Inhalt.RootElement.Deserialize<AntragArchivDto>();

        // Slot-Werte auf "letzter Wert je Slot" reduzieren (wie in der Live-Ansicht).
        var slotMap = new Dictionary<string, ArchivSlotWert>();
        foreach (var bearbeitung in dto?.Bearbeitungen ?? new List<BearbeitungArchivDto>()) {
            foreach (var sv in bearbeitung.SlotValues) {
                ArchivSlotWert wert;
                if (sv.Value is JsonElement el && el.ValueKind != JsonValueKind.Null) {
                    if (sv.Typ == "Encrypted" && el.ValueKind == JsonValueKind.Object) {
                        wert = new ArchivSlotWert(
                            sv.SlotName, sv.IstFreigegeben, true,
                            new ArchivEncryptedValue(
                                el.TryGetProperty("Cipher", out var c) ? c.GetString() ?? "" : "",
                                el.TryGetProperty("Nonce", out var n) ? n.GetString() ?? "" : "",
                                el.TryGetProperty("Tag", out var t) ? t.GetString() ?? "" : ""),
                            null);
                    } else {
                        wert = new ArchivSlotWert(sv.SlotName, sv.IstFreigegeben, false, null, el.GetRawText());
                    }
                } else {
                    wert = new ArchivSlotWert(sv.SlotName, sv.IstFreigegeben, false, null, null);
                }

                slotMap[sv.SlotName] = wert; // last wins
            }
        }

        // Verlauf aus den archivierten VerlaufsEintraegen rendern (dieselbe Darstellung wie live),
        // damit die Nachvollziehbarkeit (Übernahme, Weiterleitung, Zuständigkeitswechsel, Abschluss)
        // auch nach dem Archivieren erhalten bleibt.
        var verlauf = (dto?.VerlaufsEintraege ?? new List<VerlaufsEintragArchivDto>())
            .Select(v => {
                var (statusAenderung, beschreibung) = VerlaufDarstellung.Render(v.Art, v.BenutzerName, v.Zielbeschreibung);
                return new ArchivVerlaufEintrag(
                    v.Id, InstantPattern.General.Parse(v.CreatedAt).Value, statusAenderung, beschreibung,
                    v.BenutzerName, v.Zielbeschreibung, v.Nachricht);
            })
            .OrderBy(v => v.CreatedAt)
            .ToList();

        return new ArchivierterAntragDetail(
            a.Id, a.ProzessBezeichnung, a.Status,
            a.CreatedAt, a.AbgeschlossenAm, a.ArchiviertAm,
            a.SharedKeyEncryptedForKommune,
            slotMap.Values.ToList(),
            verlauf);
    }

    /// <summary>
    /// Prüft die 'Archiv'-Berechtigung und liefert die für den Nutzer SICHTBAREN archivierten Anträge —
    /// nach exakt derselben Zuständigkeits-Logik wie die Live-Antragsliste (GetAusfuehrungen):
    /// Superadmin sieht alle (der Kommune), Dienstleister nur die eigenen, alle anderen nur Anträge der
    /// eigenen Organisationseinheiten/Mitarbeitergruppen oder der eigenen Person. Fehlt die Zuständigkeit
    /// (z.B. bei vor dieser Änderung archivierten Einträgen), ist der Eintrag fail-closed unsichtbar.
    /// </summary>
    private static async Task<(BackofficeUser User, IQueryable<ArchivierterAntrag> Query)> SichtbareAntraege(
        CurrentUserAccessor currentUserAccessor,
        FunktionsberechtigungenService funktionsberechtigungenService,
        AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        ArchiveContext archive) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        // 1) Feature-Berechtigung: Archiv einsehen
        berechtigungen.Global(GlobaleFunktionsberechtigung.ArchivEinsicht).Fordern();
        // 2) Wie Live-Liste: nur wer Anträge sehen darf, darf auch ins Archiv
        berechtigungen
            .InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
            .Fordern();

        var query = archive.ArchivierteAntraege.AsNoTracking()
            .Where(a => a.KommuneId == user.KommuneId);

        var organisationseinheitenIds =
            (await funktionsberechtigungenService.GetOrganisationseinheitenForUser(user))
            .Select(o => o.OrganisationseinheitId)
            .ToList();
        var mitarbeiterGruppenIds = user.Gruppen.Select(g => g.Id).ToList();

        return (user, ausfuehrungZustaendigkeitService.FilterSichtbareArchivierteAntraege(
            query, user, organisationseinheitenIds, mitarbeiterGruppenIds));
    }
}
