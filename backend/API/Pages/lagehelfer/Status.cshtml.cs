using API.Features;
using API.Features.Lage;
using API.Features.Prozess;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class StatusModel(DomainContext db) : LagehelferPageModel {
    public string StatusText { get; private set; } = "";
    public int? Nummer { get; private set; }

    public async Task<IActionResult> OnGetAsync(Guid id, CancellationToken ct) {
        var meldung = await LageMeldungen.OfKommune(db, KommuneId)
            .Where(a => a.PublicId == id).Select(a => new { a.Id, a.Meldungsnummer }).SingleOrDefaultAsync(ct);
        if (meldung is null) return NotFound();
        Nummer = meldung.Meldungsnummer;
        var status = await MeldungStatusErmittlung.Ermittle(db, [meldung.Id], ct);
        StatusText = MeldungStatusErmittlung.Text(status[meldung.Id]);
        return Page();
    }
}
