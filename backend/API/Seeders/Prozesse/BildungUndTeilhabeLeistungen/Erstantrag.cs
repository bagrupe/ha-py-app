using API.Features.Expressions;
using API.Features.GovManager;
using API.Features.Prozess;

namespace API.Seeders.Prozesse.BildungUndTeilhabeLeistungen;

/// <summary>Statische Klasse zur Definition des Erstantragsprozesses für Bildungs- und Teilhabeleistungen.</summary>
public static class Erstantrag {
    /// <summary>Funktion zur Erstellung des Prozesses mit den zugehörigen Schritten und Verbindungen.</summary>
    private static readonly CreateProzess CreateProzess = (_, kommuneSeed) => {
        var sachbearbeiterGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed,
                MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);

        var antragsstellerSchritt = new FormularSchritt {
            Anweisung =
                "Bitte geben Sie Ihre Daten an. Die Daten zum berechtigten Kind werden im nächsten Schritt abgefragt.",
            Titel = "Persönliche Daten",
            NodePosition = new NodePosition { X = 12, Y = 12 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    AngezeigterName = "Vorname",
                    Anweisung = "Bitte geben Sie Ihren Vornamen ein.",
                    SlotName = "vorname",
                    Order = 0,
                    InhaltsTag = "Vorname",
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Nachname",
                    Anweisung = "Bitte geben Sie Ihren Nachnamen ein.",
                    SlotName = "nachname",
                    Order = 1,
                    InhaltsTag = "Nachname",
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Straße",
                    Anweisung = "In welcher Straße wohnen Sie?",
                    SlotName = "strasse",
                    Order = 2,
                    InhaltsTag = "Straße",
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Hausnummer",
                    Anweisung = "Wie ist Ihre Hausnummer?",
                    SlotName = "hausnummer",
                    Order = 3,
                    InhaltsTag = "Hausnummer",
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Postleitzahl",
                    Anweisung = "Wie lautet Ihre Postleitzahl?",
                    SlotName = "postleitzahl",
                    Order = 4,
                    InhaltsTag = "Postleitzahl",
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Ort",
                    Anweisung = "In welchem Ort wohnen Sie?",
                    SlotName = "ort",
                    Order = 5,
                    InhaltsTag = "Ort",
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Telefonnummer",
                    Anweisung = "Unter welcher Telefonnummer können wir Sie für eventuelle Rückfragen erreichen?",
                    SlotName = "telefonnummer",
                    Order = 6,
                    InhaltsTag = "Telefonnummer",
                    Encrypted = false,
                }
            }
        };

        var bankverbindungSchritt = new FormularSchritt {
            Titel = "Bankverbindung",
            Anweisung = "Bitte geben Sie Ihre Bankverbindung an.",
            NodePosition = new NodePosition { X = 344, Y = 36 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    AngezeigterName = "IBAN",
                    Anweisung = "Auf welche IBAN sollen wir die Leistung überweisen?",
                    SlotName = "iban",
                    Order = 0,
                    InhaltsTag = "IBAN",
                    Encrypted = false,
                    ValidationType = StringValidationType.Iban
                },
                new StringFormularFeld {
                    AngezeigterName = "Kreditinstitut",
                    Anweisung = "Wie lautet das dazugehörige Kreditinstitut?",
                    SlotName = "kreditinstitut",
                    Order = 1,
                    InhaltsTag = "Kreditinstitut",
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Kontoinhaber",
                    Anweisung = "Bitte geben Sie den Kontoinhaber ein.",
                    SlotName = "kontoinhaber",
                    Order = 2,
                    InhaltsTag = "Kontoinhaber",
                    Encrypted = false,
                }
            }
        };

        var berechtigungSchritt = new FormularSchritt {
            Titel = "Daten des Kindes für das Leistungen beantragt werden",
            Anweisung =
                "Bitte geben Sie Daten zum berechtigten Kind ein. Für jedes Kind ist ein eigener Antrag notwendig.",
            NodePosition = new NodePosition { X = 643, Y = 36 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    AngezeigterName = "Vorname des Kindes",
                    Anweisung = "Bitte geben Sie den Vornamen des Kindes ein.",
                    SlotName = "vornameKind",
                    Order = 0,
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Nachname des Kindes",
                    Anweisung = "Bitte geben Sie den Nachnamen des Kindes ein.",
                    SlotName = "nachnameKind",
                    Order = 1,
                    Encrypted = false,
                },
                new DateFormularFeld() {
                    AngezeigterName = "Geburtsdatum des Kindes",
                    Anweisung = "Bitte geben Sie das Geburtsdatum des Kindes ein.",
                    SlotName = "geburtsdatumKind",
                    Order = 2,
                    Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Kindergarten / Schule",
                    Anweisung =
                        "Bezeichnung des besuchten Kindergartens bzw. der besuchten Schule einschließlich der Klasse / der Jahrgangsstufe / des Ausbildungsgangs",
                    SlotName = "kindergartenOderSchule",
                    Order = 3,
                    Encrypted = false,
                },
            }
        };

        var leistungsbezugSchritt = new FormularSchritt {
            Titel = "Bezogene Leistungen",
            Anweisung = "Bitte geben Sie an, welche Leistungen Sie beziehen.",
            NodePosition = new NodePosition { X = 1135, Y = 48 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new List<FormularFeld> {
                new CheckboxListFormularFeld {
                    AngezeigterName = "Leistungen",
                    Options = [
                        new CheckboxListFeldOption(
                            key: "lebensunterhaltOderGrundsicherung",
                            label: "Hilfe zum Lebensunterhalt / Grundsicherung",
                            order: 0),

                        new CheckboxListFeldOption(
                            key: "leistungenNachAsylbewerberleistungsgesetz",
                            label: "Leistungen nach dem Asylbewerberleistungsgesetz",
                            order: 1),

                        new CheckboxListFeldOption(key: "kindergeldUndWohngeld", label: "Kindergeld und Wohngeld",
                            order: 2),

                        new CheckboxListFeldOption(
                            key: "kindergeldUndKinderzuschlag", label: "Kindergeld und Kinderzuschlag", order: 3)
                    ],
                    SlotName = "bezogeneLeistungen",
                    Order = 0,
                    Encrypted = false,
                }
            }
        };

        var leistungsBescheideSchritt = new FormularSchritt {
            Titel = "Leistungsbescheide",
            Anweisung = "Bitte laden Sie hier die Bescheide zu den bezogenen Leistungen hoch",
            NodePosition = new NodePosition { X = 1400, Y = 48 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new List<FormularFeld> {
                new UploadFormularFeld {
                    AngezeigterName = "Bescheide / Nachweise",
                    Anweisung = "Bitte laden Sie die Bescheide hoch.",
                    SlotName = "bescheideNachweise",
                    Order = 0,
                    Multi = true,
                    Encrypted = false,
                    Document = true,
                }
            }
        };

        List<FormularSchritt> formularSchritte = [
            antragsstellerSchritt,
            bankverbindungSchritt,
            berechtigungSchritt,
            leistungsbezugSchritt,
            leistungsBescheideSchritt
        ];
        var felder = formularSchritte.SelectMany(s => s.Felder).ToList();
        var dateiFelder = felder.Where(f => f.SlotValueType is SlotValueType.Upload);
        var jsonFelder = felder.Where(f => f.SlotValueType is not SlotValueType.Upload);
        var govManagerRestExportSchritt = new GovManagerRestExportSchritt {
            NodePosition = new NodePosition { X = 1840, Y = 92.5 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
            ExportParts = [
                .. dateiFelder.Select(f => new FilePart(f.SlotName)),
                new JsonPart(new JsonObject([
                    new JsonField("antragsart", new JsonStringValue("erstantrag")),
                    .. jsonFelder.Select(f => new JsonField(f.SlotName, new JsonSlotValue(f.SlotName))),
                ]))
            ],
            VorgangsTyp = "govman_upload",
            MandantenSchluessel = "99997777",
            VorgangsSchluessel = "ECM"
        };

        var pruefungSchritt = new FormularSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
            NodePosition = new NodePosition { X = 2140, Y = 80.5 },
            Felder = Array.Empty<FormularFeld>(),
            Titel = "Prüfung der Unterlagen",
        };

        var aktenzeichenSchritt = new FormularSchritt {
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId,
                },
            Anweisung = "Bitte geben Sie das Aktenzeichen an",
            NodePosition = new NodePosition { X = 2664, Y = 48 },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    Order = 0, SlotName = "Aktenzeichen", Anweisung = "Bitte geben Sie das Aktenzeichen an"
                }
            },
            Titel = "Aktenzeichen eintragen",
        };

        var endeSchritt = new EndeSchritt {
            NodePosition = new NodePosition { X = 3189, Y = 92.5 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
        };

        var schritte = new List<Schritt> {
            antragsstellerSchritt,
            bankverbindungSchritt,
            berechtigungSchritt,
            leistungsbezugSchritt,
            leistungsBescheideSchritt,
            govManagerRestExportSchritt,
            pruefungSchritt,
            aktenzeichenSchritt,
            endeSchritt
        };

        var verbindungen = new List<Verbindung> {
            new() { Von = antragsstellerSchritt, Nach = bankverbindungSchritt },
            new() { Von = bankverbindungSchritt, Nach = berechtigungSchritt },
            new() { Von = berechtigungSchritt, Nach = leistungsbezugSchritt },
            new() { Von = leistungsbezugSchritt, Nach = leistungsBescheideSchritt },
            new() { Von = leistungsBescheideSchritt, Nach = govManagerRestExportSchritt, },
            new() {
                Von = govManagerRestExportSchritt,
                Nach = pruefungSchritt,
                StatusAenderung = "Antrag eingegangen",
                StatusAenderungBeschreibung = "Ihr Antrag ist erfolgreich eingegangen und wird nun von uns bearbeitet."
            },
            new() { Von = pruefungSchritt, Nach = aktenzeichenSchritt, Name = "Prüfung erfolgreich" },
            new() {
                Von = aktenzeichenSchritt,
                Nach = endeSchritt,
                Name = "Aktenzeichen Speichern",
                StatusAenderung = "Antrag abgeschlossen",
                StatusAenderungBeschreibung =
                    "Für die Beantragung von Bildungs- und Teilhabeleistungen wurde Ihnen das Aktenzeichen XY-12 zugewiesen."
            },
        };

        return (schritte, verbindungen, Array.Empty<Ausfuehrung>());
    };

    /// <summary>Definiert den Seed für den Erstantragsprozess Bildungs- und Teilhabeleistungen.</summary>
    public static readonly ProzessSeed ProzessSeed = new(
        new Guid("60CD4517-F2C8-4358-B316-93E55B891DE4"),
        "Bildungs- und Teilhabeleistungen Erstantrag",
        CreateProzess,
        new StringExpression("slot('nachname') + ': ' + slot('vorname')")
    );
}
