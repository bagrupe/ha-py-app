using System.Security.Cryptography;
using System.Text;
using API.Features.Expressions;
using API.Features.Lage;
using API.Features.Prozess;
using API.Features.Prozess.ProgrammatischeSchritte;

namespace API.Seeders.LageHelfer;

/// <summary>
/// Prozess "Bürger:in meldet Ereignis": Meldung mit Standort und Kategorie, Zuordnung zur Einsatzleitung über das
/// gewählte Gebiet, danach Prüfung und Einsatz im Backoffice.
/// </summary>
/// <remarks>
/// The Bürger step comes first so the app can submit it in one anonymous call (ausfuehrungCreateAnonym). The
/// life-threat question stays in the app: with danger to life it points to 112 and sends no report at all.
/// </remarks>
public static class EreignismeldungVorlage {
    /// <summary>Bump whenever the structure below changes, so the seeder publishes a new version.</summary>
    private const int Revision = 4;

    public const string StandortSlot = GebietEinsatzleitungZustaendigkeitSchritt.StandortSlotName;
    public const string KategorieSlot = "kategorie";
    public const string BeschreibungSlot = OpenMeldungen.BeschreibungSlot;
    public const string BilderSlot = "bilder";
    public const string RueckrufnummerSlot = "rueckrufnummer";
    public const int MaxFotos = 3;

    public const string StatusEingegangen = "Meldung ist eingegangen";
    public const string StatusHilfeUnterwegs = MeldungStatusErmittlung.StatusTextHilfeUnterwegs;

    public static string Fingerprint(LageHelferProzessSeed seed) {
        var content = $"{nameof(EreignismeldungVorlage)}:{Revision}:{string.Join('\u001f', seed.Kategorien)}";
        return Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(content)))[..16];
    }

    public static StringExpression Beschreibungstext => new($"'Ereignismeldung: ' + slot('{KategorieSlot}')");

    public static (List<Schritt> Schritte, List<Verbindung> Verbindungen, List<ZustaendigkeitRolle> Rollen) Build(
        LageHelferProzessSeed seed, Guid prozessVersionId) {
        var einsatzleitung = new ZustaendigkeitRolle {
            Id = LageHelferSeedData.DeriveId(prozessVersionId, "rolle:einsatzleitung"),
            Name = "Einsatzleitung",
        };
        var buerger = () => new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger };
        var vonEinsatzleitung = () => new Zustaendigkeit {
            Art = ZustaendigkeitArt.Dynamisch,
            DynamischeArten = [ZustaendigkeitArt.Organisationseinheit],
            LiestRolle = einsatzleitung,
        };

        var meldung = new FormularSchritt {
            Titel = "Angaben zum Ereignis",
            NodePosition = new NodePosition { X = 300, Y = 200 },
            SollZustaendigkeit = buerger(),
            Felder = [
                new LocationFormularFeld {
                    SlotName = StandortSlot,
                    AngezeigterName = "Standort",
                    Encrypted = false,
                    Pflichtfeld = true,
                    Order = 0,
                    // Public: activeLagen shows open reports as pins on the map.
                    OeffentlichSichtbar = true,
                },
                new StringFormularFeld {
                    SlotName = KategorieSlot,
                    AngezeigterName = "Kategorie",
                    Encrypted = false,
                    Pflichtfeld = true,
                    Order = 1,
                    Options = seed.Kategorien.Select(k => new StringFormularFeldOption(k)).ToList(),
                },
                new StringFormularFeld {
                    SlotName = BeschreibungSlot,
                    AngezeigterName = "Beschreibung",
                    Encrypted = false,
                    Multiline = true,
                    Order = 2,
                    OeffentlichSichtbar = true,
                },
                new UploadFormularFeld {
                    SlotName = BilderSlot,
                    AngezeigterName = "Fotos",
                    Anweisung = $"Freiwillig, bis zu {MaxFotos} Fotos.",
                    Encrypted = false,
                    Multi = true,
                    MaxAnzahl = MaxFotos,
                    Order = 3,
                },
                // Encrypted: the only personal data in an otherwise anonymous report.
                new StringFormularFeld {
                    SlotName = RueckrufnummerSlot,
                    AngezeigterName = "Rückrufnummer",
                    Anweisung = "Freiwillig, nur für Rückfragen der Einsatzleitung.",
                    Encrypted = true,
                    Order = 4,
                },
            ],
        };

        var zuordnung = new ProgrammatischerSchritt {
            Titel = "Einsatzleitung ermitteln",
            NodePosition = new NodePosition { X = 600, Y = 200 },
            SollZustaendigkeit = buerger(),
            ImplementationAssemblyQualifiedName =
                typeof(GebietEinsatzleitungZustaendigkeitSchritt).AssemblyQualifiedName!,
        };

        var pruefung = new FormularSchritt {
            Titel = "Meldung prüfen",
            NodePosition = new NodePosition { X = 900, Y = 200 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Dynamisch,
                DynamischeArten = [ZustaendigkeitArt.Organisationseinheit],
            },
            SchreibtRolle = einsatzleitung,
            Felder = [],
        };

        var einsatz = new FormularSchritt {
            Titel = "Einsatz läuft",
            NodePosition = new NodePosition { X = 1200, Y = 100 },
            SollZustaendigkeit = vonEinsatzleitung(),
            Felder = [],
        };

        var ende = new EndeSchritt {
            NodePosition = new NodePosition { X = 1500, Y = 200 },
            SollZustaendigkeit = vonEinsatzleitung(),
        };

        // Start must be first: the seeder sets ProzessVersion.Start from it.
        var schritte = new List<Schritt> { meldung, zuordnung, pruefung, einsatz, ende };
        var verbindungen = new List<Verbindung> {
            new() { Von = meldung, Nach = zuordnung, StatusAenderung = StatusEingegangen },
            new() { Von = zuordnung, Nach = pruefung },
            new() {
                Von = pruefung, Nach = einsatz, Name = "Hilfe einleiten", StatusAenderung = StatusHilfeUnterwegs,
            },
            new() {
                Von = pruefung, Nach = ende, Name = "Meldung schließen",
                StatusAenderung = "Meldung wurde geprüft und geschlossen",
            },
            new() {
                Von = einsatz, Nach = ende, Name = "Einsatz abschließen", StatusAenderung = "Einsatz abgeschlossen",
            },
        };

        return (schritte, verbindungen, [einsatzleitung]);
    }
}
