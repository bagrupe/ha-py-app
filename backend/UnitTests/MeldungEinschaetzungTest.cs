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
    [InlineData("Ast auf dem Gehweg, ohne Lebensgefahr", false)]
    [InlineData("Niemand verletzt, Baum liegt quer", false)]
    [InlineData("Es sind keine Personen eingeklemmt", false)]
    [InlineData("Es besteht keine akute Lebensgefahr", false)]
    [InlineData("Baum auf Auto, Fahrer verletzt", true)]
    [InlineData("Keine Ahnung, ob jemand eingeklemmt ist", true)]
    [InlineData("Weiß nicht ob jemand verletzt ist", true)]
    [InlineData("Mann nicht ansprechbar und blutet", true)]
    [InlineData("Kein Strom, aber Nachbar ist verletzt", true)]
    public void Negation_in_the_same_clause_clears_an_emergency_but_doubt_keeps_it(string beschreibung, bool notfall) =>
        Assert.Equal(notfall, MeldungEinschaetzung.Einschaetzen("Unwetter", beschreibung).MoeglicherNotfall);

    [Fact]
    public void Negated_urgency_and_equipment_do_not_count() {
        var einschaetzung = MeldungEinschaetzung.Einschaetzen("Unwetter", "Ast an der Straße, Fahrbahn nicht blockiert, kein Wasser");

        Assert.Equal(MeldungKlasse.B, einschaetzung.Klasse);
        Assert.Equal(["Motorkettensäge"], einschaetzung.BenoetigteAusruestung);
    }

    [Theory]
    [InlineData("HLF 20 Hameln", "Motorkettensäge,Pumpe,Absperrung")]
    [InlineData("MTW Coppenbrügge", "Motorkettensäge")]
    [InlineData("Bagger Bauhof", "")]
    public void Derives_standard_equipment_from_the_vehicle_type(string name, string ausruestung) =>
        Assert.Equal(ausruestung.Split(',', StringSplitOptions.RemoveEmptyEntries), Fahrzeugausstattung.Standard(name));
}
