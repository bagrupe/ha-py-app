namespace API.Seeders.LageHelfer;

/// <summary>Inhalt von <c>seed.json</c> nach Validierung.</summary>
public sealed record LageHelferSeedDocument(
    int Version,
    Guid IdNamespace,
    LageHelferKommuneSeed Kommune,
    IReadOnlyList<LageHelferOrganisationseinheitSeed> Organisationseinheiten,
    LageHelferDemoSeed? Demo,
    IReadOnlyDictionary<string, string> BereichGeometrien,
    IReadOnlyList<LageHelferProzessSeed> Prozesse);

public sealed record LageHelferKommuneSeed(Guid Id, string Name);

public sealed record LageHelferOrganisationseinheitSeed(
    string Key,
    string Name,
    IReadOnlyList<LageHelferBereichSeed> Bereiche,
    IReadOnlyList<LageHelferAbteilungSeed> Abteilungen);

public sealed record LageHelferBereichSeed(
    string Key,
    string Name,
    string? Einsatzleitung,
    IReadOnlyList<string>? Einheiten = null);

public sealed record LageHelferAbteilungSeed(string Key, string Name);

/// <summary>Code-side process template that a <c>prozesse</c> entry in seed.json instantiates.</summary>
public enum LageHelferProzessVorlage {
    Ereignismeldung,
}

public sealed record LageHelferProzessSeed(
    string Key,
    LageHelferProzessVorlage Vorlage,
    string Name,
    IReadOnlyList<string> Tags,
    IReadOnlyList<string> Kategorien);

public sealed record LageHelferDemoSeed(string Passwort, IReadOnlyList<LageHelferDemoNutzerSeed> Nutzer);

public sealed record LageHelferDemoNutzerSeed(
    string Key,
    string Email,
    string Vorname,
    string Nachname,
    string Art,
    string? Organisationseinheit = null,
    string? EinsatzleitungBereich = null,
    IReadOnlyList<string>? Rechte = null,
    IReadOnlyList<string>? GlobaleRechte = null);
