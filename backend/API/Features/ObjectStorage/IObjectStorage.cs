using NodaTime;

namespace API.Features.ObjectStorage;

/// <summary>Stores opaque binary objects by key. The backend is the only client of the bucket.</summary>
public interface IObjectStorage {
    /// <summary>Streams <paramref name="content"/> to <paramref name="key"/>, replacing any existing object.</summary>
    Task PutAsync(string key, Stream content, long contentLength, string contentType, CancellationToken ct);

    /// <summary>Opens the object for streaming. The caller disposes the result.</summary>
    /// <exception cref="ObjectNotFoundException">No object exists under <paramref name="key"/>.</exception>
    Task<StoredObject> GetAsync(string key, CancellationToken ct);

    /// <summary>Deletes the object. A missing key is a no-op.</summary>
    Task DeleteAsync(string key, CancellationToken ct);

    /// <summary>Checks whether an object exists under <paramref name="key"/>.</summary>
    Task<bool> ExistsAsync(string key, CancellationToken ct);

    /// <summary>Lists objects whose key starts with <paramref name="keyPrefix"/>, in key order, after <paramref name="startAfter"/>.</summary>
    IAsyncEnumerable<StoredObjectInfo> ListAsync(string keyPrefix, string? startAfter, CancellationToken ct);
}

/// <summary>An opened object. Disposing it releases the underlying connection.</summary>
public sealed record StoredObject(Stream Content, string ContentType, long ContentLength, string ETag) : IAsyncDisposable {
    /// <inheritdoc />
    public ValueTask DisposeAsync() => Content.DisposeAsync();
}

/// <summary>A listed object. <see cref="LastModified"/> is the storage server's time.</summary>
public sealed record StoredObjectInfo(string Key, Instant LastModified);
