using System.Net.Mail;
using API.Features.Auth;
using API.Features.Email;
using API.Features.Email.Templates;
using API.Features.Expressions;
using API.Features.Kommune;
using API.Features.PdfGenerator;
using API.Features.Prozess;
using API.Infrastructure;
using API.Options;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using Quartz;

namespace API.Features.EmailForwarder;

/// <summary>
/// Führt den Export und Versand von E-Mails im Rahmen des EmailForwarder-Workflows aus.
/// </summary>
[DisallowConcurrentExecution]
public class EmailForwarderExportRunner(
    WalkerFactory walkerFactory,
    BlazorRenderer blazorRenderer,
    EmailService emailService,
    EMailOptions options,
    IDbContextFactory<DomainContext> dbFactory,
    EvaluatingVisitorService evaluatingVisitorService,
    GotenbergService gotenberg,
    StaticMapService staticMapService,
    KommuneDesignService kommuneDesignService)
    : IJob {
    /// <summary>
    /// Startet die Ausführung des Jobs und verarbeitet alle relevanten Schritte.
    /// </summary>
    /// <param name="context">Kontext des ausgeführten Jobs.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await foreach (var walker in walkerFactory.GetWalkerForCurrentStep<EmailForwarderExportSchritt>()) {
            try {
                await ContinueAusfuehrung(walker);
            } catch (Exception) {
                failures.RecordFailure();
            }
        }
    }

    /// <summary>
    /// Setzt die Verarbeitung eines einzelnen Schritts fort, erzeugt PDF und versendet die E-Mail.
    /// </summary>
    /// <param name="walker">Steuerungsobjekt für den aktuellen Workflow-Schritt.</param>
    private async Task ContinueAusfuehrung(Walker walker) {
        if (walker.CurrentSchritt is not EmailForwarderExportSchritt emailForwarderExportSchritt) {
            return;
        }

        var (primaryColor, logoUrl) =
            await kommuneDesignService.GetKommuneDesign(walker.Prozess.KommuneId);

        var slotValues = walker.CurrentSlotValues();
        var kommuneId = walker.Prozess.KommuneId;
        var message = new MailMessage {
            From = new MailAddress(options.From),
            Subject = evaluatingVisitorService.Evaluate(emailForwarderExportSchritt.Subject, slotValues, kommuneId),
        };
        message.To.Add(evaluatingVisitorService.Evaluate(emailForwarderExportSchritt.EmailAddress, slotValues,
            kommuneId));

        var emailText = evaluatingVisitorService.Evaluate(emailForwarderExportSchritt.Body, slotValues, kommuneId);

        await using var db = await dbFactory.CreateDbContextAsync();
        var bearbeitungen = db.Bearbeitungen
            .AsSingleQuery()
            .Where(b => b.AusfuehrungId == walker.Ausfuehrung.Id)
            .OrderBy(b => b.CreatedAt)
            .Include(b => b.Schritt)
            .ThenInclude(s => ((FormularSchritt)s).Felder.OrderBy(f => f.Order))
            .Include(b => b.User)
            .Include(b => b.SlotValues)
            .ToList();

        var zustaendigkeit = await PdfZustaendigkeit.Load(db, walker.Ausfuehrung.IstZustaendigkeit);
        var content = await AusfuehrungHtml.AusfuehrungToHtml(walker.Ausfuehrung.Id, walker.Prozess.Name,
            zustaendigkeit, bearbeitungen, blazorRenderer, staticMapService, primaryColor, logoUrl);
        var response = await gotenberg.RenderToPdf(content, GotenbergEndpoint.Chromium);

        var subject = evaluatingVisitorService.Evaluate(emailForwarderExportSchritt.Subject, slotValues, kommuneId);
        var recipientEmail = evaluatingVisitorService.Evaluate(emailForwarderExportSchritt.EmailAddress, slotValues,
            kommuneId);
        IEnumerable<Attachment> attachments = [
            new(await response.Content.ReadAsStreamAsync(), "export.pdf",
                "application/pdf")
        ];

        var (organisationseinheit, abteilung) =
            await walker.ResolveZustaendigkeitNames(walker.Ausfuehrung.IstZustaendigkeit);
        var eingegangenAm = walker.Ausfuehrung.CreatedAt
            .InZone(DateTimeZoneProviders.Tzdb["Europe/Berlin"]).ToString("dd.MM.yyyy", null);

        await emailService.AddMailToOutboxAsync<MaengelMeldungEmail, MaengelMeldungEmailText>(recipientEmail: recipientEmail,
            subject: subject,
            templateParams:
            new Dictionary<string, object> {
                { nameof(MaengelMeldungEmail.Message), emailText },
                { nameof(MaengelMeldungEmail.ProzessName), walker.Prozess.Name },
                { nameof(MaengelMeldungEmail.Organisationseinheit), organisationseinheit },
                { nameof(MaengelMeldungEmail.Abteilung), abteilung },
                { nameof(MaengelMeldungEmail.Datum), eingegangenAm },
            },
            kommuneId: kommuneId,
            attachments: attachments);

        walker.Step(SystemUser.UserId, walker.CurrentVerbindungen[0].Id, [], null);
        await walker.SaveChangesAsync();
    }
}

/// <summary>
/// Erweiterungsmethoden zur Registrierung des EmailForwarderExportRunner im DI-Container.
/// </summary>
public static class EmailForwarderExportRunnerServiceExtensions {
    /// <summary>
    /// Fügt den EmailForwarderExportRunner mit einem Zeitplan zum Dienstcontainer hinzu.
    /// </summary>
    /// <param name="services">Dienstesammlung zur Erweiterung.</param>
    /// <returns>Erweiterte Dienstesammlung.</returns>
    public static IServiceCollection AddEmailForwarderExportRunner(this IServiceCollection services) {
        const string everyTenSeconds = "0/10 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<EmailForwarderExportRunner>(everyTenSeconds, fireImmediate: true));

        return services;
    }
}
