using API.Features.Expressions;
using API.Features.Prozess;

namespace API.Seeders.Prozesse;

/// <summary>Definiert den Feedbackprozess mit den zugehörigen Schritten und Verbindungen.</summary>
public class FeedbackProzess {
    /// <summary>Erstellt den Prozess mit den Formularschritten und Verbindungen.</summary>
    private static readonly CreateProzess CreateProzess = (_, kommuneSeed) => {
        var sachbearbeiterGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed,
                MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);

        var feedbackSchritt = new FormularSchritt {
            Anweisung = "Teilen Sie uns Ihr Feedback mit",
            Titel = "Feedback",
            NodePosition = new NodePosition { X = 12, Y = 12 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new StringFormularFeld {
                    AngezeigterName = "Name", Anweisung = "Geben Sie Ihren Namen ein.", SlotName = "name", Order = 0,
                },
                new StringFormularFeld {
                    AngezeigterName = "Kontakt", Anweisung = "E-Mail / Telefon", SlotName = "contact", Order = 1,
                },
                new StringFormularFeld {
                    AngezeigterName = "Feedback",
                    Anweisung = "Ihr Feedback",
                    SlotName = "feedback",
                    Order = 2,
                    Multiline = true,
                }
            },
        };

        var reviewSchritt = new FormularSchritt {
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
            Titel = "Prüfung",
            NodePosition = new NodePosition { X = 260, Y = 56.5 },
            Felder = new List<FormularFeld>()
        };

        var endeSchritt = new EndeSchritt {
            NodePosition = new NodePosition { X = 730, Y = 68.5 },
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
        };

        var schritte = new List<Schritt> { feedbackSchritt, reviewSchritt, endeSchritt, };
        var verbindungen = new List<Verbindung> {
            new() { Von = feedbackSchritt, Nach = reviewSchritt },
            new() { Von = reviewSchritt, Nach = endeSchritt, Name = "Geprüft" },
        };

        return (schritte, verbindungen, new List<Ausfuehrung>());
    };

    /// <summary>Definiert den Prozess-Seed mit ID, Namen, Erstellfunktion und Startbedingung.</summary>
    public static readonly ProzessSeed ProzessSeed = new(
        new Guid("6aae3b77-93a4-4a71-b220-96120eb5d3e6"),
        "Feedback",
        CreateProzess,
        new StringExpression("slot('name')"));
}
