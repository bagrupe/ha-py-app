using API.Features.PdfGenerator;
using API.Options;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class StaticMapHttpClientTests(BackendApiFactory factory) {
    [Fact]
    public void LimitsConcurrentConnectionsToTileServer() {
        HttpMessageHandler? handler = factory.Services.GetRequiredService<IHttpMessageHandlerFactory>()
            .CreateHandler(StaticMapService.HttpClientName);
        while (handler is DelegatingHandler delegatingHandler) {
            handler = delegatingHandler.InnerHandler;
        }

        var socketsHandler = Assert.IsType<SocketsHttpHandler>(handler);
        Assert.Equal(new StaticMapOptions().MaxConnections, socketsHandler.MaxConnectionsPerServer);
    }

    [Fact]
    public void IdentifiesServiceOperatorInUserAgent() {
        var client = factory.Services.GetRequiredService<IHttpClientFactory>()
            .CreateClient(StaticMapService.HttpClientName);

        Assert.StartsWith("HaPy-App Backend (", client.DefaultRequestHeaders.UserAgent.ToString());
        Assert.Equal(TimeSpan.FromSeconds(new StaticMapOptions().TimeoutSeconds), client.Timeout);
    }
}
