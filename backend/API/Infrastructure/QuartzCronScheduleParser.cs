using System.Text.RegularExpressions;

namespace API.Infrastructure;

/// <summary>Parses Quartz cron expressions used in this project into an expected interval.</summary>
internal static partial class QuartzCronScheduleParser {
    private static readonly Regex SecondsStepPattern = SecondsStepRegex();
    private static readonly Regex MinutesStepPattern = MinutesStepRegex();

    /// <summary>
    /// Returns the expected interval in seconds for simple periodic schedules, or null if unknown.
    /// Supports the cron patterns used by backend Quartz jobs (e.g. every N seconds/minutes, hourly at :00).
    /// </summary>
    public static int? TryParseIntervalSeconds(string cronExpression) {
        var parts = cronExpression.Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length < 6) {
            return null;
        }

        var secondsMatch = SecondsStepPattern.Match(parts[0]);
        if (secondsMatch.Success && int.TryParse(secondsMatch.Groups[1].Value, out var secondInterval)) {
            return secondInterval;
        }

        var minutesMatch = MinutesStepPattern.Match(parts[1]);
        if (parts[0] == "0" && minutesMatch.Success && int.TryParse(minutesMatch.Groups[1].Value, out var minuteInterval)) {
            return minuteInterval * 60;
        }

        if (parts[0] == "0" && parts[1] == "*" && parts[2] == "*") {
            return 60;
        }

        if (parts[0] == "0" && parts[1] == "0" && parts[2] == "*") {
            return 3600;
        }

        return null;
    }

    [GeneratedRegex(@"^0/(\d+)$")]
    private static partial Regex SecondsStepRegex();

    [GeneratedRegex(@"^\*/(\d+)$")]
    private static partial Regex MinutesStepRegex();
}
