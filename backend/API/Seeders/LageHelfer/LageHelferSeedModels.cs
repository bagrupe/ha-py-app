namespace API.Seeders.LageHelfer;

/// <summary>Inhalt von <c>seed.json</c> nach Validierung.</summary>
public sealed record LageHelferSeedDocument(
    int Version,
    Guid IdNamespace,
    LageHelferKommuneSeed Kommune,
    IReadOnlyList<LageHelferOrganisationseinheitSeed> Organisationseinheiten,
    LageHelferDemoSeed? Demo,
    IReadOnlyDictionary<string, string> BereichGeometrien);

public sealed record LageHelferKommuneSeed(Guid Id, string Name);

public sealed record LageHelferOrganisationseinheitSeed(
    string Key,
    string Name,
    IReadOnlyList<LageHelferBereichSeed> Bereiche,
    IReadOnlyList<LageHelferAbteilungSeed> Abteilungen);

public sealed record LageHelferBereichSeed(string Key, string Name, string? Einsatzleitung);

public sealed record LageHelferAbteilungSeed(string Key, string Name);

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
