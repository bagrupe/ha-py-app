using SkiaSharp;

namespace API.Features.PdfGenerator;

/// <summary>
/// Creates data URIs for images embedded in the PDF template.
/// </summary>
public class PdfImageService(IConfiguration configuration, ILogger<PdfImageService> logger) {
    private readonly int _maxEdgePixels = configuration.GetValue("Pdf:ImageMaxEdgePixels", 480);
    private readonly int _jpegQuality = configuration.GetValue("Pdf:ImageJpegQuality", 80);

    /// <summary>
    /// Returns a data URI with the image resized to <c>Pdf:ImageMaxEdgePixels</c>,
    /// or <c>null</c> if the value is not a decodable image (such as an uploaded PDF).
    /// </summary>
    /// <param name="base64">Base64-encoded image content from a slot value.</param>
    public string? ToInlineDataUri(string base64) {
        try {
            var bytes = Convert.FromBase64String(base64);
            using var decoded = SKBitmap.Decode(bytes);
            if (decoded is null) return null;

            var scale = Math.Min(1.0, (double)_maxEdgePixels / Math.Max(decoded.Width, decoded.Height));
            var width = Math.Max(1, (int)Math.Round(decoded.Width * scale));
            var height = Math.Max(1, (int)Math.Round(decoded.Height * scale));

            using var resized = decoded.Resize(new SKImageInfo(width, height), SKFilterQuality.High);
            if (resized is null) return null;

            // [HACK] Flatten onto white because JPEG does not support transparency; otherwise signatures get a black background.
            using var surface =
                SKSurface.Create(new SKImageInfo(width, height, SKColorType.Rgba8888, SKAlphaType.Opaque));
            surface.Canvas.Clear(SKColors.White);
            surface.Canvas.DrawBitmap(resized, 0, 0);

            using var snapshot = surface.Snapshot();
            using var encoded = snapshot.Encode(SKEncodedImageFormat.Jpeg, _jpegQuality);
            if (encoded is null) return null;

            return "data:image/jpeg;base64," + Convert.ToBase64String(encoded.ToArray());
        } catch (Exception e) {
            logger.LogWarning(e, "Bild konnte für die PDF-Erzeugung nicht verkleinert werden");
            return null;
        }
    }
}
