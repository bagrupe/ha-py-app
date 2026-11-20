using System.Net;
using Amazon.S3;
using Amazon.S3.Model;
using API.Features.ObjectStorage;
using IntegrationTests.TestDoubles;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

/// <summary>Backend host with individual <c>ObjectStorage</c> keys overridden.</summary>
public class ObjectStorageOverrideApiFactory(IReadOnlyDictionary<string, string?> overrides) : BackendApiFactory {
    protected override IReadOnlyDictionary<string, string?> ConfigurationOverrides => overrides;

    protected override bool ResetsTestDatabase => false;
}

/// <summary>Backend host without an <c>ObjectStorage</c> section.</summary>
public class ObjectStorageDisabledApiFactory : BackendApiFactory {
    protected override bool ResetsTestDatabase => false;

    protected override bool ConfiguresObjectStorage => false;
}

public static class ObjectStorageTestBucket {
    /// <summary>Creates the configured bucket unless it exists. Providers create buckets in real environments.</summary>
    public static async Task EnsureExistsAsync(IServiceProvider services) {
        var s3 = services.GetRequiredService<IAmazonS3>();
        var bucket = services.GetRequiredService<ObjectStorageOptions>().Bucket;

        try {
            await s3.HeadBucketAsync(new HeadBucketRequest { BucketName = bucket });
        } catch (AmazonS3Exception e) when (e.StatusCode == HttpStatusCode.NotFound) {
            await s3.PutBucketAsync(bucket);
        }
    }

    public static string NewKey(string prefix = TestObjectStorageConsumer.PrefixValue) => $"{prefix}/{Guid.NewGuid():N}";

    /// <summary>Stores <paramref name="bytes"/> under <paramref name="key"/> and returns the key.</summary>
    public static async Task<string> PutAsync(this IObjectStorage storage, string key, byte[] bytes, string contentType = "image/png") {
        await using var content = new MemoryStream(bytes);
        await storage.PutAsync(key, content, bytes.Length, contentType, default);
        return key;
    }

    public static async Task<int> CountObjectsAsync(this IObjectStorage storage, string prefix) {
        var count = 0;
        await foreach (var _ in storage.ListAsync($"{prefix}/", null, default)) {
            count++;
        }

        return count;
    }
}
