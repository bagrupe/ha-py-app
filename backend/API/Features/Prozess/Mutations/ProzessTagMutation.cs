using System.Data;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess.Queries;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;
using Npgsql;

namespace API.Features.Prozess.Mutations;

[MutationType]
public class ProzessTagMutation {
    [Error(typeof(NotAllowedException))]
    [Error(typeof(ProzessNotFound))]
    [Error(typeof(ProzessTagNotFound))]
    [Authorize]
    [GraphQLDescription("Weist einen bestehenden Prozess-Tag einem Prozess zu und entfernt ihn dabei von jedem anderen Prozess derselben Kommune, dem er aktuell zugeordnet ist (ein Tag gehört pro Kommune immer nur einem Prozess). Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<Prozess> AssignProzessTag(
        AssignProzessTagInput input,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        IClock clock
    ) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozessKommuneId = await db.Prozesse
            .Where(p => p.Id == input.ProzessId)
            .Select(p => (Guid?)p.KommuneId)
            .FirstOrDefaultAsync() ?? throw new ProzessNotFound();
        if (user.KommuneId != prozessKommuneId) throw new NotAllowedException();

        return await WithSerializableRetryAsync(db, async () => {
            var prozess = await db.Prozesse.AsTracking()
                .Include(p => p.Tags)
                .FirstOrDefaultAsync(p => p.Id == input.ProzessId) ?? throw new ProzessNotFound();

            var tag = await db.ProzessTags.AsTracking()
                .Include(t => t.Prozesse)
                .FirstOrDefaultAsync(t => t.Id == input.TagId) ?? throw new ProzessTagNotFound();

            foreach (var bisherigerTraeger in tag.Prozesse
                         .Where(p => p.KommuneId == prozess.KommuneId && p.Id != prozess.Id)
                         .ToList()) {
                bisherigerTraeger.Tags.Remove(tag);
            }

            if (!prozess.Tags.Contains(tag)) {
                prozess.Tags.Add(tag);
            }

            var hatBereitsHistorienEintrag = await db.ProzessTagHistorie
                .AnyAsync(h => h.ProzessId == prozess.Id && h.TagId == tag.Id);
            if (!hatBereitsHistorienEintrag) {
                db.ProzessTagHistorie.Add(new ProzessTagHistorieEintrag {
                    Id = Guid.NewGuid(),
                    ProzessId = prozess.Id,
                    TagId = tag.Id,
                    ZugewiesenAm = clock.GetCurrentInstant(),
                });
            }

            return prozess;
        });
    }

    /// <summary>Führt <paramref name="action"/> in einer Serializable-Transaktion aus und wiederholt sie bis zu zweimal, falls Postgres einen Serialisierungskonflikt meldet.</summary>
    private static async Task<Prozess> WithSerializableRetryAsync(DomainContext db, Func<Task<Prozess>> action) {
        for (var attempt = 1; ; attempt++) {
            await using var transaction = await db.Database.BeginTransactionAsync(IsolationLevel.Serializable);
            try {
                var prozess = await action();
                await db.SaveChangesAsync();
                await transaction.CommitAsync();
                return prozess;
            } catch (Exception e) when (attempt < 3 && IsSerializationFailure(e)) {
                // Die Transaktion ist nach dem Serialisierungsfehler bereits abgeschlossen; Rollback kann erneut werfen.
                try {
                    await transaction.RollbackAsync();
                } catch (InvalidOperationException) { }
                db.ChangeTracker.Clear();
            }
        }
    }

    private static bool IsSerializationFailure(Exception e) {
        for (var current = e; current is not null; current = current.InnerException) {
            if (current is PostgresException { SqlState: PostgresErrorCodes.SerializationFailure }) return true;
        }
        return false;
    }
}

public record AssignProzessTagInput(Guid ProzessId, Guid TagId);

public class ProzessTagNotFound : Exception;
