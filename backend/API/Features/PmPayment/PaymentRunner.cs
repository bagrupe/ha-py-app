using System.Text.Json.Nodes;
using API.Features.Auth;
using API.Features.Prozess;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Quartz;

namespace API.Features.PmPayment;

/// <summary>Job zur Verarbeitung abgeschlossener Zahlungsanforderungen und Fortführung der zugehörigen Ausführungen.</summary>
[DisallowConcurrentExecution]
public class PaymentRunner : IJob {
    private readonly IDbContextFactory<DomainContext> _dbContextFactory;
    private readonly WalkerFactory _walkerFactory;

    /// <summary>Initialisiert eine neue Instanz des PaymentRunner mit den benötigten Fabriken.</summary>
    /// <param name="dbContextFactory">Fabrik zur Erzeugung von Datenbankkontexten.</param>
    /// <param name="walkerFactory">Fabrik zur Erzeugung von Walker-Instanzen für Prozessausführungen.</param>
    public PaymentRunner(
        IDbContextFactory<DomainContext> dbContextFactory,
        WalkerFactory walkerFactory
    ) {
        _dbContextFactory = dbContextFactory;
        _walkerFactory = walkerFactory;
    }

    /// <summary>Führt den Job aus, indem abgeschlossene Zahlungsanforderungen geladen und die zugehörigen Ausführungen fortgesetzt werden.</summary>
    /// <param name="context">Kontext des Jobausführungszeitpunkts.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        var db = await _dbContextFactory.CreateDbContextAsync(context.CancellationToken);
        var paymentRequests = await db.PaymentRequests
            .AsSingleQuery()
            .Where(pr => pr.Success == true)
            .Where(pr =>
                (pr.Ausfuehrung.Bearbeitungen.Count == 0 &&
                 (pr.Ausfuehrung.ProzessVersion.Start is BezahlenSchritt ||
                  pr.Ausfuehrung.ProzessVersion.Start is WarteAufBezahlungAbgeschlossenSchritt)) ||
                pr.Ausfuehrung.Bearbeitungen.OrderByDescending(b => b.CreatedAt).First().NextVerbindung.Nach is
                    BezahlenSchritt ||
                pr.Ausfuehrung.Bearbeitungen.OrderByDescending(b => b.CreatedAt).First().NextVerbindung.Nach is
                    WarteAufBezahlungAbgeschlossenSchritt)
            .Select(pr => new { PaymentRequest = pr, AusfuehrungId = pr.Ausfuehrung.Id })
            .ToListAsync();
        await db.DisposeAsync();

        foreach (var record in paymentRequests) {
            try {
                var walker = await _walkerFactory.ContinueAusfuehrung(record.AusfuehrungId);

                var currentSchritt = walker.CurrentSchritt;

                if (currentSchritt is BezahlenSchritt bezahlenSchritt &&
                    bezahlenSchritt.Id == record.PaymentRequest.BezahlenSchrittId) {
                    await ContinueAusfuehrung(walker, record.PaymentRequest);
                }

                if (currentSchritt is WarteAufBezahlungAbgeschlossenSchritt warteAufBezahlung &&
                    warteAufBezahlung.BezahlenSchrittId == record.PaymentRequest.BezahlenSchrittId) {
                    await ContinueAusfuehrung(walker, record.PaymentRequest);
                }
            } catch (Exception) {
                failures.RecordFailure();
            }
        }
    }

    /// <summary>Setzt die Ausführung basierend auf dem Ergebnis der Zahlungsanforderung fort.</summary>
    /// <param name="walker">Der Walker zur Steuerung der Ausführung.</param>
    /// <param name="paymentRequest">Die verarbeitete Zahlungsanforderung.</param>
    private async Task ContinueAusfuehrung(Walker walker, PaymentRequest paymentRequest) {
        var verbindung = walker.CurrentVerbindungen.First(v => v.Name == (paymentRequest.Success == true ? "Erfolgreich" : "Nicht Erfolgreich"));
        walker.Step(SystemUser.UserId, verbindung.Id, new List<SlotValuesInput> {
            new("txId", JsonValue.Create(paymentRequest.Id)),
            new("paymentMethod", JsonValue.Create(paymentRequest.PaymentMethod)!),
        }, null);
        await walker.SaveChangesAsync();
    }
}

/// <summary>Ermöglicht das Hinzufügen des PaymentRunner-Jobs zur Dienstkonfiguration mit einem festen Zeitplan.</summary>
public static class PaymentRunnerServiceExtensions {
    /// <summary>Registriert den PaymentRunner-Job, der alle zehn Sekunden ausgeführt wird.</summary>
    /// <param name="services">Die Dienstesammlung zur Erweiterung.</param>
    /// <returns>Die erweiterte Dienstesammlung.</returns>
    public static IServiceCollection AddPaymentRunner(this IServiceCollection services) {
        const string everyTenSeconds = "0/10 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<PaymentRunner>(everyTenSeconds, fireImmediate: true));

        return services;
    }
}
