using System.Net.Mime;
using System.Text.Json;
using API.Features.Auth;
using API.Features.Prozess;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SkiaSharp;

namespace API.Features.MaengelMelder;

/// <summary>Stellt Endpunkte zum Abruf und zur Verarbeitung von Dateien bereit.</summary>
[ApiController]
[Route("api/file")]
public class FileController(
    IDbContextFactory<DomainContext> dbContextFactory,
    ICurrentUserAccessor currentUserAccessor
) : ControllerBase {
    /// <summary>Gibt ein Bild aus einem SlotValue als Thumbnail zurück.</summary>
    /// <param name="slotValueId">Die Id des SlotValues als String.</param>
    /// <param name="size">Die gewünschte Breite des Thumbnails.</param>
    /// <returns>Ein IActionResult mit dem Bild oder NotFound, falls nicht vorhanden.</returns>
    [HttpGet("{slotValueId}/{size:int}")]
    public async Task<IActionResult> Get(string slotValueId, int? size) {
        if (!Guid.TryParse(slotValueId, out var parsedFileId)) {
            return NotFound();
        }

        await using var db = await dbContextFactory.CreateDbContextAsync();

        var slotValue = await db.SlotValues
            .Include(x => x.Bearbeitung).ThenInclude(b => b.Ausfuehrung).ThenInclude(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .Where(x =>
                x.Bearbeitung.Ausfuehrung.ProzessVersion.Prozess.TagHistorie.Any(h =>
                    h.Tag.Tag == "Mängelmelder" || h.Tag.Tag == "Ideenmelder"))
            .FirstOrDefaultAsync(s => s.Id == parsedFileId);

        if (slotValue is null) {
            return NotFound();
        }

        if (!await IstOeffentlichSichtbar(db, slotValue) && !await DarfAllesSehen(db, slotValue)) {
            return NotFound();
        }

        return slotValue switch {
            PlainSlotValue { Value.ValueKind: JsonValueKind.Array } plainSlotValue => GetImageFromSlotValue(
                plainSlotValue, size ?? 400),
            _ => NotFound()
        };
    }

    private static Task<bool> IstOeffentlichSichtbar(DomainContext db, SlotValue slotValue) {
        if (slotValue.IstFreigegeben != true) {
            return Task.FromResult(false);
        }

        var prozessVersionId = slotValue.Bearbeitung.Ausfuehrung.ProzessVersionId;
        return db.Set<FormularFeld>().AnyAsync(f =>
            f.OeffentlichSichtbar && f.SlotName == slotValue.SlotName && f.Schritt.ProzessVersionId == prozessVersionId);
    }

    /// <summary>
    /// Prüft, ob der aktuelle Nutzer auch nicht öffentlich sichtbare SlotValues sehen darf, weil er der
    /// Antragsteller ist oder als Backoffice-Nutzer zur zuständigen Kommune gehört.
    /// </summary>
    /// <remarks>
    /// Lädt den Nutzer bewusst direkt über <paramref name="db"/> statt über <see cref="ICurrentUserAccessor.User"/>:
    /// dessen DataLoader wird nur innerhalb einer GraphQL-Ausführung dispatcht, in einem MVC-Controller würde der
    /// Task nie abgeschlossen werden.
    /// </remarks>
    private async Task<bool> DarfAllesSehen(DomainContext db, SlotValue slotValue) {
        if (currentUserAccessor.TryUserId() is not { } userId) {
            return false;
        }

        var user = await db.Users.FirstOrDefaultAsync(u => u.Id == userId);
        var ausfuehrung = slotValue.Bearbeitung.Ausfuehrung;
        return user switch {
            BackofficeUser backofficeUser => backofficeUser.KommuneId == ausfuehrung.ProzessVersion.Prozess.KommuneId,
            Buerger buerger => buerger.Id == ausfuehrung.UserId,
            _ => false
        };
    }

    /// <summary>Erzeugt ein Bild-Resultat aus einem SlotValue mit Base64-kodierten Bildern.</summary>
    /// <param name="slotValue">Der SlotValue mit Bilddaten.</param>
    /// <param name="size">Die Breite des zu erzeugenden Thumbnails.</param>
    /// <returns>Ein IActionResult mit dem Thumbnail oder NotFound.</returns>
    public IActionResult GetImageFromSlotValue(SlotValue slotValue, int size) {
        if (slotValue is not PlainSlotValue { Value.ValueKind: JsonValueKind.Array } plainSlotValue) {
            return NotFound();
        }

        var jsonArray = plainSlotValue.Value.EnumerateArray();
        if (!jsonArray.MoveNext()) {
            return NotFound();
        }

        var firstImageBase64 = jsonArray.Current.GetString();
        if (string.IsNullOrEmpty(firstImageBase64)) {
            return NotFound();
        }

        var imageBytes = Convert.FromBase64String(firstImageBase64);
        var thumbnail = CreateThumbnail(imageBytes, size);
        var ms = new MemoryStream(thumbnail);
        try {
            ms.Seek(0, SeekOrigin.Begin);
            return File(ms, MediaTypeNames.Image.Jpeg, slotValue.Id.ToString());
        } catch {
            return NotFound();
        }
    }

    /// <summary>Erzeugt ein Thumbnail aus einem Bild-Bytearray mit gegebener Breite.</summary>
    /// <param name="imageBytes">Das Originalbild als Bytearray.</param>
    /// <param name="width">Die gewünschte Breite des Thumbnails.</param>
    /// <returns>Das Thumbnail als Bytearray oder ein leeres Array bei Fehler.</returns>
    private static byte[] CreateThumbnail(byte[] imageBytes, int width) {
        try {
            using var inputStream = new MemoryStream(imageBytes);

            using var originalImage = SKImage.FromEncodedData(inputStream);
            using var originalBitmap = SKBitmap.FromImage(originalImage);

            var aspect = originalBitmap.Height / (float)originalBitmap.Width;
            var height = (int)(width * aspect);
            var resized = new SKBitmap(width, height);

            originalBitmap.ScalePixels(resized, SKFilterQuality.High);

            using var outputStream = new MemoryStream();
            resized.Encode(outputStream, SKEncodedImageFormat.Jpeg, 80);

            return outputStream.ToArray();
        } catch {
            return Array.Empty<byte>();
        }
    }
}
