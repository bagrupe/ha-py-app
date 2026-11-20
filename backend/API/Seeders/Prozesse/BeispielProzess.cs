using API.Features.EmailForwarder;
using API.Features.Expressions;
using API.Features.GovManager;
using API.Features.Prozess;
using API.Features.Prozess.ProgrammatischeSchritte;

namespace API.Seeders.Prozesse;

/// <summary>
/// Statische Klasse zur Definition eines Beispielprozesses mit Formularschritten und Verbindungen.
/// </summary>
public static class BeispielProzess {
    /// <summary>
    /// Funktion zur Erstellung eines Prozesses mit den definierten Schritten und Verbindungen.
    /// </summary>
    /// <param name="prozessVersionId">Die ID der Prozessversion.</param>
    /// <param name="kommuneSeed">Seed für die Kommune zur Bestimmung von Mitarbeitergruppen.</param>
    /// <returns>Tuple mit Listen von Schritten, Verbindungen und Ausführungen.</returns>
    private static readonly CreateProzess CreateProzess = (prozessVersionId, kommuneSeed) => {
        var sachbearbeiterGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed,
                MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);
        var teamleitungGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed, MitarbeiterSeeder.MitarbeiterGruppeKey.Teamleitung);

        var nameSchritt = new FormularSchritt {
            Titel = "Name",
            Anweisung = "Bitte geben Sie Ihre Daten gewissenhaft an.",
            NodePosition = new NodePosition { X = 317, Y = 49.5 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = [
                new StringFormularFeld {
                    AngezeigterName = "Anrede",
                    Anweisung = "Bitte wählen Sie Ihre Anrede aus.",
                    SlotName = "anrede",
                    Order = 0,
                    InhaltsTag = "Anrede",
                    Options =
                        new List<StringFormularFeldOption> {
                            new("Mit geschlechtsneutraler Anrede"), new("Frau"), new("Herr")
                        }
                },
                new StringFormularFeld {
                    AngezeigterName = "Vorname",
                    Anweisung = "Bitte geben Sie Ihren Vornamen ein.",
                    SlotName = "vorname",
                    Order = 1,
                    InhaltsTag = "Vorname",
                    Encrypted = false
                },
                new StringFormularFeld {
                    AngezeigterName = "Nachname",
                    Anweisung = "Bitte geben Sie Ihren Nachnamen ein.",
                    SlotName = "nachname",
                    Order = 2,
                    InhaltsTag = "Nachname",
                    Encrypted = false
                },
                new StringFormularFeld {
                    AngezeigterName = "Weicht Ihr aktueller Name vom Namen auf dem Führerschein ab?",
                    SlotName = "abweichender_name_frage",
                    Order = 3,
                    Anweisung = "Bitte wählen Sie aus",
                    Options = [
                        new StringFormularFeldOption("Ja"),
                        new StringFormularFeldOption("Nein")
                    ],
                    Encrypted = false
                },
                new StringFormularFeld {
                    IstRelevant = new BoolExpression("slot('abweichender_name_frage') == 'Ja'"),
                    AngezeigterName = "Abweichender Name",
                    SlotName = "abweichender_name",
                    Order = 4,
                    Anweisung = "Bitte geben Sie den Namen an der auf dem Führerschein gedruckt ist",
                    Encrypted = false
                }
            ],
        };

        var alterSchritt = new FormularSchritt {
            Titel = "Altersangabe",
            NodePosition = new NodePosition { X = 880, Y = 183.5 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = [
                new StringFormularFeld {
                    AngezeigterName = "Alter",
                    Anweisung = "Bitte geben Sie Ihr Alter wahrheitsgemäß an.",
                    SlotName = "alter",
                    Order = 0,
                    InhaltsTag = "Alter",
                }
            ]
        };

        var checkboxSchritt = new FormularSchritt {
            Titel = "Ja oder Nein Frage",
            NodePosition = new NodePosition { X = 12, Y = 85.5 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = [
                new CheckboxListFormularFeld {
                    AngezeigterName = "Ja oder Nein?",
                    Anweisung = "Bitte haken Sie ab.",
                    Options = [
                        new CheckboxListFeldOption(key: "first", label: "Bitte haken Sie ab.", order: 0),
                        new CheckboxListFeldOption(key: "second", label: "Bitte haken Sie mich NICHT ab.", order: 1,
                            defaultChecked: true)
                    ],
                    SlotName = "yesorno",
                    Order = 0
                },
            ]
        };

        var unterschreibenSchritt = new FormularSchritt {
            Titel = "Unterschrift",
            NodePosition = new NodePosition { X = 1090, Y = 183.5 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = [
                new SignatureFormularFeld {
                    Order = 0,
                    SlotName = "Unterschrift",
                    AngezeigterName = "Unterschrift",
                    Anweisung = "Bitte Unterschreiben",
                    InhaltsTag = "Unterschrift",
                    Encrypted = false
                }
            ]
        };
        var govManagerSchritt = new GovManagerRestExportSchritt {
            NodePosition = new NodePosition { X = 1369, Y = 228 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
            ExportParts = [
                new JsonPart(new JsonObject([])),
            ],
            VorgangsTyp = "govman_upload",
            MandantenSchluessel = "99997777",
            VorgangsSchluessel = "ECM",
        };

        var loggingSchritt = new ProgrammatischerSchritt {
            NodePosition = new NodePosition { X = 1677, Y = 322.25 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
            ImplementationAssemblyQualifiedName = typeof(ProofOfConceptLoggingSchritt).AssemblyQualifiedName!
        };

        var warteAufGovManagerSchritt = new WarteAufGovManagerSchritt {
            NodePosition = new NodePosition { X = 1929, Y = 228 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
            GovManagerSchritt = govManagerSchritt,
        };

        var altersKontrolleSchritt = new FormularSchritt {
            Titel = "Alterskontrolle",
            Anweisung = "Alterskontrolle nötig?",
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
            NodePosition = new NodePosition { X = 2489, Y = 216 },
            Felder = Array.Empty<FormularFeld>()
        };

        var ausweisSchritt = new FormularSchritt {
            Titel = "Ausweisdokument",
            Anweisung = "Bitte hinterlegen Sie ein Ausweisdokument",
            NodePosition = new NodePosition { X = 3084, Y = 92 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new UploadFormularFeld { SlotName = "ausweisdokument", Order = 0, InhaltsTag = "Ausweis" }
            }
        };

        var unterschriftSchritt = new FormularSchritt {
            Titel = "Unterschrift hinzufügen",
            Anweisung = "Bitte legen Sie eine Unterschrift an.",
            NodePosition = new NodePosition { X = 3712, Y = 131.25 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] { new UploadFormularFeld { SlotName = "unterschrift", Order = 0, Encrypted = false } }
        };

        var anschriftSchritt = new FormularSchritt {
            Titel = "Anschrift",
            Anweisung = "Bitte geben Sie Ihre Anschrift an.",
            NodePosition = new NodePosition { X = 3310, Y = 119.25 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new StringFormularFeld {
                    AngezeigterName = "Straße",
                    Anweisung = "In welcher Straße wohnen Sie?",
                    SlotName = "strasse",
                    Order = 0,
                    InhaltsTag = "Straße"
                },
                new StringFormularFeld {
                    AngezeigterName = "Hausnummer",
                    Anweisung = "Wie ist Ihre Hausnummer?",
                    SlotName = "hausnummer",
                    Order = 1,
                    InhaltsTag = "Hausnummer"
                },
                new StringFormularFeld {
                    AngezeigterName = "Postleitzahl",
                    Anweisung = "Wie lautet Ihre Postleitzahl?",
                    SlotName = "postleitzahl",
                    Order = 2,
                    InhaltsTag = "Postleitzahl"
                },
                new StringFormularFeld {
                    AngezeigterName = "Ort",
                    Anweisung = "In welchem Ort wohnen Sie?",
                    SlotName = "ort",
                    Order = 3,
                    InhaltsTag = "Ort"
                }
            }
        };

        var pruefungSchritt = new FormularSchritt {
            Titel = "Prüfung durch Teamleitung",
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = teamleitungGruppeId
                },
            NodePosition = new NodePosition { X = 3978, Y = 106 },
            Felder = Array.Empty<FormularFeld>(),
        };

        var terminVereinbarenSchritt = new FormularSchritt {
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = teamleitungGruppeId
                },
            NodePosition = new NodePosition { X = 2959, Y = 315.25 },
            Felder = new List<FormularFeld> {
                new StringFormularFeld { Order = 0, SlotName = "betreff", AngezeigterName = "Betreff" },
                new StringFormularFeld {
                    Order = 1, SlotName = "bemerkung", AngezeigterName = "Bemerkung", Multiline = true
                },
                new CheckboxListFormularFeld {
                    AngezeigterName = "Termin Optional?",
                    Options = [
                        new CheckboxListFeldOption(key: "optional", label: "Optional", order: 0),
                        new CheckboxListFeldOption(key: "notOptional", label: "Verpflichtend", order: 1)
                    ],
                    SlotName = "terminOptional",
                    Order = 1
                },
            },
            Titel = "Termin vereinbaren",
        };


        var terminBestaetigenSchritt = new FormularSchritt {
            NodePosition = new NodePosition { X = 3610, Y = 327.25 },
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = teamleitungGruppeId
                },
            Felder = new List<FormularFeld> {
                new CheckboxListFormularFeld {
                    AngezeigterName = "Termin Bestätigen",
                    Anweisung = "Bitte haken Sie ab.",
                    Options = [
                        new CheckboxListFeldOption(key: "first", label: "Ich werde zu dem Termin erscheinen", order: 0),
                        new CheckboxListFeldOption(key: "second", label: "Ich kann dan dem Termin nicht", order: 1),
                    ],
                    SlotName = "terminBestaetigen",
                    Order = 0
                },
            },
            Titel = "Termin Bestätigen",
        };

        var terminBestaetigungPruefenSchritt = new FormularSchritt {
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = teamleitungGruppeId
                },
            Felder = Array.Empty<FormularFeld>(),
            NodePosition = new NodePosition { X = 3981, Y = 359.75 },
            Titel = "Termin Bestätigung Prüfen",
        };

        var druckenSchritt = new FormularSchritt {
            Titel = "Dokument wird gedruckt",
            NodePosition = new NodePosition { X = 4528, Y = 177 },
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = teamleitungGruppeId
                },
            Felder = Array.Empty<FormularFeld>(),
        };

        var emailSchritt = new EmailForwarderExportSchritt {
            Titel = "Als E-Mail weiterleiten",
            NodePosition = new NodePosition { X = 4547, Y = 59 },
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = teamleitungGruppeId
                },
            EmailAddress = "test@example.com",
            Subject = new StringExpression("'Weitergeleitete Meldung ' + slot('vorname') + ' ' + slot('nachname')"),
            Body =
                "Sehr geehrte Damen und Herren,\n\nanbei erhalten Sie eine Meldung über einen Mangel.\n\nMit freundlichen Grüßen,\nIhre Kommune",
        };

        var endeSchritt = new EndeSchritt {
            NodePosition = new NodePosition { X = 4801, Y = 177 },
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = teamleitungGruppeId
                },
        };

        var schritte = new List<Schritt> {
            checkboxSchritt,
            unterschreibenSchritt,
            nameSchritt,
            alterSchritt,
            govManagerSchritt,
            loggingSchritt,
            warteAufGovManagerSchritt,
            altersKontrolleSchritt,
            ausweisSchritt,
            anschriftSchritt,
            unterschriftSchritt,
            terminBestaetigenSchritt,
            terminBestaetigungPruefenSchritt,
            pruefungSchritt,
            terminVereinbarenSchritt,
            druckenSchritt,
            emailSchritt,
            endeSchritt,
        };

        var verbindungen = new List<Verbindung> {
            new() { Von = checkboxSchritt, Nach = nameSchritt },
            new() { Von = nameSchritt, Nach = alterSchritt, },
            new() { Von = alterSchritt, Nach = unterschreibenSchritt },
            new() { Von = unterschreibenSchritt, Nach = govManagerSchritt },
            new() { Von = govManagerSchritt, Nach = loggingSchritt },
            new() { Von = loggingSchritt, Nach = warteAufGovManagerSchritt },
            new() { Von = warteAufGovManagerSchritt, Nach = govManagerSchritt, Name = "Nicht Erfolgreich" },
            new() { Von = warteAufGovManagerSchritt, Nach = altersKontrolleSchritt, Name = "Erfolgreich" },
            new() { Von = altersKontrolleSchritt, Nach = terminVereinbarenSchritt, Name = "Termin vereinbaren" },
            new() {
                Von = terminVereinbarenSchritt, Nach = terminBestaetigenSchritt, Name = "Terminvereinbarung absenden"
            },
            new() { Von = terminBestaetigenSchritt, Nach = terminBestaetigungPruefenSchritt },
            new() { Von = terminBestaetigungPruefenSchritt, Nach = endeSchritt, Name = "Termin erledigt" },
            new() { Von = altersKontrolleSchritt, Nach = ausweisSchritt, Name = "Ausweisdokument anfordern" },
            new() { Von = altersKontrolleSchritt, Nach = anschriftSchritt, Name = "Keine Kontrolle nötig" },
            new() { Von = ausweisSchritt, Nach = anschriftSchritt },
            new() { Von = anschriftSchritt, Nach = unterschriftSchritt },
            new() { Von = unterschriftSchritt, Nach = pruefungSchritt },
            new() { Von = pruefungSchritt, Nach = druckenSchritt, Name = "Prüfung erfolgreich" },
            new() { Von = pruefungSchritt, Nach = nameSchritt, Name = "Prüfung nicht erfolgreich" },
            new() { Von = pruefungSchritt, Nach = emailSchritt, Name = "Als E-Mail weiterleiten" },
            new() { Von = emailSchritt, Nach = endeSchritt },
            new() { Von = druckenSchritt, Nach = endeSchritt },
        };

        var ausfuehrungen = new List<Ausfuehrung>();

        return (schritte, verbindungen, ausfuehrungen);
    };

    /// <summary>
    /// Definiert den Seed für den Beispielprozess mit ID, Name, Erstell-Funktion und Beschreibung.
    /// </summary>
    public static readonly ProzessSeed ProzessSeed = new(
        new Guid("87037027-4cf8-4c36-ba56-03ede3345d6f"),
        "Beispielprozess",
        CreateProzess,
        "Dies ist zum Beispiel ein Beispiel-Beschreibungstext für den Beispiel-Prozess");
}
