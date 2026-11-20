namespace API.Features.Prozess;

/// <summary>
/// Marks the slots the app shows on public Mängelmelder/Ideenmelder entries as <c>OeffentlichSichtbar</c> on every
/// version of every process that was ever tagged public (same rule as <c>OnlyPublic</c>).
/// </summary>
public static class OeffentlichSichtbarBackfill {
    /// <summary>Slot names the app reads on public surfaces.</summary>
    public static readonly string[] SlotNames = ["titel", "beschreibung", "adresse", "bilder", "kategorie", "_wurzel"];

    private static string InList(string[] values) => string.Join(", ", values.Select(v => $"'{v}'"));

    /// <summary>The UPDATE statement run by the migration.</summary>
    public static readonly string Sql = $"""
        UPDATE "FormularFelder" f
        SET "OeffentlichSichtbar" = true
        WHERE f."SlotName" IN ({InList(SlotNames)})
          AND EXISTS (
            SELECT 1
            FROM "Schritte" s
            JOIN "ProzessVersionen" v ON v."Id" = s."ProzessVersionId"
            JOIN "ProzessTagHistorie" h ON h."ProzessId" = v."ProzessId"
            JOIN "ProzessTags" t ON t."Id" = h."TagId"
            WHERE s."Id" = f."SchrittId" AND t."Tag" IN ({InList(AusfuehrungQueryableExtensions.PublicTags)})
          );
        """;
}
