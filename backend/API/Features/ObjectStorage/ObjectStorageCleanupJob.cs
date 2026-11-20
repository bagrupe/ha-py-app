using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Quartz;

namespace API.Features.ObjectStorage;

/// <summary>
/// Deletes enqueued objects outside of any database transaction, including the orphans
/// <see cref="ObjectStorageOrphanSweepJob"/> enqueued.
/// </summary>
[DisallowConcurrentExecution]
public class ObjectStorageCleanupJob(
    IDbContextFactory<DomainContext> dbContextFactory,
    IObjectStorage storage,
    ObjectStorageConsumerRegistry consumers,
    ObjectStorageOptions options,
    ILogger<ObjectStorageCleanupJob> logger
) : IJob {
    /// <inheritdoc />
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await DeleteEnqueuedObjectsAsync(failures, context.CancellationToken);
    }

    private async Task DeleteEnqueuedObjectsAsync(CronJobItemFailures failures, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        // Rows that keep failing go last, so they can't fill every batch and starve new deletions.
        var batch = await db.ObjectDeletionOutboxItems.AsTracking()
            .OrderBy(item => item.FailedAttempts)
            .ThenBy(item => item.CreatedAt)
            .Take(options.DeletionBatchSize)
            .ToListAsync(ct);

        foreach (var item in batch) {
            try {
                // A consumer may have attached the key after it was enqueued, e.g. an orphan attached before this run.
                if (!await IsReferencedByItsConsumerAsync(item.Key, ct)) {
                    await storage.DeleteAsync(item.Key, ct);
                }

                db.Remove(item);
            } catch (Exception e) when (e is not OperationCanceledException) {
                failures.RecordFailure();
                item.FailedAttempts++;
                item.LastError = e.Message;
                if (item.FailedAttempts == options.DeletionWarnAfterAttempts) {
                    logger.LogWarning(e, "Deleting object {Key} failed {FailedAttempts} times", item.Key, item.FailedAttempts);
                }
            }
        }

        await db.SaveChangesAsync(ct);
    }

    private async Task<bool> IsReferencedByItsConsumerAsync(string key, CancellationToken ct) {
        var prefix = key.Split('/', 2)[0];
        return consumers.Find(prefix) is { } consumer && await consumer.IsReferencedAsync(key, ct);
    }
}
