using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class GefahrCheckModel : PageModel {
    public const string PrecheckPassedKey = "LagehelferPrecheckPassed";

    public bool DangerReported { get; private set; }

    public void OnGet() {
        TempData.Remove(PrecheckPassedKey);
    }

    public IActionResult OnPost(string? answer) {
        if (answer == "nein") {
            TempData[PrecheckPassedKey] = true;
            return RedirectToPage("Melden");
        }

        DangerReported = answer == "ja";
        return Page();
    }
}
