namespace API.Features.ObjectStorage;

/// <summary>Registered when the <c>ObjectStorage</c> section is absent.</summary>
public class DisabledObjectStorage : IObjectStorage {
    /// <inheritdoc />
    public Task PutAsync(string key, Stream content, long contentLength, string contentType, CancellationToken ct) =>
        throw new ObjectStorageDisabledException();

    /// <inheritdoc />
    public Task<StoredObject> GetAsync(string key, CancellationToken ct) => throw new ObjectStorageDisabledException();

    /// <inheritdoc />
    public Task DeleteAsync(string key, CancellationToken ct) => throw new ObjectStorageDisabledException();

    /// <inheritdoc />
    public Task<bool> ExistsAsync(string key, CancellationToken ct) => throw new ObjectStorageDisabledException();

    /// <inheritdoc />
    public IAsyncEnumerable<StoredObjectInfo> ListAsync(string keyPrefix, string? startAfter, CancellationToken ct) =>
        throw new ObjectStorageDisabledException();
}
