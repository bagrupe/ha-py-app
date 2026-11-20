using System.Net;
using API.Features.EmailForwarder;
using API.Infrastructure;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging.Abstractions;
using Moq;
using Quartz;

namespace IntegrationTests;

public class CronJobMetricsTests : IDisposable {
    public CronJobMetricsTests() => CronJobScheduleRegistry.ResetForTesting();

    public void Dispose() => CronJobScheduleRegistry.ResetForTesting();

    [Theory]
    [InlineData("0/10 * * ? * * *", 10)]
    [InlineData("0/30 * * ? * * *", 30)]
    [InlineData("0 */1 * ? * *", 60)]
    [InlineData("0 * * ? * * *", 60)]
    [InlineData("0 0 * ? * * *", 3600)]
    [InlineData("invalid cron", null)]
    [InlineData("", null)]
    public void TryParseIntervalSeconds_ParsesProjectCronExpressions(string cronExpression, int? expectedSeconds) {
        Assert.Equal(expectedSeconds, QuartzCronScheduleParser.TryParseIntervalSeconds(cronExpression));
    }

    [Fact]
    public void ScheduleRegistry_Register_StoresParsedInterval() {
        CronJobScheduleRegistry.Register(nameof(EmailForwarderExportRunner), "0/10 * * ? * * *");

        Assert.Equal(10, CronJobScheduleRegistry.GetIntervalSeconds(nameof(EmailForwarderExportRunner)));
    }

    [Fact]
    public void ScheduleRegistry_Register_IgnoresUnknownCronExpression() {
        CronJobScheduleRegistry.Register("UnknownJob", "at midnight on tuesdays");

        Assert.Null(CronJobScheduleRegistry.GetIntervalSeconds("UnknownJob"));
    }

    [Fact]
    public void ItemFailures_TracksCountOnDispose() {
        var context = CreateJobContext(nameof(EmailForwarderExportRunner));

        using (var failures = context.TrackItemFailures()) {
            failures.RecordFailure();
            failures.RecordFailures(2);
            failures.RecordFailures(0);
        }

        Assert.Equal(3, context.GetItemFailureCount());
    }

    [Fact]
    public void ItemFailures_ReturnsZeroWhenNotTracked() {
        var context = CreateJobContext(nameof(EmailForwarderExportRunner));

        Assert.Equal(0, context.GetItemFailureCount());
    }

    [Theory]
    [InlineData(nameof(EmailForwarderExportRunner), true)]
    [InlineData("NotARealJob", false)]
    public void MetricsService_IsMonitored(string jobName, bool expected) {
        var service = CreateMetricsService(pushgatewayUrl: "http://pushgateway", out _);

        Assert.Equal(expected, service.IsMonitored(jobName));
    }

    [Fact]
    public async Task MetricsService_RecordJobRun_DoesNothingWithoutPushgatewayUrl() {
        var handler = new CapturePushgatewayHandler();
        var service = CreateMetricsService(pushgatewayUrl: null, out var factory, handler);

        service.RecordJobRun(nameof(EmailForwarderExportRunner), success: true, durationSeconds: 1.2);
        await Task.Delay(100);

        Assert.Null(handler.LastRequest);
        factory.Verify(f => f.CreateClient(It.IsAny<string>()), Times.Never);
    }

    [Fact]
    public async Task MetricsService_RecordJobRun_PushesItemsFailedTotalEvenWhenZero() {
        var handler = new CapturePushgatewayHandler();
        var service = CreateMetricsService(pushgatewayUrl: "http://pushgateway", out _, handler);

        var waitTask = handler.WaitForRequestAsync();
        service.RecordJobRun(nameof(EmailForwarderExportRunner), success: true, durationSeconds: 1.2);
        await waitTask;

        Assert.Contains("cron_job_items_failed_total{environment=\"testing\"} 0", handler.LastBody);
    }

    [Fact]
    public async Task MetricsService_RecordJobRun_PushesRunMetrics() {
        CronJobScheduleRegistry.Register(nameof(EmailForwarderExportRunner), "0/10 * * ? * * *");
        var handler = new CapturePushgatewayHandler();
        var service = CreateMetricsService(pushgatewayUrl: "http://pushgateway", out _, handler);

        var waitTask = handler.WaitForRequestAsync();
        service.RecordJobRun(
            nameof(EmailForwarderExportRunner),
            success: false,
            durationSeconds: 1.5,
            itemsFailed: 2);
        await waitTask;

        Assert.NotNull(handler.LastRequest);
        Assert.Equal(HttpMethod.Post, handler.LastRequest!.Method);
        Assert.Contains(
            "/metrics/job/EmailForwarderExportRunner/instance/testing-backend",
            handler.LastRequest.RequestUri!.ToString());
        Assert.Contains("cron_job_last_success{environment=\"testing\"} 0", handler.LastBody);
        Assert.Contains("cron_job_duration_seconds{environment=\"testing\"} 1.5", handler.LastBody);
        Assert.Contains("cron_job_items_failed_total{environment=\"testing\"} 2", handler.LastBody);
        Assert.Contains("cron_job_expected_interval_seconds{environment=\"testing\"} 10", handler.LastBody);
    }

    [Fact]
    public void MetricsService_DoesNotPushBeforeAnyJobRun() {
        CronJobScheduleRegistry.Register(nameof(EmailForwarderExportRunner), "0/10 * * ? * * *");
        var handler = new CapturePushgatewayHandler();
        CreateMetricsService(pushgatewayUrl: "http://pushgateway", out var factory, handler);

        Assert.Null(handler.LastRequest);
        factory.Verify(f => f.CreateClient(It.IsAny<string>()), Times.Never);
    }

    [Fact]
    public async Task JobListener_IgnoresUnmonitoredJobs() {
        var handler = new CapturePushgatewayHandler();
        var service = CreateMetricsService(pushgatewayUrl: "http://pushgateway", out _, handler);
        var listener = new CronJobMetricsJobListener(service);
        var context = CreateJobContext("NotARealJob", jobRunTime: TimeSpan.FromSeconds(2));

        await listener.JobWasExecuted(context, jobException: null);

        Assert.Null(handler.LastRequest);
    }

    [Fact]
    public async Task JobListener_RecordsSuccessDurationAndItemFailures() {
        var handler = new CapturePushgatewayHandler();
        var service = CreateMetricsService(pushgatewayUrl: "http://pushgateway", out _, handler);
        var listener = new CronJobMetricsJobListener(service);
        var context = CreateJobContext(nameof(EmailForwarderExportRunner), jobRunTime: TimeSpan.FromSeconds(2.5));

        using (var failures = context.TrackItemFailures()) {
            failures.RecordFailure();
        }

        var waitTask = handler.WaitForRequestAsync();
        await listener.JobWasExecuted(context, jobException: null);
        await waitTask;

        Assert.Contains("cron_job_last_success{environment=\"testing\"} 1", handler.LastBody);
        Assert.Contains("cron_job_duration_seconds{environment=\"testing\"} 2.5", handler.LastBody);
        Assert.Contains("cron_job_items_failed_total{environment=\"testing\"} 1", handler.LastBody);
    }

    [Fact]
    public async Task JobListener_RecordsFailureWhenJobThrows() {
        var handler = new CapturePushgatewayHandler();
        var service = CreateMetricsService(pushgatewayUrl: "http://pushgateway", out _, handler);
        var listener = new CronJobMetricsJobListener(service);
        var context = CreateJobContext(nameof(EmailForwarderExportRunner), jobRunTime: TimeSpan.FromSeconds(0.5));
        var jobException = new JobExecutionException(new InvalidOperationException("boom"));

        var waitTask = handler.WaitForRequestAsync();
        await listener.JobWasExecuted(context, jobException);
        await waitTask;
        Assert.Contains("cron_job_last_success{environment=\"testing\"} 0", handler.LastBody);
        Assert.Contains("cron_job_duration_seconds{environment=\"testing\"} 0.5", handler.LastBody);
        Assert.Contains("cron_job_items_failed_total{environment=\"testing\"} 0", handler.LastBody);
    }

    private static CronJobMetricsService CreateMetricsService(
        string? pushgatewayUrl,
        out Mock<IHttpClientFactory> httpClientFactory,
        CapturePushgatewayHandler? handler = null) {
        handler ??= new CapturePushgatewayHandler();
        httpClientFactory = new Mock<IHttpClientFactory>();
        httpClientFactory
            .Setup(f => f.CreateClient(CronJobMetricsService.HttpClientName))
            .Returns(() => new HttpClient(handler));

        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?> {
                ["PUSHGATEWAY_URL"] = pushgatewayUrl,
            })
            .Build();

        var hostEnvironment = new Mock<IHostEnvironment>();
        hostEnvironment.Setup(e => e.EnvironmentName).Returns("Testing");

        return new CronJobMetricsService(
            configuration,
            hostEnvironment.Object,
            httpClientFactory.Object,
            NullLogger<CronJobMetricsService>.Instance);
    }

    private static IJobExecutionContext CreateJobContext(string jobName, TimeSpan? jobRunTime = null) {
        var context = new Mock<IJobExecutionContext>();
        object? result = null;

        context.Setup(c => c.JobDetail.Key).Returns(new JobKey(jobName));
        context.Setup(c => c.JobRunTime).Returns(jobRunTime ?? TimeSpan.Zero);
        context.SetupSet(c => c.Result = It.IsAny<object>()).Callback<object>(value => result = value);
        context.SetupGet(c => c.Result).Returns(() => result);

        return context.Object;
    }

    private sealed class CapturePushgatewayHandler : HttpMessageHandler {
        private readonly Queue<TaskCompletionSource> _requestWaiters = new();

        public HttpRequestMessage? LastRequest { get; private set; }
        public string? LastBody { get; private set; }

        public Task WaitForRequestAsync(TimeSpan? timeout = null) {
            var waiter = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
            lock (_requestWaiters) {
                _requestWaiters.Enqueue(waiter);
            }

            return timeout is null
                ? waiter.Task
                : waiter.Task.WaitAsync(timeout.Value);
        }

        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken) {
            LastRequest = request;
            LastBody = request.Content is null
                ? null
                : await request.Content.ReadAsStringAsync(cancellationToken);

            TaskCompletionSource? waiter;
            lock (_requestWaiters) {
                waiter = _requestWaiters.Count > 0 ? _requestWaiters.Dequeue() : null;
            }

            waiter?.TrySetResult();

            return new HttpResponseMessage(HttpStatusCode.OK);
        }
    }
}
