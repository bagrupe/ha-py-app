using API.Features.Prozess.Mutations;

namespace API.Features.Prozess;

/// <summary>
/// Liest den aktuell veröffentlichten Prozessgraphen einer <see cref="ProzessVersion"/> und wandelt ihn in
/// die Input-Records von <see cref="NeueProzessVersionErstellenMutation.ProzessVersionErstellen"/> um - die
/// Gegenrichtung zu <see cref="MapperlyMapper"/> (die nur Input → Entity kennt). Deckt bewusst nur die
/// Schritt-/Feld-Typen ab, die "Mängelmelder-Version-2" heute tatsächlich verwendet, und wirft für jeden
/// anderen Typ eine klare Exception, statt ihn stillschweigend zu verwerfen oder falsch zu übernehmen.
/// </summary>
public static class ProzessGraphReader {
    public static (List<SchrittInput> Schritte, List<VerbindungInput> Verbindungen, List<ZustaendigkeitRolleInput> Rollen) ReadCurrentGraph(ProzessVersion version) {
        var schritte = version.Schritte.Select(ToSchrittInput).ToList();
        var verbindungen = version.Schritte.SelectMany(s => s.Verbindungen).Select(ToVerbindungInput).ToList();
        var rollen = version.Rollen.Select(r => new ZustaendigkeitRolleInput(r.Id, r.Name)).ToList();
        return (schritte, verbindungen, rollen);
    }

    private static SchrittInput ToSchrittInput(Schritt schritt) => schritt switch {
        FormularSchritt f => new SchrittInput(
            FormularSchrittInput: new FormularSchrittInput(
                f.Id, f.Titel, f.Anweisung, ToSollZustaendigkeitInput(f.SollZustaendigkeit), f.VersendeEMailAnMitarbeiterGruppe,
                f.Felder.OrderBy(feld => feld.Order).Select(ToFormularFeldInput).ToList(),
                ToNodePositionInput(f.NodePosition), f.SchreibtRolleId),
            BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null, ProgrammatischerSchrittInput: null,
            EndeSchrittInput: null, NachrichtSchrittInput: null, EmailForwardSchrittInput: null,
            GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
        ProgrammatischerSchritt p => new SchrittInput(
            FormularSchrittInput: null, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
            ProgrammatischerSchrittInput: new ProgrammatischerSchrittInput(
                p.Id, p.Titel, p.Anweisung, ToSollZustaendigkeitInput(p.SollZustaendigkeit), p.VersendeEMailAnMitarbeiterGruppe,
                p.ImplementationAssemblyQualifiedName, ToNodePositionInput(p.NodePosition), p.SchreibtRolleId),
            EndeSchrittInput: null, NachrichtSchrittInput: null, EmailForwardSchrittInput: null,
            GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
        EndeSchritt e => new SchrittInput(
            FormularSchrittInput: null, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
            ProgrammatischerSchrittInput: null,
            EndeSchrittInput: new EndeSchrittInput(
                e.Id, e.Titel, e.Anweisung, ToSollZustaendigkeitInput(e.SollZustaendigkeit), e.VersendeEMailAnMitarbeiterGruppe,
                ToNodePositionInput(e.NodePosition), e.SchreibtRolleId),
            NachrichtSchrittInput: null, EmailForwardSchrittInput: null,
            GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
        NachrichtSchritt n => new SchrittInput(
            FormularSchrittInput: null, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
            ProgrammatischerSchrittInput: null, EndeSchrittInput: null,
            NachrichtSchrittInput: new NachrichtSchrittInput(
                n.Id, n.Titel, n.Anweisung, ToSollZustaendigkeitInput(n.SollZustaendigkeit), n.VersendeEMailAnMitarbeiterGruppe,
                ToNodePositionInput(n.NodePosition), n.SchreibtRolleId),
            EmailForwardSchrittInput: null,
            GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
        _ => throw new NotSupportedException(
            $"Der Schritt-Typ '{schritt.GetType().Name}' (Schritt {schritt.Id}) wird vom Kategoriebaum-Sync-Export " +
            "nicht unterstützt. Unterstützt sind aktuell nur FormularSchritt, ProgrammatischerSchritt, EndeSchritt und " +
            "NachrichtSchritt, da 'Mängelmelder-Version-2' aktuell keine anderen Schritt-Typen verwendet. Falls das " +
            $"nicht mehr stimmt, muss {nameof(ProzessGraphReader)} entsprechend erweitert werden.")
    };

    private static FormularFeldInput ToFormularFeldInput(FormularFeld feld) => feld switch {
        StringFormularFeld s => new FormularFeldInput(
            CheckboxListFormularFeldInput: null,
            StringFormularFeldInput: new StringFormularFeldInput(
                s.Id, s.SlotName, s.AngezeigterName, s.Anweisung, s.Order, s.Encrypted, s.InhaltsTag, s.IstRelevant, s.Pflichtfeld,
                s.Multiline, s.Options.ToArray(), s.OeffentlichSichtbar, s.Durchsuchbar),
            UploadFormularFeldInput: null, LocationFormularFeldInput: null, DateFormularFeldInput: null,
            SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
        LocationFormularFeld l => new FormularFeldInput(
            CheckboxListFormularFeldInput: null, StringFormularFeldInput: null, UploadFormularFeldInput: null,
            LocationFormularFeldInput: new LocationFormularFeldInput(
                l.Id, l.SlotName, l.AngezeigterName, l.Anweisung, l.Order, l.Encrypted, l.InhaltsTag, l.IstRelevant, l.Pflichtfeld, l.OeffentlichSichtbar),
            DateFormularFeldInput: null, SignatureFormularFeldInput: null, TimeFormularFeldInput: null,
            AnzeigeTextBlockFormularFeldInput: null),
        UploadFormularFeld u => new FormularFeldInput(
            CheckboxListFormularFeldInput: null, StringFormularFeldInput: null,
            UploadFormularFeldInput: new UploadFormularFeldInput(
                u.Id, u.SlotName, u.AngezeigterName, u.Anweisung, u.Order, u.Encrypted, u.InhaltsTag, u.IstRelevant, u.Pflichtfeld,
                u.Multi, u.Document, u.BrauchtFreigabe, u.OeffentlichSichtbar, u.MaxAnzahl),
            LocationFormularFeldInput: null, DateFormularFeldInput: null, SignatureFormularFeldInput: null,
            TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
        CheckboxListFormularFeld c => new FormularFeldInput(
            CheckboxListFormularFeldInput: new CheckboxListFormularFeldInput(
                c.Id, c.SlotName, c.AngezeigterName, c.Anweisung, c.Order, c.Encrypted, c.InhaltsTag, c.IstRelevant, c.Pflichtfeld,
                c.Options.Select(o => new CheckboxListFeldOptionInput(o.Key, o.Label, o.Order, o.DefaultChecked)).ToList(), c.OeffentlichSichtbar),
            StringFormularFeldInput: null, UploadFormularFeldInput: null, LocationFormularFeldInput: null,
            DateFormularFeldInput: null, SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
        DateFormularFeld d => new FormularFeldInput(
            CheckboxListFormularFeldInput: null, StringFormularFeldInput: null, UploadFormularFeldInput: null, LocationFormularFeldInput: null,
            DateFormularFeldInput: new DateFormularFeldInput(
                d.Id, d.SlotName, d.AngezeigterName, d.Anweisung, d.Order, d.Encrypted, d.InhaltsTag, d.IstRelevant, d.Pflichtfeld, d.OeffentlichSichtbar),
            SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
        SignatureFormularFeld sig => new FormularFeldInput(
            CheckboxListFormularFeldInput: null, StringFormularFeldInput: null, UploadFormularFeldInput: null, LocationFormularFeldInput: null,
            DateFormularFeldInput: null,
            SignatureFormularFeldInput: new SignatureFormularFeldInput(
                sig.Id, sig.SlotName, sig.AngezeigterName, sig.Anweisung, sig.Order, sig.Encrypted, sig.InhaltsTag, sig.IstRelevant, sig.Pflichtfeld, sig.OeffentlichSichtbar),
            TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
        TimeFormularFeld t => new FormularFeldInput(
            CheckboxListFormularFeldInput: null, StringFormularFeldInput: null, UploadFormularFeldInput: null, LocationFormularFeldInput: null,
            DateFormularFeldInput: null, SignatureFormularFeldInput: null,
            TimeFormularFeldInput: new TimeFormularFeldInput(
                t.Id, t.SlotName, t.AngezeigterName, t.Anweisung, t.Order, t.Encrypted, t.InhaltsTag, t.IstRelevant, t.Pflichtfeld, t.OeffentlichSichtbar),
            AnzeigeTextBlockFormularFeldInput: null),
        AnzeigeTextBlockFeld a => new FormularFeldInput(
            CheckboxListFormularFeldInput: null, StringFormularFeldInput: null, UploadFormularFeldInput: null, LocationFormularFeldInput: null,
            DateFormularFeldInput: null, SignatureFormularFeldInput: null, TimeFormularFeldInput: null,
            AnzeigeTextBlockFormularFeldInput: new AnzeigeTextBlockFormularFeldInput(
                a.Id, a.SlotName, a.AngezeigterName, a.Anweisung, a.Order, a.Encrypted, a.InhaltsTag, a.Text, a.IstRelevant, a.Pflichtfeld, a.OeffentlichSichtbar)),
        _ => throw new NotSupportedException(
            $"Der Formularfeld-Typ '{feld.GetType().Name}' (Feld {feld.Id}, Slot '{feld.SlotName}') wird vom " +
            "Kategoriebaum-Sync-Export nicht unterstützt.")
    };

    private static VerbindungInput ToVerbindungInput(Verbindung v) =>
        new(v.Id, v.VonId, v.NachId, v.Name, v.StatusAenderung, v.StatusAenderungBeschreibung, v.IstRelevant);

    private static SchrittSollZustaendigkeitInput ToSollZustaendigkeitInput(Zustaendigkeit z) =>
        new(z.Art, z.DienstleisterId, z.OrganisationseinheitId, z.MitarbeiterGruppeId, z.LiestRolleId, z.DynamischeArten);

    private static NodePositionInput? ToNodePositionInput(NodePosition? np) =>
        np is null ? null : new NodePositionInput(np.X, np.Y);
}
