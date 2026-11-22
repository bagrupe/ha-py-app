using API.Features.Lage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class ErklaerungModel(MeldungService service) : LagehelferPageModel {
    public PublicLage Lage { get; private set; } = null!;
    public async Task<IActionResult> OnGetAsync(Guid lageId, CancellationToken ct) {
        var lage = (await service.LoadActiveLagenAsync(KommuneId, ct)).SingleOrDefault(l => l.Id == lageId);
        if (lage is null) return RedirectToPage("Index", KommuneRoute);
        Lage = lage;
        TempData["AktiveLage"] = lage.Id.ToString();
        TempData.Remove(GefahrCheckModel.PrecheckPassedKey);
        return Page();
    }
}
