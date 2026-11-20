using API.Features.ObjectStorage;

namespace IntegrationTests.TestDoubles;

/// <summary>Fails the first delete, then delegates everything to <paramref name="inner"/>.</summary>
public sealed class FailingFirstDeleteObjectStorage(IObjectStorage inner) : IObjectStorage {
    public const string ErrorMessage = "Simulated storage outage";

    private bool _hasFailed;

    public Task PutAsync(string key, Stream content, long contentLength, string contentType, CancellationToken ct) =>
        inner.PutAsync(key, content, contentLength, contentType, ct);

    public Task<StoredObject> GetAsync(string key, CancellationToken ct) => inner.GetAsync(key, ct);

    public Task DeleteAsync(string key, CancellationToken ct) {
        if (!_hasFailed) {
            _hasFailed = true;
            throw new IOException(ErrorMessage);
        }

        return inner.DeleteAsync(key, ct);
    }

    public Task<bool> ExistsAsync(string key, CancellationToken ct) => inner.ExistsAsync(key, ct);

    public IAsyncEnumerable<StoredObjectInfo> ListAsync(string keyPrefix, string? startAfter, CancellationToken ct) =>
        inner.ListAsync(keyPrefix, startAfter, ct);
}
