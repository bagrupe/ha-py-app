using System.ComponentModel;
using API.Features.Email.Templates;

namespace API.Features.Email;

/// <summary>
/// Schnittstelle für E-Mail-Vorlagen mit Kommune-spezifischem Design.
/// </summary>
public interface IEmailTemplate : IComponent, IKommuneThemedTemplate {
}

/// <summary>
/// Repräsentiert eine E-Mail im Postausgang mit Empfänger, Inhalt und Anhängen.
/// </summary>
public class EmailOutboxItem {
    /// <summary>
    /// Eindeutige Identifikation der E-Mail.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// ID der zugehörigen Kommune.
    /// </summary>
    public Guid KommuneId { get; init; }

    /// <summary>
    /// Empfängeradresse der E-Mail.
    /// </summary>
    public required string RecipientEmail { get; set; }

    /// <summary>
    /// Betreff der E-Mail.
    /// </summary>
    public required string Subject { get; set; }

    /// <summary>
    /// HTML-Inhalt der E-Mail.
    /// </summary>
    public required string Html { get; set; }

    /// <summary>
    /// Textinhalt der E-Mail.
    /// </summary>
    public required string Text { get; set; }

    private List<EmailAttachment> _attachments = [];

    /// <summary>
    /// Liste der Anhänge zur E-Mail.
    /// </summary>
    public List<EmailAttachment> Attachments {
        get => _attachments;
        init {
            _attachments = value;
            NumberOfAttachments = value.Count;
        }
    }

    /// <summary>
    /// Anzahl der Anhänge.
    /// </summary>
    public int NumberOfAttachments { get; private set; }

    /// <summary>
    /// Anzahl der fehlgeschlagenen Zustellversuche.
    /// </summary>
    public int FailedDeliveryAttempts { get; set; } = 0;

    /// <summary>
    /// Fehlermeldung des letzten Zustellversuchs.
    /// </summary>
    public string FailedAttemptErrorMessage { get; set; } = "";
}

/// <summary>
/// Repräsentiert einen Anhang einer E-Mail mit Metadaten und Inhalt.
/// </summary>
public class EmailAttachment {
    /// <summary>
    /// Eindeutige Identifikation des Anhangs.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Zugehörige E-Mail im Postausgang.
    /// </summary>
    public Guid EmailOutboxItemId { get; init; }

    /// <summary>
    /// Medientyp des Anhangs (z.B. "application/pdf").
    /// </summary>
    public string? MediaType { get; set; } = "";

    /// <summary>
    /// Größe des Anhangs in Bytes.
    /// </summary>
    public long? Size { get; set; } = 0;

    /// <summary>
    /// Name des Anhangs.
    /// </summary>
    public string? Name { get; set; } = "";

    /// <summary>
    /// Content-ID, unter der der Anhang als eingebettetes Bild (<c>cid:</c>) statt als Datei versendet wird.
    /// </summary>
    public string? ContentId { get; set; }

    /// <summary>
    /// Binärdaten des Anhangs.
    /// </summary>
    public byte[] Bytes { get; set; } = [];
}
