using System.Text.Json.Nodes;
using API.Features.Auth;
using API.Features.Prozess;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Quartz;

namespace API.Features.GovManager;

/// <summary>Job zur Verarbeitung und Fortsetzung von GovManager-Anfragen im Prozessablauf.</summary>
[DisallowConcurrentExecution]
public class GovManagerRequestRunner : IJob {
    private readonly IDbContextFactory<DomainContext> _dbContextFactory;
    private readonly WalkerFactory _walkerFactory;

    /// <summary>Initialisiert den Runner mit Datenbankkontextfabrik und WalkerFactory.</summary>
    public GovManagerRequestRunner(IDbContextFactory<DomainContext> dbContextFactory, WalkerFactory walkerFactory) {
        _dbContextFactory = dbContextFactory;
        _walkerFactory = walkerFactory;
    }

    /// <summary>Führt den Job aus und verarbeitet alle relevanten GovManager-Anfragen.</summary>
    /// <param name="context">Kontext der Jobausführung.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        var db = await _dbContextFactory.CreateDbContextAsync(context.CancellationToken);

        var govManagerRequests = await db.GovManagerRequests
            .AsSingleQuery()
            .Where(r => r.Success == true)
            .Where(r => (r.Ausfuehrung.Bearbeitungen.Count == 0 &&
                         (r.Ausfuehrung.ProzessVersion.Start is GovManagerRestExportSchritt ||
                          r.Ausfuehrung.ProzessVersion.Start is WarteAufGovManagerSchritt)) ||
                        r.Ausfuehrung.Bearbeitungen.OrderByDescending(b => b.CreatedAt).First().NextVerbindung.Nach is
                            GovManagerRestExportSchritt ||
                        r.Ausfuehrung.Bearbeitungen.OrderByDescending(b => b.CreatedAt).First().NextVerbindung.Nach is
                            WarteAufGovManagerSchritt)
            .Select(r => new { GovManagerRequest = r, AusfuehrungId = r.Ausfuehrung.Id })
            .ToListAsync(context.CancellationToken);

        await db.DisposeAsync();

        foreach (var record in govManagerRequests) {
            try {
                var walker = await _walkerFactory.ContinueAusfuehrung(record.AusfuehrungId);
                var currentSchritt = walker.CurrentSchritt;

                if (currentSchritt is GovManagerRestExportSchritt govManagerRestExport &&
                    govManagerRestExport.Id == record.GovManagerRequest.GovManagerSchrittId) {
                    await ContinueAusfuehrung(walker, record.GovManagerRequest);
                }

                if (currentSchritt is WarteAufGovManagerSchritt warteAufGovManager &&
                    warteAufGovManager.GovManagerSchrittId == record.GovManagerRequest.GovManagerSchrittId) {
                    await ContinueAusfuehrung(walker, record.GovManagerRequest);
                }
            } catch (Exception) {
                failures.RecordFailure();
            }
        }
    }

    /// <summary>Setzt die Ausführung im Prozess basierend auf dem Ergebnis der GovManager-Anfrage fort.</summary>
    /// <param name="walker">Der Prozess-Walker zur Steuerung der Ausführung.</param>
    /// <param name="govManagerRequest">Die GovManager-Anfrage mit Ergebnisdaten.</param>
    private async Task ContinueAusfuehrung(Walker walker, GovManagerRequest govManagerRequest) {
        var verbindung = walker.CurrentVerbindungen.First(v => v.Name == (govManagerRequest.Success == true ? "Erfolgreich" : "Nicht Erfolgreich"));
        walker.Step(SystemUser.UserId, verbindung.Id, new List<SlotValuesInput> {
            new("govmanager-body", JsonValue.Create(govManagerRequest.ResponseBody)!),
        }, null);
        await walker.SaveChangesAsync();
    }
}

/// <summary>Erweiterungsmethoden zur Registrierung des GovManagerRequestRunner im DI-Container.</summary>
public static class GovManagerRequestRunnerExtensions {
    /// <summary>Registriert den GovManagerRequestRunner mit einem Zeitplan im DI-Container.</summary>
    /// <param name="services">Die Service-Sammlung zur Erweiterung.</param>
    /// <returns>Die erweiterte Service-Sammlung.</returns>
    public static IServiceCollection AddGovManagerRequestRunner(this IServiceCollection services) {
        const string everyTenSeconds = "0/10 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<GovManagerRequestRunner>(everyTenSeconds, fireImmediate: true));

        return services;
    }
}
