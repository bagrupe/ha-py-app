using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Lage.Mutations;

public class LageNotFoundException()
    : DomainException("Die Lage existiert nicht.");

public class LageUntereinheitNotFoundException()
    : DomainException("Die Organisationseinheit existiert nicht.");

public class GebietOfOtherUntereinheitException()
    : DomainException("Mindestens ein Gebiet gehört nicht zur Organisationseinheit der Lage.");

public class LageClosedException()
    : DomainException("Die Lage ist geschlossen.");

public class GebietAlreadyInLageException()
    : DomainException("Mindestens ein Gebiet ist bereits in der Lage aktiv.");

public class GebietNotInLageException()
    : DomainException("Das Gebiet gehört nicht zur Lage.");

public class InvalidLageGebietTransitionException(LageGebietStatus from, LageGebietStatus to)
    : DomainException($"Der Status des Gebiets kann nicht von {from} zu {to} wechseln.");

[MutationType]
public class LageMutations {
    /// <summary>Creates a new Lage</summary>
    /// <param name="untereinheitId">OE ID</param>
    /// <param name="title">title</param>
    /// <param name="note">note</param>
    /// <param name="gebietIds">Optional OE Gebiete in which a Lage happens</param>
    /// <returns>created Lage</returns>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(LageUntereinheitNotFoundException))]
    [Error(typeof(GebietOfOtherUntereinheitException))]
    public async Task<Lage> CreateLage(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        IClock clock,
        Guid untereinheitId,
        string title,
        string? note,
        List<Guid>? gebietIds,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var untereinheitExists = await db.Untereinheit
            .AnyAsync(u => u.Id == untereinheitId && u.KommuneId == user.KommuneId, ct);
        if (!untereinheitExists) throw new LageUntereinheitNotFoundException();

        var requestedGebietIds = (gebietIds ?? []).Distinct().ToList();
        var gebiete = await db.Gebiete
            .Where(g => requestedGebietIds.Contains(g.Id) && g.UntereinheitId == untereinheitId)
            .ToListAsync(ct);
        if (gebiete.Count != requestedGebietIds.Count) throw new GebietOfOtherUntereinheitException();

        var lage = Lage.Create(untereinheitId, title, gebiete, user.Id, clock.GetCurrentInstant());
        lage.Note = note;
        db.Gebiete.AttachRange(gebiete);
        db.Lagen.Add(lage);
        await db.SaveChangesAsync(ct);

        return lage;
    }

    /// <summary>Changes Title and note for the lage</summary>
    /// <param name="lageId">Lage ID.</param>
    /// <param name="title">new title.</param>
    /// <param name="note">new note.</param>
    /// <returns>updated Lage</returns>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(LageNotFoundException))]
    public async Task<Lage> UpdateLage(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        IClock clock,
        Guid lageId,
        string title,
        string? note,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var lage = await TrackedLageOfKommune(db, lageId, user.KommuneId, ct);

        lage.Title = title;
        lage.Note = note;
        lage.UpdatedAt = clock.GetCurrentInstant();
        await db.SaveChangesAsync(ct);

        return lage;
    }

    /// <summary>Adds Gebiete to a Lage as Inactive; a Gebiet whose earlier pass has ended gets a new pass</summary>
    /// <param name="lageId">Lage ID</param>
    /// <param name="gebietIds">Gebiete of the Lage's OE</param>
    /// <returns>updated Lage</returns>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(LageNotFoundException))]
    [Error(typeof(LageClosedException))]
    [Error(typeof(GebietOfOtherUntereinheitException))]
    [Error(typeof(GebietAlreadyInLageException))]
    public async Task<Lage> AddGebieteToLage(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        IClock clock,
        Guid lageId,
        List<Guid> gebietIds,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var lage = await TrackedLageOfKommune(db, lageId, user.KommuneId, ct);
        if (lage.Status == LageStatus.Closed) throw new LageClosedException();

        var requestedGebietIds = gebietIds.Distinct().ToList();
        var gebiete = await db.Gebiete.AsTracking()
            .Where(g => requestedGebietIds.Contains(g.Id) && g.UntereinheitId == lage.UntereinheitId)
            .ToListAsync(ct);
        if (gebiete.Count != requestedGebietIds.Count) throw new GebietOfOtherUntereinheitException();
        if (gebiete.Any(g => lage.HasOpenPass(g.Id))) throw new GebietAlreadyInLageException();

        foreach (var gebiet in gebiete) {
            lage.AddGebiet(gebiet);
        }
        lage.UpdatedAt = clock.GetCurrentInstant();
        await db.SaveChangesAsync(ct);

        return lage;
    }

    /// <summary>Moves the current pass of a Gebiet to the next status, stamping time and person</summary>
    /// <param name="lageId">Lage ID</param>
    /// <param name="gebietId">Gebiet ID</param>
    /// <param name="status">new status</param>
    /// <returns>updated Lage</returns>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(LageNotFoundException))]
    [Error(typeof(LageClosedException))]
    [Error(typeof(GebietNotInLageException))]
    [Error(typeof(InvalidLageGebietTransitionException))]
    public async Task<Lage> SetLageGebietStatus(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        IClock clock,
        Guid lageId,
        Guid gebietId,
        LageGebietStatus status,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var lage = await TrackedLageOfKommune(db, lageId, user.KommuneId, ct);
        if (lage.Status == LageStatus.Closed) throw new LageClosedException();

        var pass = lage.CurrentPass(gebietId) ?? throw new GebietNotInLageException();
        if (!LageGebietStateMachine.IsAllowed(pass.Status, status)) {
            throw new InvalidLageGebietTransitionException(pass.Status, status);
        }

        var now = clock.GetCurrentInstant();
        lage.TransitionGebiet(gebietId, status, user.Id, now);
        lage.UpdatedAt = now;
        await db.SaveChangesAsync(ct);

        return lage;
    }

    /// <summary>Ends all running Gebiete and closes the Lage: no new reports, the citizen button disappears</summary>
    /// <param name="lageId">Lage ID</param>
    /// <returns>closed Lage</returns>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(LageNotFoundException))]
    [Error(typeof(LageClosedException))]
    public async Task<Lage> CloseLage(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        IClock clock,
        Guid lageId,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var lage = await TrackedLageOfKommune(db, lageId, user.KommuneId, ct);
        if (lage.Status == LageStatus.Closed) throw new LageClosedException();

        lage.Close(user.Id, clock.GetCurrentInstant());
        await db.SaveChangesAsync(ct);

        return lage;
    }

    /// <summary>Sets the notice the citizen app shows in the Lage banner; null or blank removes it</summary>
    /// <param name="lageId">Lage ID</param>
    /// <param name="warningText">notice for citizens</param>
    /// <returns>updated Lage</returns>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(LageNotFoundException))]
    [Error(typeof(LageClosedException))]
    public async Task<Lage> UpdateLageWarningText(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        IClock clock,
        Guid lageId,
        string? warningText,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var lage = await TrackedLageOfKommune(db, lageId, user.KommuneId, ct);
        if (lage.Status == LageStatus.Closed) throw new LageClosedException();

        lage.WarningText = string.IsNullOrWhiteSpace(warningText) ? null : warningText.Trim();
        lage.UpdatedAt = clock.GetCurrentInstant();
        await db.SaveChangesAsync(ct);

        return lage;
    }

    [Authorize]
    [GraphQLDescription(
        "Nur Leitstelle: nimmt den Meldeweg einer Lage offline (offen: false) oder wieder online (offen: true). " +
        "Offline nimmt keine neuen Meldungen und keine Bestätigungen an und blendet die Lage in activeLagen aus; " +
        "die Gebiete bleiben LIVE, offene Meldungen bleiben bearbeitbar.")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(LageNotFoundException))]
    [Error(typeof(LageClosedException))]
    public async Task<Lage> SetLageMeldeweg(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        IClock clock,
        Guid lageId,
        bool offen,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();
        if (!LageMeldungen.IstLeitstelle(user)) {
            throw new NotAllowedException("Nur die Leitstelle kann den Meldeweg schalten.");
        }

        var lage = await TrackedLageOfKommune(db, lageId, user.KommuneId, ct);
        if (lage.Status == LageStatus.Closed) throw new LageClosedException();

        lage.SetMeldeweg(offen, user.Id, clock.GetCurrentInstant());
        await db.SaveChangesAsync(ct);

        return lage;
    }

    private static async Task<Lage> TrackedLageOfKommune(DomainContext db, Guid lageId, Guid kommuneId,
        CancellationToken ct) =>
        await db.Lagen.AsTracking()
            .Include(l => l.LageGebiete).ThenInclude(lg => lg.Gebiet)
            .FirstOrDefaultAsync(l => l.Id == lageId
                && l.DeletedAt == null
                && l.Untereinheit.KommuneId == kommuneId, ct)
        ?? throw new LageNotFoundException();
}
