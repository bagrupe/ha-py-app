using Microsoft.AspNetCore.Components;

namespace API.Features.Email.Templates;

public partial class AccountConfirmedEmailText : EmailTemplateBase {
    [Parameter, EditorRequired]
    public string LoginUrl { get; set; } = null!;
}
