using API.Features;
using API.Features.Lage;
using API.Features.Lage.Mutations;
using API.Features.Lage.Queries;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NodaTime;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class UmgebungModel(DomainContext db, IClock clock) : LagehelferPageModel {
    public record Treffer(PublicMeldung Meldung, int Meter);
    public IReadOnlyList<Treffer> Trefferliste { get; private set; } = [];
    [BindProperty(SupportsGet = true)] public double Lat { get; set; }
    [BindProperty(SupportsGet = true)] public double Lng { get; set; }
    [BindProperty(SupportsGet = true)] public string? Adresse { get; set; }
    public Guid? Bestaetigt { get; private set; }

    public async Task<IActionResult> OnGetAsync(CancellationToken ct) {
        if (TempData.Peek(GefahrCheckModel.PrecheckPassedKey) is not true) return RedirectToPage("GefahrCheck", KommuneRoute);
        var lagen = await PublicLageQueries.GetActiveLagen(KommuneId, db, ct);
        var selected = TempData.Peek("AktiveLage") as string;
        Trefferliste = lagen.Where(l => selected == null || l.Id.ToString() == selected).SelectMany(l => l.Meldungen)
            .Select(m => new Treffer(m, Entfernung(m))).Where(t => t.Meter <= 500)
            .OrderBy(t => t.Meter).Take(10).ToList();
        if (Guid.TryParse(TempData.Peek("UmgebungBestaetigt") as string, out var id)) Bestaetigt = id;
        return Page();
    }

    public async Task<IActionResult> OnPostAsync(Guid id, CancellationToken ct) {
        var result = await OnGetAsync(ct);
        if (result is not Microsoft.AspNetCore.Mvc.RazorPages.PageResult) return result;
        if (!Trefferliste.Any(t => t.Meldung.Id == id)) return BadRequest();
        if (Bestaetigt != id) {
            await new LageMeldungMutations().MeldungBestaetigen(db, clock, id, null, ct);
            TempData["UmgebungBestaetigt"] = id.ToString();
        }
        return RedirectToPage(new { kommuneId = KommuneId, Lat, Lng, Adresse });
    }

    private int Entfernung(PublicMeldung m) {
        var nord = (m.Latitude - Lat) * 111320;
        var ost = (m.Longitude - Lng) * 111320 * Math.Cos(Lat * Math.PI / 180);
        return (int)Math.Round(Math.Sqrt(nord * nord + ost * ost));
    }
}
