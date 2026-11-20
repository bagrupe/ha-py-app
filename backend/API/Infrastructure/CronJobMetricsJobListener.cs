using Quartz;

namespace API.Infrastructure;

/// <summary>Records cron job metrics for monitored Quartz jobs after each execution.</summary>
public class CronJobMetricsJobListener(CronJobMetricsService metricsService) : IJobListener {
    public string Name => "CronJobMetrics";

    public Task JobToBeExecuted(IJobExecutionContext context, CancellationToken cancellationToken = default) {
        return Task.CompletedTask;
    }

    public Task JobExecutionVetoed(IJobExecutionContext context, CancellationToken cancellationToken = default) {
        return Task.CompletedTask;
    }

    public Task JobWasExecuted(
        IJobExecutionContext context,
        JobExecutionException? jobException,
        CancellationToken cancellationToken = default) {
        var jobName = context.JobDetail.Key.Name;
        if (!metricsService.IsMonitored(jobName)) {
            return Task.CompletedTask;
        }

        var success = jobException is null;
        var durationSeconds = context.JobRunTime.TotalSeconds;
        var itemsFailed = context.GetItemFailureCount();
        metricsService.RecordJobRun(jobName, success, durationSeconds, itemsFailed);
        return Task.CompletedTask;
    }
}
