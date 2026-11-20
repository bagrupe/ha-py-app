using System.Text.Json;
using API.Features.Aufbewahrung.Archive;
using API.Features.Prozess;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using Quartz;

namespace API.Features.Aufbewahrung.Jobs;

/// <summary>
/// Verschiebt abgeschlossene Anträge nach Ablauf der konfigurierten Archivfrist in die
/// separate Archiv-Datenbank. Läuft nur, wenn
/// <see cref="AufbewahrungsEinstellungen.ArchivierungAktiv"/> = true.
/// Vorgehen je Antrag: ins Archiv schreiben (verifizieren) → dann aus der Live-DB entfernen.
/// Bricht das Entfernen ab, bleibt der Archiv-Eintrag bestehen und wird beim nächsten Lauf
/// nicht doppelt angelegt (Dedupe über Id).
/// </summary>
[DisallowConcurrentExecution]
public class AntragArchivierungJob(
    IDbContextFactory<DomainContext> dbContextFactory,
    IDbContextFactory<ArchiveContext> archiveContextFactory,
    IClock clock,
    ILogger<AntragArchivierungJob> logger
) : IJob {
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await using var db = await dbContextFactory.CreateDbContextAsync();

        var settings = await db.AufbewahrungsEinstellungen.AsNoTracking()
            .FirstOrDefaultAsync(e => e.Id == AufbewahrungsEinstellungen.SingletonId);
        if (settings is null || !settings.ArchivierungAktiv) {
            return;
        }

        var cutoff = clock.GetCurrentInstant() - Duration.FromMinutes(settings.ArchivVerzoegerungMinuten);

        var faellige = await db.Ausfuehrungen.AsTracking()
            .AsSplitQuery() // verhindert MultipleCollectionIncludeWarning (Bearbeitungen + SlotValues)
            .Where(a => a.GeloeschtAm == null
                        && a.Status == AusfuehrungStatus.Abgeschlossen
                        && a.AbgeschlossenAm != null
                        && a.AbgeschlossenAm <= cutoff)
            .Include(a => a.ProzessVersion).ThenInclude(pv => pv.Prozess)
            .Include(a => a.Bearbeitungen).ThenInclude(b => b.SlotValues)
            .OrderBy(a => a.AbgeschlossenAm)
            .Take(50)
            .ToListAsync();

        foreach (var ausfuehrung in faellige) {
            try {
                var now = clock.GetCurrentInstant();
                var kommuneId = ausfuehrung.ProzessVersion.Prozess.KommuneId;

                // Ausfuehrung hat keine inversen Collection-Navigations für diese drei Typen
                // (VerlaufsEintragConfig nutzt WithMany() ohne Property) - einzeln laden, damit
                // sie mit ins Archiv wandern. Alle drei hängen per Cascade-Delete an der
                // Ausfuehrung und gehen beim Entfernen aus der Live-DB sonst verloren.
                var verlaufsEintraege = await db.VerlaufsEintraege.AsNoTracking()
                    .Where(v => v.AusfuehrungId == ausfuehrung.Id).ToListAsync();
                var paymentRequests = await db.PaymentRequests.AsNoTracking()
                    .Where(p => p.AusfuehrungId == ausfuehrung.Id).ToListAsync();
                var govManagerRequests = await db.GovManagerRequests.AsNoTracking()
                    .Where(g => g.AusfuehrungId == ausfuehrung.Id).ToListAsync();

                // 1) Ins Archiv schreiben (idempotent über Id)
                await using (var archive = await archiveContextFactory.CreateDbContextAsync()) {
                    var alreadyArchived = await archive.ArchivierteAntraege.AsNoTracking()
                        .AnyAsync(x => x.Id == ausfuehrung.Id);
                    if (!alreadyArchived) {
                        archive.ArchivierteAntraege.Add(new ArchivierterAntrag {
                            Id = ausfuehrung.Id,
                            KommuneId = kommuneId,
                            ProzessVersionId = ausfuehrung.ProzessVersionId,
                            ProzessBezeichnung = ausfuehrung.ProzessVersion.Prozess.Name,
                            Status = ausfuehrung.Status,
                            CreatedAt = ausfuehrung.CreatedAt,
                            AbgeschlossenAm = ausfuehrung.AbgeschlossenAm,
                            ArchiviertAm = now,
                            // Zuständigkeit mitspeichern, damit die Archiv-Sichtbarkeit der Live-Liste entspricht.
                            ZustaendigkeitArt = ausfuehrung.IstZustaendigkeit.Art,
                            ZustaendigkeitOrganisationseinheitId = ausfuehrung.IstZustaendigkeit.OrganisationseinheitId,
                            ZustaendigkeitMitarbeiterGruppeId = ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId,
                            ZustaendigkeitZugewiesenePersonId = ausfuehrung.IstZustaendigkeit.ZugewiesenePersonId,
                            ZustaendigkeitDienstleisterId = ausfuehrung.IstZustaendigkeit.DienstleisterId,
                            SharedKeyEncryptedForKommune = ausfuehrung.SharedKeyEncryptedForKommune,
                            Inhalt = JsonSerializer.SerializeToDocument(AntragArchivDto.From(
                                ausfuehrung, verlaufsEintraege, paymentRequests, govManagerRequests)),
                        });
                        await archive.SaveChangesAsync();
                    }
                }

                // 2) Aus der Live-DB entfernen
                foreach (var bearbeitung in ausfuehrung.Bearbeitungen) {
                    db.SlotValues.RemoveRange(bearbeitung.SlotValues);
                }

                db.Bearbeitungen.RemoveRange(ausfuehrung.Bearbeitungen);

                db.AntragLoeschProtokolle.Add(new AntragLoeschProtokoll {
                    AusfuehrungId = ausfuehrung.Id,
                    KommuneId = kommuneId,
                    Ereignis = AntragLoeschEreignis.Archiviert,
                    Zeitpunkt = now,
                });

                db.Ausfuehrungen.Remove(ausfuehrung);
                await db.SaveChangesAsync();
                logger.LogInformation("Antrag {Id} archiviert und aus Live-DB entfernt.", ausfuehrung.Id);
            } catch (Exception e) {
                failures.RecordFailure();
                logger.LogError(e, "Archivierung von Antrag {Id} fehlgeschlagen.", ausfuehrung.Id);
                db.ChangeTracker.Clear();
            }
        }
    }
}

/// <summary>Registriert den AntragArchivierungJob (Standard: stündlich, nicht sofort).</summary>
public static class AntragArchivierungJobExtension {
    public static IServiceCollection AddAntragArchivierungJob(this IServiceCollection services) {
        // Jede Minute prüfen. Der Job steigt sofort aus, wenn ArchivierungAktiv == false,
        // ist also auch produktiv unbedenklich. Cadence bei Bedarf hier anpassen.
        const string everyMinute = "0 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<AntragArchivierungJob>(everyMinute, fireImmediate: false));

        return services;
    }
}
