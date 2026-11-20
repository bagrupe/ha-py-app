using System.Collections.Concurrent;
using System.Net;
using API.Features.PdfGenerator;
using API.Options;
using Moq;
using SkiaSharp;

namespace UnitTests;

public sealed class FakeTileHandler(Func<HttpRequestMessage, HttpResponseMessage>? respond = null) : HttpMessageHandler {
    private static readonly byte[] GrayTilePng = SolidTilePng(SKColors.Gray);

    public ConcurrentBag<string> RequestedUrls { get; } = [];

    protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken ct) {
        RequestedUrls.Add(request.RequestUri!.ToString());
        return Task.FromResult(respond?.Invoke(request) ?? PngResponse(GrayTilePng));
    }

    public static byte[] SolidTilePng(SKColor color) {
        using var bitmap = new SKBitmap(WebMercator.TileSizePx, WebMercator.TileSizePx);
        bitmap.Erase(color);
        using var data = bitmap.Encode(SKEncodedImageFormat.Png, 100);
        return data.ToArray();
    }

    public static HttpResponseMessage PngResponse(byte[] png) =>
        new(HttpStatusCode.OK) { Content = new ByteArrayContent(png) };

    public StaticMapService CreateService(StaticMapOptions? options = null) {
        var factory = new Mock<IHttpClientFactory>();
        factory.Setup(f => f.CreateClient(StaticMapService.HttpClientName)).Returns(() => new HttpClient(this));
        return new StaticMapService(factory.Object, options ?? new StaticMapOptions());
    }
}
