using API.Features.Email;
using API.Features.Email.Templates;
using Microsoft.AspNetCore.Components;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EmailTemplateRenderTests(BackendApiFactory factory) {
    private const string Url = "https://example.org/go?token=a&x=1";

    private static Dictionary<string, object?> Params(params (string Key, object? Value)[] extra) {
        var all = new Dictionary<string, object?> {
            ["KommuneName"] = "Landkreis Hameln-Pyrmont",
            ["ImpressumUrl"] = "https://example.org/impressum",
            ["DatenschutzUrl"] = "https://example.org/datenschutz",
            ["LogoUrl"] = "cid:kommune-logo",
            ["LogoWidth"] = 180,
            ["LogoHeight"] = 103,
        };
        foreach (var (key, value) in extra) all[key] = value;
        return all;
    }

    public static IEnumerable<object[]> Templates() {
        yield return [typeof(AntragEingegangenEmail),
            true,
            Params(
            ("AntragUrl", Url), ("ProzessName", "Mängelmelder"), ("Organisationseinheit", "Hameln"), ("Abteilung", "Abt. 53"),
            ("Angaben", new List<EmailAngabe> { new("Titel", "K") }), ("AusfuehrungId", "1"), ("Datum", "04.11.2026"))];
        yield return [typeof(AntragWeiterleitenEmail),
            false,
            Params(
            ("ProzessName", "Mängelmelder"), ("AusfuehrungId", "1"), ("Organisationseinheit", "Hameln"), ("Abteilung", "Abt. 53"),
            ("Datum", "04.11.2026"))];
        yield return [typeof(InvitationEmail), true, Params(("MandantName", "Landkreis"), ("InviteUrl", Url))];
        yield return [typeof(ResetPasswordEmail), true, Params(("ResetUrl", Url))];
        yield return [typeof(AccountConfirmedEmail), true, Params(("LoginUrl", Url))];
        yield return [typeof(MaengelMeldungEmail),
            false,
            Params(
            ("Message", "Text"), ("ProzessName", "Mängelmelder"), ("Organisationseinheit", "Hameln"), ("Abteilung", "Abt. 53"),
            ("Datum", "04.11.2026"))];
    }

    [Theory]
    [MemberData(nameof(Templates))]
    public async Task Outlook_conditionals_survive_razor_and_stay_balanced(Type template, bool hasButton, Dictionary<string, object?> parameters) {
        await using var scope = factory.Services.CreateAsyncScope();
        var renderer = scope.ServiceProvider.GetRequiredService<BlazorRenderer>();

        var render = typeof(BlazorRenderer).GetMethods()
            .First(m => m.Name == nameof(BlazorRenderer.RenderComponent) && m.GetParameters() is [{ ParameterType: var type }] && type == typeof(Dictionary<string, object?>))
            .MakeGenericMethod(template);
        var html = await (Task<string>)render.Invoke(renderer, [parameters])!;

        Assert.Contains("PixelsPerInch", html);
        Assert.Equal(Count(html, "<!--[if"), Count(html, "<![endif]"));
        Assert.Equal(Count(html, "<!--[if !mso]><!-->"), Count(html, "<!--<![endif]-->"));

        Assert.Contains("height:4px;line-height:4px;font-size:4px;mso-line-height-rule:exactly", html);
        Assert.Equal((hasButton ? 1 : 0) + 2, Count(html, "<v:roundrect"));
        Assert.Contains("href=\"https://example.org/datenschutz\"", html);
        Assert.Contains("href=\"https://example.org/impressum\"", html);

        if (hasButton) {
            Assert.Contains("href=\"https://example.org/go?token=a&amp;x=1\"", html);
        }
    }

    private static int Count(string text, string part) => text.Split(part).Length - 1;
}
