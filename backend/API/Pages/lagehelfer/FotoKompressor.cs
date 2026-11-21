using SkiaSharp;

namespace API.Pages.lagehelfer;

/// <summary>Skaliert Fotos herunter und kodiert sie als JPEG neu; dabei gehen EXIF-Daten wie GPS verloren.</summary>
public static class FotoKompressor {
    private const int MaxSide = 1280;
    private const int JpegQuality = 80;

    /// <returns>Das JPEG oder <c>null</c>, wenn die Datei kein lesbares Bild ist.</returns>
    public static async Task<byte[]?> CompressAsync(IFormFile file, CancellationToken ct) {
        await using var buffer = new MemoryStream();
        await file.CopyToAsync(buffer, ct);
        buffer.Position = 0;

        using var codec = SKCodec.Create(buffer);
        if (codec is null) return null;

        var origin = codec.EncodedOrigin;
        buffer.Position = 0;
        using var source = SKBitmap.Decode(buffer);
        if (source is null) return null;

        var swapsAxes = origin is SKEncodedOrigin.RightTop or SKEncodedOrigin.LeftBottom;
        var width = swapsAxes ? source.Height : source.Width;
        var height = swapsAxes ? source.Width : source.Height;
        var scale = Math.Min(1f, MaxSide / (float)Math.Max(width, height));
        var targetWidth = Math.Max(1, (int)Math.Round(width * scale));
        var targetHeight = Math.Max(1, (int)Math.Round(height * scale));

        using var surface = SKSurface.Create(new SKImageInfo(targetWidth, targetHeight, SKColorType.Rgba8888, SKAlphaType.Premul));
        var canvas = surface.Canvas;
        canvas.Clear(SKColors.White);
        canvas.Scale(scale);
        switch (origin) {
            case SKEncodedOrigin.BottomRight:
                canvas.RotateDegrees(180, width / 2f, height / 2f);
                break;
            case SKEncodedOrigin.RightTop:
                canvas.Translate(width, 0);
                canvas.RotateDegrees(90);
                break;
            case SKEncodedOrigin.LeftBottom:
                canvas.Translate(0, height);
                canvas.RotateDegrees(270);
                break;
        }
        canvas.DrawBitmap(source, 0, 0);

        using var image = surface.Snapshot();
        using var data = image.Encode(SKEncodedImageFormat.Jpeg, JpegQuality);
        return data.ToArray();
    }
}
