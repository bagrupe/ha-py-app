using System.Net.Mail;
using System.Text;
using API.Infrastructure;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Quartz;

namespace API.Features.Auth.Jobs;

/// <summary>
/// Job zum Versenden von E-Mails aus der E-Mail-Outbox. Verarbeitet ausstehende E-Mails und entfernt erfolgreich gesendete.
/// </summary>
/// <param name="dbContextFactory">Factory zur Erstellung des Datenbankkontexts.</param>
/// <param name="smtpClient">SMTP-Client zum Versenden der E-Mails.</param>
/// <param name="options">Konfigurationsoptionen für E-Mails.</param>
/// <param name="ct">Optionaler Abbruch-Token.</param>
[DisallowConcurrentExecution]
public class EmailOutboxSendJob(
    IDbContextFactory<DomainContext> dbContextFactory,
    SmtpClient smtpClient,
    EMailOptions options,
    CancellationToken ct = default
) : IJob {
    /// <summary>
    /// Führt den Job aus, indem ausstehende E-Mails aus der Datenbank abgerufen, verarbeitet und versendet werden.
    /// </summary>
    /// <param name="context">Kontext des aktuellen Jobs.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await using var db = await dbContextFactory.CreateDbContextAsync();
        var toSend = await db.EmailOutboxItems.AsTracking()
            .Include(item => item.Attachments)
            .ToListAsync();

        foreach (var item in toSend) {
            var emailMessage = new MailMessage {
                From = new MailAddress(options.From, displayName: options.FromDisplayName),
                Subject = item.Subject,
                BodyEncoding = Encoding.Unicode
            };
            emailMessage.Body = item.Text;

            var htmlView =
                AlternateView.CreateAlternateViewFromString(item.Html, contentEncoding: Encoding.UTF8,
                    mediaType: "text/html");

            emailMessage.AlternateViews.Add(htmlView);
            emailMessage.To.Add(new MailAddress(item.RecipientEmail));

            if (item.Attachments.Count > 0) {
                var attachments = item.Attachments;
                foreach (var attachment in attachments) {
                    if (attachment.ContentId is { } contentId) {
                        htmlView.LinkedResources.Add(new LinkedResource(new MemoryStream(attachment.Bytes),
                            attachment.MediaType) { ContentId = contentId });
                        continue;
                    }

                    using MemoryStream ms = new MemoryStream();
                    var file = attachment.Bytes;
                    ms.Write(file, 0, file.Length);
                    emailMessage.Attachments.Add(new Attachment(new MemoryStream(ms.ToArray()), attachment.Name,
                        attachment.MediaType));
                }
            }

            try {
                await smtpClient.SendMailAsync(emailMessage, ct);
                db.Remove(item);
                await db.SaveChangesAsync();
            } catch (Exception e) {
                failures.RecordFailure();
                item.FailedAttemptErrorMessage = e.InnerException?.Message ?? e.Message;
                item.FailedDeliveryAttempts++;
                if (item.FailedDeliveryAttempts >= 3) {
                    db.Remove(item);
                }
                await db.SaveChangesAsync();
            }
        }
    }
}

/// <summary>
/// Erweiterungsmethoden für die Registrierung des EmailOutboxSendJob in den Services.
/// </summary>
public static class EmailOutboxItemJobExtension {
    /// <summary>
    /// Registriert den EmailOutboxSendJob mit einem Zeitplan von alle 10 Sekunden.
    /// </summary>
    /// <param name="services">Service-Sammlung zur Registrierung.</param>
    /// <returns>Die aktualisierte Service-Sammlung.</returns>
    public static IServiceCollection AddEmailOutboxSendJob(this IServiceCollection services) {
        const string everyTenSeconds = "0/10 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<EmailOutboxSendJob>(everyTenSeconds, fireImmediate: true));

        return services;
    }
}
