using Amazon.S3;
using Amazon.S3.Model;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace API.Features.ObjectStorage;

/// <summary>Checks that the bucket is reachable with the configured credentials.</summary>
public class ObjectStorageHealthCheck(IAmazonS3 s3, ObjectStorageOptions options) : IHealthCheck {
    /// <inheritdoc />
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken ct = default) {
        try {
            // Scoped provider credentials deny every get-bucket-* call; HeadBucket is the only bucket-level call allowed.
            await s3.HeadBucketAsync(new HeadBucketRequest { BucketName = options.Bucket }, ct);
            return HealthCheckResult.Healthy();
        } catch (Exception e) {
            return new HealthCheckResult(context.Registration.FailureStatus, exception: e);
        }
    }
}
