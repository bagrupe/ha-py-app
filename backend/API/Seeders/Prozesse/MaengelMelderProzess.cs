using System.Security.Cryptography;
using System.Text.Json.Nodes;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Infrastructure;
using NodaTime;

namespace API.Seeders.Prozesse;

/// <summary>Definiert den Mängelmelder-Prozess mit den zugehörigen Schritten, Verbindungen und Ausführungen.</summary>
public class MaengelMelderProzess {
    /// <summary>Erstellt den Mängelmelder-Prozess mit Formularschritten, Verbindungen und Beispielausführungen.</summary>
    /// <param name="prozessVersionId">Die ID der Prozessversion.</param>
    /// <param name="kommuneSeed">Seed der Kommune zur Bestimmung von Mitarbeitergruppen und Verschlüsselung.</param>
    /// <returns>Tuple mit Listen von Schritten, Verbindungen und Ausführungen.</returns>
    private static readonly CreateProzess CreateProzess = (prozessVersionId, kommuneSeed) => {
        var sachbearbeiterGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed,
                MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);
        var abfallverbandGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed, MitarbeiterSeeder.MitarbeiterGruppeKey.Abfallverband);

        var mangelInformationenSchritt = new FormularSchritt {
            Titel = "Informationen zum Mangel",
            Anweisung = "Bitte geben Sie die benötigten Informationen ein.",
            NodePosition = new NodePosition { X = 12, Y = 12 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new List<FormularFeld> {
                new LocationFormularFeld {
                    AngezeigterName = "Adresse", Encrypted = false, SlotName = "adresse", Order = 0, OeffentlichSichtbar = true,
                },
                new StringFormularFeld {
                    AngezeigterName = "Titel",
                    Anweisung = "z.B. Müllverschmutzung",
                    Encrypted = false,
                    SlotName = "titel",
                    OeffentlichSichtbar = true,
                    Order = 1,
                },
                new StringFormularFeld {
                    AngezeigterName = "Kategorie",
                    Encrypted = false,
                    SlotName = "kategorie",
                    OeffentlichSichtbar = true,
                    Order = 2,
                    Options =
                        new List<StringFormularFeldOption> {
                            new("Müllentsorgung"), new("Straßenschäden"), new("Vandalismus")
                        }
                },
                new StringFormularFeld {
                    AngezeigterName = "Beschreibung",
                    Encrypted = false,
                    SlotName = "beschreibung",
                    OeffentlichSichtbar = true,
                    Order = 3,
                    Multiline = true,
                }
            },
            Informationstext =
                "Falls es sich um akute Gefahr im Verzug handelt, melden Sie sich bitte direkt bei der Polizei!"
        };

        var imageUploadSchritt = new FormularSchritt {
            Titel = "Fotoupload",
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Anweisung =
                "Bitte machen Sie Fotos des vorliegenden Mangels. Bitte achten Sie darauf, dass man den Mangel gut erkennen kann und dass keine Personen auf dem Bild zu sehen sind.",
            NodePosition = new NodePosition { X = 318, Y = 24 },
            Felder = new[] {
                new UploadFormularFeld {
                    Encrypted = false, SlotName = "bilder", Order = 0, Multi = true, OeffentlichSichtbar = true,
                }
            }
        };

        var pruefungSchritt = new FormularSchritt {
            Titel = "Prüfung der Meldung",
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
            NodePosition = new NodePosition { X = 540, Y = 115.75 },
            Felder = Array.Empty<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true
        };

        var fahrzeugZuweisungsSchritt = new FormularSchritt {
            Titel = "Fahrzeugzuweisung",
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = abfallverbandGruppeId
                },
            NodePosition = new NodePosition { X = 1048, Y = 56.5 },
            Felder = Array.Empty<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true
        };

        var avbFinalerSchritt = new FormularSchritt {
            Titel = "Abschliessen und als E-Mail versenden",
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
            NodePosition = new NodePosition { X = 1546, Y = 56.5 },
            Felder = Array.Empty<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
        };

        var endeSchritt = new EndeSchritt {
            NodePosition = new NodePosition { X = 2182, Y = 127.75 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId
            }
        };

        var schritte = new List<Schritt> {
            mangelInformationenSchritt,
            imageUploadSchritt,
            pruefungSchritt,
            fahrzeugZuweisungsSchritt,
            avbFinalerSchritt,
            endeSchritt
        };

        var mangelToImageUpload = new Verbindung { Von = mangelInformationenSchritt, Nach = imageUploadSchritt };
        var imageUploadToPruefung = new Verbindung {
            Von = imageUploadSchritt,
            Nach = pruefungSchritt,
            StatusAenderung = "Mangel wurde gemeldet.",
            IstRelevant = new BoolExpression("isInside('Hameln', slot('adresse'))")
        };

        var verbindungen = new List<Verbindung> {
            mangelToImageUpload,
            imageUploadToPruefung,
            new() {
                Von = imageUploadSchritt,
                Nach = fahrzeugZuweisungsSchritt,
                StatusAenderung = "Die Meldung wurde an den Abfallverband weitergegeben.",
                IstRelevant = new BoolExpression("isInside('Hameln', slot('adresse')) == false")
            },
            new() {
                Von = pruefungSchritt,
                Nach = fahrzeugZuweisungsSchritt,
                StatusAenderung = "Die Meldung wurde an den Abfallverband weitergegeben.",
                Name = "An Abfallverband übergeben"
            },
            new() {
                Von = pruefungSchritt,
                Nach = fahrzeugZuweisungsSchritt,
                StatusAenderung = "Die Meldung wurde an den Abfallverband weitergegeben.",
                Name = "An Abfallverband übergeben",
                IstRelevant = new BoolExpression("isInside('Hameln', slot('adresse'))")
            },
            new() {
                Von = fahrzeugZuweisungsSchritt,
                Nach = avbFinalerSchritt,
                StatusAenderung = "Ein Fahrzeug wurde zugewiesen.",
                Name = "Fahrzeug zuweisen"
            },
            new() {
                Von = avbFinalerSchritt,
                Nach = endeSchritt,
                StatusAenderung = "Mangel behoben.",
                Name = "Mangel als behoben markieren"
            },
            new() {
                Von = pruefungSchritt,
                Nach = endeSchritt,
                StatusAenderung = "Mangel behoben.",
                Name = "Mangel als behoben markieren"
            },
        };

        var unusedKey = RandomNumberGenerator.GetBytes(32);

        var bearbeitungen = new List<Bearbeitung> {
            new() {
                CreatedAt = Instant.FromUtc(2023, 1, 1, 12, 0),
                UserId = BuergerSeeder.MangelBuergerId,
                SlotValues = new List<SlotValue> {
                    new PlainSlotValue {
                        SlotName = "adresse",
                        Value = new JsonObject {
                            ["addressString"] = "Am Markt 1, 31785 Hameln",
                            ["coordinates"] = new JsonArray { JsonValue.Create(9.743), JsonValue.Create(52.374) }
                        }.ToJsonElement(),
                    },
                    new PlainSlotValue {
                        SlotName = "titel", Value = JsonValue.Create("Müllverschmutzung").ToJsonElement()
                    },
                    new PlainSlotValue {
                        SlotName = "kategorie", Value = JsonValue.Create("Müllentsorgung").ToJsonElement()
                    },
                    new PlainSlotValue {
                        SlotName = "beschreibung", Value = JsonValue.Create("Eine längere Beschreibung").ToJsonElement()
                    },
                },
                Schritt = mangelInformationenSchritt,
                NextVerbindung = mangelToImageUpload
            },
            new() {
                CreatedAt = Instant.FromUtc(2023, 1, 1, 12, 0),
                UserId = BuergerSeeder.MangelBuergerId,
                SlotValues = new List<SlotValue> {
                    new PlainSlotValue {
                        SlotName = "bilder",
                        Value = new JsonArray {
                            JsonValue.Create(Convert.ToBase64String(File.ReadAllBytes("Muell.jpg")))
                        }.ToJsonElement(),
                    }
                },
                Schritt = imageUploadSchritt,
                NextVerbindung = imageUploadToPruefung
            },
        };

        var ausfuehrungen = new List<Ausfuehrung> {
            new() {
                ProzessVersionId = prozessVersionId,
                UserId = BuergerSeeder.MangelBuergerId,
                CreatedAt = Instant.FromUtc(2023, 1, 1, 12, 0),
                SharedKeyEncryptedForBuerger =
                    Convert.ToBase64String(
                        BuergerSeeder.UnsafeBuergerRsa.Encrypt(unusedKey, RSAEncryptionPadding.OaepSHA512)),
                SharedKeyEncryptedForKommune =
                    Convert.ToBase64String(kommuneSeed.UnsafeRsa.Encrypt(unusedKey, RSAEncryptionPadding.OaepSHA512)),
                Bearbeitungen = bearbeitungen,
                Status = AusfuehrungStatus.BearbeitungDurchKommune,
                Schritt = bearbeitungen.Last().NextVerbindung.Nach,
            },
        };

        return (schritte, verbindungen, ausfuehrungen);
    };

    /// <summary>Definiert den Prozess-Seed mit ID, Namen, Erstellfunktion und Titel-Expression.</summary>
    public static readonly ProzessSeed ProzessSeed =
        new(new Guid("218a1d51-5603-4c16-87a0-2c36990270db"), "Mängelmelder", CreateProzess, new StringExpression(
            "slot('kategorie') + ': ' + slot('titel')"
        ));
}
