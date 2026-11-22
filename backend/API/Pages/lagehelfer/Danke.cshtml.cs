using Microsoft.EntityFrameworkCore;
using API.Features.Lage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class DankeModel(API.Features.DomainContext db) : LagehelferPageModel {
    public string Confirmation { get; private set; } = "";

    public Guid? PublicId { get; private set; }

    public async Task<IActionResult> OnGetAsync(CancellationToken ct) {
        if (Request.Query["bestaetigt"] == "true" && Guid.TryParse(TempData.Peek("UmgebungBestaetigt") as string, out var bestaetigt)) {
            var nummer = await LageMeldungen.OfKommune(db, KommuneId).Where(a => a.PublicId == bestaetigt)
                .Select(a => a.Meldungsnummer).SingleOrDefaultAsync(ct);
            if (nummer is null) return NotFound();
            PublicId = bestaetigt;
            Confirmation = nummer.ToString()!;
            return Page();
        }
        if (TempData.Peek(MeldenModel.ConfirmationKey) is not string confirmation) return RedirectToPage("Index", KommuneRoute);

        if (!Guid.TryParse(confirmation.Replace("Meldungs-Nr. ", ""), out var correlation)) return RedirectToPage("Index", KommuneRoute);
        var report = await LageMeldungen.OfKommune(db, KommuneId).Where(a => a.CorrelationId == correlation)
            .Select(a => new { a.PublicId, a.Meldungsnummer }).SingleOrDefaultAsync(ct);
        if (report is null) return RedirectToPage("Index", KommuneRoute);
        Confirmation = report.Meldungsnummer?.ToString() ?? correlation.ToString();
        PublicId = report.PublicId;
        return Page();
    }
}
