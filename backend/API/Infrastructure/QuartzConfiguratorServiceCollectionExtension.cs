using Quartz;

namespace API.Infrastructure;

/// <summary>Ermöglicht das Planen von Quartz-Jobs mit optionalem Cron-Trigger oder sofortiger Ausführung.</summary>
public static class QuartzConfiguratorServiceCollectionExtension {
    /// <summary>Plant einen Job vom Typ T mit optionalem Cron-Zeitplan und sofortiger Ausführung.</summary>
    /// <typeparam name="T">Der Jobtyp, der geplant wird.</typeparam>
    /// <param name="quartz">Der Quartz-Konfigurator.</param>
    /// <param name="cronSchedule">Der Cron-Ausdruck für die Zeitplanung.</param>
    /// <param name="fireImmediate">Gibt an, ob der Job sofort gestartet werden soll.</param>
    public static void ScheduleJob<T>(this IServiceCollectionQuartzConfigurator quartz, string cronSchedule = "",
        bool fireImmediate = false) where T : IJob {
        string jobName = typeof(T).Name;
        var jobKey = new JobKey(jobName);

        quartz.AddJob<T>(opts => opts.WithIdentity(jobKey));

        if (cronSchedule.Length > 0) {
            CronJobScheduleRegistry.Register(jobName, cronSchedule);
            quartz.AddTrigger(opts =>
                opts.ForJob(jobKey).WithIdentity($"{jobName}-trigger-cron").WithCronSchedule(cronSchedule));
        }

        if (fireImmediate) {
            quartz.AddTrigger(opts => opts.ForJob(jobKey).WithIdentity($"{jobName}-trigger-immediate").StartNow());
        }
    }

    /// <summary>Plant einen Job vom Typ T mit optionalem Cron-Zeitplan und sofortiger Ausführung.</summary>
    /// <typeparam name="T">Der Jobtyp, der geplant wird.</typeparam>
    /// <param name="quartz">Die Quartz-Optionen.</param>
    /// <param name="cronSchedule">Der Cron-Ausdruck für die Zeitplanung.</param>
    /// <param name="fireImmediate">Gibt an, ob der Job sofort gestartet werden soll.</param>
    public static void ScheduleJob<T>(this QuartzOptions quartz, string cronSchedule = "", bool fireImmediate = false)
        where T : IJob {
        string jobName = typeof(T).Name;
        var jobKey = new JobKey(jobName);

        quartz.AddJob<T>(opts => opts.WithIdentity(jobKey));

        if (cronSchedule.Length > 0) {
            CronJobScheduleRegistry.Register(jobName, cronSchedule);
            quartz.AddTrigger(opts =>
                opts.ForJob(jobKey).WithIdentity($"{jobName}-trigger-cron").WithCronSchedule(cronSchedule));
        }

        if (fireImmediate) {
            quartz.AddTrigger(opts => opts.ForJob(jobKey).WithIdentity($"{jobName}-trigger-immediate").StartNow());
        }
    }
}
