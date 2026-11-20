using API.Features.Prozess;

namespace UnitTests;

public class VerlaufDarstellungTest {
    [Theory]
    [InlineData(VerlaufsEreignisArt.Eingang, "Antrag eingegangen")]
    [InlineData(VerlaufsEreignisArt.Uebernahme, "Vorgang übernommen")]
    [InlineData(VerlaufsEreignisArt.WeiterleitungAnsicht, "Weiterleitung zur Ansicht")]
    [InlineData(VerlaufsEreignisArt.WeiterleitungAbgabe, "Weiterleitung zur Abgabe")]
    [InlineData(VerlaufsEreignisArt.WeiterleitungDienstleister, "Weiterleitung an Dienstleister")]
    [InlineData(VerlaufsEreignisArt.WeiterleitungOrganisationseinheit, "Weiterleitung an Organisationseinheit")]
    [InlineData(VerlaufsEreignisArt.Zustaendigkeitswechsel, "Zuständigkeitswechsel")]
    [InlineData(VerlaufsEreignisArt.Abschluss, "Vorgang abgeschlossen")]
    public void RendersStatusAenderungLabelForEachArt(VerlaufsEreignisArt art, string expected) {
        var (statusAenderung, _) = VerlaufDarstellung.Render(art, benutzerName: null, ziel: null);
        Assert.Equal(expected, statusAenderung);
    }

    [Fact]
    public void UebernahmeBeschreibungEnthaeltBenutzerName() {
        var (_, beschreibung) = VerlaufDarstellung.Render(VerlaufsEreignisArt.Uebernahme, "M. Mustermann", ziel: null);
        Assert.Equal("Vorgang wurde von M. Mustermann übernommen", beschreibung);
    }

    [Fact]
    public void UebernahmeOhneBenutzerNameBleibtGenerisch() {
        var (_, beschreibung) = VerlaufDarstellung.Render(VerlaufsEreignisArt.Uebernahme, benutzerName: null, ziel: null);
        Assert.Equal("Vorgang wurde übernommen", beschreibung);
    }

    [Fact]
    public void WeiterleitungAnsichtBeschreibungEnthaeltZiel() {
        var (_, beschreibung) =
            VerlaufDarstellung.Render(VerlaufsEreignisArt.WeiterleitungAnsicht, "Sachbearbeiter", "Max Mustermann");
        Assert.Equal("Vorgang zur Ansicht an Max Mustermann weitergeleitet", beschreibung);
    }

    [Fact]
    public void WeiterleitungAbgabeBeschreibungEnthaeltZiel() {
        var (_, beschreibung) =
            VerlaufDarstellung.Render(VerlaufsEreignisArt.WeiterleitungAbgabe, "Sachbearbeiter", "Abteilung XY");
        Assert.Equal("Vorgang zur Bearbeitung an Abteilung XY weitergeleitet", beschreibung);
    }

    [Fact]
    public void DienstleisterBeschreibungEnthaeltZiel() {
        var (_, beschreibung) =
            VerlaufDarstellung.Render(VerlaufsEreignisArt.WeiterleitungDienstleister, "Sachbearbeiter", "ABC GmbH");
        Assert.Equal("Vorgang an Dienstleister ABC GmbH übergeben", beschreibung);
    }

    [Fact]
    public void OrganisationseinheitBeschreibungEnthaeltZiel() {
        var (_, beschreibung) =
            VerlaufDarstellung.Render(VerlaufsEreignisArt.WeiterleitungOrganisationseinheit, "Sachbearbeiter", "Hameln");
        Assert.Equal("Vorgang an Organisationseinheit Hameln übergeben", beschreibung);
    }

    [Fact]
    public void ZustaendigkeitswechselBeschreibungEnthaeltZiel() {
        var (_, beschreibung) =
            VerlaufDarstellung.Render(VerlaufsEreignisArt.Zustaendigkeitswechsel, "Sachbearbeiter", "B. Beispiel");
        Assert.Equal("Zuständigkeit geändert zu B. Beispiel", beschreibung);
    }
}
