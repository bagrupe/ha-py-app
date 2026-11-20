using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using Quartz;

namespace API.Features.Aufbewahrung.Jobs;

/// <summary>
/// Löscht soft-gelöschte Anträge endgültig, sobald die konfigurierte Karenzzeit abgelaufen ist.
/// Läuft nur, wenn <see cref="AufbewahrungsEinstellungen.HardDeleteAktiv"/> = true.
/// Entfernt Bearbeitungen + SlotValues (verschlüsselte Inhalte) und die Ausführung selbst –
/// damit verschwinden auch die zur Entschlüsselung nötigen Schlüssel (Crypto-Shredding).
/// </summary>
[DisallowConcurrentExecution]
public class AntragHardDeleteJob(
    IDbContextFactory<DomainContext> dbContextFactory,
    IClock clock,
    ILogger<AntragHardDeleteJob> logger
) : IJob {
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await using var db = await dbContextFactory.CreateDbContextAsync();

        var settings = await db.AufbewahrungsEinstellungen.AsNoTracking()
            .FirstOrDefaultAsync(e => e.Id == AufbewahrungsEinstellungen.SingletonId);
        if (settings is null || !settings.HardDeleteAktiv) {
            return;
        }

        var cutoff = clock.GetCurrentInstant() - Duration.FromMinutes(settings.HardDeleteVerzoegerungMinuten);

        var faellige = await db.Ausfuehrungen.AsTracking()
            .AsSplitQuery() // verhindert MultipleCollectionIncludeWarning (Bearbeitungen + SlotValues)
            .Where(a => a.GeloeschtAm != null && a.GeloeschtAm <= cutoff)
            .Include(a => a.Bearbeitungen).ThenInclude(b => b.SlotValues)
            .OrderBy(a => a.GeloeschtAm)
            .Take(100) // in Batches arbeiten
            .ToListAsync();

        foreach (var ausfuehrung in faellige) {
            await using var transaction = await db.Database.BeginTransactionAsync();
            try {
                foreach (var bearbeitung in ausfuehrung.Bearbeitungen) {
                    db.SlotValues.RemoveRange(bearbeitung.SlotValues);
                }

                db.Bearbeitungen.RemoveRange(ausfuehrung.Bearbeitungen);

                // HINWEIS (Testverifikation): Sollten weitere abhängige Datensätze mit
                // restriktivem FK existieren (z.B. PaymentRequest, GovManagerRequest), hier
                // explizit entfernen, falls SaveChanges eine FK-Verletzung wirft.
                await db.SaveChangesAsync();

                // Zwischen der Auswahl oben und hier kann der Antrag per AntragWiederherstellen
                // wiederhergestellt worden sein. Ein schlüsselbasiertes Remove() würde ihn dann
                // trotzdem löschen (Datenverlust nach erfolgreicher Wiederherstellung) - deshalb
                // hier atomar gegen den aktuellen DB-Zustand prüfen statt gegen die oben geladene,
                // ggf. veraltete Instanz. Blockiert kurz auf dem Zeilen-Lock, falls eine
                // Wiederherstellung parallel gerade läuft, und respektiert danach deren Ergebnis.
                var geloescht = await db.Ausfuehrungen
                    .Where(a => a.Id == ausfuehrung.Id && a.GeloeschtAm != null && a.GeloeschtAm <= cutoff)
                    .ExecuteDeleteAsync();

                if (geloescht == 0) {
                    await transaction.RollbackAsync();
                    logger.LogInformation(
                        "Antrag {Id} zwischenzeitlich wiederhergestellt oder nicht mehr fällig - endgültige Löschung übersprungen.",
                        ausfuehrung.Id);
                    db.ChangeTracker.Clear();
                    continue;
                }

                // Audit NACH der bestätigten Löschung (überlebt, da kein FK auf die Ausführung).
                db.AntragLoeschProtokolle.Add(new AntragLoeschProtokoll {
                    AusfuehrungId = ausfuehrung.Id,
                    Ereignis = AntragLoeschEreignis.EndgueltigGeloescht,
                    Grund = ausfuehrung.Loeschgrund,
                    Zeitpunkt = clock.GetCurrentInstant(),
                });
                await db.SaveChangesAsync();
                await transaction.CommitAsync();
                db.ChangeTracker.Clear();
                logger.LogInformation("Antrag {Id} endgültig gelöscht (Crypto-Shredding).", ausfuehrung.Id);
            } catch (Exception e) {
                failures.RecordFailure();
                await transaction.RollbackAsync();
                logger.LogError(e, "Endgültige Löschung von Antrag {Id} fehlgeschlagen.", ausfuehrung.Id);
                db.ChangeTracker.Clear();
            }
        }
    }
}

/// <summary>Registriert den AntragHardDeleteJob (Standard: alle 5 Minuten, nicht sofort).</summary>
public static class AntragHardDeleteJobExtension {
    public static IServiceCollection AddAntragHardDeleteJob(this IServiceCollection services) {
        // Jede Minute prüfen. Der Job steigt sofort aus, wenn HardDeleteAktiv == false,
        // ist also auch produktiv unbedenklich. Cadence bei Bedarf hier anpassen.
        const string everyMinute = "0 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<AntragHardDeleteJob>(everyMinute, fireImmediate: false));

        return services;
    }
}
