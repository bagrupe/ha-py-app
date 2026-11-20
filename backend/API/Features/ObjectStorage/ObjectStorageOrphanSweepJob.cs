using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using Quartz;

namespace API.Features.ObjectStorage;

/// <summary>
/// Enqueues the deletion of uploads that no consumer references after the retention period.
/// <see cref="ObjectStorageCleanupJob"/> deletes them.
/// </summary>
[DisallowConcurrentExecution]
public class ObjectStorageOrphanSweepJob(
    IDbContextFactory<DomainContext> dbContextFactory,
    IObjectStorage storage,
    ObjectStorageConsumerRegistry consumers,
    OrphanSweepCursor sweepCursor,
    IClock clock,
    ObjectStorageOptions options,
    ILogger<ObjectStorageOrphanSweepJob> logger
) : IJob {
    /// <inheritdoc />
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await EnqueueOrphansAsync(failures, context.CancellationToken);
    }

    private async Task EnqueueOrphansAsync(CronJobItemFailures failures, CancellationToken ct) {
        var ring = consumers.All.ToList();
        if (ring.Count == 0) {
            return;
        }

        var now = clock.GetCurrentInstant();
        var cutoff = now - Duration.FromMinutes(options.OrphanRetentionMinutes);
        var remainingKeys = options.OrphanSweepMaxKeysPerRun;
        var startIndex = Math.Max(0, ring.FindIndex(consumer => consumer.Prefix == sweepCursor.Prefix));
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        for (var offset = 0; offset < ring.Count && remainingKeys > 0; offset++) {
            var consumer = ring[(startIndex + offset) % ring.Count];
            var nextPrefix = ring[(startIndex + offset + 1) % ring.Count].Prefix;
            var startAfter = consumer.Prefix == sweepCursor.Prefix ? sweepCursor.LastCheckedKey : null;

            var candidates = new List<string>();
            try {
                var reachedEnd = true;
                await foreach (var listed in storage.ListAsync($"{consumer.Prefix}/", startAfter, ct)) {
                    if (remainingKeys == 0) {
                        reachedEnd = false;
                        break;
                    }

                    remainingKeys--;
                    sweepCursor.Advance(consumer.Prefix, listed.Key);
                    if (listed.LastModified < cutoff && !await consumer.IsReferencedAsync(listed.Key, ct)) {
                        candidates.Add(listed.Key);
                    }
                }

                if (reachedEnd) {
                    sweepCursor.MoveTo(nextPrefix);
                }
            } catch (Exception e) when (e is not OperationCanceledException) {
                failures.RecordFailure();
                logger.LogError(e, "Orphan sweep of prefix {Prefix} failed", consumer.Prefix);
                sweepCursor.MoveTo(nextPrefix);
            }

            await EnqueueNotPendingAsync(db, candidates, now, ct);
        }
    }

    private static async Task EnqueueNotPendingAsync(DomainContext db, List<string> keys, Instant now, CancellationToken ct) {
        if (keys.Count == 0) {
            return;
        }

        var pending = await db.ObjectDeletionOutboxItems
            .Where(item => keys.Contains(item.Key))
            .Select(item => item.Key)
            .ToHashSetAsync(ct);
        foreach (var key in keys.Where(key => !pending.Contains(key))) {
            db.EnqueueObjectDeletion(key, now);
        }

        await db.SaveChangesAsync(ct);
    }
}

/// <summary>
/// Where the orphan sweep continues, going round all consumer prefixes. Listing is in key order, so without it
/// the per-run key limit would only ever cover the first keys of the first prefix. Kept in memory: after a
/// restart the sweep starts over.
/// </summary>
public class OrphanSweepCursor {
    /// <summary>Prefix the next run starts with, or <c>null</c> for the first consumer.</summary>
    public string? Prefix { get; private set; }

    /// <summary>Last checked key in <see cref="Prefix"/>, or <c>null</c> to start at its beginning.</summary>
    public string? LastCheckedKey { get; private set; }

    /// <summary>Records <paramref name="key"/> of <paramref name="prefix"/> as checked.</summary>
    public void Advance(string prefix, string key) {
        Prefix = prefix;
        LastCheckedKey = key;
    }

    /// <summary>Continues at the beginning of <paramref name="prefix"/>.</summary>
    public void MoveTo(string prefix) {
        Prefix = prefix;
        LastCheckedKey = null;
    }
}
