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
/// Job zum Versenden von E-Mails zum Zurücksetzen des Passworts. 
/// Verarbeitet Benutzer mit gültigen Reset-Codes und erstellt entsprechende E-Mails.
/// </summary>
/// <param name="clock">Uhrzeit-Provider zur Berechnung von Zeitstempeln.</param>
/// <param name="dbContextFactory">Factory zur Erstellung des Datenbankkontexts.</param>
/// <param name="emailService">Service zum Versenden von E-Mails.</param>
/// <param name="webOptions">Konfigurationsoptionen für die Web-URLs.</param>
[DisallowConcurrentExecution]
public class PasswordResetEmailJob(
    IClock clock,
    IDbContextFactory<DomainContext> dbContextFactory,
    EmailService emailService,
    WebOptions webOptions
) : IJob {
    /// <summary>
    /// Führt den Job aus, indem E-Mails zum Zurücksetzen des Passworts generiert und in die Outbox gelegt werden.
    /// </summary>
    /// <param name="context">Kontext des aktuellen Jobs.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await using var db = await dbContextFactory.CreateDbContextAsync();
        var toSend = await db.BackofficeUser
            .AsTracking()
            .Where(u => u.PasswordResetCode != null && u.PasswordResetValidUntil == null)
            .ToListAsync();

        foreach (var user in toSend) {
            try {
                var resetUrl =
                    $"{webOptions.BaseUrl}/auth/reset-password/{HttpUtility.UrlEncode(user.PasswordResetCode!.Value.ToString(), Encoding.UTF8)}?email={HttpUtility.UrlEncode(user.EMail, Encoding.UTF8)}";

                await emailService.AddMailToOutboxAsync<ResetPasswordEmail, ResetPasswordEmailText>(
                    recipientEmail: user.EMail, subject: "Passwort zurücksetzen",
                    templateParams:
                    new Dictionary<string, object> { { nameof(ResetPasswordEmail.ResetUrl), resetUrl } },
                    kommuneId: user.KommuneId
                );

                user.PasswordResetValidUntil = clock.GetCurrentInstant().Plus(Duration.FromDays(1));
            } catch (Exception e) {
                failures.RecordFailure();
                SentrySdk.CaptureException(e);
            }
        }

        await db.SaveChangesAsync();
    }
}

/// <summary>
/// Erweiterungsmethoden für den PasswordResetEmailJob, um ihn in den Dienstcontainer zu integrieren.
/// </summary>
public static class PasswordResetEmailJobExtension {
    /// <summary>
    /// Registriert den PasswordResetEmailJob mit einem Zeitplan im Dienstcontainer.
    /// </summary>
    /// <param name="services">Dienstcontainer.</param>
    /// <returns>Erweiterte Dienstsammlung.</returns>
    public static IServiceCollection AddResetEmailJob(this IServiceCollection services) {
        const string everyTenSeconds = "0/10 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<PasswordResetEmailJob>(everyTenSeconds, fireImmediate: true));

        return services;
    }
}
