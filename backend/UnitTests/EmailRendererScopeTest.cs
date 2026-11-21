using API.Features.Email;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace IntegrationTests;

/// <summary>
/// Development validates scopes, the Testing environment does not, so a singleton capturing a scoped service only
/// fails locally. AddRazorPages registers ICascadingValueSupplier as scoped, and HtmlRenderer resolves it.
/// </summary>
public class EmailRendererScopeTest {
    [Fact]
    public async Task Email_renderers_resolve_next_to_razor_pages_with_scope_validation() {
        var builder = WebApplication.CreateBuilder();
        builder.Host.UseDefaultServiceProvider(options => options.ValidateScopes = true);
        builder.Services.AddRazorPages();
        builder.Services.AddEmailRendering();
        await using var app = builder.Build();

        Assert.NotNull(app.Services.GetRequiredService<HtmlRenderer>());
        Assert.NotNull(app.Services.GetRequiredService<BlazorRenderer>());
    }
}
