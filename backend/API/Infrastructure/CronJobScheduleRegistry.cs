using System.Collections.Concurrent;

namespace API.Infrastructure;

/// <summary>Stores expected cron intervals registered at startup for cron job metrics.</summary>
public static class CronJobScheduleRegistry {
    private static readonly ConcurrentDictionary<string, int> IntervalSecondsByJob = new(StringComparer.Ordinal);

    public static void Register(string jobName, string cronExpression) {
        if (string.IsNullOrWhiteSpace(cronExpression)) {
            return;
        }

        var intervalSeconds = QuartzCronScheduleParser.TryParseIntervalSeconds(cronExpression);
        if (intervalSeconds is not null) {
            IntervalSecondsByJob[jobName] = intervalSeconds.Value;
        }
    }

    public static int? GetIntervalSeconds(string jobName) =>
        IntervalSecondsByJob.TryGetValue(jobName, out var intervalSeconds) ? intervalSeconds : null;

    public static IReadOnlyCollection<KeyValuePair<string, int>> GetAll() =>
        IntervalSecondsByJob.ToArray();

    internal static void ResetForTesting() => IntervalSecondsByJob.Clear();
}
