using Npgsql;
using Quartz;

namespace API.Infrastructure;

/// <summary>Hört auf Quartz-Jobs und startet den Dienst neu, wenn eine fehlende Tabelle erkannt wird.</summary>
public class QuartzRestartServiceOnMissingTableJobListener : IJobListener {
    /// <summary>Wird aufgerufen, bevor ein Job ausgeführt wird.</summary>
    /// <param name="context">Der Kontext des auszuführenden Jobs.</param>
    /// <param name="cancellationToken">Token zum Abbrechen der Ausführung.</param>
    /// <returns>Ein abgeschlossener Task.</returns>
    public Task JobToBeExecuted(IJobExecutionContext context, CancellationToken cancellationToken = default) {
        return Task.CompletedTask;
    }

    /// <summary>Wird aufgerufen, wenn die Ausführung eines Jobs verhindert wird.</summary>
    /// <param name="context">Der Kontext des verhinderten Jobs.</param>
    /// <param name="cancellationToken">Token zum Abbrechen der Ausführung.</param>
    /// <returns>Ein abgeschlossener Task.</returns>
    public Task JobExecutionVetoed(IJobExecutionContext context, CancellationToken cancellationToken = default) {
        return Task.CompletedTask;
    }

    /// <summary>Wird nach der Ausführung eines Jobs aufgerufen und prüft auf fehlende Datenbanktabellen.</summary>
    /// <param name="context">Der Kontext des ausgeführten Jobs.</param>
    /// <param name="jobException">Die Ausnahme, die während der Ausführung aufgetreten ist.</param>
    /// <param name="cancellationToken">Token zum Abbrechen der Ausführung.</param>
    /// <returns>Ein abgeschlossener Task.</returns>
    public Task JobWasExecuted(IJobExecutionContext context, JobExecutionException? jobException,
        CancellationToken cancellationToken = default) {

        if (jobException is { InnerException: SchedulerException { InnerException: PostgresException { SqlState: "42P01" } } }) {
            // Database is empty for some reason, let's restart and hope for the best
            Environment.Exit(9001);
        }

        return Task.CompletedTask;
    }

    /// <summary>Der Name des Job-Listeners.</summary>
    public string Name => "RestartServiceOnMissingTable";
}
