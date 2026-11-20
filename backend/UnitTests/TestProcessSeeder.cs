using API.Features;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Seeders;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// Builds reusable, publishable process graphs for integration tests.
/// </summary>
public static class TestProcessSeeder {
    /// <summary>
    /// Persists the "Renew Driving License" fixture: a four-step, published process that mirrors the
    /// real seeded graph. Its edges deliberately cover the distinct Verlauf paths:
    /// <list type="bullet">
    ///   <item>Persönliche Daten → Kontakt: <c>StatusAenderung = null</c>, no responsibility change.</item>
    ///   <item>Kontakt → Prüfung: configured StatusAenderung (reconstructed) plus a responsibility change
    ///     to an Organisationseinheit (persisted).</item>
    ///   <item>Prüfung → Ende: configured StatusAenderung (reconstructed), terminal step (persisted Abschluss).</item>
    /// </list>
    /// Points the Prüfung step at <see cref="KommuneSeeder.AerzenOrganisationseinheitId"/>, so callers must
    /// have ensured that Untereinheit exists (see <c>TestSeeder.EnsureSeedOrganisationseinheitExists</c>).
    /// </summary>
    public static async Task<RenewDrivingLicenseFixture> SeedRenewDrivingLicense(DomainContext db) {
        var prozessId = Guid.NewGuid();
        var prozessVersionId = Guid.NewGuid();

        var prozess = new Prozess {
            Id = prozessId,
            Name = "Renew Driving License (Fixture)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        var prozessVersion = new ProzessVersion {
            Id = prozessVersionId,
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 7, 7, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 7, 7, 12, 0, 0),
            Beschreibungstext = (StringExpression)"Renew Driving License",
        };

        var persoenlicheDaten = new FormularSchritt {
            Titel = "Persönliche Daten",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    SlotName = "name", AngezeigterName = "Name", Order = 0, Encrypted = false, Pflichtfeld = true,
                },
                new DateFormularFeld {
                    SlotName = "geburtsdatum", AngezeigterName = "Geburtsdatum", Order = 1, Encrypted = false,
                    Pflichtfeld = true,
                },
            },
        };

        var kontakt = new FormularSchritt {
            Titel = "Kontakt",
            NodePosition = new NodePosition { X = 0, Y = 160 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    SlotName = "email", AngezeigterName = "E-Mail", Order = 0, Encrypted = false, Pflichtfeld = true,
                },
            },
        };

        var pruefung = new FormularSchritt {
            Titel = "Prüfung durch die Kommune",
            NodePosition = new NodePosition { X = 0, Y = 320 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    SlotName = "entscheidung", AngezeigterName = "Entscheidung", Order = 0, Encrypted = false,
                    Pflichtfeld = true,
                },
            },
        };

        var ende = new EndeSchritt {
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 480 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };

        prozessVersion.Schritte.Add(persoenlicheDaten);
        prozessVersion.Schritte.Add(kontakt);
        prozessVersion.Schritte.Add(pruefung);
        prozessVersion.Schritte.Add(ende);

        var persoenlicheDatenNachKontakt = new Verbindung {
            Von = persoenlicheDaten,
            Nach = kontakt,
            StatusAenderung = null,
        };
        var kontaktNachPruefung = new Verbindung {
            Von = kontakt,
            Nach = pruefung,
            StatusAenderung = "Antrag in Prüfung",
            StatusAenderungBeschreibung = "Ihr Antrag ist bei der Kommune eingegangen und wird geprüft.",
        };
        var pruefungNachEnde = new Verbindung {
            Von = pruefung,
            Nach = ende,
            Name = "Bescheid erstellen",
            StatusAenderung = "Bescheid erstellt",
        };

        persoenlicheDaten.Verbindungen.Add(persoenlicheDatenNachKontakt);
        kontakt.Verbindungen.Add(kontaktNachPruefung);
        pruefung.Verbindungen.Add(pruefungNachEnde);

        await db.ProzessVersionen.AddAsync(prozessVersion);
        await db.SaveChangesAsync();

        prozessVersion.Start = persoenlicheDaten;
        await db.SaveChangesAsync();

        return new RenewDrivingLicenseFixture(
            prozessId, prozessVersionId,
            persoenlicheDaten, kontakt, pruefung, ende,
            persoenlicheDatenNachKontakt, kontaktNachPruefung, pruefungNachEnde);
    }
}

/// <summary>Handles to the persisted "Renew Driving License" fixture graph for driving steps in tests.</summary>
public record RenewDrivingLicenseFixture(
    Guid ProzessId,
    Guid ProzessVersionId,
    FormularSchritt PersoenlicheDaten,
    FormularSchritt Kontakt,
    FormularSchritt Pruefung,
    EndeSchritt Ende,
    Verbindung PersoenlicheDatenNachKontakt,
    Verbindung KontaktNachPruefung,
    Verbindung PruefungNachEnde);
