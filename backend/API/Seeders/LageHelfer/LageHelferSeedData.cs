using NGuid;

namespace API.Seeders.LageHelfer;

/// <summary>
/// Deterministische ID-Ableitung für LageHelfer-Seed-Daten (Schlüssel stehen in <c>seed.json</c>).
/// </summary>
public static class LageHelferSeedData {
    /// <summary>Leitet die ID einer Organisationseinheit (Landkreis) ab.</summary>
    public static Guid OrganisationseinheitId(Guid idNamespace, string key) => DeriveId(idNamespace, $"landkreis:{key}");

    /// <summary>Leitet die ID der Einsatzleitung-Abteilung (Mitarbeitergruppe) eines Bereichs ab.</summary>
    public static Guid EinsatzleitungId(Guid idNamespace, string bereichKey) =>
        DeriveId(idNamespace, $"einsatzleitung:{bereichKey}");

    /// <summary>Leitet die ID des Gebiets eines Bereichs ab.</summary>
    public static Guid GebietId(Guid idNamespace, string bereichKey) => DeriveId(idNamespace, $"gebiet:{bereichKey}");

    /// <summary>Leitet die ID der Abteilung einer Organisationseinheit ab.</summary>
    public static Guid AbteilungId(Guid idNamespace, string organisationseinheitKey) =>
        DeriveId(idNamespace, $"abteilung:{organisationseinheitKey}");

    /// <summary>Leitet die ID eines Demo-Nutzers ab.</summary>
    public static Guid NutzerId(Guid idNamespace, string nutzerKey) => DeriveId(idNamespace, $"nutzer:{nutzerKey}");

    /// <summary>Leitet die ID eines Prozesses ab.</summary>
    public static Guid ProzessId(Guid idNamespace, string prozessKey) => DeriveId(idNamespace, $"prozess:{prozessKey}");

    /// <summary>
    /// Leitet die ID einer Prozessversion aus ihrem Inhalt ab: gleicher Inhalt, gleiche Version; jede Änderung
    /// erzeugt eine neue Version, sodass laufende Anträge auf ihrer alten Version bleiben.
    /// </summary>
    public static Guid ProzessVersionId(Guid idNamespace, string prozessKey, string fingerprint) =>
        DeriveId(idNamespace, $"prozess:{prozessKey}:version:{fingerprint}");

    /// <summary>Leitet die ID eines neu angelegten Prozess-Tags ab; vorhandene Tags werden über ihren Namen gefunden.</summary>
    public static Guid TagId(Guid idNamespace, string tag) => DeriveId(idNamespace, $"tag:{tag}");

    internal static Guid DeriveId(Guid idNamespace, string source) => GuidHelpers.CreateFromName(idNamespace, source);
}
