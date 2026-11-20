using System.Collections.Concurrent;
using API.Features.Aufbewahrung.Jobs;
using API.Features.Auth.Jobs;
using API.Features.Auth.RefreshTokens;
using API.Features.BereichB.Jobs;
using API.Features.EmailForwarder;
using API.Features.GovManager;
using API.Features.ObjectStorage;
using API.Features.PmPayment;
using API.Features.Prozess;
using API.Features.PushNotifications.Jobs;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Prometheus;

namespace API.Infrastructure;

/// <summary>Pushes cron job run metrics to Prometheus Pushgateway after each monitored Quartz job execution.</summary>
public class CronJobMetricsService {
    public const string HttpClientName = "Pushgateway";

    private static readonly HashSet<string> MonitoredJobs = new(StringComparer.Ordinal) {
        nameof(AntragArchivierungJob),
        nameof(AntragHardDeleteJob),
        nameof(EmailForwarderExportRunner),
        nameof(EmailOutboxSendJob),
        nameof(GovManagerRequestRunner),
        nameof(GovManagerRestExportRunner),
        nameof(InvitationEmailJob),
        nameof(NewsartikelPushNotificationJob),
        nameof(ObjectStorageCleanupJob),
        nameof(ObjectStorageOrphanSweepJob),
        nameof(PasswordResetEmailJob),
        nameof(PaymentRunner),
        nameof(ProgrammatischerSchrittRunner),
        nameof(RefreshTokenCleanupJob),
        nameof(SynchronizerRunner),
    };

    private readonly string? _pushgatewayUrl;
    private readonly string _environment;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<CronJobMetricsService> _logger;
    private readonly ConcurrentDictionary<string, JobMetricSet> _metricSets = new();
    private readonly ConcurrentDictionary<string, byte> _jobsWithAtLeastOneRun = new(StringComparer.Ordinal);

    public CronJobMetricsService(
        IConfiguration configuration,
        IHostEnvironment hostEnvironment,
        IHttpClientFactory httpClientFactory,
        ILogger<CronJobMetricsService> logger) {
        _pushgatewayUrl = configuration["PUSHGATEWAY_URL"];
        _environment = hostEnvironment.EnvironmentName.ToLowerInvariant();
        _httpClientFactory = httpClientFactory;
        _logger = logger;
    }

    public bool IsMonitored(string jobName) => MonitoredJobs.Contains(jobName);

    public void RecordJobRun(
        string jobName,
        bool success,
        double durationSeconds,
        int itemsFailed = 0) {
        if (string.IsNullOrEmpty(_pushgatewayUrl)) {
            return;
        }

        var metrics = _metricSets.GetOrAdd(jobName, CreateMetricSet);

        metrics.LastSuccess.WithLabels(_environment).Set(success ? 1 : 0);
        metrics.LastRunTimestamp.WithLabels(_environment).Set(DateTimeOffset.UtcNow.ToUnixTimeSeconds());
        metrics.DurationSeconds.WithLabels(_environment).Set(durationSeconds);
        ApplyScheduleMetrics(metrics, jobName);
        var itemsFailedTotal = metrics.ItemsFailedTotal.WithLabels(_environment);
        if (itemsFailed > 0) {
            itemsFailedTotal.Inc(itemsFailed);
        }

        _jobsWithAtLeastOneRun[jobName] = 0;
        _ = PushJobMetricsAsync(metrics.Registry, jobName);
    }

    private async Task PushJobMetricsAsync(CollectorRegistry registry, string jobName) {
        try {
            await PushToGatewayAsync(registry, jobName);
        } catch (Exception ex) {
            _logger.LogWarning(ex, "Failed to push cron job metrics for {JobName}", jobName);
        }
    }

    private void ApplyScheduleMetrics(JobMetricSet metrics, string jobName) {
        if (CronJobScheduleRegistry.GetIntervalSeconds(jobName) is not { } intervalSeconds) {
            return;
        }

        metrics.ExpectedIntervalSeconds.WithLabels(_environment).Set(intervalSeconds);
    }

    private JobMetricSet CreateMetricSet(string jobName) {
        var registry = Metrics.NewCustomRegistry();
        var factory = Metrics.WithCustomRegistry(registry);

        var lastSuccess = factory.CreateGauge(
            "cron_job_last_success",
            "Whether the last cron job run completed without uncaught exception (1 = success, 0 = failure)",
            "environment");
        var lastRunTimestamp = factory.CreateGauge(
            "cron_job_last_run_timestamp",
            "Unix timestamp of the last cron job run",
            "environment");
        var durationSeconds = factory.CreateGauge(
            "cron_job_duration_seconds",
            "Duration of the last cron job run in seconds",
            "environment");
        var itemsFailedTotal = factory.CreateCounter(
            "cron_job_items_failed_total",
            "Total number of items that could not be processed across cron job runs",
            "environment");
        var expectedIntervalSeconds = factory.CreateGauge(
            "cron_job_expected_interval_seconds",
            "Configured interval between cron job runs in seconds",
            "environment");

        return new JobMetricSet(
            registry,
            lastSuccess,
            lastRunTimestamp,
            durationSeconds,
            itemsFailedTotal,
            expectedIntervalSeconds);
    }

    private async Task PushToGatewayAsync(CollectorRegistry registry, string jobName) {
        if (!_jobsWithAtLeastOneRun.ContainsKey(jobName)) {
            return;
        }

        var pushgatewayInstance = $"{_environment}-backend";
        var targetUrl =
            $"{_pushgatewayUrl!.TrimEnd('/')}/metrics/job/{Uri.EscapeDataString(jobName)}/instance/{Uri.EscapeDataString(pushgatewayInstance)}";

        using var memoryStream = new MemoryStream();
        await registry.CollectAndExportAsTextAsync(memoryStream);

        var httpClient = _httpClientFactory.CreateClient(HttpClientName);
        using var content = new ByteArrayContent(memoryStream.ToArray());
        content.Headers.TryAddWithoutValidation("Content-Type", "text/plain; version=0.0.4; charset=utf-8");

        using var response = await httpClient.PostAsync(targetUrl, content);
        response.EnsureSuccessStatusCode();
    }

    private sealed record JobMetricSet(
        CollectorRegistry Registry,
        Gauge LastSuccess,
        Gauge LastRunTimestamp,
        Gauge DurationSeconds,
        Counter ItemsFailedTotal,
        Gauge ExpectedIntervalSeconds);
}
