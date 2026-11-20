using API.Features.Expressions;
using API.Features.GovManager;
using API.Features.Prozess;

namespace API.Seeders.Prozesse.BildungUndTeilhabeLeistungen;

/// <summary>
/// Statische Klasse zur Definition des Folgeantragsprozesses für Bildungs- und Teilhabeleistungen.
/// </summary>
public static class Folgeantrag {
    /// <summary>
    /// Funktion zur Erstellung des Folgeantragsprozesses mit den definierten Schritten und Verbindungen.
    /// </summary>
    private static readonly CreateProzess CreateProzess = (_, kommuneSeed) => {
        var sachbearbeiterGruppeId =
            MitarbeiterSeeder.GetMitarbeiterGruppeId(kommuneSeed,
                MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);
        var aktenzeichenSchritt = new FormularSchritt {
            Titel = "Aktenzeichen",
            Anweisung =
                "Bitte tragen Sie hier das Aktenzeichen ein, welches Sie bei Ihrem Erstantrag erhalten haben.",
            NodePosition = new NodePosition { X = 12, Y = 120 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    AngezeigterName = "Aktenzeichen",
                    Anweisung =
                        "Bitte tragen Sie das Aktenzeichen ein",
                    SlotName = "aktenzeichen",
                    Order = 0,
                    Encrypted = false,
                },
            }
        };

        var datenDesKindes = new FormularSchritt {
            Titel = "Daten des Kindes für das Leistungen beantragt werden",
            Anweisung =
                "Bitte geben Sie Daten zum berechtigten Kind ein. Für jedes Kind ist ein eigener Antrag notwendig.",
            NodePosition = new NodePosition { X = 314, Y = 120 },
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
            }
        };

        var beantragteLeistungenSchritt = new FormularSchritt {
            Titel = "Beantragte Leistungen",
            Anweisung = "Bitte wählen Sie die Leistungen aus, die Sie beantragen möchten",
            NodePosition = new NodePosition { X = 806, Y = 12 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, },
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    AngezeigterName = "Leistung",
                    Anweisung = "Bitte wählen Sie eine Leistung aus",
                    Options = [
                        new("Gemeinschaftliche Mittagsverpflegung"),
                        new("Teilnahme an einem eintägigen Ausflug"),
                        new("Teilnahme an einer mehrtägigen Klassenfahrt"),
                        new("Lernförderung"),
                        new("Teilnahme am sozialen und kulturellen Leben (bis zur Vollendung des 18. Lebensjahres)"),
                        new("Schulbeförderung ab Klasse 11"),
                        new("Persönlicher Schulbedarf")
                    ],
                    SlotName = "beantragteLeistung",
                    Order = 0,
                    Encrypted = false,
                },
            }
        };

        #region MittagsVerpflegung

        var relevantWhenMittagsVerpflegung =
            new BoolExpression("slot('beantragteLeistung') == 'Gemeinschaftliche Mittagsverpflegung'");

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenMittagsVerpflegung,
                SlotName = "schule_oder_kita",
                Order = 1,
                AngezeigterName = "Einrichtung",
                Options = new List<StringFormularFeldOption>() {
                    new("Schule"),
                    new StringFormularFeldOption("Kindertageseinrichtung (KiTa)"),
                    new("Kindertagespflege")
                },
                Anweisung =
                    "Für die Teilnahme an der gemeinschaftlichen Mittagsverpflegung in der Schule, Kindertageseinrichtung oder Kindertagespflege ist die BuT-Berechtigung bei der Anbieter*in oder dem Anbieter vorzulegen. Diese/ dieser rechnet entstehende Kosten direkt mit dem zuständigen Leistungsträger ab.",
                Encrypted = false,
            }
        );

        #endregion

        #region EintaegigerAusflug

        var relevantWhenEintaegigerAusflug =
            new BoolExpression("slot('beantragteLeistung') == 'Teilnahme an einem eintägigen Ausflug'");

        beantragteLeistungenSchritt.Felder.Add(
            new DateFormularFeld() {
                IstRelevant = relevantWhenEintaegigerAusflug,
                SlotName = "datum_des_ausflug",
                Order = 1,
                AngezeigterName = "Datum des Ausfluges",
                Anweisung =
                    "Bitte geben Sie das Datum des Ausfluges an",
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenEintaegigerAusflug,
                SlotName = "kosten_des_ausflug",
                Order = 2,
                AngezeigterName = "Kosten des Ausfluges",
                Anweisung =
                    "Bitte geben Sie die voraussichtlichen Kosten des Ausfluges an",
                Encrypted = false,
            }
        );
        beantragteLeistungenSchritt.Felder.Add(
            new UploadFormularFeld() {
                IstRelevant = relevantWhenEintaegigerAusflug,
                SlotName = "informationsschreiben_ausflug",
                Order = 3,
                AngezeigterName = "Dokumentenanhänge",
                Anweisung =
                    "Bitte laden Sie das Informationsschreiben der Schule / Kita zum Ausflug hoch",
                Multi = true,
                Encrypted = false,
                Document = true,
            }
        );

        #endregion

        #region Klassenfahrt

        var relevantWhenKlassenfahrt =
            new BoolExpression("slot('beantragteLeistung') == 'Teilnahme an einer mehrtägigen Klassenfahrt'");

        beantragteLeistungenSchritt.Felder.Add(
            new DateFormularFeld() {
                IstRelevant = relevantWhenKlassenfahrt,
                SlotName = "beginn_der_Klassenfahrt",
                Order = 1,
                AngezeigterName = "Beginn der Klassenfahrt",
                Anweisung =
                    "Bitte geben Sie das Startdatum der Klassenfahrt an",
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new DateFormularFeld() {
                IstRelevant = relevantWhenKlassenfahrt,
                SlotName = "ende_der_Klassenfahrt",
                Order = 2,
                AngezeigterName = "Ende der Klassenfahrt",
                Anweisung =
                    "Bitte geben Sie das Enddatum der Klassenfahrt an",
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenKlassenfahrt,
                SlotName = "kosten_der_Klassenfahrt",
                Order = 3,
                AngezeigterName = "Kosten der Klassenfahrt",
                Anweisung =
                    "Bitte geben Sie die voraussichtlichen Kosten der Klassenfahrt an",
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new UploadFormularFeld() {
                IstRelevant = relevantWhenKlassenfahrt,
                SlotName = "informationsschreiben_klassenfahrt",
                Order = 4,
                AngezeigterName = "Dokumentenanhänge",
                Anweisung =
                    "Bitte laden Sie das Informationsschreiben der Schule zur Klassenfahrt hoch",
                Multi = true,
                Encrypted = false,
                Document = true,
            }
        );

        #endregion

        #region Lernfoerderung

        var relevantWhenLernfoerderung =
            new BoolExpression("slot('beantragteLeistung') == 'Lernförderung'");

        beantragteLeistungenSchritt.Felder.Add(
            new UploadFormularFeld() {
                IstRelevant = relevantWhenLernfoerderung,
                SlotName = "ausgefuellter_vordruck_der_schule",
                Order = 1,
                AngezeigterName = "Dokumentenanhänge",
                Anweisung =
                    "Bitte laden Sie das ausgefüllte Formular der Schule hoch",
                Multi = true,
                Encrypted = false,
                Document = true,
            }
        );

        #endregion

        #region TeilnahmeAnSozialemUndKulturellemLeben

        var relevantWhenSozialUndKulturell =
            new BoolExpression(
                "slot('beantragteLeistung') == 'Teilnahme am sozialen und kulturellen Leben (bis zur Vollendung des 18. Lebensjahres)'");

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenSozialUndKulturell,
                SlotName = "aktivitaet",
                Order = 1,
                AngezeigterName = "Beschreibung der Aktivität",
                Anweisung =
                    "Bitte geben Sie die Aktivität an",
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenSozialUndKulturell,
                SlotName = "kosten_der_aktivität",
                Order = 2,
                AngezeigterName = "Monatliche Kosten",
                Anweisung =
                    "Bitte geben Sie die monatlichen Kosten der Aktivität an",
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new UploadFormularFeld() {
                IstRelevant = relevantWhenSozialUndKulturell,
                SlotName = "nachweis_ueber_geleisteten_beitrag",
                Order = 3,
                AngezeigterName = "Dokumentenanhänge",
                Anweisung =
                    "Bitte laden Sie eine Bescheinigung des Vereins oder der sozialen oder kulturellen Institution über den geleisteten Beitrag bzw. den zu leistenden Betrag hoch",
                Multi = true,
                Encrypted = false,
                Document = true,
            }
        );

        #endregion

        #region Schulbefoerderung

        var relevantWhenSchulbefoerderung =
            new BoolExpression(
                "slot('beantragteLeistung') == 'Schulbeförderung ab Klasse 11'");

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenSchulbefoerderung,
                SlotName = "von",
                Order = 1,
                AngezeigterName = "Von",
                Anweisung = "Von", // Todo bedder naming?
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenSchulbefoerderung,
                SlotName = "ort_der_schule",
                Order = 2,
                AngezeigterName = "Ort der Schule",
                Anweisung = "Bitte geben Sie den Ort der Schule an", // Todo ist Ort or Adresse wanted?
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenSchulbefoerderung,
                SlotName = "verkehrsmittel",
                Order = 3,
                AngezeigterName = "Verkehrsmittel",
                Anweisung =
                    "Bitte wählen Sie das Verkehrsmittel aus",
                Options = [new("Bus"), new("Bahn")],
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new StringFormularFeld {
                IstRelevant = relevantWhenSchulbefoerderung,
                SlotName = "kosten_der_befoerderung",
                Order = 4,
                AngezeigterName = "Monatliche Kosten",
                Anweisung =
                    "Bitte geben Sie die monatlichen Kosten der Beförderung an",
                Encrypted = false,
            }
        );

        beantragteLeistungenSchritt.Felder.Add(
            new UploadFormularFeld() {
                IstRelevant = relevantWhenSchulbefoerderung,
                SlotName = "fahrkarten_und_kundenkarte",
                Order = 6,
                AngezeigterName = "Dokumentenanhänge",
                Anweisung =
                    "Bitte laden Sie die Schulbescheinigung, Fahrkarten und die Vorder- und Rückseite der GVH-Kundenkarte hoch",
                Multi = true,
                Encrypted = false,
                Document = true,
            }
        );

        #endregion

        #region PersoenlicherSchulbedarf

        var relevantWhenSchulbasisPaket =
            new BoolExpression(
                "slot('beantragteLeistung') == 'Persönlicher Schulbedarf'");

        beantragteLeistungenSchritt.Felder.Add(
            new UploadFormularFeld() {
                IstRelevant = relevantWhenSchulbasisPaket,
                SlotName = "schulbescheinigung_persoenlicher_schulbedarf",
                Order = 1,
                AngezeigterName = "Dokumentenanhänge",
                Anweisung =
                    "Bitte laden Sie die Schulbescheinigung hoch",
                Multi = true,
                Encrypted = false,
                Document = true,
            }
        );

        #endregion

        List<FormularSchritt> formularSchritte = [aktenzeichenSchritt, datenDesKindes, beantragteLeistungenSchritt];
        var felder = formularSchritte.SelectMany(s => s.Felder).ToList();
        var dateiFelder = felder.Where(f => f.SlotValueType is SlotValueType.Upload);
        var jsonFelder = felder.Where(f => f.SlotValueType is not SlotValueType.Upload);
        var govManagerRestExportSchritt = new GovManagerRestExportSchritt {
            NodePosition = new NodePosition { X = 1296, Y = 164.5 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
            ExportParts = [
                .. dateiFelder.Select(f => new FilePart(f.SlotName)),
                new JsonPart(new JsonObject([
                    new JsonField("antragsart", new JsonStringValue("folgeantrag")),
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
            NodePosition = new NodePosition { X = 1596, Y = 152.5 },
            Felder = Array.Empty<FormularFeld>(),
            Titel = "Prüfung der Unterlagen",
        };

        var endeSchritt = new EndeSchritt {
            NodePosition = new NodePosition { X = 2120, Y = 164.5 },
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                MitarbeiterGruppeId = sachbearbeiterGruppeId,
            },
        };

        var schritte = new List<Schritt> {
            aktenzeichenSchritt,
            datenDesKindes,
            beantragteLeistungenSchritt,
            govManagerRestExportSchritt,
            pruefungSchritt,
            endeSchritt
        };

        var verbindungen = new List<Verbindung> {
            new() { Von = aktenzeichenSchritt, Nach = datenDesKindes },
            new() { Von = datenDesKindes, Nach = beantragteLeistungenSchritt },
            new() { Von = beantragteLeistungenSchritt, Nach = govManagerRestExportSchritt },
            new() {
                Von = govManagerRestExportSchritt,
                Nach = pruefungSchritt,
                StatusAenderung = "Antrag eingegangen",
                StatusAenderungBeschreibung = "Ihre Antrag ist bei uns eingegangen und wird nun von uns bearbeitet."
            },
            new() {
                Von = pruefungSchritt,
                Nach = endeSchritt,
                Name = "Prüfung erfolgreich",
                StatusAenderung = "Antrag erfolgreich",
                StatusAenderungBeschreibung = "Die Kosten werden direkt mit der Schule abgerechnet."
            },
        };

        return (schritte, verbindungen, Array.Empty<Ausfuehrung>());
    };

    /// <summary>
    /// Definiert den Seed für den Folgeantragsprozess mit eindeutiger ID, Name, Erstell-Funktion und Ausdrücken.
    /// </summary>
    public static readonly ProzessSeed ProzessSeed = new(
        new Guid("5d9e4e6b-4a8d-461e-a38e-fd15593ffb9a"),
        "Bildungs- und Teilhabeleistungen Folgeantrag",
        CreateProzess,
        new StringExpression("slot('beantragteLeistung')"));
}
