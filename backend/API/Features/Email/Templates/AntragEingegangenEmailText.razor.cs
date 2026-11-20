using Microsoft.AspNetCore.Components;

namespace API.Features.Email.Templates;

public partial class AntragEingegangenEmailText : EmailTemplateBase {
    [Parameter, EditorRequired]
    public string AntragUrl { get; set; } = null!;

    [Parameter, EditorRequired]
    public string ProzessName { get; set; } = null!;
    [Parameter, EditorRequired]
    public string Organisationseinheit { get; set; } = null!;
    [Parameter, EditorRequired]
    public string Abteilung { get; set; } = null!;
    [Parameter, EditorRequired]
    public IReadOnlyList<EmailAngabe> Angaben { get; set; } = null!;
    [Parameter, EditorRequired]
    public string AusfuehrungId { get; set; } = null!;
    [Parameter, EditorRequired]
    public string Datum { get; set; } = null!;
}
