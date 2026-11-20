using API.Features;
using API.Features.Auth;
using API.Features.Lage;
using API.Features.Untereinheit;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

public class GebietEinsatzleitungSeeder(BackendApiFactory factory) {
    private const string Polygon = """{"type":"Polygon","coordinates":[[[9.35,52.1],[9.4,52.1],[9.4,52.15],[9.35,52.1]]]}""";

    private DomainContext NewDb() =>
        factory.Services.CreateScope().ServiceProvider.GetRequiredService<DomainContext>();

    public static Gebiet NewGebiet(Guid untereinheitId) => new() {
        Id = Guid.NewGuid(),
        UntereinheitId = untereinheitId,
        Name = $"Gebiet {Guid.NewGuid():N}",
        Geometry = Polygon,
    };

    public static MitarbeiterGruppe NewMitarbeiterGruppe(Untereinheit owner) => new() {
        Id = Guid.NewGuid(),
        Name = $"Gruppe {Guid.NewGuid():N}",
        KommuneId = owner.KommuneId,
        Organisationseinheiten = [owner],
    };

    public async Task<API.Features.Kommune.Kommune> SeedKommune() {
        var kommune = new API.Features.Kommune.Kommune { Name = $"Andere Kommune {Guid.NewGuid():N}" };
        var db = NewDb();
        db.Kommunen.Add(kommune);
        await db.SaveChangesAsync();
        return kommune;
    }

    public async Task<Untereinheit> SeedUntereinheit(Guid? kommuneId = null) {
        var untereinheit = new Untereinheit {
            Id = Guid.NewGuid(),
            Name = $"Landkreis {Guid.NewGuid():N}",
            KommuneId = kommuneId ?? KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = false,
        };
        var db = NewDb();
        db.Untereinheit.Add(untereinheit);
        await db.SaveChangesAsync();
        return untereinheit;
    }

    public async Task SeedMitarbeiterGruppen(Untereinheit owner, params MitarbeiterGruppe[] gruppen) {
        var db = NewDb();
        db.Untereinheit.AttachRange(gruppen.SelectMany(g => g.Organisationseinheiten).Append(owner).Distinct());
        db.MitarbeiterGruppen.AddRange(gruppen);
        await db.SaveChangesAsync();
    }

    public async Task SeedGebiet(Gebiet gebiet, params MitarbeiterGruppe[] einsatzleitungen) {
        var db = NewDb();
        db.Gebiete.Add(gebiet);
        db.GebietEinsatzleitungen.AddRange(einsatzleitungen.Select(g =>
            new GebietEinsatzleitung { GebietId = gebiet.Id, MitarbeiterGruppeId = g.Id }));
        await db.SaveChangesAsync();
    }

    public async Task<List<Guid>> StoredEinsatzleitungIdsIncludingDeleted(Guid gebietId) {
        var ids = await NewDb().GebietEinsatzleitungen
            .Where(ge => ge.GebietId == gebietId)
            .Select(ge => ge.MitarbeiterGruppeId)
            .ToListAsync();
        return ids.Order().ToList();
    }

    public async Task DeleteMitarbeiterGruppe(Guid id) {
        var db = NewDb();
        var gruppe = await db.MitarbeiterGruppen.AsTracking().SingleAsync(g => g.Id == id);
        gruppe.IsDeleted = true;
        await db.SaveChangesAsync();
    }

    public async Task RemoveOrganisationseinheit(Guid gruppeId, Guid untereinheitId) {
        var db = NewDb();
        var gruppe = await db.MitarbeiterGruppen.AsTracking()
            .Include(g => g.Organisationseinheiten)
            .SingleAsync(g => g.Id == gruppeId);
        gruppe.Organisationseinheiten.Remove(gruppe.Organisationseinheiten.Single(u => u.Id == untereinheitId));
        await db.SaveChangesAsync();
    }
}
