using System.Net;
using API.Features.PdfGenerator;
using API.Options;
using SkiaSharp;

namespace UnitTests;

public class StaticMapServiceTests {
    private const double HamelnLongitude = 9.3553;
    private const double HamelnLatitude = 52.1037;

    private static SKBitmap DecodeDataUri(string dataUri) {
        const string prefix = "data:image/png;base64,";
        Assert.StartsWith(prefix, dataUri);
        return SKBitmap.Decode(Convert.FromBase64String(dataUri[prefix.Length..]));
    }

    [Fact]
    public void ProjectsEquatorAndPrimeMeridianToWorldCentre() {
        var (x, y) = WebMercator.ToWorldPixel(0, 0, 1);

        Assert.Equal(256, x, 6);
        Assert.Equal(256, y, 6);
    }

    [Fact]
    public void ProjectsLongitudeLinearly() {
        var (x, _) = WebMercator.ToWorldPixel(90, 0, 0);

        Assert.Equal(192, x, 6);
    }

    [Fact]
    public void ProjectsHamelnToKnownTile() {
        var (x, y) = WebMercator.ToWorldPixel(HamelnLongitude, HamelnLatitude, 16);

        Assert.Equal(34471, (int)(x / WebMercator.TileSizePx));
        Assert.Equal(21616, (int)(y / WebMercator.TileSizePx));
        Assert.Equal(8824596.58, x, 2);
        Assert.Equal(5533908.84, y, 2);
    }

    [Fact]
    public async Task CompositesTilesAroundPointWithColouredPin() {
        var greenTilePng = FakeTileHandler.SolidTilePng(new SKColor(0, 200, 0));
        var handler = new FakeTileHandler(_ => FakeTileHandler.PngResponse(greenTilePng));
        var service = handler.CreateService(new StaticMapOptions {
            TileUrlTemplate = "https://tiles.test/{z}/{x}/{y}.png",
        });

        var dataUri = await service.RenderPngDataUri(HamelnLongitude, HamelnLatitude, "#1d4ed8");

        using var map = DecodeDataUri(dataUri);
        Assert.Equal(640, map.Width);
        Assert.Equal(400, map.Height);
        Assert.Equal(new SKColor(0, 200, 0), map.GetPixel(5, 5));
        Assert.Equal(new SKColor(0x1d, 0x4e, 0xd8), map.GetPixel(320, 200 - 10));

        var expectedUrls = from x in Enumerable.Range(34469, 4)
                           from y in Enumerable.Range(21616, 2)
                           select $"https://tiles.test/16/{x}/{y}.png";
        Assert.Equal(expectedUrls.Order(), handler.RequestedUrls.Order());
    }

    [Fact]
    public async Task UsesConfiguredSizeAndZoom() {
        var handler = new FakeTileHandler();
        var service = handler.CreateService(new StaticMapOptions { Zoom = 12, WidthPx = 300, HeightPx = 200 });

        using var map = DecodeDataUri(await service.RenderPngDataUri(HamelnLongitude, HamelnLatitude, null));

        Assert.Equal(300, map.Width);
        Assert.Equal(200, map.Height);
        Assert.All(handler.RequestedUrls, url => Assert.StartsWith("https://tile.openstreetmap.de/12/", url));
    }

    [Theory]
    [InlineData("#1d4ed8", 0x1d, 0x4e, 0xd8)]
    [InlineData("29 78 216", 29, 78, 216)]
    [InlineData(null, 0xF9, 0x73, 0x16)]
    [InlineData("not a colour", 0xF9, 0x73, 0x16)]
    public void ParsesPinColourWithOrangeFallback(string? color, byte r, byte g, byte b) {
        Assert.Equal(new SKColor(r, g, b), StaticMapService.ParsePinColor(color));
    }

    [Fact]
    public async Task FailsWhenAnyTileFails() {
        var grayTilePng = FakeTileHandler.SolidTilePng(SKColors.Gray);
        var calls = 0;
        var handler = new FakeTileHandler(_ => Interlocked.Increment(ref calls) == 3
            ? new HttpResponseMessage(HttpStatusCode.ServiceUnavailable)
            : FakeTileHandler.PngResponse(grayTilePng));

        await Assert.ThrowsAsync<StaticMapException>(() =>
            handler.CreateService().RenderPngDataUri(HamelnLongitude, HamelnLatitude, null));
    }

    [Fact]
    public async Task FailsWhenTileIsNotAnImage() {
        var handler = new FakeTileHandler(_ => FakeTileHandler.PngResponse("%PDF-fake"u8.ToArray()));

        await Assert.ThrowsAsync<StaticMapException>(() =>
            handler.CreateService().RenderPngDataUri(HamelnLongitude, HamelnLatitude, null));
    }

    [Fact]
    public async Task FailsWhenTileRequestThrows() {
        var handler = new FakeTileHandler(_ => throw new HttpRequestException("tile host unreachable"));

        await Assert.ThrowsAsync<StaticMapException>(() =>
            handler.CreateService().RenderPngDataUri(HamelnLongitude, HamelnLatitude, null));
    }
}
