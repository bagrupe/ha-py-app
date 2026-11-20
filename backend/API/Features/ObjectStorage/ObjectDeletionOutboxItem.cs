using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.ObjectStorage;

/// <summary>An object to delete from storage, written in the same transaction as the entity that referenced it.</summary>
/// <remarks>Rows are never dropped after failures: a dropped row would leak the object forever.</remarks>
public class ObjectDeletionOutboxItem {
    /// <summary>Row id.</summary>
    public Guid Id { get; set; }

    /// <summary>Storage key to delete.</summary>
    public required string Key { get; set; }

    /// <summary>When the deletion was enqueued.</summary>
    public Instant CreatedAt { get; set; }

    /// <summary>Failed delete attempts so far.</summary>
    public int FailedAttempts { get; set; }

    /// <summary>Error of the last failed attempt.</summary>
    public string? LastError { get; set; }
}

/// <summary>Not unique: two consumers may enqueue the same key, and the second delete is a no-op.</summary>
public class ObjectDeletionOutboxItemEntityTypeConfiguration : IEntityTypeConfiguration<ObjectDeletionOutboxItem> {
    /// <inheritdoc />
    public void Configure(EntityTypeBuilder<ObjectDeletionOutboxItem> builder) {
        builder.HasIndex(item => item.Key);
    }
}

/// <summary>Consumer API for deleting objects.</summary>
public static class ObjectDeletionOutbox {
    /// <summary>
    /// Enqueues the deletion of <paramref name="key"/>. It is committed or rolled back with the caller's own
    /// <c>SaveChanges</c> or transaction; the object is deleted later by <see cref="ObjectStorageCleanupJob"/>.
    /// Call it in the same transaction as the entity delete, never <see cref="IObjectStorage.DeleteAsync"/> directly.
    /// </summary>
    public static void EnqueueObjectDeletion(this DomainContext db, string key, Instant now) {
        db.ObjectDeletionOutboxItems.Add(new ObjectDeletionOutboxItem {
            Id = Guid.NewGuid(),
            Key = key,
            CreatedAt = now,
        });
    }

    /// <summary>
    /// Whether the deletion of <paramref name="key"/> is enqueued. A mutation that attaches an uploaded key checks
    /// this in the same transaction as the attach and rejects the key if it returns <c>true</c>.
    /// </summary>
    public static Task<bool> IsObjectDeletionPendingAsync(this DomainContext db, string key, CancellationToken ct) =>
        db.ObjectDeletionOutboxItems.AnyAsync(item => item.Key == key, ct);
}
