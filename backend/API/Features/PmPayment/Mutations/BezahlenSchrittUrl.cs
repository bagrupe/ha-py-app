using API.Features.Auth;
using API.Features.Prozess;
using API.Features.Prozess.Queries;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.PmPayment.Mutations;

/// <summary>Erzeugt eine Zahlungs-URL für einen bestimmten Bezahlen-Schritt einer Ausführung.</summary>
[MutationType]
public class BezahlenSchrittUrl {
    /// <summary>Ermittelt die Zahlungs-URL für den aktuellen Bezahlen-Schritt einer Ausführung.</summary>
    /// <param name="ausfuehrungId">Die Id der Ausführung.</param>
    /// <param name="bezahlenSchrittId">Die Id des Bezahlen-Schritts.</param>
    /// <param name="client">Der Zahlungsclient zur URL-Erzeugung.</param>
    /// <param name="currentSchrittByAusfuehrungIdDataLoader">Lädt den aktuellen Schritt der Ausführung.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Nutzer.</param>
    /// <param name="ausfuehrungZustaendigkeitService">Service zur Prüfung der Zuständigkeit.</param>
    /// <param name="domainContext">Der Datenbankkontext.</param>
    /// <returns>Die generierte Zahlungs-URL als String.</returns>
    /// <exception cref="NotAllowedException">Wenn der Nutzer keinen Zugriff auf die Ausführung hat.</exception>
    [Authorize]
    [GraphQLDescription("Erzeugt die Zahlungs-URL für den aktuellen Bezahlen-Schritt eines Antrags. Nur für den Antragsteller oder zuständige Backoffice-Nutzer.")]
    public async Task<string> GetBezahlenSchrittUrl(Guid ausfuehrungId, Guid bezahlenSchrittId,
        [Service] PmPaymentClient client, ICurrentSchrittByAusfuehrungIdDataLoader currentSchrittByAusfuehrungIdDataLoader,
        [Service] ICurrentUserAccessor currentUserAccessor,
        [Service] AusfuehrungZustaendigkeitService ausfuehrungZustaendigkeitService, DomainContext domainContext) {

        var ausfuehrung = await domainContext.Ausfuehrungen
            .NotDeleted()
            .Include(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .FirstOrDefaultAsync(a => a.Id == ausfuehrungId);

        // Nicht vorhandene und fremde Anträge sind absichtlich ununterscheidbar (kein Existenz-Leak).
        if (ausfuehrung is null) {
            throw new NotAllowedException();
        }

        await ausfuehrungZustaendigkeitService.EnsureZugriffAufAusfuehrung(ausfuehrung, currentUserAccessor);

        var currentSchritt = await currentSchrittByAusfuehrungIdDataLoader.LoadAsync(ausfuehrungId);

        if (currentSchritt is not BezahlenSchritt bezahlenSchritt || currentSchritt.Id != bezahlenSchrittId) {
            throw new Exception("Schritt ist nicht der aktuelle Schritt");
        }

        var paymentRequest = new PaymentRequest {
            AusfuehrungId = ausfuehrungId,
            BezahlenSchrittId = bezahlenSchrittId,
            CreatedAt = DateTimeOffset.UtcNow,
        };
        domainContext.PaymentRequests.Add(paymentRequest);

        await domainContext.SaveChangesAsync();

        return client.GeneratePaymentUrl((int)(bezahlenSchritt.Betrag * 100), ausfuehrung.ProzessVersion.Prozess.Name, paymentRequest.Id, ausfuehrungId);
    }
}
