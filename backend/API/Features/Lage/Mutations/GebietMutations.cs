using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage.Mutations;

public class GebietNotFoundException()
    : DomainException("Das Gebiet existiert nicht.");

public class MitarbeiterGruppeOfOtherUntereinheitException()
    : DomainException("Die Mitarbeitergruppe gehört nicht zur Organisationseinheit des Gebiets.");

public class MitarbeiterGruppeDeletedException()
    : DomainException("Die Mitarbeitergruppe wurde gelöscht.");

[MutationType]
public class GebietMutations {
    /// <summary>Trägt eine Mitarbeitergruppe der Organisationseinheit des Gebiets als Einsatzleitung des Gebiets ein.</summary>
    /// <param name="gebietId">ID des Gebiets.</param>
    /// <param name="mitarbeiterGruppeId">ID der Mitarbeitergruppe, die Einsatzleitung werden soll.</param>
    /// <returns>Das Gebiet.</returns>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(GebietNotFoundException))]
    [Error(typeof(MitarbeiterGruppeOfOtherUntereinheitException))]
    [Error(typeof(MitarbeiterGruppeDeletedException))]
    public async Task<Gebiet> AddGebietEinsatzleitung(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        Guid gebietId,
        Guid mitarbeiterGruppeId,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var gebiet = await db.Gebiete
            .FirstOrDefaultAsync(g => g.Id == gebietId && g.Untereinheit.KommuneId == user.KommuneId, ct)
            ?? throw new GebietNotFoundException();

        var gruppe = await db.MitarbeiterGruppen
            .Where(mg => mg.Id == mitarbeiterGruppeId
                && mg.Organisationseinheiten.Any(u => u.Id == gebiet.UntereinheitId))
            .Select(mg => new { mg.IsDeleted })
            .FirstOrDefaultAsync(ct)
            ?? throw new MitarbeiterGruppeOfOtherUntereinheitException();

        if (gruppe.IsDeleted) throw new MitarbeiterGruppeDeletedException();

        var isAlreadyEinsatzleitung = await db.GebietEinsatzleitungen
            .AnyAsync(ge => ge.GebietId == gebietId && ge.MitarbeiterGruppeId == mitarbeiterGruppeId, ct);

        if (!isAlreadyEinsatzleitung) {
            db.GebietEinsatzleitungen.Add(new GebietEinsatzleitung {
                GebietId = gebietId,
                MitarbeiterGruppeId = mitarbeiterGruppeId
            });
            await db.SaveChangesAsync(ct);
        }

        return gebiet;
    }

    /// <summary>Entfernt eine Mitarbeitergruppe aus der Einsatzleitung des Gebiets.</summary>
    /// <param name="gebietId">ID des Gebiets.</param>
    /// <param name="mitarbeiterGruppeId">ID der Mitarbeitergruppe, die nicht mehr Einsatzleitung sein soll.</param>
    /// <returns>Das Gebiet.</returns>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(GebietNotFoundException))]
    public async Task<Gebiet> RemoveGebietEinsatzleitung(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        Guid gebietId,
        Guid mitarbeiterGruppeId,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var gebiet = await db.Gebiete
            .FirstOrDefaultAsync(g => g.Id == gebietId && g.Untereinheit.KommuneId == user.KommuneId, ct)
            ?? throw new GebietNotFoundException();

        await db.GebietEinsatzleitungen
            .Where(ge => ge.GebietId == gebietId && ge.MitarbeiterGruppeId == mitarbeiterGruppeId)
            .ExecuteDeleteAsync(ct);

        return gebiet;
    }
}
