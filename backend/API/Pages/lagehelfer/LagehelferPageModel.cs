using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace API.Pages.lagehelfer;

/// <summary>Shared tenant context for the public Lagehelfer pages.</summary>
public abstract class LagehelferPageModel : PageModel {
    [BindProperty(SupportsGet = true, Name = "kommuneId")]
    public Guid KommuneId { get; set; }

    protected object KommuneRoute => new { kommuneId = KommuneId };

    public override void OnPageHandlerExecuting(PageHandlerExecutingContext context) {
        ViewData[nameof(KommuneId)] = KommuneId;
        base.OnPageHandlerExecuting(context);
    }
}
