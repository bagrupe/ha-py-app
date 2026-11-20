using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess;

public static class ZustaendigkeitNames {
    private const string NoValue = "-";

    public static async Task<(string Organisationseinheit, string Abteilung)> Resolve(
        DomainContext domainContext, Zustaendigkeit? zustaendigkeit) {
        if (zustaendigkeit is null) {
            return (NoValue, NoValue);
        }

        if (zustaendigkeit is { Art: ZustaendigkeitArt.Dienstleister, DienstleisterId: { } dienstleisterId }) {
            var dienstleister = await domainContext.Dienstleister
                .Where(d => d.Id == dienstleisterId).Select(d => d.Name).FirstOrDefaultAsync();
            return (dienstleister ?? NoValue, NoValue);
        }

        var abteilung = zustaendigkeit.MitarbeiterGruppeId is { } gruppeId
            ? await domainContext.MitarbeiterGruppen.Where(m => m.Id == gruppeId).Select(m => m.Name)
                .FirstOrDefaultAsync()
            : null;

        var organisationseinheiten = zustaendigkeit.OrganisationseinheitId is { } oeId
            ? await domainContext.Untereinheit.Where(u => u.Id == oeId).Select(u => u.Name).ToListAsync()
            : zustaendigkeit.MitarbeiterGruppeId is { } gruppe
                ? await domainContext.MitarbeiterGruppen.Where(m => m.Id == gruppe)
                    .SelectMany(m => m.Organisationseinheiten).Select(u => u.Name).ToListAsync()
                : [];

        return (organisationseinheiten.Count > 0 ? string.Join(", ", organisationseinheiten) : NoValue,
            abteilung ?? NoValue);
    }
}
