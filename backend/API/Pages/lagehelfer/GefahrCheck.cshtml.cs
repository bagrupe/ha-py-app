using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class GefahrCheckModel(MeldungService meldungService) : LagehelferPageModel {
    public const string PrecheckPassedKey = "LagehelferPrecheckPassed";

    public bool DangerReported { get; private set; }

    public async Task<IActionResult> OnGetAsync(CancellationToken ct) {
        if ((await meldungService.LoadActiveLagenAsync(KommuneId, ct)).Count == 0) return RedirectToPage("Index", KommuneRoute);

        TempData.Remove(PrecheckPassedKey);
        return Page();
    }

    public async Task<IActionResult> OnPostAsync(string? answer, CancellationToken ct) {
        if ((await meldungService.LoadActiveLagenAsync(KommuneId, ct)).Count == 0) return RedirectToPage("Index", KommuneRoute);

        if (answer == "nein") {
            TempData[PrecheckPassedKey] = true;
            return RedirectToPage("Melden", KommuneRoute);
        }

        TempData.Remove(PrecheckPassedKey);
        DangerReported = answer == "ja";
        return Page();
    }
}
