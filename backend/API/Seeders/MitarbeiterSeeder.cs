using API.Features;
using API.Features.Auth;
using API.Infrastructure;
using API.Seeders.Base;
using FluentValidation;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace API.Seeders;

/// <summary>Seeder-Klasse zum Anlegen von Mitarbeitern und Mitarbeitergruppen in der Datenbank.</summary>
public class MitarbeiterSeeder : DataSeeder<DomainContext> {
    /// <summary>Gibt an, ob der Seeder vor Importen ausgeführt werden muss.</summary>
    public override bool MustRunBeforeImports => false;

    /// <summary>Initialisiert eine neue Instanz des MitarbeiterSeeders mit den erforderlichen Abhängigkeiten.</summary>
    /// <param name="dbContextFactory">Fabrik zur Erzeugung des Datenbankkontexts.</param>
    /// <param name="logger">Logger für die Ausgabe von Informationen.</param>
    /// <param name="passwordHasher">Dienst zum Hashen von Passwörtern.</param>
    /// <param name="validators">Sammlung von Validatoren für die Datenvalidierung.</param>
    public MitarbeiterSeeder(IDbContextFactory<DomainContext> dbContextFactory, ILogger<MitarbeiterSeeder> logger,
        IPasswordHasher<User> passwordHasher, IEnumerable<IValidator> validators) : base(dbContextFactory, logger,
        validators) {
        _passwordHasher = passwordHasher;
    }

    /// <summary>Schlüssel zur Identifikation von Mitarbeitergruppen.</summary>
    public enum MitarbeiterGruppeKey {
        Sachbearbeiter,
        Teamleitung,
        Abfallverband
    }

    private readonly IPasswordHasher<User> _passwordHasher;

    /// <summary>Führt das Seed-Verfahren aus und legt Mitarbeitergruppen und Mitarbeiter an.</summary>
    /// <param name="cancellationToken">Token zur Abbruchsteuerung.</param>
    protected override async Task Run(CancellationToken cancellationToken = default) {
        var sachbearbeiterGruppeHapy = await SeedMitarbeiterGruppe(KommuneSeeder.LandkreisHaPy,
            MitarbeiterGruppeKey.Sachbearbeiter, ["sachbearbeitung-hapy@example.com"], cancellationToken);

        await SeedMitarbeiter<BackofficeUser>(
            new Guid("82869623-4c16-4c30-8c70-9458954b8715"),
            "superadmin-hapy@example.com",
            "Susanne",
            "Superadmin",
            KommuneSeeder.LandkreisHaPy,
            sachbearbeiterGruppeHapy,
            BackofficeNutzerArt.Superadmin,
            cancellationToken
            );
    }

    /// <summary>Legt einen Mitarbeiter mit den angegebenen Daten an oder aktualisiert ihn.</summary>
    /// <typeparam name="TMitarbeiter">Typ des Mitarbeiters.</typeparam>
    /// <param name="id">Eindeutige ID des Mitarbeiters.</param>
    /// <param name="email">E-Mail-Adresse des Mitarbeiters.</param>
    /// <param name="vorname">Vorname des Mitarbeiters.</param>
    /// <param name="nachname">Nachname des Mitarbeiters.</param>
    /// <param name="kommuneSeed">Seed der Kommune zur Zuordnung.</param>
    /// <param name="gruppe">Optionale Mitarbeitergruppe.</param>
    /// <param name="art">Art des Backoffice-Nutzers.</param>
    /// <param name="cancellationToken">Token zur Abbruchsteuerung.</param>
    private async Task SeedMitarbeiter<TMitarbeiter>(Guid id, String email, String vorname, String nachname,
        KommuneSeed kommuneSeed, MitarbeiterGruppe? gruppe = null, BackofficeNutzerArt art = BackofficeNutzerArt.Nutzer,
        CancellationToken cancellationToken = default) where TMitarbeiter : Mitarbeiter, new() {
        Type mitarbeiterType = typeof(TMitarbeiter);
        if (mitarbeiterType == typeof(BackofficeUser)) {
            var nextBackofficeUser = new BackofficeUser {
                Id = id,
                EMail = email,
                Vorname = vorname,
                Nachname = nachname,
                KommuneId = kommuneSeed.Id,
                Password = "123456",
                Gruppen = gruppe is not null ? [gruppe] : [],
                Art = art,
            };

            await Build(nextBackofficeUser)
                .OnCreate(ma =>
                    ma.SetOrganisationCryptoAndPassword(ma.Password, kommuneSeed.KeyEncryptionKey, _passwordHasher)
                ).SeedAsync(cancellationToken);
        } else {
            await Build(new TMitarbeiter {
                Id = id,
                EMail = email,
                Vorname = vorname,
                Nachname = nachname,
                KommuneId = kommuneSeed.Id,
                Password = "123456",
                Gruppen = gruppe is not null ? [gruppe] : []
            })
                .OnCreate(ma =>
                    ma.SetOrganisationCryptoAndPassword(ma.Password, kommuneSeed.KeyEncryptionKey, _passwordHasher)
                ).SeedAsync(cancellationToken);
        }
    }

    /// <summary>Legt eine Mitarbeitergruppe mit den angegebenen Daten an oder aktualisiert sie.</summary>
    /// <param name="kommuneSeed">Seed der Kommune zur Zuordnung.</param>
    /// <param name="key">Schlüssel zur Identifikation der Mitarbeitergruppe.</param>
    /// <param name="eMailAdressen">E-Mail-Adressen der Gruppe.</param>
    /// <param name="cancellationToken">Token zur Abbruchsteuerung.</param>
    /// <returns>Die angelegte oder aktualisierte Mitarbeitergruppe.</returns>
    private async Task<MitarbeiterGruppe> SeedMitarbeiterGruppe(KommuneSeed kommuneSeed, MitarbeiterGruppeKey key, List<string> eMailAdressen,
        CancellationToken cancellationToken = default) {
        return await Build(new MitarbeiterGruppe {
            Id = GetMitarbeiterGruppeId(kommuneSeed, key),
            Name = Enum.GetName(typeof(MitarbeiterGruppeKey), key)!,
            KommuneId = kommuneSeed.Id,
            EMailAdressen = eMailAdressen

        })
            .SeedAsync(cancellationToken);
    }

    /// <summary>Ermittelt die eindeutige ID einer Mitarbeitergruppe basierend auf Kommune und Schlüssel.</summary>
    /// <param name="kommuneSeed">Seed der Kommune.</param>
    /// <param name="key">Schlüssel der Mitarbeitergruppe.</param>
    /// <returns>Eindeutige ID der Mitarbeitergruppe.</returns>
    public static Guid GetMitarbeiterGruppeId(KommuneSeed kommuneSeed, MitarbeiterGruppeKey key) =>
        DeriveId(kommuneSeed.Id, Enum.GetName(typeof(MitarbeiterGruppeKey), key)!);
}
