using Quartz;

namespace API.Infrastructure;

/// <summary>Tracks per-item failures during a Quartz job run for cron metrics.</summary>
public sealed class CronJobItemFailures : IDisposable {
    private readonly IJobExecutionContext _context;
    private int _count;

    internal CronJobItemFailures(IJobExecutionContext context) {
        _context = context;
    }

    public void RecordFailure() => _count++;

    public void RecordFailures(int count) {
        if (count > 0) {
            _count += count;
        }
    }

    public void Dispose() => _context.Result = _count;
}

/// <summary>Helpers for reporting item-level failures from Quartz cron jobs.</summary>
public static class CronJobExecutionMetrics {
    public static CronJobItemFailures TrackItemFailures(this IJobExecutionContext context) =>
        new(context);

    public static int GetItemFailureCount(this IJobExecutionContext context) =>
        context.Result switch {
            int count => count,
            _ => 0,
        };
}
