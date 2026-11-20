using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Features.ObjectStorage;

/// <summary>Connection to the S3-compatible object storage. The feature is disabled when the section is absent.</summary>
public class ObjectStorageOptions : IValidatable {
    /// <summary>Configuration section name.</summary>
    public const string SectionName = "ObjectStorage";

    /// <summary>S3 endpoint, e.g. <c>http://localhost:9000</c>.</summary>
    [Required] public string ServiceUrl { get; set; } = null!;

    /// <summary>Bucket that holds all objects. It is created by the provider, never by the backend.</summary>
    [Required] public string Bucket { get; set; } = null!;

    /// <summary>Access key scoped to the bucket.</summary>
    [Required] public string AccessKeyId { get; set; } = null!;

    /// <summary>Secret key scoped to the bucket.</summary>
    [Required] public string SecretAccessKey { get; set; } = null!;

    /// <summary>Signing region.</summary>
    [Required] public string Region { get; set; } = "eu-central-1";

    /// <summary>Addresses the bucket in the path instead of the host name.</summary>
    public bool ForcePathStyle { get; set; } = true;

    /// <summary>
    /// Upload limit in bytes, unless a consumer sets its own. Must stay below nginx's <c>client_max_body_size</c>
    /// (100M), otherwise nginx rejects the upload before the backend sees it.
    /// </summary>
    [Range(1, long.MaxValue)] public long MaxUploadBytes { get; set; } = 50 * 1024 * 1024;

    // Nullable because the configuration binder appends a configured array to a non-empty default instead of replacing it.
    /// <summary>Content types accepted on upload, unless a consumer sets its own. <c>null</c> means <see cref="DefaultAllowedContentTypes"/>.</summary>
    public string[]? AllowedContentTypes { get; set; }

    /// <summary>Accepted content types when <see cref="AllowedContentTypes"/> is not configured.</summary>
    public static readonly IReadOnlyCollection<string> DefaultAllowedContentTypes = [
        "image/jpeg",
        "image/png",
        "image/webp",
        "image/heic",
        "application/pdf",
        "application/octet-stream",
    ];

    /// <summary>The configured content types, or the defaults.</summary>
    public IReadOnlyCollection<string> EffectiveAllowedContentTypes => AllowedContentTypes ?? DefaultAllowedContentTypes;

    /// <summary>Quartz cron schedule of <see cref="ObjectStorageCleanupJob"/>.</summary>
    [Required] public string CleanupJobCron { get; set; } = "0 * * ? * * *";

    /// <summary>Quartz cron schedule of <see cref="ObjectStorageOrphanSweepJob"/>.</summary>
    [Required] public string OrphanSweepCron { get; set; } = "0 0 * ? * * *";

    /// <summary>Enqueued deletions processed per job run.</summary>
    [Range(1, int.MaxValue)] public int DeletionBatchSize { get; set; } = 100;

    /// <summary>Failed attempts after which a deletion is logged as a warning.</summary>
    [Range(1, int.MaxValue)] public int DeletionWarnAfterAttempts { get; set; } = 10;

    /// <summary>Minutes an unreferenced upload is kept before the orphan sweep enqueues its deletion.</summary>
    [Range(1, int.MaxValue)] public int OrphanRetentionMinutes { get; set; } = 24 * 60;

    /// <summary>Listed keys the orphan sweep checks per job run, so a run's duration stays bounded.</summary>
    [Range(1, int.MaxValue)] public int OrphanSweepMaxKeysPerRun { get; set; } = 60000;

    /// <summary>Validates the current options against the defined rules.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
