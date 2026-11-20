using Microsoft.AspNetCore.Components;

namespace API.Features.Email.Templates;

public partial class InvitationEmail : EmailTemplateBase {
    [Parameter, EditorRequired]
    public string MandantName { get; set; } = null!;

    [Parameter, EditorRequired]
    public string InviteUrl { get; set; } = null!;
}
