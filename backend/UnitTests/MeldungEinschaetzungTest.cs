using API.Features.Lage;

namespace IntegrationTests;

public class MeldungEinschaetzungTest {
    [Theory]
    [InlineData("Baum liegt quer über der Fahrbahn", MeldungKlasse.A, "Motorkettensäge", false)]
    [InlineData("Dachziegel lose, fallen auf Gehweg", MeldungKlasse.A, "Drehleiter,Absperrung", false)]
    [InlineData("Keller vollgelaufen, ca. 30 cm Wasser", MeldungKlasse.C, "Pumpe", false)]
    [InlineData("Mehrere Bäume auf Waldweg", MeldungKlasse.D, "Motorkettensäge,Radlader", false)]
    [InlineData("Großer Ast auf Spielplatz", MeldungKlasse.B, "Motorkettensäge", false)]
    [InlineData("Baum aufs Haus gefallen, Nachbarin noch drin", MeldungKlasse.A, "Motorkettensäge,Drehleiter,Absperrung", true)]
    public void Assesses_class_equipment_and_emergency_from_the_description(string beschreibung,
        MeldungKlasse klasse, string ausruestung, bool notfall) {
        var einschaetzung = MeldungEinschaetzung.Einschaetzen("Unwetter", beschreibung);

        Assert.Equal(klasse, einschaetzung.Klasse);
        Assert.Equal(ausruestung.Split(','), einschaetzung.BenoetigteAusruestung);
        Assert.Equal(notfall, einschaetzung.MoeglicherNotfall);
    }

    [Theory]
    [InlineData("HLF 20 Hameln", "Motorkettensäge,Pumpe,Absperrung")]
    [InlineData("MTW Coppenbrügge", "Motorkettensäge")]
    [InlineData("Bagger Bauhof", "")]
    public void Derives_standard_equipment_from_the_vehicle_type(string name, string ausruestung) =>
        Assert.Equal(ausruestung.Split(',', StringSplitOptions.RemoveEmptyEntries), Fahrzeugausstattung.Standard(name));
}
