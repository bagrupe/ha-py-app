using Microsoft.AspNetCore.Components.Web;

namespace API.Features.Email;

public static class EmailRenderingServiceCollectionExtensions {
    public static IServiceCollection AddEmailRendering(this IServiceCollection services) =>
        services
            // HtmlRenderer resolves ICascadingValueSupplier, which AddRazorPages registers as scoped. The app-wide
            // renderer therefore gets a scope of its own that lives as long as the app.
            .AddSingleton(provider => new HtmlRenderer(
                provider.CreateScope().ServiceProvider, provider.GetRequiredService<ILoggerFactory>()))
            .AddSingleton<BlazorRenderer>();
}
