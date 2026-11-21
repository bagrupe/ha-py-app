using API.Features.Expressions;
using API.Features.Geo;
using API.Features.Lage;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.ProgrammatischeSchritte;

/// <summary>
/// Leitet eine LageHelfer-Meldung an die Einsatzleitung des Gebiets weiter, in dem ihr Standort (Slot "adresse")
/// liegt. Überlappen sich Gebiete, gewinnt eines, dessen Lage gerade Meldungen annimmt
/// (<see cref="LageGebietStateMachine.AcceptsMeldungen"/>). Ohne Live-Lage wird trotzdem die Einsatzleitung des
/// Gebiets zuständig: die Gebietszuordnung gilt unabhängig von einer Lage. Erwartet genau eine ausgehende Verbindung.
/// </summary>
[SchrittName("Einsatzleitung anhand Gebiet ermitteln", LiefertZustaendigkeit = true)]
public class GebietEinsatzleitungZustaendigkeitSchritt(
    ILogger<GebietEinsatzleitungZustaendigkeitSchritt> logger,
    IDbContextFactory<DomainContext> dbContextFactory
) : ProgrammatischerSchrittExecutable {
    public const string StandortSlotName = KategorieOrtZustaendigkeitSchritt.AdresseSlotName;

    public async Task<ProgrammatischerSchrittResult> ExecuteAsync(Walker walker) {
        var kommuneId = walker.Prozess.KommuneId;
        var standort = KategorieOrtZustaendigkeitSchritt.GetLocationSlot(walker.CurrentSlotValues(), StandortSlotName);

        var treffer = await ErmittleEinsatzleitung(kommuneId, standort)
            ?? throw new InvalidOperationException(
                $"Kein Gebiet mit Einsatzleitung deckt den Standort ({standort.Lng}, {standort.Lat}) ab " +
                $"(Kommune {kommuneId}, Ausführung {walker.Ausfuehrung.Id}).");

        logger.LogInformation(
            "Meldung {AusfuehrungId} geht an Einsatzleitung {MitarbeiterGruppeId} von Gebiet {Gebiet} (Live-Lage: {Live})",
            walker.Ausfuehrung.Id, treffer.Zustaendigkeit.MitarbeiterGruppeId, treffer.GebietName, treffer.LageIstLive);

        return new ProgrammatischerSchrittResult(walker.CurrentVerbindungen[0].Id, treffer.Zustaendigkeit);
    }

    public record Treffer(Guid GebietId, string GebietName, bool LageIstLive, Zustaendigkeit Zustaendigkeit);

    public async Task<Treffer?> ErmittleEinsatzleitung(Guid kommuneId, EvaluatingVisitor.ParsedLocation standort) {
        await using var db = await dbContextFactory.CreateDbContextAsync();

        var gebiete = await db.Gebiete
            .Where(g => g.Untereinheit.KommuneId == kommuneId && g.Geometry != null)
            .Select(g => new { g.Id, g.Name, g.UntereinheitId, g.Geometry })
            .ToListAsync();
        var gebieteAmStandort = gebiete.Where(g => GeoJsonGeometry.Contains(g.Geometry!, standort)).ToList();
        if (gebieteAmStandort.Count == 0) {
            return null;
        }
        var gebietIds = gebieteAmStandort.Select(g => g.Id).ToList();

        var einsatzleitungen = await db.GebietEinsatzleitungen
            .Where(GebietEinsatzleitung.IsEffective)
            .Where(ge => gebietIds.Contains(ge.GebietId))
            .Select(ge => new { ge.GebietId, ge.MitarbeiterGruppeId, ge.MitarbeiterGruppe.Name })
            .ToListAsync();

        var offeneStatus = await db.LageGebiete
            .Where(lg => gebietIds.Contains(lg.GebietId) && lg.Lage.Status != LageStatus.Closed && lg.Lage.DeletedAt == null)
            .Select(lg => new { lg.GebietId, lg.Status })
            .ToListAsync();
        var liveGebietIds = offeneStatus
            .Where(lg => LageGebietStateMachine.AcceptsMeldungen(lg.Status))
            .Select(lg => lg.GebietId)
            .ToHashSet();

        var gewaehlt = gebieteAmStandort
            .Select(g => new {
                Gebiet = g,
                Live = liveGebietIds.Contains(g.Id),
                Einsatzleitung = einsatzleitungen.Where(e => e.GebietId == g.Id).OrderBy(e => e.Name).FirstOrDefault(),
            })
            .Where(k => k.Einsatzleitung is not null)
            .OrderByDescending(k => k.Live)
            .ThenBy(k => k.Gebiet.Name)
            .FirstOrDefault();
        if (gewaehlt is null) {
            return null;
        }

        return new Treffer(gewaehlt.Gebiet.Id, gewaehlt.Gebiet.Name, gewaehlt.Live, new Zustaendigkeit {
            Art = ZustaendigkeitArt.Organisationseinheit,
            OrganisationseinheitId = gewaehlt.Gebiet.UntereinheitId,
            MitarbeiterGruppeId = gewaehlt.Einsatzleitung!.MitarbeiterGruppeId,
        });
    }
}
