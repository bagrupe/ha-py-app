using Microsoft.AspNetCore.Components;

namespace API.Features.Email.Templates;

public partial class ResetPasswordEmail : EmailTemplateBase {
    [Parameter, EditorRequired]
    public string ResetUrl { get; set; } = null!;
}
