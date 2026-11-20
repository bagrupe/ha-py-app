using API.Features.Auth;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.Net.Http.Headers;

namespace API.Features.ObjectStorage;

/// <summary>Streams objects between clients and the bucket.</summary>
/// <remarks>No <c>[Authorize]</c>: downloads may be anonymous, and a disabled storage must answer 503 before 401.</remarks>
[ApiController]
[Route("api/objects")]
public class ObjectStorageController(
    IObjectStorage storage,
    ObjectStorageConsumerRegistry consumers,
    IOptions<ObjectStorageOptions> options,
    ICurrentUserAccessor currentUserAccessor
) : ControllerBase {
    /// <summary>Stores the raw request body under a new key of the consumer's prefix.</summary>
    /// <remarks>
    /// The body is raw, not multipart: <c>IFormFile</c> buffers uploads above 64 KB to disk.
    /// </remarks>
    [HttpPost("{prefix}")]
    public async Task<IActionResult> Upload(string prefix, CancellationToken ct) {
        if (storage is DisabledObjectStorage) {
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }

        if (currentUserAccessor.TryUserId() is not { } userId) {
            return Unauthorized();
        }

        var consumer = consumers.Find(prefix);
        if (consumer is null) {
            return NotFound();
        }

        if (!await consumer.CanUploadAsync(userId, ct)) {
            return StatusCode(StatusCodes.Status403Forbidden);
        }

        if (Request.ContentLength is not { } contentLength) {
            return StatusCode(StatusCodes.Status411LengthRequired);
        }

        var maxBytes = consumer.MaxUploadBytes ?? options.Value.MaxUploadBytes;
        if (contentLength > maxBytes) {
            return StatusCode(StatusCodes.Status413PayloadTooLarge, new ObjectTooLargeError(maxBytes));
        }

        var allowedContentTypes = consumer.AllowedContentTypes ?? options.Value.EffectiveAllowedContentTypes;
        if (DeclaredMediaType() is not { } contentType ||
            !allowedContentTypes.Contains(contentType, StringComparer.OrdinalIgnoreCase)) {
            return StatusCode(StatusCodes.Status415UnsupportedMediaType, new ContentTypeNotAllowedError(allowedContentTypes));
        }

        // Kestrel's default body limit is 30 MB. The feature is missing or read-only under TestServer.
        if (HttpContext.Features.Get<IHttpMaxRequestBodySizeFeature>() is { IsReadOnly: false } bodySizeLimit) {
            bodySizeLimit.MaxRequestBodySize = maxBytes;
        }

        var key = $"{consumer.Prefix}/{Guid.NewGuid():N}";
        await storage.PutAsync(key, Request.Body, contentLength, contentType, ct);

        return StatusCode(StatusCodes.Status201Created, new UploadedObject(key));
    }

    /// <summary>Streams an object. Unknown prefix, malformed id, denied access and missing object all answer 404.</summary>
    [HttpGet("{prefix}/{id}")]
    public async Task<IActionResult> Download(string prefix, string id, CancellationToken ct) {
        if (storage is DisabledObjectStorage) {
            return StatusCode(StatusCodes.Status503ServiceUnavailable);
        }

        var consumer = consumers.Find(prefix);
        if (consumer is null || !IsObjectId(id)) {
            return NotFound();
        }

        var key = $"{consumer.Prefix}/{id}";
        if (!await consumer.CanReadAsync(currentUserAccessor.TryUserId(), key, ct)) {
            return NotFound();
        }

        StoredObject stored;
        try {
            stored = await storage.GetAsync(key, ct);
        } catch (ObjectNotFoundException) {
            return NotFound();
        }

        // Objects may be user-restricted and nothing invalidates cached copies.
        Response.Headers.CacheControl = "private, no-store";
        Response.Headers.ETag = stored.ETag;
        Response.ContentLength = stored.ContentLength;

        return File(stored.Content, stored.ContentType);
    }

    private string? DeclaredMediaType() =>
        MediaTypeHeaderValue.TryParse(Request.ContentType, out var mediaType) ? mediaType.MediaType.Value : null;

    /// <summary>Whether <paramref name="id"/> has the shape of a generated object id.</summary>
    public static bool IsObjectId(string id) =>
        Guid.TryParseExact(id, "N", out var guid) && guid.ToString("N") == id;
}

/// <summary>Response of a successful upload.</summary>
public record UploadedObject(string Key);

/// <summary>413 body. Clients switch on <see cref="Code"/>.</summary>
public record ObjectTooLargeError(long MaxBytes) {
    /// <summary>Stable error code.</summary>
    public string Code => "ObjectTooLarge";
}

/// <summary>415 body. Clients switch on <see cref="Code"/>.</summary>
public record ContentTypeNotAllowedError(IReadOnlyCollection<string> Allowed) {
    /// <summary>Stable error code.</summary>
    public string Code => "ContentTypeNotAllowed";
}
