using API.Features.Aufbewahrung.Archive;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Aufbewahrung.Papierkorb;

public record GeloeschterAntrag(
    Guid Id,
    string ProzessBezeichnung,
    AusfuehrungStatus Status,
    Instant CreatedAt,
    Instant GeloeschtAm,
    string? Loeschgrund,
    string? GeloeschtVon,
    [property: GraphQLDescription(
        "Zeitpunkt der endgültigen Löschung. Null, wenn der Lösch-Job derzeit deaktiviert ist (keine Frist).")]
    Instant? EndgueltigGeloeschtAm);

public record GeloeschterAntragDetail(
    GeloeschterAntrag Antrag,
    string SharedKeyEncryptedForKommune,
    IReadOnlyList<ArchivSlotWert> SlotWerte,
    IReadOnlyList<ArchivVerlaufEintrag> Verlauf);

[QueryType]
public class PapierkorbQueries {
    [GraphQLDescription("Liste soft-gelöschter Anträge im eigenen Zuständigkeitsbereich, die noch nicht endgültig gelöscht sind. Berechtigung 'Anträge löschen' erforderlich.")]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [Authorize]
    public async Task<IQueryable<GeloeschterAntrag>> GetGeloeschteAntraege(
        [Service] CurrentUserAccessor currentUserAccessor,
        [Service] FunktionsberechtigungenService funktionsberechtigungenService,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Service] IClock clock,
        DomainContext db,
        string? search) {
        var (_, query, einstellungen) = await SichtbareAntraege(
            currentUserAccessor, funktionsberechtigungenService, ausfuehrungZustaendigkeitService, clock, db);

        if (!string.IsNullOrWhiteSpace(search)) {
            var escaped = search.Replace("\\", "\\\\").Replace("%", "\\%").Replace("_", "\\_");
            var pattern = $"%{escaped}%";
            query = query.Where(a => EF.Functions.ILike(a.ProzessVersion.Prozess.Name, pattern, "\\"));
        }

        var verzoegerung = Duration.FromMinutes(einstellungen.HardDeleteVerzoegerungMinuten);
        var hardDeleteAktiv = einstellungen.HardDeleteAktiv;

        return query
            .OrderByDescending(a => a.GeloeschtAm)
            .ThenBy(a => a.Id)
            .Select(a => new GeloeschterAntrag(
                a.Id,
                a.ProzessVersion.Prozess.Name,
                a.Status,
                a.CreatedAt,
                a.GeloeschtAm!.Value,
                a.Loeschgrund,
                db.BackofficeUser
                    .Where(u => u.Id == a.GeloeschtVonId)
                    .Select(u => u.Vorname + " " + u.Nachname)
                    .FirstOrDefault(),
                hardDeleteAktiv ? a.GeloeschtAm!.Value + verzoegerung : (Instant?)null));
    }

    [GraphQLDescription("Einzelner soft-gelöschter Antrag im Papierkorb inkl. (verschlüsselter) Slot-Werte und Verlauf. Berechtigung 'Anträge löschen' + Zuständigkeit erforderlich.")]
    [Authorize]
    public async Task<GeloeschterAntragDetail?> GetGeloeschterAntrag(
        [Service] CurrentUserAccessor currentUserAccessor,
        [Service] FunktionsberechtigungenService funktionsberechtigungenService,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
        [Service] IClock clock,
        DomainContext db,
        Guid id) {
        var (_, query, einstellungen) = await SichtbareAntraege(
            currentUserAccessor, funktionsberechtigungenService, ausfuehrungZustaendigkeitService, clock, db);

        var verzoegerung = Duration.FromMinutes(einstellungen.HardDeleteVerzoegerungMinuten);
        var hardDeleteAktiv = einstellungen.HardDeleteAktiv;

        var a = await query
            .Where(x => x.Id == id)
            .Include(x => x.ProzessVersion).ThenInclude(pv => pv.Prozess)
            .Include(x => x.Bearbeitungen).ThenInclude(b => b.SlotValues)
            .AsSplitQuery()
            .FirstOrDefaultAsync();
        if (a is null) {
            return null;
        }

        var geloeschtVon = a.GeloeschtVonId is { } vonId
            ? await db.BackofficeUser.AsNoTracking().Where(u => u.Id == vonId)
                .Select(u => u.Vorname + " " + u.Nachname).FirstOrDefaultAsync()
            : null;

        var slotMap = new Dictionary<string, ArchivSlotWert>();
        foreach (var sv in a.Bearbeitungen.OrderBy(b => b.CreatedAt).SelectMany(b => b.SlotValues)) {
            slotMap[sv.SlotName] = sv switch {
                EncryptedSlotValue e => new ArchivSlotWert(
                    e.SlotName, e.IstFreigegeben, true,
                    new ArchivEncryptedValue(e.Value.Cipher, e.Value.Nonce, e.Value.Tag), null),
                PlainSlotValue p => new ArchivSlotWert(
                    p.SlotName, p.IstFreigegeben, false, null,
                    p.Value.ValueKind == System.Text.Json.JsonValueKind.Null ? null : p.Value.GetRawText()),
                _ => new ArchivSlotWert(sv.SlotName, sv.IstFreigegeben, false, null, null),
            };
        }

        var verlauf = (await db.VerlaufsEintraege.AsNoTracking()
                .Where(v => v.AusfuehrungId == a.Id)
                .OrderBy(v => v.CreatedAt)
                .ToListAsync())
            .Select(v => {
                var (statusAenderung, beschreibung) = VerlaufDarstellung.Render(v.Art, v.BenutzerName, v.Zielbeschreibung);
                return new ArchivVerlaufEintrag(
                    v.Id, v.CreatedAt, statusAenderung, beschreibung, v.BenutzerName, v.Zielbeschreibung, v.Nachricht);
            })
            .ToList();

        return new GeloeschterAntragDetail(
            new GeloeschterAntrag(
                a.Id, a.ProzessVersion.Prozess.Name, a.Status, a.CreatedAt, a.GeloeschtAm!.Value,
                a.Loeschgrund, geloeschtVon,
                hardDeleteAktiv ? a.GeloeschtAm!.Value + verzoegerung : null),
            a.SharedKeyEncryptedForKommune,
            slotMap.Values.ToList(),
            verlauf);
    }

    private static async Task<(BackofficeUser User, IQueryable<Ausfuehrung> Query, AufbewahrungsEinstellungen Einstellungen)>
        SichtbareAntraege(
            CurrentUserAccessor currentUserAccessor,
            FunktionsberechtigungenService funktionsberechtigungenService,
            AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService,
            IClock clock,
            DomainContext db) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        berechtigungen.Global(GlobaleFunktionsberechtigung.AntragLoeschung).Fordern();
        berechtigungen
            .InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
            .Fordern();

        var einstellungen = await db.AufbewahrungsEinstellungen.AsNoTracking()
                                .FirstOrDefaultAsync(e => e.Id == AufbewahrungsEinstellungen.SingletonId)
                            ?? new AufbewahrungsEinstellungen();

        var organisationseinheitenIds =
            (await funktionsberechtigungenService.GetOrganisationseinheitenForUser(user))
            .Select(o => o.OrganisationseinheitId)
            .ToList();
        var mitarbeiterGruppenIds = user.Gruppen.Select(g => g.Id).ToList();

        var query = ausfuehrungZustaendigkeitService.FilterSichtbareAusfuehrungen(
                db.Ausfuehrungen.AsNoTracking().Where(a => a.GeloeschtAm != null && a.GeloeschtVonId != null),
                user, organisationseinheitenIds, mitarbeiterGruppenIds)
            .Where(a => a.ProzessVersion.Prozess.KommuneId == user.KommuneId);

        if (einstellungen.HardDeleteAktiv) {
            var cutoff = clock.GetCurrentInstant() - Duration.FromMinutes(einstellungen.HardDeleteVerzoegerungMinuten);
            query = query.Where(a => a.GeloeschtAm > cutoff);
        }

        return (user, query, einstellungen);
    }
}
