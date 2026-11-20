using API.Features;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Seeders.Base;
using API.Seeders.Prozesse.BildungUndTeilhabeLeistungen;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Seeders.Prozesse;

/// <summary>Delegate zur Erstellung eines Prozesses mit Schritten, Verbindungen und Ausführungen.</summary>
/// <param name="prozessVersionId">Die ID der Prozessversion.</param>
/// <param name="kommuneSeed">Seed der Kommune zur Kontextbestimmung.</param>
/// <returns>Tuple mit Sammlungen von Schritten, Verbindungen und Ausführungen.</returns>
public delegate (ICollection<Schritt> schritte, ICollection<Verbindung> verbindungen, ICollection<Ausfuehrung> ausfuehrungen) CreateProzess(Guid prozessVersionId, KommuneSeed kommuneSeed);

/// <summary>Repräsentiert einen Prozess-Seed mit ID, Namen, Erstellfunktion und Beschreibungstext.</summary>
/// <param name="Id">Eindeutige Prozess-ID.</param>
/// <param name="Name">Name des Prozesses.</param>
/// <param name="CreateProzess">Funktion zur Erstellung des Prozesses.</param>
/// <param name="Beschreibungstext">Beschreibung des Prozesses als Ausdruck.</param>
public record ProzessSeed(Guid Id, string Name, CreateProzess CreateProzess, StringExpression Beschreibungstext);

/// <summary>Seeder-Klasse zum Anlegen und Verwalten von Prozessen in der Datenbank.</summary>
public class ProzesseSeeder : DataSeeder<DomainContext> {
    public override bool MustRunBeforeImports => false;

    /// <summary>Konstruktor mit Abhängigkeiten für Datenbankkontext, Logger und Validatoren.</summary>
    public ProzesseSeeder(IDbContextFactory<DomainContext> dbContextFactory, ILogger<ProzesseSeeder> logger, IEnumerable<IValidator> validators) : base(dbContextFactory, logger, validators) { }

    /// <summary>Führt das Seed-Verfahren aus und legt verschiedene Prozessgruppen und Prozesse an.</summary>
    /// <param name="cancellationToken">Token zur Abbruchsteuerung.</param>
    protected override async Task Run(CancellationToken cancellationToken = default) {
        var sozialeGruppeHaPy = new ProzessGroup { Id = new Guid(), Name = "Kinder, Familie, Soziales", KommuneId = KommuneSeeder.LandkreisHaPy.Id };
        var verkehrGruppeHaPy = new ProzessGroup { Id = new Guid(), Name = "Führerschein, Zulassung, Verkehr", KommuneId = KommuneSeeder.LandkreisHaPy.Id };

        await Seed(FuehrerscheinVerlaengern.ProzessSeed, KommuneSeeder.LandkreisHaPy, cancellationToken, null, verkehrGruppeHaPy);

        await Seed(BeispielProzess.ProzessSeed, KommuneSeeder.LandkreisHaPy, cancellationToken, null, verkehrGruppeHaPy);

        var maengelTags = new List<ProzessTag> { new() { Id = new Guid("099167d1-8a6a-4d30-838b-851b125c7fd2"), Tag = "Mängelmelder" } };
        await Seed(MaengelMelderProzess.ProzessSeed, KommuneSeeder.LandkreisHaPy, cancellationToken, maengelTags);

        await Seed(Erstantrag.ProzessSeed, KommuneSeeder.LandkreisHaPy, cancellationToken, null, sozialeGruppeHaPy);

        await Seed(Folgeantrag.ProzessSeed, KommuneSeeder.LandkreisHaPy, cancellationToken, null, sozialeGruppeHaPy);

        var feedbackTags = new List<ProzessTag> { new() { Id = new Guid("3e2ebb9a-6f29-49fb-8daf-e8a870131505"), Tag = "Feedback" } };
        await Seed(FeedbackProzess.ProzessSeed, KommuneSeeder.LandkreisHaPy, cancellationToken, feedbackTags);

        var ideenmelderTags = new List<ProzessTag> { new() { Id = new Guid("d9f4a2b3-5c6e-7f8a-9b0c-1d2e3f4a5b6c"), Tag = "Ideenmelder" } };
        await Seed(IdeenmelderProzess.ProzessSeed, KommuneSeeder.LandkreisHaPy, cancellationToken, ideenmelderTags);
    }

    /// <summary>Legt einen Prozess mit zugehörigen Daten in der Datenbank an.</summary>
    /// <param name="prozessSeed">Seed-Daten des Prozesses.</param>
    /// <param name="kommuneSeed">Seed der Kommune für Kontext.</param>
    /// <param name="cancellationToken">Token zur Abbruchsteuerung.</param>
    /// <param name="Tags">Optionale Liste von Prozess-Tags.</param>
    /// <param name="prozessGroup">Optionale Prozessgruppe.</param>
    private async Task Seed(ProzessSeed prozessSeed, KommuneSeed kommuneSeed,
        CancellationToken cancellationToken = default, List<ProzessTag>? Tags = null, ProzessGroup? prozessGroup = null) {
        var prozessId = DeriveId(prozessSeed.Id, kommuneSeed.Id);
        var prozessVersionId = DeriveId(prozessId, 0);

        var prozess = new Prozess { Id = prozessId, Name = prozessSeed.Name, KommuneId = kommuneSeed.Id, Tags = Tags ?? new List<ProzessTag>(), Group = prozessGroup ?? null };
        var (schritte, verbindungen, ausfuehrungen) = prozessSeed.CreateProzess(prozessVersionId, kommuneSeed);

        await Build(prozess).SeedAsync(cancellationToken);

        var version = new ProzessVersion {
            Id = prozessVersionId,
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2023, 1, 1, 12, 0),
            PublishedAt = Instant.FromUtc(2023, 1, 1, 12, 0),
            Schritte = schritte,
            Beschreibungstext = prozessSeed.Beschreibungstext
        };

        foreach (var schritt in schritte) {
            foreach (var verbindung in verbindungen.Where(v => v.Von == schritt)) {
                schritt.Verbindungen.Add(verbindung);
            }
        }

        await Build(version).OnCreateAsync(async p => {
            await SaveChangesAsync(cancellationToken);
            p.StartId = p.Schritte.First().Id;
            foreach (var verbindung in verbindungen) {
                await Build(verbindung).SeedAsync(cancellationToken);
            }
            foreach (var ausfuehrung in ausfuehrungen) {
                await Build(ausfuehrung).SeedAsync(cancellationToken);
            }
        }).SeedAsync(cancellationToken);
    }
}
