using API.Features.Expressions;
using API.Features.Prozess;

namespace API.Seeders.Prozesse;

/// <summary>Definiert den Ideenmelder-Prozess mit den zugehörigen Schritten und Verbindungen.</summary>
public class IdeenmelderProzess {
    private static readonly CreateProzess CreateProzess = (_, kommuneSeed) => {
        var sachbearbeiterGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed,
                MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);

        var ideenSchritt = new FormularSchritt {
            Anweisung = "Teilen Sie uns Ihre Idee mit",
            Titel = "Ideenmelder",
            NodePosition = new NodePosition { X = 12, Y = 12 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new StringFormularFeld {
                    AngezeigterName = "Titel",
                    Anweisung = "Kurze Zusammenfassung Ihrer Idee",
                    SlotName = "titel",
                    OeffentlichSichtbar = true,
                    Order = 0,
                },
                new StringFormularFeld {
                    AngezeigterName = "Beschreibung",
                    Anweisung = "Beschreiben Sie Ihre Idee",
                    SlotName = "beschreibung",
                    OeffentlichSichtbar = true,
                    Order = 1,
                    Multiline = true,
                }
            },
        };

        var endeSchritt = new EndeSchritt {
            NodePosition = new NodePosition { X = 260, Y = 56.5 },
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
        };

        var schritte = new List<Schritt> { ideenSchritt, endeSchritt, };
        var verbindungen = new List<Verbindung> {
            new() { Von = ideenSchritt, Nach = endeSchritt },
        };

        return (schritte, verbindungen, new List<Ausfuehrung>());
    };

    /// <summary>Definiert den Prozess-Seed mit ID, Namen, Erstellfunktion und Beschreibungstext.</summary>
    public static readonly ProzessSeed ProzessSeed = new(
        new Guid("c8e3f1a2-4b5d-6e7f-8a9b-0c1d2e3f4a5b"),
        "Ideenmelder",
        CreateProzess,
        new StringExpression("slot('titel')"));
}
