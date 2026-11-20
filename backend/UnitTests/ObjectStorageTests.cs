using System.Net.Http.Json;
using System.Security.Cryptography;
using API.Features.ObjectStorage;
using IntegrationTests.TestDoubles;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using NodaTime;
using static IntegrationTests.ObjectStorageTestBucket;

namespace IntegrationTests;

[Collection("Api Tests")]
public class ObjectStorageTests(BackendApiFactory factory) : IAsyncLifetime {
    private IObjectStorage Storage => factory.Services.GetRequiredService<IObjectStorage>();

    public Task InitializeAsync() => ObjectStorageTestBucket.EnsureExistsAsync(factory.Services);

    public Task DisposeAsync() => Task.CompletedTask;

    [Fact]
    public async Task Put_StreamsNonSeekableContent_AndGetReturnsItUnchanged() {
        var key = NewKey();
        var bytes = RandomNumberGenerator.GetBytes(5 * 1024 * 1024 + 17);

        await using (var content = new NonSeekableStream(new MemoryStream(bytes))) {
            await Storage.PutAsync(key, content, bytes.Length, "image/png", default);
        }

        await using var stored = await Storage.GetAsync(key, default);
        Assert.Equal("image/png", stored.ContentType);
        Assert.Equal(bytes.Length, stored.ContentLength);
        Assert.False(string.IsNullOrEmpty(stored.ETag));
        Assert.Equal(bytes, await ReadAllAsync(stored.Content));
    }

    [Fact]
    public async Task List_ReturnsKeyWithLastModifiedInUtc() {
        var key = NewKey();
        await Storage.PutAsync(key, [1], "image/png");

        var listed = new List<StoredObjectInfo>();
        await foreach (var stored in Storage.ListAsync(key, null, default)) {
            listed.Add(stored);
        }

        var single = Assert.Single(listed);
        Assert.Equal(key, single.Key);
        // A local-vs-UTC mix-up would shift this by the host's UTC offset and move the orphan cutoff with it.
        var drift = single.LastModified - SystemClock.Instance.GetCurrentInstant();
        Assert.True(drift < Duration.FromMinutes(5) && drift > -Duration.FromMinutes(5), $"LastModified is off by {drift}");
    }

    [Fact]
    public async Task HealthCheck_IsHealthyAgainstTheContainer() {
        Assert.Equal("Healthy", await ReadHealthEntryAsync(factory));
    }

    public static TheoryData<string, string> BrokenConnections => new() {
        { "ObjectStorage:ServiceUrl", "http://localhost:1" },
        { "ObjectStorage:SecretAccessKey", "wrong-secret" },
        { "ObjectStorage:Bucket", $"missing-{Guid.NewGuid():N}" },
    };

    [Theory]
    [MemberData(nameof(BrokenConnections))]
    public async Task HealthCheck_IsUnhealthyWithBrokenConnection(string key, string value) {
        await using var brokenFactory = new ObjectStorageOverrideApiFactory(new Dictionary<string, string?> { [key] = value });

        var report = await brokenFactory.Services.GetRequiredService<HealthCheckService>()
            .CheckHealthAsync(check => check.Name == ObjectStorageServiceExtensions.HealthCheckName);

        Assert.Equal(HealthStatus.Unhealthy, report.Entries[ObjectStorageServiceExtensions.HealthCheckName].Status);
        Assert.Equal("Unhealthy", await ReadHealthEntryAsync(brokenFactory));
    }

    [Fact]
    public async Task Startup_FailsWithIncompleteSection() {
        await using var incompleteFactory = new ObjectStorageOverrideApiFactory(
            new Dictionary<string, string?> { ["ObjectStorage:Bucket"] = "" });

        var exception = Assert.ThrowsAny<Exception>(() => incompleteFactory.Services);

        Assert.Contains(nameof(ObjectStorageOptions.Bucket), exception.ToString());
    }

    [Fact]
    public async Task Startup_WithoutSection_HasNoHealthEntry() {
        await using var disabledFactory = new ObjectStorageDisabledApiFactory();

        Assert.IsType<DisabledObjectStorage>(disabledFactory.Services.GetRequiredService<IObjectStorage>());
        Assert.Null(await ReadHealthEntryAsync(disabledFactory));
    }

    private static async Task<byte[]> ReadAllAsync(Stream stream) {
        using var buffer = new MemoryStream();
        await stream.CopyToAsync(buffer);
        return buffer.ToArray();
    }

    private static async Task<string?> ReadHealthEntryAsync(BackendApiFactory host) {
        using var client = host.CreateClient();
        // The overall status is 503 in tests because the configured Postgres and Gotenberg URLs aren't running.
        using var response = await client.GetAsync("/health/ready");
        var health = await response.Content.ReadFromJsonAsync<HealthResponse>();
        return health!.Checks.GetValueOrDefault(ObjectStorageServiceExtensions.HealthCheckName);
    }

    private sealed record HealthResponse(string Status, Dictionary<string, string> Checks);
}
