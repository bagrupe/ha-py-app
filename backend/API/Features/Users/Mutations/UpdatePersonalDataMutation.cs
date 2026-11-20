using API.Features.Auth;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Users.Mutations;

/// <summary>Enthält Mutation zum Aktualisieren der persönlichen Daten eines Bürgers.</summary>
[MutationType]
public class UpdatePersonalDataMutation {
    /// <summary>Aktualisiert die persönlichen Daten des aktuell angemeldeten Bürgers.</summary>
    /// <param name="personalData">Liste der neuen persönlichen Daten als Schlüssel-Wert-Paare.</param>
    /// <param name="db">Datenbankkontext für die Persistenz.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <returns>Den aktualisierten Bürger mit den neuen persönlichen Daten.</returns>
    [Authorize]
    public async Task<Buerger> PersonalDataUpdate(List<BuergerPersonalDataInput> personalData, DomainContext db, CurrentUserAccessor currentUserAccessor) {
        var userId = currentUserAccessor.UserId();

        var buerger = await db.Buerger
            .AsTracking()
            .Include(b => b.PersonalData)
            .FirstOrDefaultAsync(b => b.Id == userId);

        if (buerger == null) {
            throw new NotAllowedException("This action is only allowed for Buerger");
        }

        buerger.PersonalData.Clear();
        buerger.PersonalData.AddRange(
            personalData
                .Select(d => new BuergerPersonalData { Key = d.Key, Value = d.Value })
        );

        await db.SaveChangesAsync();

        return buerger;
    }

    /// <summary>Repräsentiert ein Eingabeobjekt für persönliche Daten eines Bürgers.</summary>
    /// <param name="Key">Der Schlüssel der persönlichen Information.</param>
    /// <param name="Value">Der verschlüsselte Wert der Information.</param>
    public record BuergerPersonalDataInput(string Key, EncryptedValue Value);
}
