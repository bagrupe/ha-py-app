using API.Features.Prozess;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage.Queries;

[GraphQLDescription("Lage und Gebiet, denen eine Meldung zugeordnet ist.")]
public record LageAssignment(Guid LageId, string LageTitle, Guid GebietId, string GebietName);

[ExtendObjectType<Ausfuehrung>]
public class AusfuehrungLageExtensions {
    [GraphQLDescription("Lage und Gebiet, die die meldende Person gewählt hat. Null außerhalb des LageHelfers.")]
    public async Task<LageAssignment?> GetLage([Parent] Ausfuehrung ausfuehrung,
        ILageAssignmentByLageGebietIdDataLoader loader, CancellationToken ct) =>
        ausfuehrung.LageGebietId is { } lageGebietId ? await loader.LoadAsync(lageGebietId, ct) : null;

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, LageAssignment>> GetLageAssignmentByLageGebietId(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return await db.LageGebiete
            .Where(lg => keys.Contains(lg.Id))
            .Select(lg => new { lg.Id, Assignment = new LageAssignment(lg.LageId, lg.Lage.Title, lg.GebietId, lg.Gebiet.Name) })
            .ToDictionaryAsync(x => x.Id, x => x.Assignment, ct);
    }
}
