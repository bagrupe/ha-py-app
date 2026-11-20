using Amazon.Runtime;
using Amazon.S3;
using API.Infrastructure;
using NetEscapades.Configuration.Validation;
using Quartz;

namespace API.Features.ObjectStorage;

/// <summary>Registers the object storage, which is optional and only active when its section is configured.</summary>
public static class ObjectStorageServiceExtensions {
    public const string HealthCheckName = "object-storage";

    /// <summary>Registers <see cref="IObjectStorage"/> against S3, or <see cref="DisabledObjectStorage"/> when the section is absent.</summary>
    public static IServiceCollection AddObjectStorage(this IServiceCollection services, IConfigurationSection section) {
        services
            .AddScoped<ObjectStorageConsumerRegistry>()
            .AddHostedService<ObjectStorageConsumerRegistryValidator>();

        if (!section.Exists()) {
            return services.AddSingleton<IObjectStorage, DisabledObjectStorage>();
        }

        services.AddHealthChecks().AddCheck<ObjectStorageHealthCheck>(HealthCheckName);

        return services
            .ConfigureValidatableSetting<ObjectStorageOptions>(section)
            .AddSingleton<IAmazonS3>(sp => {
                var options = sp.GetRequiredService<ObjectStorageOptions>();
                return new AmazonS3Client(
                    new BasicAWSCredentials(options.AccessKeyId, options.SecretAccessKey),
                    new AmazonS3Config {
                        ServiceURL = options.ServiceUrl,
                        AuthenticationRegion = options.Region,
                        ForcePathStyle = options.ForcePathStyle,
                    });
            })
            .AddSingleton<IObjectStorage, S3ObjectStorage>()
            .AddObjectStorageCleanupJob();
    }

    /// <summary>Registers a consumer. Scoped so consumers can inject scoped services such as <c>DomainContext</c>.</summary>
    public static IServiceCollection AddObjectStorageConsumer<TConsumer>(this IServiceCollection services)
        where TConsumer : class, IObjectStorageConsumer {
        return services.AddScoped<IObjectStorageConsumer, TConsumer>();
    }

    private static IServiceCollection AddObjectStorageCleanupJob(this IServiceCollection services) {
        services
            .AddSingleton<OrphanSweepCursor>()
            .AddOptions<QuartzOptions>()
            .Configure<ObjectStorageOptions>((quartz, options) => {
                quartz.ScheduleJob<ObjectStorageCleanupJob>(options.CleanupJobCron);
                quartz.ScheduleJob<ObjectStorageOrphanSweepJob>(options.OrphanSweepCron);
            });

        return services;
    }
}
