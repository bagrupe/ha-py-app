using API.Features;
using API.Features.ObjectStorage;
using API.Infrastructure;
using IntegrationTests.TestDoubles;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;
using NodaTime;
using NodaTime.Testing;
using Quartz;
using static IntegrationTests.ObjectStorageTestBucket;

namespace IntegrationTests;

[Collection("Api Tests")]
public class ObjectStorageCleanupJobTests(BackendApiFactory factory) : IAsyncLifetime {
    private const string Test = TestObjectStorageConsumer.PrefixValue;
    private const string TestOther = OtherTestObjectStorageConsumer.PrefixValue;

    private IObjectStorage Storage => factory.Services.GetRequiredService<IObjectStorage>();
    private ObjectStorageOptions Options => factory.Services.GetRequiredService<ObjectStorageOptions>();
    private TestObjectStorageConsumers Consumers => factory.Services.GetRequiredService<TestObjectStorageConsumers>();

    public async Task InitializeAsync() {
        Consumers.Reset();
        await ObjectStorageTestBucket.EnsureExistsAsync(factory.Services);
        await using var scope = factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await db.ObjectDeletionOutboxItems.ExecuteDeleteAsync();
    }

    public Task DisposeAsync() {
        Consumers.Reset();
        return Task.CompletedTask;
    }

    [Fact]
    public async Task Run_DeletesObjectAndRemovesRow() {
        var key = await Storage.PutAsync(NewKey(), [1, 2, 3]);
        await EnqueueAsync(key);

        await RunJobAsync(Storage);

        Assert.False(await Storage.ExistsAsync(key, default));
        Assert.Empty(await OutboxRowsAsync(key));
    }

    [Fact]
    public async Task Run_FailedDelete_KeepsRowAndRetriesNextRun() {
        var key = await Storage.PutAsync(NewKey(), [1, 2, 3]);
        await EnqueueAsync(key);
        var storage = new FailingFirstDeleteObjectStorage(Storage);

        var firstRun = await RunJobAsync(storage);

        var row = Assert.Single(await OutboxRowsAsync(key));
        Assert.Equal(1, row.FailedAttempts);
        Assert.Equal(FailingFirstDeleteObjectStorage.ErrorMessage, row.LastError);
        Assert.Equal(1, firstRun.GetItemFailureCount());
        Assert.True(await Storage.ExistsAsync(key, default));

        var secondRun = await RunJobAsync(storage);

        Assert.Empty(await OutboxRowsAsync(key));
        Assert.False(await Storage.ExistsAsync(key, default));
        Assert.Equal(0, secondRun.GetItemFailureCount());
    }

    [Fact]
    public async Task Run_KeyAttachedAfterEnqueue_KeepsObjectAndRemovesRow() {
        var key = await Storage.PutAsync(NewKey(), [1, 2, 3]);
        await EnqueueAsync(key);
        Assert.True(await IsDeletionPendingAsync(key));
        Consumers.Test.ReferencedKeys.Add(key);

        await RunJobAsync(Storage);

        Assert.True(await Storage.ExistsAsync(key, default));
        Assert.Empty(await OutboxRowsAsync(key));
    }

    [Fact]
    public async Task Run_KeyWithoutRegisteredConsumer_IsDeleted() {
        var key = await Storage.PutAsync(NewKey("unregistered"), [1, 2, 3]);
        await EnqueueAsync(key);

        await RunJobAsync(Storage);

        Assert.False(await Storage.ExistsAsync(key, default));
        Assert.Empty(await OutboxRowsAsync(key));
    }

    [Fact]
    public async Task Run_MissingObject_RemovesRow() {
        var key = NewKey();
        await EnqueueAsync(key);

        await RunJobAsync(Storage);

        Assert.Empty(await OutboxRowsAsync(key));
    }

    [Fact]
    public void Jobs_AreScheduledWhenStorageIsConfigured() {
        Assert.Contains(nameof(ObjectStorageCleanupJob), ScheduledJobNames(factory));
        Assert.Contains(nameof(ObjectStorageOrphanSweepJob), ScheduledJobNames(factory));
    }

    [Fact]
    public async Task Jobs_AreNotScheduledWhenStorageIsDisabled() {
        await using var disabledFactory = new ObjectStorageDisabledApiFactory();

        Assert.DoesNotContain(nameof(ObjectStorageCleanupJob), ScheduledJobNames(disabledFactory));
        Assert.DoesNotContain(nameof(ObjectStorageOrphanSweepJob), ScheduledJobNames(disabledFactory));
    }

    [Fact]
    public async Task Sweep_UnreferencedUploadPastRetention_IsEnqueuedThenDeletedByNextRun() {
        var key = await Storage.PutAsync(NewKey(), [1, 2, 3]);
        var clock = ClockPastRetention(await LastModifiedAsync(key));

        await RunCleanupThenSweepAsync(clock);

        Assert.Single(await OutboxRowsAsync(key));
        Assert.True(await Storage.ExistsAsync(key, default));

        await RunCleanupThenSweepAsync(clock);

        Assert.False(await Storage.ExistsAsync(key, default));
        Assert.Empty(await OutboxRowsAsync(key));
    }

    [Fact]
    public async Task Sweep_ReferencedUploadPastRetention_IsKept() {
        var key = await Storage.PutAsync(NewKey(), [1, 2, 3]);
        Consumers.Test.ReferencedKeys.Add(key);
        var clock = ClockPastRetention(await LastModifiedAsync(key));

        await RunCleanupThenSweepAsync(clock);
        await RunCleanupThenSweepAsync(clock);

        Assert.Contains(key, Consumers.Test.KeysCheckedForReferences);
        Assert.Empty(await OutboxRowsAsync(key));
        Assert.True(await Storage.ExistsAsync(key, default));
    }

    [Fact]
    public async Task Sweep_UnreferencedUploadWithinRetention_IsKept() {
        var key = await Storage.PutAsync(NewKey(), [1, 2, 3]);
        var lastModified = await LastModifiedAsync(key);
        var clock = new FakeClock(lastModified + Duration.FromMinutes(Options.OrphanRetentionMinutes - 1));

        await RunCleanupThenSweepAsync(clock);
        await RunCleanupThenSweepAsync(clock);

        Assert.DoesNotContain(key, Consumers.Test.KeysCheckedForReferences);
        Assert.Empty(await OutboxRowsAsync(key));
        Assert.True(await Storage.ExistsAsync(key, default));
    }

    [Fact]
    public async Task Sweep_ChecksEachKeyOnlyWithItsOwnConsumer() {
        var testKey = await Storage.PutAsync(NewKey(Test), [1, 2, 3]);
        var otherKey = await Storage.PutAsync(NewKey(TestOther), [1, 2, 3]);
        var clock = ClockPastRetention(await LastModifiedAsync(otherKey));

        await RunCleanupThenSweepAsync(clock);

        Assert.Contains(testKey, Consumers.Test.KeysCheckedForReferences);
        Assert.Contains(otherKey, Consumers.TestOther.KeysCheckedForReferences);
        Assert.All(Consumers.Test.KeysCheckedForReferences, key => Assert.StartsWith($"{Test}/", key));
        Assert.All(Consumers.TestOther.KeysCheckedForReferences, key => Assert.StartsWith($"{TestOther}/", key));
    }

    [Fact]
    public async Task Sweep_LeavesObjectsUnderUnregisteredPrefixesAlone() {
        var key = await Storage.PutAsync(NewKey("unregistered"), [1, 2, 3]);
        var clock = ClockPastRetention(await LastModifiedAsync(key));

        await RunCleanupThenSweepAsync(clock);
        await RunCleanupThenSweepAsync(clock);

        Assert.Empty(await OutboxRowsAsync(key));
        Assert.True(await Storage.ExistsAsync(key, default));
        await Storage.DeleteAsync(key, default);
    }

    [Fact]
    public async Task Sweep_WithKeyLimit_ContinuesWhereThePreviousRunStopped() {
        // Two referenced keys in one prefix: a run has to stop inside the prefix, and because referenced keys are
        // never deleted, only the cursor can move the next run past them.
        var testKeys = new[] { await Storage.PutAsync(NewKey(Test), [1, 2, 3]), await Storage.PutAsync(NewKey(Test), [1, 2, 3]) };
        var otherKey = await Storage.PutAsync(NewKey(TestOther), [1, 2, 3]);
        Consumers.Test.ReferencedKeys.UnionWith(testKeys);
        Consumers.TestOther.ReferencedKeys.Add(otherKey);
        var clock = ClockPastRetention(await LastModifiedAsync(otherKey));
        var oneKeyPerRun = new ObjectStorageOptions { OrphanSweepMaxKeysPerRun = 1 };
        var cursor = new OrphanSweepCursor();
        var listedKeys = await Storage.CountObjectsAsync(Test) + await Storage.CountObjectsAsync(TestOther);
        var runsToCoverAllPrefixes = await CountObjectsOfAllConsumersAsync();

        for (var run = 0; run < runsToCoverAllPrefixes; run++) {
            await RunCleanupThenSweepAsync(clock, oneKeyPerRun, cursor);
        }

        Assert.All(testKeys, key => Assert.Contains(key, Consumers.Test.KeysCheckedForReferences));
        Assert.Contains(otherKey, Consumers.TestOther.KeysCheckedForReferences);
        // Distinct, because the delete phase asks again for every orphan the sweep enqueued.
        Assert.Equal(listedKeys, Consumers.Test.KeysCheckedForReferences.Distinct().Count() +
                                 Consumers.TestOther.KeysCheckedForReferences.Distinct().Count());
    }

    private async Task<int> CountObjectsOfAllConsumersAsync() {
        using var scope = factory.Services.CreateScope();
        var count = 0;
        foreach (var consumer in scope.ServiceProvider.GetServices<IObjectStorageConsumer>()) {
            count += await Storage.CountObjectsAsync(consumer.Prefix);
        }

        return count;
    }

    private static Instant Now => SystemClock.Instance.GetCurrentInstant();

    // LastModified is the storage server's real time, while the factory's FakeClock starts at 2026-06-30.
    private FakeClock ClockPastRetention(Instant lastModified) =>
        new(lastModified + Duration.FromMinutes(Options.OrphanRetentionMinutes + 1));

    private async Task<Instant> LastModifiedAsync(string key) {
        await foreach (var listed in Storage.ListAsync(key, null, default)) {
            return listed.LastModified;
        }

        throw new InvalidOperationException($"{key} is not stored.");
    }

    private static IEnumerable<string> ScheduledJobNames(BackendApiFactory host) =>
        host.Services.GetRequiredService<IOptions<QuartzOptions>>().Value.JobDetails.Select(job => job.Key.Name);

    private async Task EnqueueAsync(string key) {
        await using var scope = factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        db.EnqueueObjectDeletion(key, Now);
        await db.SaveChangesAsync();
    }

    private async Task<bool> IsDeletionPendingAsync(string key) {
        await using var scope = factory.Services.CreateAsyncScope();
        return await scope.ServiceProvider.GetRequiredService<DomainContext>().IsObjectDeletionPendingAsync(key, default);
    }

    private async Task<List<ObjectDeletionOutboxItem>> OutboxRowsAsync(string key) {
        await using var scope = factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        return await db.ObjectDeletionOutboxItems.Where(item => item.Key == key).ToListAsync();
    }

    private async Task<IJobExecutionContext> RunJobAsync(IObjectStorage storage) {
        await using var scope = factory.Services.CreateAsyncScope();
        var job = new ObjectStorageCleanupJob(
            factory.Services.GetRequiredService<IDbContextFactory<DomainContext>>(),
            storage,
            scope.ServiceProvider.GetRequiredService<ObjectStorageConsumerRegistry>(),
            Options,
            NullLogger<ObjectStorageCleanupJob>.Instance);
        var context = JobExecutionContextTestHelper.Create(nameof(ObjectStorageCleanupJob));
        await job.Execute(context);
        return context;
    }

    /// <summary>
    /// Runs the cleanup job, then the sweep, so orphans a sweep enqueued are deleted by the following call.
    /// The clock must lie after the uploads' LastModified, otherwise the sweep finds no orphans.
    /// </summary>
    private async Task RunCleanupThenSweepAsync(IClock clock, ObjectStorageOptions? options = null,
        OrphanSweepCursor? cursor = null) {
        await RunJobAsync(Storage);
        await using var scope = factory.Services.CreateAsyncScope();
        var sweep = new ObjectStorageOrphanSweepJob(
            factory.Services.GetRequiredService<IDbContextFactory<DomainContext>>(),
            Storage,
            scope.ServiceProvider.GetRequiredService<ObjectStorageConsumerRegistry>(),
            cursor ?? new OrphanSweepCursor(),
            clock,
            options ?? Options,
            NullLogger<ObjectStorageOrphanSweepJob>.Instance);
        await sweep.Execute(JobExecutionContextTestHelper.Create(nameof(ObjectStorageOrphanSweepJob)));
    }
}
