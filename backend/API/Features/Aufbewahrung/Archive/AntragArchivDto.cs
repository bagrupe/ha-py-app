using API.Features.GovManager;
using API.Features.PmPayment;
using API.Features.Prozess;

namespace API.Features.Aufbewahrung.Archive;

/// <summary>
/// Selbst-enthaltende, serialisierbare Abbildung eines Antrags für das Archiv.
/// Enthält die weiterhin VERSCHLÜSSELTEN Inhalte; Zeitstempel werden als ISO-Strings
/// gespeichert, um von NodaTime-spezifischer JSON-Konfiguration unabhängig zu sein.
/// Enthält neben den Bearbeitungen auch VerlaufsEintraege/PaymentRequests/GovManagerRequests -
/// diese hängen per Cascade-Delete an der Ausführung und würden beim Entfernen aus der Live-DB
/// sonst unwiederbringlich verloren gehen (Review-Feedback von Loic Ishimwe, MR 324).
/// </summary>
public record AntragArchivDto(
    Guid Id,
    Guid ProzessVersionId,
    AusfuehrungStatus Status,
    string CreatedAt,
    string? AbgeschlossenAm,
    string SharedKeyEncryptedForBuerger,
    string SharedKeyEncryptedForKommune,
    List<BearbeitungArchivDto> Bearbeitungen,
    List<VerlaufsEintragArchivDto> VerlaufsEintraege,
    List<PaymentRequestArchivDto> PaymentRequests,
    List<GovManagerRequestArchivDto> GovManagerRequests) {
    public static AntragArchivDto From(
        Ausfuehrung a,
        IReadOnlyList<VerlaufsEintrag> verlaufsEintraege,
        IReadOnlyList<PaymentRequest> paymentRequests,
        IReadOnlyList<GovManagerRequest> govManagerRequests) => new(
        a.Id,
        a.ProzessVersionId,
        a.Status,
        a.CreatedAt.ToString(),
        a.AbgeschlossenAm?.ToString(),
        a.SharedKeyEncryptedForBuerger,
        a.SharedKeyEncryptedForKommune,
        a.Bearbeitungen.Select(BearbeitungArchivDto.From).ToList(),
        verlaufsEintraege.Select(VerlaufsEintragArchivDto.From).ToList(),
        paymentRequests.Select(PaymentRequestArchivDto.From).ToList(),
        govManagerRequests.Select(GovManagerRequestArchivDto.From).ToList());
}

public record VerlaufsEintragArchivDto(
    Guid Id,
    string CreatedAt,
    VerlaufsEreignisArt Art,
    Guid? BenutzerId,
    string? BenutzerName,
    string? Zielbeschreibung,
    string? Nachricht) {
    public static VerlaufsEintragArchivDto From(VerlaufsEintrag v) => new(
        v.Id,
        v.CreatedAt.ToString(),
        v.Art,
        v.BenutzerId,
        v.BenutzerName,
        v.Zielbeschreibung,
        v.Nachricht);
}

public record PaymentRequestArchivDto(
    Guid Id,
    Guid BezahlenSchrittId,
    string CreatedAt,
    string? CompletedAt,
    bool? Success,
    string? PaymentMethod) {
    public static PaymentRequestArchivDto From(PaymentRequest p) => new(
        p.Id,
        p.BezahlenSchrittId,
        p.CreatedAt.ToString("O"),
        p.CompletedAt?.ToString("O"),
        p.Success,
        p.PaymentMethod);
}

public record GovManagerRequestArchivDto(
    Guid Id,
    Guid GovManagerSchrittId,
    string CreatedAt,
    string? CompletedAt,
    bool? Success,
    string? ResponseBody) {
    public static GovManagerRequestArchivDto From(GovManagerRequest g) => new(
        g.Id,
        g.GovManagerSchrittId,
        g.CreatedAt.ToString("O"),
        g.CompletedAt?.ToString("O"),
        g.Success,
        g.ResponseBody);
}

public record BearbeitungArchivDto(
    Guid Id,
    Guid SchrittId,
    Guid UserId,
    string CreatedAt,
    List<SlotValueArchivDto> SlotValues) {
    public static BearbeitungArchivDto From(Bearbeitung b) => new(
        b.Id,
        b.SchrittId,
        b.UserId,
        b.CreatedAt.ToString(),
        (b.SlotValues ?? new List<SlotValue>()).Select(SlotValueArchivDto.From).ToList());
}

public record SlotValueArchivDto(
    Guid Id,
    string SlotName,
    bool? IstFreigegeben,
    string Typ,
    object? Value) {
    public static SlotValueArchivDto From(SlotValue sv) => sv switch {
        EncryptedSlotValue e => new(e.Id, e.SlotName, e.IstFreigegeben, "Encrypted", e.Value),
        PlainSlotValue p => new(p.Id, p.SlotName, p.IstFreigegeben, "Plain", p.Value),
        _ => new(sv.Id, sv.SlotName, sv.IstFreigegeben, "Unknown", null),
    };
}
