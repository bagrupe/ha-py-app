using API.Features.Expressions;
using API.Features.Prozess;

namespace API.Seeders.Prozesse;

/// <summary>
/// Statische Klasse zur Definition des Prozesses "Führerschein verlängern".
/// </summary>
public static class FuehrerscheinVerlaengern {
    /// <summary>
    /// Funktion zur Erstellung des Prozesses mit allen Schritten, Verbindungen und Ausführungen.
    /// </summary>
    private static readonly CreateProzess CreateProzess = (_, kommuneSeed) => {
        var sachbearbeiterGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed,
                MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);
        var teamleitungGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed, MitarbeiterSeeder.MitarbeiterGruppeKey.Teamleitung);

        var staatsangehoerigkeitSchritt = new FormularSchritt {
            Anweisung =
                "Bitte geben Sie Ihre Staatsangehörigkeit und die Art des Ausweisdokumentes an, mit welchem Sie die Beantragung durchführen.",
            Titel = "Staatsangehörigkeit und Ausweisart",
            NodePosition = new NodePosition { X = 12, Y = 266.5 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new StringFormularFeld {
                    AngezeigterName = "Staatsangehörigkeit",
                    Anweisung = "Bitte geben Sie das Land an.",
                    SlotName = "staatsangehörigkeit",
                    Order = 0,
                    InhaltsTag = "Staatsangehörigkeit",
                    Options =
                        Staatsangehoerigkeit.Staatsangehoerigkeiten.Select(s => new StringFormularFeldOption(s))
                            .ToList()
                },
                new StringFormularFeld {
                    AngezeigterName = "Ausweisart",
                    Anweisung = "Bitte wählen Sie Ihre Ausweisart aus.",
                    SlotName = "ausweisart",
                    Order = 1,
                    InhaltsTag = "Ausweisart",
                    Options = new List<StringFormularFeldOption> {
                        new("Duldung"),
                        new("Ankunftsnachweis"),
                        new("Personalausweis"),
                        new("Reisepass"),
                        new("Reiseausweis"),
                        new("Ausweisersatz"),
                        new("Gestattung")
                    }
                },
            }
        };

        var anschriftSchritt = new FormularSchritt {
            Anweisung =
                "Bitte geben Sie Ihre Daten gewissenhaft an, diese Daten erscheinen später auf Ihrem Führerschein",
            Titel = "Persönliche Daten",
            NodePosition = new NodePosition { X = 407, Y = 194.5 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new FormularFeld[] {
                new StringFormularFeld {
                    AngezeigterName = "Anrede",
                    Anweisung = "Bitte wählen Sie Ihre Anrede aus.",
                    SlotName = "anrede",
                    Order = 0,
                    InhaltsTag = "Anrede",
                    Options = [
                        new StringFormularFeldOption("Mit geschlechtsneutraler Anrede"),
                        new StringFormularFeldOption("Frau"),
                        new StringFormularFeldOption("Herr")
                    ]
                },
                new StringFormularFeld {
                    AngezeigterName = "Vorname",
                    Anweisung = "Bitte geben Sie Ihren Vornamen ein.",
                    SlotName = "vorname",
                    Order = 1,
                    InhaltsTag = "Vorname"
                },
                new StringFormularFeld {
                    AngezeigterName = "Nachname",
                    Anweisung = "Bitte geben Sie Ihren Nachnamen ein.",
                    SlotName = "nachname",
                    Order = 2,
                    InhaltsTag = "Nachname",
                },
                new StringFormularFeld {
                    AngezeigterName = "Doktorgrad",
                    Anweisung = "Bitte geben Sie Ihren Doktorgrad ein.",
                    SlotName = "doktorgrad",
                    Order = 3,
                    InhaltsTag = "Doktorgrad",
                },
                new StringFormularFeld {
                    AngezeigterName = "Geschlecht",
                    Anweisung = "Bitte geben Sie Ihr Geschlecht ein.",
                    SlotName = "geschlecht",
                    Order = 4,
                    InhaltsTag = "Geschlecht",
                    Options = new List<StringFormularFeldOption> { new("Weiblich"), new("Männlich"), new("Divers") }
                },
                new DateFormularFeld {
                    AngezeigterName = "Geburtsdatum",
                    Anweisung = "Bitte geben Sie Ihr Geburtsdatum ein.",
                    SlotName = "geburtsdatum",
                    Order = 5,
                    InhaltsTag = "Geburtsdatum",
                },
                new StringFormularFeld {
                    AngezeigterName = "Geburtsort",
                    Anweisung = "Bitte geben Sie Ihren Geburtsort ein.",
                    SlotName = "geburtsort",
                    Order = 6,
                    InhaltsTag = "Geburtsort",
                },
                new StringFormularFeld {
                    AngezeigterName = "Geburtsname",
                    Anweisung = "Bitte geben Sie Ihren Geburtsnamen ein.",
                    SlotName = "geburtsname",
                    Order = 7,
                    InhaltsTag = "Geburtsname",
                },
                new StringFormularFeld {
                    AngezeigterName = "Straße",
                    Anweisung = "In welcher Straße wohnen Sie?",
                    SlotName = "strasse",
                    Order = 8,
                    InhaltsTag = "Straße"
                },
                new StringFormularFeld {
                    AngezeigterName = "Hausnummer",
                    Anweisung = "Wie ist Ihre Hausnummer?",
                    SlotName = "hausnummer",
                    Order = 9,
                    InhaltsTag = "Hausnummer"
                },
                new StringFormularFeld {
                    AngezeigterName = "Postleitzahl",
                    Anweisung = "Wie lautet Ihre Postleitzahl?",
                    SlotName = "postleitzahl",
                    Order = 10,
                    InhaltsTag = "Postleitzahl"
                },
                new StringFormularFeld {
                    AngezeigterName = "Ort",
                    Anweisung = "In welchem Ort wohnen Sie?",
                    SlotName = "ort",
                    Order = 11,
                    InhaltsTag = "Ort"
                },
                new StringFormularFeld {
                    AngezeigterName = "Zusatz",
                    Anweisung = "Zusätzliche Angaben zur Adresse",
                    SlotName = "zusatz",
                    Order = 12,
                    InhaltsTag = "Adresszusatz"
                }
            }
        };

        var angabenZumFuehreschein = new FormularSchritt {
            Titel = "Angaben zum Führerschein",
            Anweisung = "Bitte fühlen Sie die Angaben zu Ihrem aktuellen Führerschein aus",
            NodePosition = new NodePosition { X = 722, Y = 28 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new StringFormularFeld {
                    AngezeigterName = "Ausstellende Republik",
                    SlotName = "ausstellung",
                    Order = 0,
                    InhaltsTag = "Führerschein Ausstellung",
                    Anweisung = "Bitte wählen Sie aus",
                    Options =
                        new List<StringFormularFeldOption> {
                            new("Bundesrepublik Deutschland"), new("Deutsche Demokratische Republik")
                        }
                },
                new StringFormularFeld {
                    AngezeigterName = "Ausstellende Behörde",
                    SlotName = "ausstellende_behoerde",
                    Order = 1,
                    Anweisung = "Bitte geben Sie die letzte ausstellende Behörde an",
                    InhaltsTag = "Ausstellende Behörde",
                },
                new StringFormularFeld {
                    AngezeigterName = "Weicht Ihr aktueller Name vom Namen auf dem Führerschein ab?",
                    SlotName = "abweichender_name_frage",
                    Order = 2,
                    Anweisung = "Bitte wählen Sie aus",
                    Options = new List<StringFormularFeldOption> { new("Ja"), new("Nein") }
                },
                new StringFormularFeld {
                    IstRelevant = new BoolExpression("slot('abweichender_name_frage') == 'Ja'"),
                    AngezeigterName = "Abweichender Name",
                    SlotName = "abweichender_name",
                    Order = 3,
                    Anweisung = "Bitte geben Sie den Namen anf der auf dem Führerschein gedruckt ist",
                }
            }
        };

        var fuehrerscheinSchritt = new FormularSchritt {
            Titel = "Führerscheinupload",
            Anweisung =
                "Bitte laden Sie Ihren aktuellen Führerschein hoch. Fotografieren Sie bitte jede Seite",
            NodePosition = new NodePosition { X = 1285, Y = 52 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new UploadFormularFeld {
                    AngezeigterName = "Führerschein",
                    Anweisung = "Bitte laden Sie Ihren Führerschein hoch",
                    SlotName = "fuehrerschein",
                    Order = 0,
                    InhaltsTag = "Führerschein",
                    Multi = true
                },
            },
        };

        var ausweisSchritt = new FormularSchritt {
            Titel = "Ausweisupload",
            Anweisung =
                "Bitte laden Sie Ihr Ausweis-Dokument hoch. Fotografieren Sie bitte jede Seite",
            NodePosition = new NodePosition { X = 1580, Y = 52 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new UploadFormularFeld {
                    AngezeigterName = "Ausweis",
                    Anweisung = "Bitte laden Sie Ihr Ausweis-Dokument hoch",
                    SlotName = "ausweis",
                    Order = 1,
                    InhaltsTag = "Ausweis-Dokument",
                    Multi = true
                }
            },
        };

        var fotoSchritt = new FormularSchritt {
            Titel = "Fotoupload",
            Anweisung = "Bitte laden Sie ein aktuelles biometrisches Foto hoch.",
            NodePosition = new NodePosition { X = 1804, Y = 52 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new UploadFormularFeld { SlotName = "foto", Order = 0, InhaltsTag = "Biometrisches Foto" }
            },
        };

        var unterschriftSchritt = new FormularSchritt {
            Titel = "Unterschrift hinzufügen",
            Anweisung = "Bitte legen Sie eine Unterschrift an.",
            NodePosition = new NodePosition { X = 2026, Y = 52 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] { new UploadFormularFeld { SlotName = "unterschrift", Order = 0 } }
        };

        var kontaktDatenSchritt = new FormularSchritt {
            Titel = "Weitere Angaben",
            Anweisung =
                "Die Angabe Ihrer E-Mail-Adresse und Telefonnummer ist freiwillig. Diese Angaben helfen aber, dass Sie bei Rückfragen oder fehlenden Informationen schneller kontaktiert werden können.",
            NodePosition = new NodePosition { X = 2292, Y = 40 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new[] {
                new StringFormularFeld {
                    Order = 0,
                    SlotName = "e-mail",
                    AngezeigterName = "E-Mail-Adresse",
                    Anweisung = "Bitte geben Sie Ihre E-Mail-Adresse an"
                },
                new StringFormularFeld {
                    Order = 1,
                    SlotName = "telefonnummer",
                    AngezeigterName = "Telefonnummer",
                    Anweisung = "Bitte geben Sie Ihre Telefonnummer an"
                },
                new StringFormularFeld { Order = 3, SlotName = "weitere", AngezeigterName = "Weitere Bemerkungen", }
            }
        };

        var bezahlenSchritt = new BezahlenSchritt {
            NodePosition = new NodePosition { X = 2739.5, Y = 84.5 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Titel = "Bezahlen",
            Betrag = 42.50m
        };

        var wartenAufBezahlungAbgeschlossenSchritt =
            new WarteAufBezahlungAbgeschlossenSchritt {
                NodePosition = new NodePosition { X = 3239, Y = 84.5 },
                Titel = "Bezahlen",
                BezahlenSchritt = bezahlenSchritt,
                SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            };

        var pruefungSchritt = new FormularSchritt {
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
            NodePosition = new NodePosition { X = 3718, Y = 162 },
            Felder = Array.Empty<FormularFeld>(),
            Titel = "Prüfung der Unterlagen",
        };

        var terminVereinbarenSchritt = new FormularSchritt {
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
            NodePosition = new NodePosition { X = 4260, Y = 12 },
            Felder = new List<FormularFeld> {
                new StringFormularFeld { Order = 0, SlotName = "betreff", AngezeigterName = "Betreff" },
                new StringFormularFeld {
                    Order = 1, SlotName = "inhalt", AngezeigterName = "Bemerkung", Multiline = true
                }
            },
            Titel = "Termin Vereinbaren",
        };

        var teamleitungSchritt = new FormularSchritt {
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
            NodePosition = new NodePosition { X = 4242, Y = 299 },
            Felder = Array.Empty<FormularFeld>(),
            Titel = "Prüfung durch Teamleitung",
        };

        var endeSchritt = new EndeSchritt {
            NodePosition = new NodePosition { X = 4792, Y = 276.5 },
            SollZustaendigkeit =
                new Zustaendigkeit {
                    Art = ZustaendigkeitArt.Organisationseinheit,
                    OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                    MitarbeiterGruppeId = sachbearbeiterGruppeId
                },
        };

        var schritte = new List<Schritt> {
            staatsangehoerigkeitSchritt,
            anschriftSchritt,
            angabenZumFuehreschein,
            fuehrerscheinSchritt,
            ausweisSchritt,
            fotoSchritt,
            unterschriftSchritt,
            kontaktDatenSchritt,
            bezahlenSchritt,
            wartenAufBezahlungAbgeschlossenSchritt,
            pruefungSchritt,
            teamleitungSchritt,
            terminVereinbarenSchritt,
            endeSchritt
        };

        var verbindungen = new List<Verbindung> {
            new() { Von = staatsangehoerigkeitSchritt, Nach = anschriftSchritt },
            new() { Von = anschriftSchritt, Nach = angabenZumFuehreschein },
            new() { Von = angabenZumFuehreschein, Nach = fuehrerscheinSchritt },
            new() { Von = fuehrerscheinSchritt, Nach = ausweisSchritt },
            new() { Von = ausweisSchritt, Nach = fotoSchritt },
            new() { Von = fotoSchritt, Nach = unterschriftSchritt },
            new() { Von = unterschriftSchritt, Nach = kontaktDatenSchritt },
            new() { Von = kontaktDatenSchritt, Nach = bezahlenSchritt },
            new() { Von = bezahlenSchritt, Nach = wartenAufBezahlungAbgeschlossenSchritt, Name = "Erfolgreich" },
            new() { Von = bezahlenSchritt, Nach = bezahlenSchritt, Name = "Nicht Erfolgreich" },
            new() { Von = wartenAufBezahlungAbgeschlossenSchritt, Nach = pruefungSchritt, Name = "Erfolgreich" },
            new() { Von = wartenAufBezahlungAbgeschlossenSchritt, Nach = bezahlenSchritt, Name = "Nicht Erfolgreich" },
            new() {
                Von = pruefungSchritt,
                Nach = endeSchritt,
                Name = "Prüfung erfolgreich",
                StatusAenderung = "Prüfung erfolgreich"
            },
            new() { Von = pruefungSchritt, Nach = terminVereinbarenSchritt, Name = "Termin vereinbaren" },
            new() { Von = pruefungSchritt, Nach = anschriftSchritt, Name = "Prüfung nicht erfolgreich" },
            new() { Von = pruefungSchritt, Nach = teamleitungSchritt, Name = "Weitergeben an Teamleitung" },
            new() { Von = teamleitungSchritt, Nach = endeSchritt, Name = "Prüfung erfolgreich" },
            new() { Von = teamleitungSchritt, Nach = anschriftSchritt, Name = "Prüfung nicht erfolgreich" },
        };

        var ausfuehrungen = new List<Ausfuehrung>();

        return (schritte, verbindungen, ausfuehrungen);
    };

    /// <summary>
    /// Definiert den Prozess-Seed für den Prozess "Führerschein verlängern".
    /// </summary>
    public static readonly ProzessSeed ProzessSeed = new(
        new Guid("d5383894-795a-46d7-ac0f-7e674b28ec0d"),
        "Führerschein verlängern",
        CreateProzess,
        new StringExpression("slot('nachname') + ', ' + slot('vorname')"));
}
