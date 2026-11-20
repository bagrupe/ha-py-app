using System.Net.Mail;
using API.Features.Email.Templates;
using API.Features.EmailForwarder;
using API.Features.Kommune;
using Microsoft.AspNetCore.Components;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Email;

/// <summary>
/// Dienst zur Verwaltung und Erstellung von E-Mails im Postausgang.
/// </summary>
public class EmailService(
    BlazorRenderer blazorRenderer,
    IDbContextFactory<DomainContext> domainContextFactory,
    KommuneDesignService kommuneDesignService
) {
    /// <summary>
    /// Fügt eine E-Mail mit gerendertem HTML- und Textinhalt sowie optionalen Anhängen dem Postausgang hinzu.
    /// </summary>
    /// <typeparam name="THtml">Typ der HTML-E-Mail-Vorlage.</typeparam>
    /// <typeparam name="TText">Typ der Text-E-Mail-Vorlage.</typeparam>
    /// <param name="recipientEmail">Empfängeradresse der E-Mail.</param>
    /// <param name="subject">Betreff der E-Mail.</param>
    /// <param name="kommuneId">ID der zugehörigen Kommune.</param>
    /// <param name="templateParams">Optionale Parameter für die Vorlage.</param>
    /// <param name="attachments">Optionale Anhänge der E-Mail.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Task zur asynchronen Ausführung.</returns>
    public Task AddMailToOutboxAsync<THtml, TText>(string recipientEmail, string subject, Guid kommuneId,
        IDictionary<string, object>? templateParams = null, IEnumerable<Attachment>? attachments = null,
        CancellationToken ct = default)
        where THtml : IComponent, IKommuneThemedTemplate
        where TText : IComponent, IKommuneThemedTemplate =>
        AddMailToOutboxAsync<THtml, TText>([recipientEmail], subject, kommuneId, templateParams, attachments, ct);

    /// <summary>
    /// Fügt für jede der angegebenen Empfängeradressen eine eigene E-Mail (mit identischem, nur einmal gerendertem
    /// Inhalt) dem Postausgang hinzu. Ein Outbox-Eintrag pro Adresse, damit Zustellung/Fehler pro Empfänger einzeln
    /// nachvollziehbar bleiben (z. B. für Formularschritt-Benachrichtigungen an mehrere Abteilungs-Adressen).
    /// </summary>
    /// <typeparam name="THtml">Typ der HTML-E-Mail-Vorlage.</typeparam>
    /// <typeparam name="TText">Typ der Text-E-Mail-Vorlage.</typeparam>
    /// <param name="recipientEmails">Empfängeradressen der E-Mail.</param>
    /// <param name="subject">Betreff der E-Mail.</param>
    /// <param name="kommuneId">ID der zugehörigen Kommune.</param>
    /// <param name="templateParams">Optionale Parameter für die Vorlage.</param>
    /// <param name="attachments">Optionale Anhänge der E-Mail.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Task zur asynchronen Ausführung.</returns>
    public async Task AddMailToOutboxAsync<THtml, TText>(IEnumerable<string> recipientEmails, string subject, Guid kommuneId,
        IDictionary<string, object>? templateParams = null, IEnumerable<Attachment>? attachments = null,
        CancellationToken ct = default)
        where THtml : IComponent, IKommuneThemedTemplate
        where TText : IComponent, IKommuneThemedTemplate {
        var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        await AddMailToOutboxAsync<THtml, TText>(domainContext, recipientEmails, subject, kommuneId, templateParams,
            attachments);
        await domainContext.SaveChangesAsync(ct);
    }

    /// <summary>Adds emails to the provided context's outbox without saving.</summary>
    public async Task AddMailToOutboxAsync<THtml, TText>(DomainContext domainContext,
        IEnumerable<string> recipientEmails, string subject, Guid kommuneId,
        IDictionary<string, object>? templateParams = null, IEnumerable<Attachment>? attachments = null)
        where THtml : IComponent, IKommuneThemedTemplate
        where TText : IComponent, IKommuneThemedTemplate {
        var logo = await kommuneDesignService.GetKommuneLogo(kommuneId);
        var legalLinks = await kommuneDesignService.GetKommuneLegalLinks(kommuneId);

        var kommuneName = await domainContext.Kommunen
            .Where(k => k.Id == kommuneId).Select(k => k.Name).FirstOrDefaultAsync();

        var allTemplateParams = new Dictionary<string, object?> {
            { nameof(IKommuneThemedTemplate.KommuneName), kommuneName },
            { nameof(IKommuneThemedTemplate.ImpressumUrl), legalLinks.Impressum },
            { nameof(IKommuneThemedTemplate.DatenschutzUrl), legalLinks.Privacy },
        };

        if (logo is not null) {
            var (width, height) = ScaleLogo(logo);
            allTemplateParams[nameof(IKommuneThemedTemplate.LogoUrl)] = $"cid:{LogoContentId}";
            allTemplateParams[nameof(IKommuneThemedTemplate.LogoWidth)] = width;
            allTemplateParams[nameof(IKommuneThemedTemplate.LogoHeight)] = height;
        }

        if (templateParams is not null) {
            foreach (var (key, value) in templateParams) {
                allTemplateParams[key] = value;
            }
        }

        var text = System.Net.WebUtility.HtmlDecode(await blazorRenderer.RenderComponent<TText>(allTemplateParams));
        var html = await blazorRenderer.RenderComponent<THtml>(allTemplateParams);

        var attachmentEntities = attachments?.Select(a => {
            using MemoryStream ms = new MemoryStream();
            a.ContentStream.CopyTo(ms);
            return new EmailAttachment {
                MediaType = a.ContentType.MediaType,
                Size = ms.Length,
                Name = a.Name,
                Bytes = ms.ToArray()
            };
        }
        ).ToList() ?? new List<EmailAttachment>();

        foreach (var recipientEmail in recipientEmails) {
            domainContext.Add(new EmailOutboxItem {
                KommuneId = kommuneId,
                RecipientEmail = recipientEmail,
                Subject = subject,
                Html = html,
                Text = text,
                // Jeder Empfänger bekommt eine eigene Kopie der Anhänge (eigene EmailOutboxItemId-Zuordnung).
                Attachments = attachmentEntities.Select(a => new EmailAttachment {
                    MediaType = a.MediaType,
                    Size = a.Size,
                    Name = a.Name,
                    Bytes = a.Bytes,
                }).Concat(LogoAttachment(logo)).ToList(),
            });
        }
    }

    private const string LogoContentId = "kommune-logo";
    private const int LogoMaxWidth = 180;

    private static (int width, int height) ScaleLogo(KommuneLogo logo) {
        var width = Math.Min(logo.Width, LogoMaxWidth);
        return (width, (int)Math.Round(logo.Height * (double)width / logo.Width));
    }

    private static IEnumerable<EmailAttachment> LogoAttachment(KommuneLogo? logo) =>
        logo is null
            ? []
            : [new EmailAttachment {
                ContentId = LogoContentId,
                MediaType = logo.MediaType,
                Size = logo.Bytes.Length,
                Name = "logo",
                Bytes = logo.Bytes,
            }];
}
