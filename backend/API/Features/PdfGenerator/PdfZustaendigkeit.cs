using API.Features.Prozess;
using Microsoft.EntityFrameworkCore;

namespace API.Features.PdfGenerator;

/// <summary>Names of the responsible unit printed in the PDF header.</summary>
public record PdfZustaendigkeit(string? Organisationseinheit, string? Abteilung, string? Dienstleister) {
    /// <summary>An empty Zuständigkeit, e.g. for a Bürger or dynamic Zuständigkeit.</summary>
    public static readonly PdfZustaendigkeit None = new(null, null, null);

    /// <summary>Builds the header names from a Zuständigkeit whose navigations are loaded.</summary>
    public static PdfZustaendigkeit FromLoaded(Zustaendigkeit zustaendigkeit) => zustaendigkeit.Art switch {
        ZustaendigkeitArt.Organisationseinheit => new PdfZustaendigkeit(zustaendigkeit.Organisationseinheit?.Name,
            zustaendigkeit.MitarbeiterGruppe?.Name, null),
        ZustaendigkeitArt.Dienstleister => new PdfZustaendigkeit(null, null, zustaendigkeit.Dienstleister?.Name),
        _ => None,
    };

    /// <summary>Builds the header names by looking up the Zuständigkeit's ids.</summary>
    public static async Task<PdfZustaendigkeit> Load(DomainContext db, Zustaendigkeit zustaendigkeit,
        CancellationToken ct = default) {
        switch (zustaendigkeit.Art) {
            case ZustaendigkeitArt.Organisationseinheit:
                var organisationseinheit = await db.Untereinheit
                    .Where(u => u.Id == zustaendigkeit.OrganisationseinheitId)
                    .Select(u => u.Name)
                    .FirstOrDefaultAsync(ct);
                var abteilung = await db.MitarbeiterGruppen
                    .Where(g => g.Id == zustaendigkeit.MitarbeiterGruppeId)
                    .Select(g => g.Name)
                    .FirstOrDefaultAsync(ct);
                return new PdfZustaendigkeit(organisationseinheit, abteilung, null);
            case ZustaendigkeitArt.Dienstleister:
                var dienstleister = await db.Dienstleister
                    .Where(d => d.Id == zustaendigkeit.DienstleisterId)
                    .Select(d => d.Name)
                    .FirstOrDefaultAsync(ct);
                return new PdfZustaendigkeit(null, null, dienstleister);
            default:
                return None;
        }
    }
}
