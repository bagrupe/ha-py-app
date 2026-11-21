using API.Features.Lage;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace API.Pages.lagehelfer;

[AllowAnonymous]
public class IndexModel(MeldungService meldungService) : PageModel {
    public IReadOnlyList<PublicLage> Lagen { get; private set; } = [];

    public async Task OnGetAsync(CancellationToken ct) {
        Lagen = await meldungService.LoadActiveLagenAsync(ct);
    }
}
