using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class GefahrCheckModel(MeldungService meldungService) : LagehelferPageModel {
    public const string PrecheckPassedKey = "LagehelferPrecheckPassed";



    public async Task<IActionResult> OnGetAsync(CancellationToken ct) {
        if ((await meldungService.LoadActiveLagenAsync(KommuneId, ct)).Count == 0) return RedirectToPage("Index", KommuneRoute);

        TempData.Remove(PrecheckPassedKey);
        return Page();
    }

    public async Task<IActionResult> OnPostAsync(CancellationToken ct) {
        if ((await meldungService.LoadActiveLagenAsync(KommuneId, ct)).Count == 0) return RedirectToPage("Index", KommuneRoute);

        var answers = Enumerable.Range(0, 3).Select(i => Request.Form[$"answers[{i}]"].ToString()).ToArray();
        if (answers.Length == 3 && answers.All(a => a == "nein")) {
            TempData[PrecheckPassedKey] = true;
            return RedirectToPage("Melden", KommuneRoute);
        }

        TempData.Remove(PrecheckPassedKey);
        if (answers.Contains("ja")) return RedirectToPage("Notruf", KommuneRoute);
        return Page();
    }
}
