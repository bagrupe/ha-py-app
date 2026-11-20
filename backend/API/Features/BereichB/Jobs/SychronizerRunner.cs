using API.Features.Auth;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Quartz;

namespace API.Features.BereichB.Jobs;

/// <summary>
/// Führt Synchronisationsaufgaben für Untereinheiten und Backoffice-Nutzer aus.
/// </summary>
[DisallowConcurrentExecution]
public class SynchronizerRunner(
    IDbContextFactory<DomainContext> dbContextFactory,
    UntereinheitenSynchronizer untereinheitenSynchronizer,
    BackofficeUserSynchronizer backofficeUserSynchronizer,
    BackoffService backoff)
    : IJob {

    /// <summary>
    /// Startet die Ausführung der Synchronisationsaufgaben.
    /// </summary>
    /// <param name="context">Der Kontext des aktuellen Jobs.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await SynchronizeUntereinheiten(failures);
        await SynchronizeBackofficeUser(failures);
    }

    /// <summary>
    /// Synchronisiert Untereinheiten, die noch nicht mit Bereich B abgeglichen wurden.
    /// </summary>
    private async Task SynchronizeUntereinheiten(CronJobItemFailures failures) {
        await using var db = await dbContextFactory.CreateDbContextAsync();
        var recordsToUpdate = db.Untereinheit.AsTracking().Where(ue => !ue.IsSyncedToBereichB);

        foreach (var untereinheit in recordsToUpdate) {
            if (!backoff.AllowedWithBackoff(untereinheit.Id)) continue;

            var success = await untereinheitenSynchronizer.Synchronize(untereinheit.Id);
            backoff.RecordResult(untereinheit.Id, success);
            if (!success) {
                failures.RecordFailure();
            }
        }
    }

    /// <summary>
    /// Synchronisiert Backoffice-Nutzer, die noch nicht mit Bereich B abgeglichen wurden.
    /// </summary>
    private async Task SynchronizeBackofficeUser(CronJobItemFailures failures) {
        await using var db = await dbContextFactory.CreateDbContextAsync();
        var recordsToUpdate = db.BackofficeUser.AsTracking().Where(user => !user.IsSyncedToBereichB);

        foreach (var backofficeUser in recordsToUpdate) {
            if (!backoff.AllowedWithBackoff(backofficeUser.Id)) continue;

            var success = await backofficeUserSynchronizer.Synchronize(backofficeUser.Id);
            backoff.RecordResult(backofficeUser.Id, success);
            if (!success) {
                failures.RecordFailure();
            }
        }
    }
}

/// <summary>
/// Erweiterungsmethoden für die Registrierung des SynchronizerRunner-Dienstes.
/// </summary>
public static class SynchronizerRunnerServiceExtensions {
    /// <summary>
    /// Registriert den SynchronizerRunner-Dienst mit einer Ausführungsfrequenz von einer Minute.
    /// </summary>
    /// <param name="services">Die Service-Sammlung.</param>
    /// <returns>Die aktualisierte Service-Sammlung.</returns>
    public static IServiceCollection AddBereichBSynchronizerRunner(this IServiceCollection services) {
        const string everyMinute = "0 */1 * ? * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<SynchronizerRunner>(everyMinute, fireImmediate: true));

        return services;
    }
}
