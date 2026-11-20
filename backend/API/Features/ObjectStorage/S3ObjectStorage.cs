using System.Net;
using System.Runtime.CompilerServices;
using Amazon.S3;
using Amazon.S3.Model;
using NodaTime;

namespace API.Features.ObjectStorage;

/// <summary><see cref="IObjectStorage"/> backed by an S3-compatible bucket.</summary>
public class S3ObjectStorage(IAmazonS3 s3, ObjectStorageOptions options) : IObjectStorage {
    /// <inheritdoc />
    public async Task PutAsync(string key, Stream content, long contentLength, string contentType, CancellationToken ct) {
        var request = new PutObjectRequest {
            BucketName = options.Bucket,
            Key = key,
            InputStream = content,
            ContentType = contentType,
            AutoCloseStream = false,
        };
        request.Headers.ContentLength = contentLength;

        await s3.PutObjectAsync(request, ct);
    }

    /// <inheritdoc />
    public async Task<StoredObject> GetAsync(string key, CancellationToken ct) {
        try {
            var response = await s3.GetObjectAsync(options.Bucket, key, ct);
            return new StoredObject(
                response.ResponseStream,
                response.Headers.ContentType,
                response.Headers.ContentLength,
                response.ETag);
        } catch (AmazonS3Exception e) when (e.ErrorCode == "NoSuchKey" || e.StatusCode == HttpStatusCode.NotFound) {
            throw new ObjectNotFoundException(key);
        }
    }

    /// <inheritdoc />
    public async Task DeleteAsync(string key, CancellationToken ct) {
        await s3.DeleteObjectAsync(options.Bucket, key, ct);
    }

    /// <inheritdoc />
    public async Task<bool> ExistsAsync(string key, CancellationToken ct) {
        try {
            await s3.GetObjectMetadataAsync(options.Bucket, key, ct);
            return true;
        } catch (AmazonS3Exception e) when (e.StatusCode == HttpStatusCode.NotFound) {
            // Some providers (Wobcom) answer HeadObject with a bare 404 and no NoSuchKey error code.
            return false;
        }
    }

    /// <inheritdoc />
    public async IAsyncEnumerable<StoredObjectInfo> ListAsync(string keyPrefix, string? startAfter,
        [EnumeratorCancellation] CancellationToken ct) {
        var request = new ListObjectsV2Request {
            BucketName = options.Bucket,
            Prefix = keyPrefix,
            StartAfter = startAfter,
        };

        await foreach (var s3Object in s3.Paginators.ListObjectsV2(request).S3Objects.WithCancellation(ct)) {
            yield return new StoredObjectInfo(
                s3Object.Key,
                Instant.FromDateTimeUtc(s3Object.LastModified!.Value.ToUniversalTime()));
        }
    }
}
