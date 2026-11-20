using API.Features.Auth;
using API.Features.Ehrenamtsbank.Queries;
using API.Infrastructure;
using API.Options;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using NodaTime;
using Npgsql;

namespace API.Features.Ehrenamtsbank.Mutations;

public class AbschlussNotVereinbartException()
    : DomainException("Ein Abschluss kann nur für eine vereinbarte Anfrage vorgeschlagen werden");
public class AbschlussMinutesOutOfRangeException(int max)
    : DomainException($"Die Dauer muss zwischen 1 und {max} Minuten liegen");
public class AbschlussDateInFutureException()
    : DomainException("Das Datum darf nicht in der Zukunft liegen");
public class AbschlussNoteTooLongException(int max)
    : DomainException($"Die Notiz darf höchstens {max} Zeichen lang sein");
public class AbschlussNoProposalException()
    : DomainException("Für diese Anfrage liegt kein Abschlussvorschlag vor");
public class AbschlussSelfConfirmException()
    : DomainException("Der Vorschlag muss von der anderen Partei bestätigt werden");
public class AbschlussAlreadyBookedException()
    : DomainException("Der Abschluss dieser Anfrage wurde bereits gebucht");
public class AbschlussEintragNotAssignedException()
    : DomainException("Ein Abschluss ist nur für einen vergebenen Eintrag möglich");

[MutationType]
public class AbschlussMutations {

    [Error(typeof(CurrentUserAccessor.Unauthenticated))]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(AnfrageNotFoundException))]
    [Error(typeof(EintragNotFoundException))]
    [Error(typeof(AbschlussNotVereinbartException))]
    [Error(typeof(AbschlussMinutesOutOfRangeException))]
    [Error(typeof(AbschlussDateInFutureException))]
    [Error(typeof(AbschlussNoteTooLongException))]
    [Error(typeof(AbschlussEintragNotAssignedException))]
    [Authorize]
    [GraphQLDescription(
        "Schlägt den Abschluss einer vereinbarten Anfrage vor. Ein neuer Vorschlag ersetzt den vorherigen.")]
    public async Task<EhrenamtsbankAnfrage> ProposeEhrenamtsbankAbschluss(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        [Service] IClock clock,
        [Service] IOptions<EhrenamtsbankZeitkontoOptions> zeitkontoOptions,
        Guid anfrageId,
        int minutes,
        LocalDate date,
        string? note,
        CancellationToken ct) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();
        var anfrage = await db.EhrenamtsbankAnfragen.AsTracking()
            .FirstOrDefaultAsync(a => a.Id == anfrageId, ct)
            ?? throw new AnfrageNotFoundException();

        var eintrag = await db.EhrenamtsbankEintraege
            .FirstOrDefaultAsync(e => e.Id == anfrage.EintragId && !e.IsDeleted, ct)
            ?? throw new EintragNotFoundException();

        AnfrageMutations.ResolveActor(buerger.Id, anfrage, eintrag);

        if (anfrage.Status != EhrenamtsbankAnfrageStatus.Vereinbart) {
            throw new AbschlussNotVereinbartException();
        }

        if (eintrag.Status != EhrenamtsbankEintragStatus.Assigned) {
            throw new AbschlussEintragNotAssignedException();
        }

        var options = zeitkontoOptions.Value;
        if (minutes < 1 || minutes > options.MaxTransactionMinutes) {
            throw new AbschlussMinutesOutOfRangeException(options.MaxTransactionMinutes);
        }

        if (date > API.Utils.DateTime.Today()) {
            throw new AbschlussDateInFutureException();
        }

        if (note?.Length > options.MaxNoteLength) {
            throw new AbschlussNoteTooLongException(options.MaxNoteLength);
        }

        anfrage.ProposedMinutes = minutes;
        anfrage.ProposedDate = date;
        anfrage.ProposedNote = note;
        anfrage.ProposedById = buerger.Id;
        anfrage.UpdatedAt = clock.GetCurrentInstant();
        await db.SaveChangesAsync(ct);

        return anfrage;
    }

    [Error(typeof(CurrentUserAccessor.Unauthenticated))]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(AnfrageNotFoundException))]
    [Error(typeof(EintragNotFoundException))]
    [Error(typeof(AbschlussNotVereinbartException))]
    [Error(typeof(AbschlussNoProposalException))]
    [Error(typeof(AbschlussSelfConfirmException))]
    [Error(typeof(AbschlussAlreadyBookedException))]
    [Error(typeof(AbschlussEintragNotAssignedException))]
    [Authorize]
    [GraphQLDescription(
        "Bestätigt den Abschlussvorschlag der anderen Partei und bucht die Stunden.")]
    public async Task<EhrenamtsbankAnfrage> ConfirmEhrenamtsbankAbschluss(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        [Service] IClock clock,
        Guid anfrageId,
        CancellationToken ct) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();
        var anfrage = await db.EhrenamtsbankAnfragen.AsTracking()
            .FirstOrDefaultAsync(a => a.Id == anfrageId, ct)
            ?? throw new AnfrageNotFoundException();

        // The Eintrag carries an xmin concurrency token that is only populated on a tracked load.
        var eintrag = await db.EhrenamtsbankEintraege.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == anfrage.EintragId && !e.IsDeleted, ct)
            ?? throw new EintragNotFoundException();

        AnfrageMutations.ResolveActor(buerger.Id, anfrage, eintrag);

        if (anfrage.Status != EhrenamtsbankAnfrageStatus.Vereinbart) {
            throw new AbschlussNotVereinbartException();
        }

        if (eintrag.Status != EhrenamtsbankEintragStatus.Assigned) {
            throw new AbschlussEintragNotAssignedException();
        }

        if (anfrage.ProposedById is not { } proposedById
            || anfrage.ProposedMinutes is not { } minutes
            || anfrage.ProposedDate is not { } performedOn) {
            throw new AbschlussNoProposalException();
        }

        if (proposedById == buerger.Id) {
            throw new AbschlussSelfConfirmException();
        }

        var gesuch = eintrag.Typ == EhrenamtsbankEintragTyp.Gesuch;
        db.EhrenamtsbankTransaktionen.Add(new EhrenamtsbankTransaktion {
            Id = Guid.NewGuid(),
            AnfrageId = anfrage.Id,
            EintragId = anfrage.EintragId,
            GiverId = gesuch ? anfrage.InteressentId : eintrag.OwnerId,
            ReceiverId = gesuch ? eintrag.OwnerId : anfrage.InteressentId,
            Minutes = minutes,
            PerformedOn = performedOn,
            Status = EhrenamtsbankTransaktionStatus.Confirmed,
            Note = anfrage.ProposedNote,
            CreatedAt = clock.GetCurrentInstant(),
            CreatedBy = EhrenamtsbankTransaktionCreatedBy.System
        });

        anfrage.Status = EhrenamtsbankAnfrageStatus.Erledigt;
        anfrage.UpdatedAt = clock.GetCurrentInstant();
        eintrag.Status = EhrenamtsbankEintragStatus.Completed;
        eintrag.UpdatedAt = clock.GetCurrentInstant();

        try {
            await db.SaveChangesAsync(ct);
        } catch (DbUpdateException e) when (e is DbUpdateConcurrencyException || IsUniqueViolation(e)) {
            // Concurrent confirmation: either the unique index on AnfrageId or the Eintrag's xmin
            // token trips, depending on which statement in the batch fails first.
            throw new AbschlussAlreadyBookedException();
        }

        return anfrage;
    }

    private static bool IsUniqueViolation(DbUpdateException e) =>
        e.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation };
}
