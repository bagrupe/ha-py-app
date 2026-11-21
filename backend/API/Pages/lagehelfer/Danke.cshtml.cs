using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class DankeModel : LagehelferPageModel {
    public string Confirmation { get; private set; } = "";

    public IActionResult OnGet() {
        if (TempData[MeldenModel.ConfirmationKey] is not string confirmation) return RedirectToPage("Index", KommuneRoute);

        Confirmation = confirmation;
        return Page();
    }
}
