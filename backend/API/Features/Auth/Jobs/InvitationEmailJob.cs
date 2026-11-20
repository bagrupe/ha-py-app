using System.Text;
using System.Web;
using API.Features.Email;
using API.Features.Email.Templates;
using API.Infrastructure;
using API.Options;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using Quartz;
using Sentry;

namespace API.Features.Auth.Jobs;

/// <summary>
/// Job zum Versenden von Einladungs-E-Mails an Mitarbeiter, deren Einladungscodes generiert wurden.
/// </summary>
/// <param name="clock">Uhrzeit-Provider zur Berechnung von Zeitstempeln.</param>
/// <param name="dbContextFactory">Factory zur Erstellung des Datenbankkontexts.</param>
/// <param name="emailService">Service zum Versenden von E-Mails.</param>
/// <param name="webOptions">Konfigurationsoptionen für die Web-URLs.</param>
[DisallowConcurrentExecution]
public class InvitationEmailJob(
    IClock clock,
    IDbContextFactory<DomainContext> dbContextFactory,
    EmailService emailService,
    WebOptions webOptions
) : IJob {
    /// <summary>
    /// Führt den Job aus, indem Einladungs-E-Mails an berechtigte Mitarbeiter versendet werden.
    /// </summary>
    /// <param name="context">Kontext des aktuellen Jobs.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await using var db = await dbContextFactory.CreateDbContextAsync();
        var toSend = await db.Mitarbeiter
            .AsTracking()
            .Include(user => user.Kommune)
            .Where(u => u.InvitationCode != null && u.InvitationValidUntil == null)
            .ToListAsync();

        foreach (var user in toSend) {
            try {
                var inviteUrl =
                    $"{webOptions.BaseUrl}/auth/accept-invitation/{HttpUtility.UrlEncode(user.InvitationCode!.Value.ToString(), Encoding.UTF8)}?email={HttpUtility.UrlEncode(user.EMail, Encoding.UTF8)}";

                await emailService.AddMailToOutboxAsync<InvitationEmail, InvitationEmailText>(
                    recipientEmail: user.EMail, subject: $"Einladung in das Backoffice der Ha-Py App {user.Kommune.Name}",
                    templateParams:
                    new Dictionary<string, object> { { nameof(InvitationEmail.InviteUrl), inviteUrl }, { nameof(InvitationEmail.MandantName), user.Kommune.Name } },
                    kommuneId: user.KommuneId
                );

                user.InvitationValidUntil = clock.GetCurrentInstant().Plus(Duration.FromDays(14));
            } catch (Exception e) {
                failures.RecordFailure();
                SentrySdk.CaptureException(e);
            }
        }

        await db.SaveChangesAsync();
    }
}

/// <summary>
/// Erweiterungsmethoden für den InvitationEmailJob, um ihn in den Dienstcontainer zu integrieren.
/// </summary>
public static class InvitationEmailJobExtension {
    /// <summary>
    /// Registriert den InvitationEmailJob im Dienstcontainer und plant ihn zur regelmäßigen Ausführung.
    /// </summary>
    /// <param name="services">Dienstcontainer zur Registrierung des Jobs.</param>
    /// <returns>Der aktualisierte Dienstcontainer.</returns>
    public static IServiceCollection AddInvitationEmailJob(this IServiceCollection services) {
        const string everyTenSeconds = "0/10 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<InvitationEmailJob>(everyTenSeconds, fireImmediate: true));

        return services;
    }
}
