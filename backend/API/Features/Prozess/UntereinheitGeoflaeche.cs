namespace API.Features.Prozess;

/// <summary>
/// Der Name der Geofläche in der Geo-Kartierung (bereich-b) deckt sich nicht mit dem vollen Namen der
/// Untereinheit (z.B. Geofläche "BadMuender" vs. Untereinheit "Bad Münder am Deister") - keine persistierte
/// Zuordnung zwischen beidem, daher diese feste Zuordnung als einzige Quelle.
/// </summary>
public static class UntereinheitGeoflaeche {
    public static readonly Dictionary<string, string> NameByUntereinheitName = new() {
        ["Hameln"] = "Hameln",
        ["Bad Münder am Deister"] = "BadMuender",
        ["Bad Pyrmont"] = "BadPyrmont",
        ["Hessisch Oldendorf"] = "HessischOldendorf",
        ["Emmerthal"] = "Emmertahl",
        ["Coppenbrügge"] = "Coppenbruegge",
        ["Salzhemmendorf"] = "Salzhemmendorf",
        ["Aerzen"] = "Aerzen",
    };
}
