using Microsoft.AspNetCore.Components;

namespace API.Features.Email.Templates;

public abstract class EmailTemplateBase : ComponentBase, IKommuneThemedTemplate {
    [Parameter]
    public string? LogoUrl { get; set; }

    [Parameter]
    public string? KommuneName { get; set; }

    [Parameter]
    public int LogoWidth { get; set; }

    [Parameter]
    public int LogoHeight { get; set; }

    [Parameter]
    public string? ImpressumUrl { get; set; }

    [Parameter]
    public string? DatenschutzUrl { get; set; }

    protected static MarkupString Raw(string html) => new(html);
}
