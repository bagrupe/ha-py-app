using Microsoft.AspNetCore.Components;

namespace API.Features.Email.Templates;

public partial class ResetPasswordEmailText : EmailTemplateBase {
    [Parameter, EditorRequired]
    public string ResetUrl { get; set; } = null!;
}
