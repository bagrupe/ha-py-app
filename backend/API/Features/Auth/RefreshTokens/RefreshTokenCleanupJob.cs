using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using Quartz;

namespace API.Features.Auth.RefreshTokens;

[DisallowConcurrentExecution]
public class RefreshTokenCleanupJob(
    IDbContextFactory<DomainContext> dbContextFactory,
    IClock clock,
    ILogger<RefreshTokenCleanupJob> logger
) : IJob {
    public async Task Execute(IJobExecutionContext context) {
        await using var db = await dbContextFactory.CreateDbContextAsync(context.CancellationToken);
        var now = clock.GetCurrentInstant();
        var deleted = await db.RefreshTokens
            .Where(t => t.ExpiresAt <= now)
            .ExecuteDeleteAsync(context.CancellationToken);

        if (deleted > 0) {
            logger.LogInformation("Deleted {Count} expired refresh tokens", deleted);
        }
    }
}

public static class RefreshTokenCleanupJobExtension {
    public static IServiceCollection AddRefreshTokenCleanupJob(this IServiceCollection services) {
        const string hourly = "0 0 * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<RefreshTokenCleanupJob>(hourly, fireImmediate: false));

        return services;
    }
}
