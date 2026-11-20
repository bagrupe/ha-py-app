using API.Features.Auth;
using API.Features.Ehrenamtsbank.Queries;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Ehrenamtsbank.Mutations;

public class AnfrageForItselfException() : DomainException("Anfrage kann nicht an eigenen Eintrag gemacht werden");
public class EintragNotActiveException() : DomainException("Anfrage kann nur an aktive Einträge gestellt werden");
public class AnfrageNotFoundException() : DomainException("Anfrage nicht gefunden");
public class MultipleAnfrageException() : DomainException("Ein Interessent darf nur eine Anfrage pro Eintrag stellen");
public class AnfrageStatusTransitionException : DomainException {
    public AnfrageStatusTransitionException(
        EhrenamtsbankAnfrageStatus from, EhrenamtsbankAnfrageStatus to)
        : base($"Übergang von {from} nach {to} ist für diesen Akteur nicht erlaubt.") { }
}
[MutationType]
public class AnfrageMutations {

    /// <summary>
    /// Erstellt eine neue Anfrage für einen EhrenamtsbankEintrag
    /// </summary>
    /// <exception cref="EintragNotFoundException">Es gibt keinen EhrenamtsbankEintrag mit der Id</exception>
    /// <exception cref="AnfrageForItselfException">Anfragen können nicht an eigene Einträge gestellt werden</exception>
    /// <exception cref="EintragNotActiveException">Der EhrenamtsbankEintrag ist nicht im Status Active</exception>
    [Error(typeof(CurrentUserAccessor.Unauthenticated))]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(EintragNotFoundException))]
    [Error(typeof(AnfrageForItselfException))]
    [Error(typeof(EintragNotActiveException))]
    [Error(typeof(MultipleAnfrageException))]
    [Authorize]
    public async Task<EhrenamtsbankAnfrage> CreateEhrenamtsbankAnfrage(
            DomainContext db,
            CurrentUserAccessor currentUserAccessor,
            [Service] IClock clock,
            Guid eintragId,
            string? nachricht,
            CancellationToken ct) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();
        var eintrag = await db.EhrenamtsbankEintraege.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == eintragId && !e.IsDeleted, ct)
            ?? throw new EintragNotFoundException();

        if (eintrag.OwnerId == buerger.Id) {
            throw new AnfrageForItselfException();
        }

        if (eintrag.Status != EhrenamtsbankEintragStatus.Active) {
            throw new EintragNotActiveException();
        }

        var existingAnfrage = await db.EhrenamtsbankAnfragen.FirstOrDefaultAsync(a => a.InteressentId == buerger.Id && a.EintragId == eintragId);
        if (existingAnfrage != null) {
            throw new MultipleAnfrageException();
        }

        var now = clock.GetCurrentInstant();
        var anfrage = new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            InteressentId = buerger.Id,
            EintragId = eintrag.Id,
            CreatedAt = now,
            UpdatedAt = now,
            Nachricht = nachricht
        };
        db.EhrenamtsbankAnfragen.Add(anfrage);
        await db.SaveChangesAsync(ct);
        return anfrage;
    }

    /// <summary>
    /// Statuswechsel entlang des Anfrage-Lebenszyklus. Der Akteur ergibt sich aus dem
    /// Aufrufer: Interessent oder Eintragsinhaber. Vereinbaren lehnt alle übrigen
    /// Anfragen desselben Eintrags ab.
    /// </summary>
    [Error(typeof(CurrentUserAccessor.Unauthenticated))]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(AnfrageStatusTransitionException))]
    [Error(typeof(AnfrageNotFoundException))]
    [Error(typeof(EintragNotFoundException))]
    [Error(typeof(EintragNotActiveException))]
    [Error(typeof(EintragConflictException))]
    [Authorize]
    public async Task<EhrenamtsbankAnfrage> UpdateEhrenamtsbankAnfrageStatus(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        [Service] IClock clock,
        Guid anfrageId,
        EhrenamtsbankAnfrageStatus status,
        CancellationToken ct
    ) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();
        var anfrage = await db.EhrenamtsbankAnfragen.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == anfrageId, ct)
            ?? throw new AnfrageNotFoundException();

        var eintrag = await db.EhrenamtsbankEintraege.AsTracking()
            .Include(e => e.Anfragen)
            .FirstOrDefaultAsync(e => e.Id == anfrage.EintragId && !e.IsDeleted, ct)
            ?? throw new EintragNotFoundException();

        if (eintrag.Status != EhrenamtsbankEintragStatus.Active) {
            throw new EintragNotActiveException();
        }

        var actor = ResolveActor(buerger.Id, anfrage, eintrag);
        var transition = AnfrageStateMachine.Check(anfrage.Status, status, actor);
        if (!transition.Allowed) {
            throw new AnfrageStatusTransitionException(anfrage.Status, status);
        }

        var now = clock.GetCurrentInstant();
        if (transition.RejectsSiblingAnfragen) {
            foreach (var a in eintrag.Anfragen.Where(
                a => a.Id != anfrageId
                && (a.Status == EhrenamtsbankAnfrageStatus.Offen || a.Status == EhrenamtsbankAnfrageStatus.Akzeptiert))) {

                a.Status = EhrenamtsbankAnfrageStatus.Abgelehnt;
                a.UpdatedAt = now;
            }

            eintrag.Status = EintragStateMachine.AfterVereinbart;
            eintrag.UpdatedAt = now;
        }

        if (status == EhrenamtsbankAnfrageStatus.Vereinbart) {
            anfrage.VereinbartAt = now;
        }

        anfrage.Status = status;
        anfrage.UpdatedAt = now;
        await EintragMutations.SaveGuarded(db, ct);

        return anfrage;
    }

    internal static AnfrageActor ResolveActor(
        Guid buergerId, EhrenamtsbankAnfrage anfrage, EhrenamtsbankEintrag eintrag) {
        if (anfrage.InteressentId == buergerId) {
            return AnfrageActor.Interessent;
        }
        if (eintrag.OwnerId == buergerId) {
            return AnfrageActor.Owner;
        }
        throw new NotAllowedException("Nur Interessent oder Eintragsinhaber können den Status ändern");
    }
}

