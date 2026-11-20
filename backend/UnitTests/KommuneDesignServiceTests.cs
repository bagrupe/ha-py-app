using System.Net;
using System.Text;
using API.Features.Kommune;
using API.Features.Prozess;
using API.Seeders;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class KommuneDesignServiceTests(BackendApiFactory factory) {
    private static readonly Guid KommuneId = KommuneSeeder.LandkreisHaPy.Id;

    private const string Svg = """<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10"><rect width="10" height="10"/></svg>""";

    [Fact]
    public async Task Design_keeps_an_svg_logo_as_data_uri() {
        await using var scope = ScopeWithLogo(Encoding.UTF8.GetBytes(Svg), "image/svg+xml");
        var design = scope.ServiceProvider.GetRequiredService<KommuneDesignService>();

        var (primaryColor, logoUrl) = await design.GetKommuneDesign(KommuneId);

        Assert.Equal("#74A220", primaryColor);
        Assert.StartsWith("data:image/svg+xml;base64,", logoUrl);
    }

    [Fact]
    public async Task Mail_logo_is_skipped_for_an_svg_logo() {
        await using var scope = ScopeWithLogo(Encoding.UTF8.GetBytes(Svg), "image/svg+xml");
        var design = scope.ServiceProvider.GetRequiredService<KommuneDesignService>();

        Assert.Null(await design.GetKommuneLogo(KommuneId));
    }

    [Fact]
    public async Task Mail_logo_carries_the_dimensions_of_a_png_logo() {
        await using var scope = ScopeWithLogo(Convert.FromBase64String(OnePixelPng), "image/png");
        var design = scope.ServiceProvider.GetRequiredService<KommuneDesignService>();

        var logo = await design.GetKommuneLogo(KommuneId);

        Assert.NotNull(logo);
        Assert.Equal((1, 1), (logo.Width, logo.Height));
        Assert.Equal("image/png", logo.MediaType);
    }

    [Fact]
    public async Task Failed_logo_download_leaves_the_design_and_the_mail_without_logo() {
        await using var scope = ScopeWithLogo([], "image/png", HttpStatusCode.NotFound);
        var design = scope.ServiceProvider.GetRequiredService<KommuneDesignService>();

        var (primaryColor, logoUrl) = await design.GetKommuneDesign(KommuneId);

        Assert.Equal("#74A220", primaryColor);
        Assert.Null(logoUrl);
        Assert.Null(await design.GetKommuneLogo(KommuneId));
    }

    private const string OnePixelPng =
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==";

    private AsyncServiceScope ScopeWithLogo(byte[] logo, string mediaType, HttpStatusCode status = HttpStatusCode.OK) {
        var host = factory.WithWebHostBuilder(builder => builder.ConfigureTestServices(services => {
            services.AddHttpClient("BereichBClient")
                .ConfigurePrimaryHttpMessageHandler(() => new LogoCmsHandler());
            services.AddHttpClient(string.Empty)
                .ConfigurePrimaryHttpMessageHandler(() => new LogoFileHandler(logo, mediaType, status));
        }));

        return host.Services.CreateAsyncScope();
    }

    private sealed class LogoCmsHandler : HttpMessageHandler {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct) {
            const string json = """
                {"data":{"KommuneByBereichAId":{"__typename":"BereichBKommune","design":{"__typename":"KommuneDesign",
                "colors":{"__typename":"KommuneDesignColors","primary":"#74A220","primaryLight":"#DAEFA7"},
                "logo":{"__typename":"Medien","url":"http://cms.test/logo"},"fallbackImage":null}}}}
                """;

            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK) {
                Content = new StringContent(json, Encoding.UTF8, "application/json")
            });
        }
    }

    private sealed class LogoFileHandler(byte[] bytes, string mediaType, HttpStatusCode status) : HttpMessageHandler {
        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct) {
            var response = new HttpResponseMessage(status) { Content = new ByteArrayContent(bytes) };
            response.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(mediaType);
            return Task.FromResult(response);
        }
    }
}
