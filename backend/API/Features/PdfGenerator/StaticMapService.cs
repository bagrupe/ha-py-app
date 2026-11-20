using API.Options;
using SkiaSharp;

namespace API.Features.PdfGenerator;

/// <summary>Thrown when the map image for the PDF cannot be produced.</summary>
public class StaticMapException(string message, Exception? innerException = null)
    : Exception(message, innerException);

/// <summary>Web Mercator projection as used by slippy-map raster tiles.</summary>
public static class WebMercator {
    /// <summary>Edge length of a raster tile in pixels.</summary>
    public const int TileSizePx = 256;

    /// <summary>Projects a coordinate to world pixels at the given zoom, where the world is <c>256 · 2^zoom</c> pixels wide.</summary>
    public static (double X, double Y) ToWorldPixel(double longitude, double latitude, int zoom) {
        var worldSizePx = TileSizePx * Math.Pow(2, zoom);
        var latitudeRad = latitude * Math.PI / 180;
        var x = (longitude + 180) / 360 * worldSizePx;
        var y = (1 - Math.Log(Math.Tan(latitudeRad) + 1 / Math.Cos(latitudeRad)) / Math.PI) / 2 * worldSizePx;
        return (x, y);
    }
}

/// <summary>Renders a map image around a coordinate from raster tiles, for embedding in the PDF.</summary>
public class StaticMapService(IHttpClientFactory httpClientFactory, StaticMapOptions options) {
    /// <summary>Name of the HttpClient used to fetch tiles.</summary>
    public const string HttpClientName = "StaticMapTiles";

    private static readonly SKColor FallbackPinColor = new(0xF9, 0x73, 0x16);
    private const float PinRadiusPx = 11;
    private const float PinHeightPx = 34;

    /// <summary>Renders the map centred on the coordinate with a pin at it.</summary>
    /// <param name="longitude">Longitude of the pin.</param>
    /// <param name="latitude">Latitude of the pin.</param>
    /// <param name="pinColor">Kommune primary colour as <c>#rrggbb</c> or <c>"r g b"</c>; orange when missing or unparsable.</param>
    /// <param name="ct">Cancellation token.</param>
    /// <returns>A <c>data:image/png;base64,…</c> URI.</returns>
    /// <exception cref="StaticMapException">Any tile could not be fetched or decoded.</exception>
    public async Task<string> RenderPngDataUri(double longitude, double latitude, string? pinColor,
        CancellationToken ct = default) {
        var (centerX, centerY) = WebMercator.ToWorldPixel(longitude, latitude, options.Zoom);
        var left = centerX - options.WidthPx / 2.0;
        var top = centerY - options.HeightPx / 2.0;
        var tileCount = 1 << options.Zoom;

        var firstTileX = (int)Math.Floor(left / WebMercator.TileSizePx);
        var lastTileX = (int)Math.Floor((left + options.WidthPx - 1) / WebMercator.TileSizePx);
        var firstTileY = Math.Max(0, (int)Math.Floor(top / WebMercator.TileSizePx));
        var lastTileY = Math.Min(tileCount - 1, (int)Math.Floor((top + options.HeightPx - 1) / WebMercator.TileSizePx));

        var client = httpClientFactory.CreateClient(HttpClientName);
        var tiles = new List<(int X, int Y)>();
        for (var tileY = firstTileY; tileY <= lastTileY; tileY++) {
            for (var tileX = firstTileX; tileX <= lastTileX; tileX++) {
                tiles.Add((tileX, tileY));
            }
        }

        var bitmaps = await Task.WhenAll(tiles.Select(tile =>
            FetchTile(client, ((tile.X % tileCount) + tileCount) % tileCount, tile.Y, ct)));

        try {
            using var surface = SKSurface.Create(new SKImageInfo(options.WidthPx, options.HeightPx));
            var canvas = surface.Canvas;
            canvas.Clear(SKColors.White);
            for (var i = 0; i < tiles.Count; i++) {
                var destination = SKRect.Create(
                    (float)(tiles[i].X * WebMercator.TileSizePx - left),
                    (float)(tiles[i].Y * WebMercator.TileSizePx - top),
                    WebMercator.TileSizePx, WebMercator.TileSizePx);
                canvas.DrawBitmap(bitmaps[i], destination);
            }

            DrawPin(canvas, options.WidthPx / 2f, options.HeightPx / 2f, ParsePinColor(pinColor));

            using var image = surface.Snapshot();
            using var png = image.Encode(SKEncodedImageFormat.Png, 100);
            return $"data:image/png;base64,{Convert.ToBase64String(png.ToArray())}";
        } finally {
            foreach (var bitmap in bitmaps) bitmap.Dispose();
        }
    }

    private async Task<SKBitmap> FetchTile(HttpClient client, int x, int y, CancellationToken ct) {
        var url = options.TileUrlTemplate
            .Replace("{z}", options.Zoom.ToString())
            .Replace("{x}", x.ToString())
            .Replace("{y}", y.ToString());
        try {
            using var response = await client.GetAsync(url, ct);
            if (!response.IsSuccessStatusCode) {
                throw new StaticMapException($"Kartenkachel {url} lieferte HTTP {(int)response.StatusCode}.");
            }

            var bytes = await response.Content.ReadAsByteArrayAsync(ct);
            return SKBitmap.Decode(bytes) ?? throw new StaticMapException($"Kartenkachel {url} ist kein Bild.");
        } catch (Exception e) when (e is not StaticMapException && !ct.IsCancellationRequested) {
            throw new StaticMapException($"Kartenkachel {url} konnte nicht geladen werden.", e);
        }
    }

    /// <summary>Draws a teardrop pin whose tip touches the given point.</summary>
    private static void DrawPin(SKCanvas canvas, float tipX, float tipY, SKColor color) {
        var headCenterY = tipY - PinHeightPx + PinRadiusPx;
        using var path = new SKPath();
        path.MoveTo(tipX, tipY);
        path.LineTo(tipX - PinRadiusPx * 0.87f, headCenterY + PinRadiusPx * 0.5f);
        path.ArcTo(SKRect.Create(tipX - PinRadiusPx, headCenterY - PinRadiusPx, PinRadiusPx * 2, PinRadiusPx * 2),
            150, 240, false);
        path.Close();

        using var fill = new SKPaint { Color = color, IsAntialias = true, Style = SKPaintStyle.Fill };
        using var outline = new SKPaint {
            Color = SKColors.White,
            IsAntialias = true,
            Style = SKPaintStyle.Stroke,
            StrokeWidth = 2,
        };
        using var dot = new SKPaint { Color = SKColors.White, IsAntialias = true, Style = SKPaintStyle.Fill };
        canvas.DrawPath(path, fill);
        canvas.DrawPath(path, outline);
        canvas.DrawCircle(tipX, headCenterY, PinRadiusPx * 0.4f, dot);
    }

    /// <summary>Accepts the two formats the Kommune design delivers: <c>#rrggbb</c> or space-separated RGB.</summary>
    public static SKColor ParsePinColor(string? color) {
        if (string.IsNullOrWhiteSpace(color)) return FallbackPinColor;
        if (SKColor.TryParse(color, out var hex)) return hex;

        var channels = color.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        return channels.Length == 3 && channels.All(c => byte.TryParse(c, out _))
            ? new SKColor(byte.Parse(channels[0]), byte.Parse(channels[1]), byte.Parse(channels[2]))
            : FallbackPinColor;
    }
}
