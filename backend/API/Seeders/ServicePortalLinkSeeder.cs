using API.Features;
using API.Features.Prozess;
using API.Seeders.Base;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace API.Seeders;

/// <summary>Seeder-Klasse zum Anlegen von ServicePortalLinks in der Datenbank.</summary>
public class ServicePortalLinkSeeder(
    IDbContextFactory<DomainContext> dbContextFactory,
    ILogger<ServicePortalLinkSeeder> logger,
    IEnumerable<IValidator> validators)
    : DataSeeder<DomainContext>(dbContextFactory, logger, validators) {
    /// <summary>Gibt an, ob der Seeder vor Importen ausgeführt werden muss.</summary>
    public override bool MustRunBeforeImports => false;

    /// <summary>Führt den Seed-Prozess asynchron aus und legt ServicePortalLinks für Kommunen an.</summary>
    /// <param name="cancellationToken">Token zur Steuerung des Abbruchs.</param>
    protected override async Task Run(CancellationToken cancellationToken = default) {
        await Seed(ServicePortalLinks.ErsterwerbFuehrerschein, KommuneSeeder.LandkreisHaPy, cancellationToken);

        await Seed(ServicePortalLinks.AufenthaltsgewaehrungUkraine, KommuneSeeder.LandkreisHaPy, cancellationToken);
    }

    /// <summary>Seedet einen einzelnen ServicePortalLink basierend auf den übergebenen Seed-Daten und Kommune.</summary>
    /// <param name="leistungSeed">Seed-Daten des ServicePortalLinks.</param>
    /// <param name="kommuneSeed">Seed-Daten der Kommune.</param>
    /// <param name="ct">Abbruchtoken zur Steuerung der Ausführung.</param>
    private async Task Seed(ServicePortalLinkSeed leistungSeed, KommuneSeed kommuneSeed, CancellationToken ct = default) {
        var leistungId = DeriveId(leistungSeed.Id, kommuneSeed.Id);

        var serviceLink = new ServicePortalLink {
            Id = leistungId,
            Name = leistungSeed.Name,
            Url = leistungSeed.ServiceLink,
            KommuneId = kommuneSeed.Id
        };

        await Build(serviceLink).SeedAsync(ct);
    }
}

/// <summary>Repräsentiert die Seed-Daten eines ServicePortalLinks.</summary>
/// <param name="Id">Eindeutige Kennung des Links.</param>
/// <param name="Name">Name des Links.</param>
/// <param name="ServiceLink">URL des Serviceportals.</param>
public record ServicePortalLinkSeed(Guid Id, string Name, string ServiceLink);

/// <summary>Enthält vordefinierte ServicePortalLinkSeed-Instanzen für das Seeden.</summary>
public static class ServicePortalLinks {
    public static readonly ServicePortalLinkSeed AufenthaltsgewaehrungUkraine = new(
        new Guid("c75b39c0-f4b4-4599-b02c-6c44ab4ff32b"),
        "Aufenthaltsgewährung Ukraine",
        "https://www.digitale-verwaltung-as-a-service.de/dienste-demos/at-germany-for-ukraine.html#/"
    );

    public static readonly ServicePortalLinkSeed ErsterwerbFuehrerschein = new(
        new Guid("5d495899-a4df-4ac4-adce-ce24fc0380b0"),
        "Ersterwerb Führerschein",
        "https://portal-civ-efa-qs.ekom21.de/civ-efa-fsa-qs.public/start.html?oe=00.00.FS.03.LKHM&mode=cc&cc_key=Fahrerlaubnisantrag"
    );
}
