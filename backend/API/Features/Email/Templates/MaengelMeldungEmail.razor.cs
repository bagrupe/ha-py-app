using System.Text.RegularExpressions;
using System.Web;
using Microsoft.AspNetCore.Components;

namespace API.Features.Email.Templates;

public partial class MaengelMeldungEmail : EmailTemplateBase {
    [Parameter, EditorRequired]
    public string Message { get; set; } = null!;

    [Parameter, EditorRequired]
    public string ProzessName { get; set; } = null!;

    [Parameter, EditorRequired]
    public string Organisationseinheit { get; set; } = null!;

    [Parameter, EditorRequired]
    public string Abteilung { get; set; } = null!;

    [Parameter, EditorRequired]
    public string Datum { get; set; } = null!;

    public MarkupString TextContent => (MarkupString)Regex.Replace(
        HttpUtility.HtmlEncode(Message), "\r?\n|\r", "<br />");
}
