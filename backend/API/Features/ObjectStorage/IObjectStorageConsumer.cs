namespace API.Features.ObjectStorage;

/// <summary>
/// A feature that stores objects under its own key prefix and decides who may upload and read them.
/// Register it with <see cref="ObjectStorageServiceExtensions.AddObjectStorageConsumer{TConsumer}"/>.
/// </summary>
/// <remarks>
/// Don't use <c>ICurrentUserAccessor.User()</c> or the helpers built on it (<c>EnsureBackofficeUser</c>):
/// its DataLoader only completes inside a GraphQL execution, and consumers are called from controllers
/// and the cleanup job.
/// </remarks>
public interface IObjectStorageConsumer {
    /// <summary>Key prefix. Keys are <c>&lt;prefix&gt;/&lt;id&gt;</c>.</summary>
    string Prefix { get; }

    /// <summary>Upload limit in bytes. <c>null</c> uses <see cref="ObjectStorageOptions.MaxUploadBytes"/>.</summary>
    long? MaxUploadBytes => null;

    /// <summary>Accepted content types. <c>null</c> uses <see cref="ObjectStorageOptions.AllowedContentTypes"/>.</summary>
    IReadOnlyCollection<string>? AllowedContentTypes => null;

    /// <summary>Whether the authenticated user may upload under this prefix.</summary>
    Task<bool> CanUploadAsync(Guid userId, CancellationToken ct);

    /// <summary>Whether the user may read <paramref name="key"/>. <paramref name="userId"/> is <c>null</c> for anonymous requests.</summary>
    Task<bool> CanReadAsync(Guid? userId, string key, CancellationToken ct);

    /// <summary>
    /// Whether an entity still uses <paramref name="key"/>. Unreferenced objects older than
    /// <see cref="ObjectStorageOptions.OrphanRetentionMinutes"/> are deleted by <see cref="ObjectStorageCleanupJob"/>.
    /// </summary>
    /// <remarks>
    /// An upload attached just as its retention runs out can already be enqueued or deleted, so a mutation that attaches
    /// a key rejects it when <see cref="ObjectDeletionOutbox.IsObjectDeletionPendingAsync"/> is true or
    /// <see cref="IObjectStorage.ExistsAsync"/> is false. An enqueued key attached after that check is still kept,
    /// because <see cref="ObjectStorageCleanupJob"/> asks this method again before deleting.
    /// </remarks>
    Task<bool> IsReferencedAsync(string key, CancellationToken ct);
}
