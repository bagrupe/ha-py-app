using API.Features.Email;
using API.Features.Expressions;
using API.Infrastructure;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NodaTime;

namespace API.Features.Prozess;

/// <summary>Fabrik zur Erzeugung und Fortsetzung von Walker-Instanzen für Prozessausführungen.</summary>
public class WalkerFactory(
    IClock clock,
    IDbContextFactory<DomainContext> domainContextFactory,
    EvaluatingVisitorService evaluatingVisitorService,
    EmailService emailService,
    WebOptions webOptions,
    ILogger<Walker> logger) {
    /// <summary>Startet eine neue Ausführung eines Prozesses anhand der Prozessversions-ID und der Ausführung.</summary>
    /// <param name="prozessVersionId">ID der Prozessversion, die gestartet werden soll.</param>
    /// <param name="ausfuehrung">Die neue Ausführung, die gestartet wird.</param>
    /// <returns>Ein Walker zur Steuerung der Ausführung.</returns>
    public async Task<Walker> StartNewAusfuehrung(Guid prozessVersionId, Ausfuehrung ausfuehrung) {
        var domainContext = await domainContextFactory.CreateDbContextAsync();
        var prozessVersion = await GetProzessVersion(domainContext, prozessVersionId);
        if (prozessVersion.Prozess.DeaktiviertAm != null) {
            throw new ProzessDeaktiviertException();
        }
        return BuildWalker(domainContext, prozessVersion, ausfuehrung);
    }

    /// <summary>Baut einen Walker zur reinen Vorschau des Ablaufs, ohne die Prozess-Deaktivierung zu prüfen.</summary>
    public async Task<Walker> PreviewWalker(Guid prozessVersionId, Ausfuehrung ausfuehrung) {
        var domainContext = await domainContextFactory.CreateDbContextAsync();
        var prozessVersion = await GetProzessVersion(domainContext, prozessVersionId);
        return BuildWalker(domainContext, prozessVersion, ausfuehrung);
    }

    private Walker BuildWalker(DomainContext domainContext, ProzessVersion prozessVersion, Ausfuehrung ausfuehrung) {
        if (prozessVersion.StartId == null) {
            throw new InvalidOperationException("StartId is null");
        }
        ausfuehrung.SchrittId = prozessVersion.StartId.Value;
        domainContext.Add(ausfuehrung);
        return new Walker(clock, domainContext, prozessVersion, ausfuehrung,
            evaluatingVisitorService, emailService, webOptions, logger);
    }

    /// <summary>Setzt eine bestehende Ausführung anhand ihrer ID fort.</summary>
    /// <param name="ausfuehrungId">ID der fortzusetzen Ausführung.</param>
    /// <returns>Ein Walker zur Steuerung der fortgesetzten Ausführung.</returns>
    public async Task<Walker> ContinueAusfuehrung(Guid ausfuehrungId) {
        var domainContext = await domainContextFactory.CreateDbContextAsync();

        var ausfuehrung = await domainContext.Ausfuehrungen
                              .AsTracking()
                              .AsSingleQuery()
                              .Include(a => a.Bearbeitungen
                                  .OrderBy(b => b.CreatedAt))
                              .ThenInclude(b => b.Schritt)
                              .Include(a => a.Bearbeitungen
                                  .OrderBy(b => b.CreatedAt))
                              .ThenInclude(b => b.SlotValues)
                              .FirstOrDefaultAsync(a => a.Id == ausfuehrungId) ??
                          throw new ArgumentException($"Ausfuehrung {ausfuehrungId} not found");

        return new Walker(clock, domainContext, await GetProzessVersion(domainContext, ausfuehrung.ProzessVersionId),
            ausfuehrung, evaluatingVisitorService, emailService, webOptions, logger);
    }

    /// <summary>Liefert alle Walker für Ausführungen, die sich aktuell in einem bestimmten Schritt befinden.</summary>
    /// <typeparam name="TStep">Typ des Schritts, für den die Ausführungen ermittelt werden.</typeparam>
    /// <returns>Asynchrone Aufzählung von Walkern für die passenden Ausführungen.</returns>
    public async IAsyncEnumerable<Walker> GetWalkerForCurrentStep<TStep>() {
        List<Guid> ausfuehrungIdsCurrentlyAtSchritt;

        await using (var domainContext = await domainContextFactory.CreateDbContextAsync()) {
            ausfuehrungIdsCurrentlyAtSchritt = await domainContext.Ausfuehrungen
                .AsSingleQuery()
                .Where(a => (a.Bearbeitungen.Count == 0 && a.ProzessVersion.Start is TStep) ||
                            a.Bearbeitungen.OrderByDescending(b => b.CreatedAt).First().NextVerbindung.Nach is TStep)
                .Select(a => a.Id)
                .ToListAsync();
        }

        foreach (var ausfuehrungId in ausfuehrungIdsCurrentlyAtSchritt) {
            await using var walker = await ContinueAusfuehrung(ausfuehrungId);
            yield return walker;
        }
    }

    /// <summary>Lädt eine Prozessversion mit allen relevanten Daten anhand der ID.</summary>
    /// <param name="domainContext">Datenbankkontext für die Abfrage.</param>
    /// <param name="prozessVersionId">ID der zu ladenden Prozessversion.</param>
    /// <returns>Die geladene Prozessversion.</returns>
    private async Task<ProzessVersion> GetProzessVersion(DomainContext domainContext, Guid prozessVersionId) {
        return await domainContext.ProzessVersionen
                   .AsSingleQuery()
                   .Include(pv => pv.Schritte)
                   .ThenInclude(s => s.SollZustaendigkeit)
                   .ThenInclude(a => a!.MitarbeiterGruppe)
                   .Include(pv => pv.Schritte)
                   .ThenInclude(a => a!.SchreibtRolle)
                   .Include(pv => pv.Schritte)
                   .ThenInclude(s => s.Verbindungen)
                   .Include(pv => pv.Prozess.Tags)
                   .Include(pv => pv.Prozess.TagHistorie)
                   .ThenInclude(h => h.Tag)
                   .FirstOrDefaultAsync(pv => pv.Id == prozessVersionId) ??
               throw new ArgumentException($"ProzessVersion {prozessVersionId} not found");
    }
}

public class ProzessDeaktiviertException()
    : DomainException("Dieser Prozess ist aktuell deaktiviert und kann nicht gestartet werden.");
