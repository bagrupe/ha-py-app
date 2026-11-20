using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.Web.HtmlRendering;

namespace API.Features.Email;

/// <summary>
/// Stellt Methoden zum Rendern von Blazor-Komponenten als HTML bereit.
/// </summary>
/// <remarks>
/// Initialisiert eine neue Instanz mit dem angegebenen HtmlRenderer.
/// </remarks>
/// <param name="htmlRenderer">Renderer für Blazor-Komponenten.</param>
public class BlazorRenderer(HtmlRenderer htmlRenderer) {
    private readonly HtmlRenderer _htmlRenderer = htmlRenderer;

    /// <summary>
    /// Rendert eine Blazor-Komponente ohne Parameter als HTML-String.
    /// </summary>
    /// <typeparam name="T">Typ der zu rendernden Komponente.</typeparam>
    /// <returns>HTML-Darstellung der Komponente.</returns>
    public Task<string> RenderComponent<T>() where T : IComponent
        => RenderComponent<T>(ParameterView.Empty);

    /// <summary>
    /// Rendert eine Blazor-Komponente mit angegebenen Parametern als HTML-String.
    /// </summary>
    /// <typeparam name="T">Typ der zu rendernden Komponente.</typeparam>
    /// <param name="dictionary">Parameter als Schlüssel-Wert-Paare.</param>
    /// <returns>HTML-Darstellung der Komponente.</returns>
    public Task<string> RenderComponent<T>(Dictionary<string, object?> dictionary) where T : IComponent
        => RenderComponent<T>(ParameterView.FromDictionary(dictionary));

    private Task<string> RenderComponent<T>(ParameterView parameters) where T : IComponent {
        return _htmlRenderer.Dispatcher.InvokeAsync(async () => {
            HtmlRootComponent output = await _htmlRenderer.RenderComponentAsync<T>(parameters);
            return output.ToHtmlString();
        });
    }
}
