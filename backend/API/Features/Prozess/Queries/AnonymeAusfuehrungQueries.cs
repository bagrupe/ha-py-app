using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Queries;

[QueryType]
public class AnonymeAusfuehrungQueries {
    [AllowAnonymous]
    [GraphQLDescription(
        "Status eines anonym eingereichten Antrags anhand der CorrelationId aus ausfuehrungCreateAnonym. " +
        "Null, wenn es keinen solchen Antrag (mehr) gibt.")]
    public async Task<AnonymeAusfuehrungStatus?> AusfuehrungStatusAnonym(Guid correlationId, DomainContext db,
        IAusfuehrungHistorieByIdDataLoader historieLoader, CancellationToken ct) {
        var ausfuehrung = await db.Ausfuehrungen.NotDeleted()
            .Where(a => a.CorrelationId == correlationId)
            .Select(a => new { a.Id, a.Status, a.CreatedAt, a.AbgeschlossenAm })
            .SingleOrDefaultAsync(ct);
        if (ausfuehrung is null) {
            return null;
        }

        var historie = await historieLoader.LoadAsync(ausfuehrung.Id, ct);
        return new AnonymeAusfuehrungStatus(ausfuehrung.Status, ausfuehrung.CreatedAt, ausfuehrung.AbgeschlossenAm,
            historie.Select(h => new AnonymerHistorieEintrag(h.CreatedAt, h.StatusAenderung,
                h.StatusAenderungBeschreibung, h.Nachricht)).ToList());
    }
}
