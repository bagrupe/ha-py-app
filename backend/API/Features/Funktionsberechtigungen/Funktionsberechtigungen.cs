using System.Reflection;
using API.Features.Auth;

namespace API.Features.Funktionsberechtigungen;

/// <summary>Definiert globale Funktionsberechtigungen im System.</summary>
public enum GlobaleFunktionsberechtigung {
    [Funktionsberechtigung(Name = "Prozessverwaltung", Beschreibung = "Kann Prozesse verwalten", Gruppe = "Global", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    Prozessverwaltung,

    [Funktionsberechtigung(Name = "Anträge löschen", Beschreibung = "Kann Anträge löschen und wiederherstellen", Gruppe = "Global", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    AntragLoeschung,

    [Funktionsberechtigung(Name = "Aufbewahrung verwalten", Beschreibung = "Kann Aufbewahrungsfristen und Lösch-/Archiv-Jobs verwalten", Gruppe = "Global", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    AufbewahrungVerwaltung,

    [Funktionsberechtigung(Name = "Archiv", Beschreibung = "Kann archivierte Anträge einsehen (schreibgeschützt)", Gruppe = "Global", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    ArchivEinsicht,

    [Funktionsberechtigung(Name = "Ehrenamtsbank", Beschreibung = "Kann Ehrenamtsbank-Einträge moderieren", Gruppe = "Global", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    Ehrenamtsbank,

    [Funktionsberechtigung(Name = "LageHelfer", Beschreibung = "Kann Lagen, Gebiete und deren Einsatzleitungen verwalten", Gruppe = "Global", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    LageHelfer,
}

/// <summary>Definiert Funktionsberechtigungen, die an Organisationseinheiten gebunden sind.</summary>
public enum FunktionsberechtigungInOrganisationseinheit {
    [Funktionsberechtigung(Name = "Backoffice", Beschreibung = "Zugriff auf das Backoffice", Gruppe = "Backoffice", Virtuell = true)]
    Backoffice,
    [Funktionsberechtigung(Name = "Anträge", Beschreibung = "Kann Anträge bearbeiten", Gruppe = "Backoffice", NutzerArtMindestens = BackofficeNutzerArt.Dienstleister)]
    BackofficeAntraege,
    [Funktionsberechtigung(Name = "Nutzendenverwaltung", Beschreibung = "Kann Nutzende verwalten", Gruppe = "Backoffice", NutzerArtMindestens = BackofficeNutzerArt.Admin)]
    BackofficeNutzendenverwaltung,
    [Funktionsberechtigung(Name = "Dienstleisterverwaltung", Beschreibung = "Kann externe Dienstleister verwalten", Gruppe = "Backoffice", NutzerArtMindestens = BackofficeNutzerArt.Admin)]
    BackofficeDienstleisterverwaltung,
    [Funktionsberechtigung(Name = "Mängelmelder-Kategoriebaum", Beschreibung = "Kann den Mängelmelder-Kategoriebaum und die Zuständigkeiten darin für die eigene Untereinheit verwalten", Gruppe = "Backoffice", NutzerArtMindestens = BackofficeNutzerArt.Admin)]
    MaengelmelderZustaendigkeitsverwaltung,
    [Funktionsberechtigung(Name = "Inhaltspflege", Beschreibung = "Zugriff auf die Inhaltspflege", Gruppe = "Inhaltspflege", Virtuell = true)]
    Inhaltspflege,
    [Funktionsberechtigung(Name = "News-Artikel", Beschreibung = "Kann News-Artikel verwalten", Gruppe = "Inhaltspflege", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    InhaltspflegeNewsArtikel,
    [Funktionsberechtigung(Name = "Wettermesspunkte", Beschreibung = "Kann Wettermesspunkte verwalten", Gruppe = "Inhaltspflege", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    InhaltspflegeWettermesspunkte,
    [Funktionsberechtigung(Name = "Geoflächen", Beschreibung = "Kann Geoflächen verwalten", Gruppe = "Inhaltspflege", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    InhaltspflegeGeoflaechen,
    [Funktionsberechtigung(Name = "POIs", Beschreibung = "Kann POIs (Points of Interest) verwalten", Gruppe = "Inhaltspflege", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    InhaltspflegePois,
    [Funktionsberechtigung(Name = "Integrationen", Beschreibung = "Kann Integrationen verwalten", Gruppe = "Inhaltspflege", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    InhaltspflegeIntegrationen,
    [Funktionsberechtigung(Name = "Veranstaltungen", Beschreibung = "Kann Veranstaltungen verwalten", Gruppe = "Inhaltspflege", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    InhaltspflegeVeranstaltungen,
    [Funktionsberechtigung(Name = "Sensoren", Beschreibung = "Kann Sensoren verwalten", Gruppe = "Inhaltspflege", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    InhaltspflegeSensoren,
    [Funktionsberechtigung(Name = "Aufrufe", Beschreibung = "Kann Aufrufe verwalten", Gruppe = "Inhaltspflege", NutzerArtMindestens = BackofficeNutzerArt.Nutzer)]
    InhaltspflegeAufrufe,
}

/// <summary>Attribut zur Beschreibung von Funktionsberechtigungen an Enum-Feldern.</summary>
[AttributeUsage(AttributeTargets.Field)]
class FunktionsberechtigungAttribute : Attribute {
    /// <summary>Name der Funktionsberechtigung.</summary>
    public required string Name;
    /// <summary>Beschreibung der Funktionsberechtigung.</summary>
    public required string Beschreibung { get; init; } = "";
    /// <summary>Gruppe, zu der die Funktionsberechtigung gehört.</summary>
    public string Gruppe { get; init; } = "";

    /// <summary>Gibt an, ob die Berechtigung virtuell und nicht direkt zuweisbar ist.</summary>
    public bool Virtuell { get; init; } = false;

    /// <summary>Erforderliche Nutzerart für diese Berechtigung.</summary>
    public BackofficeNutzerArt NutzerArtMindestens { get; init; } = BackofficeNutzerArt.Nutzer;

    /// <summary>Gibt an, ob die Berechtigung implizit und nicht entfernbar ist.</summary>
    public bool Implizit { get; init; } = false;
}

/// <summary>Repräsentiert Metadaten einer Funktionsberechtigung.</summary>
/// <typeparam name="TValue">Typ der Funktionsberechtigung.</typeparam>
/// <param name="Value">Der Enum-Wert der Berechtigung.</param>
/// <param name="Name">Name der Berechtigung.</param>
/// <param name="Description">Beschreibung der Berechtigung.</param>
/// <param name="GroupName">Gruppenname der Berechtigung.</param>
/// <param name="NutzerArtMindestens">Erforderliche Nutzerart.</param>
/// <param name="Virtuell">Gibt an, ob die Berechtigung virtuell ist.</param>
/// <param name="Implizit">Gibt an, ob die Berechtigung implizit ist.</param>
public record FunktionsberechtigungMetadata<TValue>(
    TValue Value,
    string Name,
    string Description,
    string GroupName,
    BackofficeNutzerArt NutzerArtMindestens,
    [property: GraphQLIgnore] bool Virtuell,
    bool Implizit
);

/// <summary>Bietet Erweiterungsmethoden zur Ermittlung von Metadaten für Funktionsberechtigungen.</summary>
public static class MetadataExtensions {
    /// <summary>Ermittelt Metadaten für eine globale Funktionsberechtigung.</summary>
    /// <param name="berechtigung">Die globale Funktionsberechtigung.</param>
    /// <returns>Metadaten der Berechtigung.</returns>
    public static FunktionsberechtigungMetadata<GlobaleFunktionsberechtigung> GetMetadata(this GlobaleFunktionsberechtigung berechtigung) {
        return GetMetadata<GlobaleFunktionsberechtigung>(berechtigung);
    }

    /// <summary>Ermittelt Metadaten für eine Funktionsberechtigung in einer Organisationseinheit.</summary>
    /// <param name="berechtigung">Die Funktionsberechtigung in der Organisationseinheit.</param>
    /// <returns>Metadaten der Berechtigung.</returns>
    public static FunktionsberechtigungMetadata<FunktionsberechtigungInOrganisationseinheit> GetMetadata(this FunktionsberechtigungInOrganisationseinheit berechtigung) {
        return GetMetadata<FunktionsberechtigungInOrganisationseinheit>(berechtigung);
    }

    private static FunktionsberechtigungMetadata<T> GetMetadata<T>(T berechtigung) where T : Enum {
        var enumType = typeof(T);
        var member = enumType.GetMember(berechtigung.ToString()).First();
        var attr = member.GetCustomAttribute<FunktionsberechtigungAttribute>() ?? throw new InvalidOperationException();
        return new FunktionsberechtigungMetadata<T>(
            berechtigung,
            attr.Name,
            attr.Beschreibung,
            attr.Gruppe,
            attr.NutzerArtMindestens,
            attr.Virtuell,
            attr.Implizit
        );
    }
}
