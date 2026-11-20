using API.Features.Auth;
using API.Features.Ehrenamtsbank.Queries;
using API.Features.Funktionsberechtigungen;
using API.Features.ObjectStorage;
using API.Infrastructure;
using API.Options;
using HotChocolate.Authorization;
using HotChocolate.Resolvers;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using NodaTime;

namespace API.Features.Ehrenamtsbank.Mutations;

public class EintragValidationException : DomainException {
    public EintragValidationException(string message) : base(message) { }
}

public class EintragConflictException : DomainException {
    public EintragConflictException()
        : base("Der Eintrag wurde zwischenzeitlich geändert. Bitte neu laden und erneut versuchen.") { }
}

public class EintragStatusTransitionException : DomainException {
    public EintragStatusTransitionException(
        EhrenamtsbankEintragStatus from, EhrenamtsbankEintragStatus to)
        : base($"Übergang von {from} nach {to} ist für diesen Akteur nicht erlaubt.") { }
}

[MutationType]
public class EintragMutations {
    /// <summary>Creates a draft entry for the current registered citizen.</summary>
    [Error(typeof(NotAllowedException))]
    [Error(typeof(EintragValidationException))]
    [Authorize]
    public async Task<EhrenamtsbankEintrag> CreateEhrenamtsbankEintrag(
        DomainContext db, CurrentUserAccessor currentUserAccessor, [Service] IClock clock,
        [Service] IOptions<EhrenamtsbankOptions> options, [Service] IObjectStorage objectStorage,
        EhrenamtsbankEintragTyp typ, string title, string description,
        Guid kategorieId, Guid untereinheitId, int? radiusKm,
        EhrenamtsbankDringlichkeit? urgency, int? estimatedDurationMinutes,
        string? availability, string? imageKey, List<string>? tags,
        EhrenamtsbankLocationInput? location, CancellationToken ct) {
        var buerger = await RequireRegistrierterBuerger(currentUserAccessor);
        ValidateFelder(typ, title, description, radiusKm, urgency, estimatedDurationMinutes, availability);
        var normalizedLocation = location is null
            ? (EhrenamtsbankLocation?)null
            : EhrenamtsbankLocationValidation.Normalize(location);
        await ValidateKategorieUndClearance(db, buerger, typ, kategorieId, ct);
        await ValidateGemeinde(db, untereinheitId, ct);
        if (imageKey is not null) {
            await ValidateNewImageKey(db, objectStorage, imageKey, ct);
        }

        var now = clock.GetCurrentInstant();
        var eintrag = new EhrenamtsbankEintrag {
            Id = Guid.NewGuid(),
            Typ = typ,
            OwnerId = buerger.Id,
            Title = title,
            Description = description,
            KategorieId = kategorieId,
            UntereinheitId = untereinheitId,
            RadiusKm = radiusKm,
            Status = EintragStateMachine.InitialStatus(options.Value.EintragSkipReview),
            Urgency = urgency,
            EstimatedDurationMinutes = estimatedDurationMinutes,
            Availability = availability,
            ImageKey = imageKey,
            Tags = tags ?? [],
            Address = normalizedLocation?.Address,
            Latitude = normalizedLocation?.Latitude,
            Longitude = normalizedLocation?.Longitude,
            CreatedAt = now,
            UpdatedAt = now,
        };
        db.EhrenamtsbankEintraege.Add(eintrag);
        await db.SaveChangesAsync(ct);
        return eintrag;
    }

    /// <summary>Updates an owned entry, returning active or paused entries to review.
    /// An omitted location or imageKey is unchanged, null clears it, and a value replaces it.</summary>
    [Error(typeof(NotAllowedException))]
    [Error(typeof(EintragValidationException))]
    [Error(typeof(EintragNotFoundException))]
    [Error(typeof(EintragConflictException))]
    [Authorize]
    public async Task<EhrenamtsbankEintrag> UpdateEhrenamtsbankEintrag(
        DomainContext db, CurrentUserAccessor currentUserAccessor, [Service] IClock clock,
        [Service] IOptions<EhrenamtsbankOptions> options, [Service] IObjectStorage objectStorage,
        Guid id, string title, string description,
        Guid kategorieId, Guid untereinheitId, int? radiusKm,
        EhrenamtsbankDringlichkeit? urgency, int? estimatedDurationMinutes,
        string? availability, string? imageKey, List<string>? tags,
        EhrenamtsbankLocationInput? location, IResolverContext context, CancellationToken ct) {
        var buerger = await RequireRegistrierterBuerger(currentUserAccessor);

        var isLocationProvided = context.ArgumentOptional<EhrenamtsbankLocationInput>("location").HasValue;
        var isImageKeyProvided = context.ArgumentOptional<string>("imageKey").HasValue;
        var eintrag = await db.EhrenamtsbankEintraege.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == id && !e.IsDeleted, ct)
            ?? throw new EintragNotFoundException();
        if (eintrag.OwnerId != buerger.Id) {
            throw new NotAllowedException("Nur eigene Einträge können bearbeitet werden.");
        }

        if (EintragStateMachine.AfterContentEdit(eintrag.Status, options.Value.EintragSkipReview)
            is not { } statusNachBearbeitung) {
            throw new NotAllowedException(
                "Vergebene und abgeschlossene Einträge können nicht bearbeitet werden.");
        }

        ValidateFelder(eintrag.Typ, title, description, radiusKm, urgency, estimatedDurationMinutes, availability);

        var neuerOrt = isLocationProvided && location is not null
            ? EhrenamtsbankLocationValidation.Normalize(location)
            : (EhrenamtsbankLocation?)null;
        // Bewusst bei jeder Bearbeitung: ein zwischenzeitlich entzogenes Führungszeugnis muss
        // auch dann greifen, wenn die Kategorie unverändert bleibt (kein Clearance = nicht live).
        await ValidateKategorieUndClearance(db, buerger, eintrag.Typ, kategorieId, ct);

        if (untereinheitId != eintrag.UntereinheitId) {
            await ValidateGemeinde(db, untereinheitId, ct);
        }

        var now = clock.GetCurrentInstant();
        if (isImageKeyProvided && imageKey != eintrag.ImageKey) {
            if (imageKey is not null) {
                await ValidateNewImageKey(db, objectStorage, imageKey, ct);
            }

            if (eintrag.ImageKey is not null) {
                db.EnqueueObjectDeletion(eintrag.ImageKey, now);
            }

            eintrag.ImageKey = imageKey;
        }

        eintrag.Status = statusNachBearbeitung;
        if (statusNachBearbeitung == EhrenamtsbankEintragStatus.PendingReview) {
            eintrag.ReviewedAt = null;
        }
        eintrag.Title = title;
        eintrag.Description = description;
        eintrag.KategorieId = kategorieId;
        eintrag.UntereinheitId = untereinheitId;
        eintrag.RadiusKm = radiusKm;
        eintrag.Urgency = urgency;
        eintrag.EstimatedDurationMinutes = estimatedDurationMinutes;
        eintrag.Availability = availability;
        eintrag.Tags = tags ?? [];
        if (isLocationProvided) {
            eintrag.Address = neuerOrt?.Address;
            eintrag.Latitude = neuerOrt?.Latitude;
            eintrag.Longitude = neuerOrt?.Longitude;
        }

        eintrag.UpdatedAt = now;
        await SaveGuarded(db, ct);
        return eintrag;
    }

    /// <summary>Statuswechsel entlang des Lebenszyklus. Der Akteur ergibt sich aus dem
    /// Aufrufer: Inhaber → Owner, Backoffice mit Funktionsberechtigung Ehrenamtsbank →
    /// Moderation. Freigabe und Ablehnung setzen ReviewedAt.</summary>
    [Error(typeof(NotAllowedException))]
    [Error(typeof(EintragStatusTransitionException))]
    [Error(typeof(EintragNotFoundException))]
    [Error(typeof(EintragConflictException))]
    [Authorize]
    public async Task<EhrenamtsbankEintrag> UpdateEhrenamtsbankEintragStatus(
        DomainContext db, CurrentUserAccessor currentUserAccessor, [Service] IClock clock,
        [Service] IOptions<EhrenamtsbankOptions> options,
        Guid id, EhrenamtsbankEintragStatus status, CancellationToken ct) {
        var eintrag = await db.EhrenamtsbankEintraege.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == id && !e.IsDeleted, ct)
            ?? throw new EintragNotFoundException();

        var actor = await ResolveActor(currentUserAccessor, eintrag);
        var transition = EintragStateMachine.Check(eintrag.Status, status, actor, options.Value.EintragSkipReview);
        if (!transition.Allowed) {
            throw new EintragStatusTransitionException(eintrag.Status, status);
        }

        var now = clock.GetCurrentInstant();
        eintrag.Status = status;
        eintrag.UpdatedAt = now;
        if (transition.SetsReviewedAt) {
            eintrag.ReviewedAt = now;
        } else if (status == EhrenamtsbankEintragStatus.PendingReview) {
            eintrag.ReviewedAt = null;
        }

        if (status is EhrenamtsbankEintragStatus.Closed or EhrenamtsbankEintragStatus.Completed) {
            await RejectNonTerminalAnfragen(db, eintrag.Id, now, ct);
        }

        await SaveGuarded(db, ct);
        return eintrag;
    }

    /// <summary>Soft-Delete eines eigenen Eintrags (in jedem Status). Die Zeile bleibt
    /// erhalten, verschwindet aber aus allen Queries.</summary>
    [UseMutationConvention(PayloadFieldName = "deletedId")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(EintragNotFoundException))]
    [Error(typeof(EintragConflictException))]
    [Authorize]
    public async Task<Guid> DeleteEhrenamtsbankEintrag(
        DomainContext db, CurrentUserAccessor currentUserAccessor, [Service] IClock clock,
        Guid id, CancellationToken ct) {
        var buerger = await RequireRegistrierterBuerger(currentUserAccessor);
        var eintrag = await db.EhrenamtsbankEintraege.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == id && !e.IsDeleted, ct)
            ?? throw new EintragNotFoundException();
        if (eintrag.OwnerId != buerger.Id) {
            throw new NotAllowedException("Nur eigene Einträge können gelöscht werden.");
        }

        var now = clock.GetCurrentInstant();
        eintrag.IsDeleted = true;
        eintrag.UpdatedAt = now;
        if (eintrag.ImageKey is not null) {
            db.EnqueueObjectDeletion(eintrag.ImageKey, now);
        }
        await RejectNonTerminalAnfragen(db, eintrag.Id, now, ct);
        await SaveGuarded(db, ct);
        return eintrag.Id;
    }

    private static async Task RejectNonTerminalAnfragen(
        DomainContext db, Guid eintragId, Instant now, CancellationToken ct) {
        var nonTerminal = await db.EhrenamtsbankAnfragen.AsTracking()
            .Where(a => a.EintragId == eintragId && AnfrageStateMachine.NonTerminal.Contains(a.Status))
            .ToListAsync(ct);
        foreach (var anfrage in nonTerminal) {
            anfrage.Status = EhrenamtsbankAnfrageStatus.Abgelehnt;
            anfrage.UpdatedAt = now;
        }
    }

    /// <summary>Speichert und übersetzt eine verlorene Schreib-Wettlaufsituation (der Eintrag
    /// wurde zwischen Laden und Speichern von jemand anderem geändert) in einen typisierten
    /// Fehler, statt die fremde Änderung stillschweigend zu überschreiben oder zu behalten.</summary>
    internal static async Task SaveGuarded(DomainContext db, CancellationToken ct) {
        try {
            await db.SaveChangesAsync(ct);
        } catch (DbUpdateConcurrencyException) {
            throw new EintragConflictException();
        }
    }

    private static async Task<Buerger> RequireRegistrierterBuerger(CurrentUserAccessor currentUserAccessor) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger { IsRegistered: true } buerger) {
            throw new NotAllowedException("Nur registrierte Nutzer können diese Aktion ausführen.");
        }

        return buerger;
    }

    private static void ValidateFelder(EhrenamtsbankEintragTyp typ, string title, string description,
        int? radiusKm, EhrenamtsbankDringlichkeit? urgency, int? estimatedDurationMinutes, string? availability) {
        if (string.IsNullOrWhiteSpace(title) || title.Length > 150) {
            throw new EintragValidationException("Der Titel muss 1 bis 150 Zeichen lang sein.");
        }

        if (string.IsNullOrWhiteSpace(description)) {
            throw new EintragValidationException("Die Beschreibung darf nicht leer sein.");
        }

        if (radiusKm is < 0) {
            throw new EintragValidationException("Der Radius darf nicht negativ sein.");
        }

        if (estimatedDurationMinutes is < 0) {
            throw new EintragValidationException("Der geschätzte Aufwand darf nicht negativ sein.");
        }

        if (EintragTypValidation.Validate(typ, urgency, estimatedDurationMinutes, availability) is { } fehler) {
            throw new EintragValidationException(fehler);
        }
    }

    private static async Task ValidateKategorieUndClearance(DomainContext db, Buerger buerger,
        EhrenamtsbankEintragTyp typ, Guid kategorieId, CancellationToken ct) {
        var alleKategorien = await db.EhrenamtsbankKategorien.ToListAsync(ct);
        var effektivAktiv = KategorieTree.FilterEffectivelyActive(alleKategorien);
        if (effektivAktiv.All(k => k.Id != kategorieId)) {
            throw new EintragValidationException("Die Kategorie existiert nicht oder ist nicht aktiv.");
        }

        if (typ == EhrenamtsbankEintragTyp.Angebot
            && KategorieTree.RequiresEffectiveClearance(kategorieId, alleKategorien)
            && !buerger.RequiresClearanceVerified) {
            throw new NotAllowedException(
                "Angebote in dieser Kategorie erfordern ein verifiziertes Führungszeugnis.");
        }
    }

    /// <summary>Rejects malformed keys, keys of other consumers or other Einträge, missing objects, and objects whose
    /// deletion is already enqueued.</summary>
    private static async Task ValidateNewImageKey(
        DomainContext db, IObjectStorage objectStorage, string imageKey, CancellationToken ct) {
        var keyPrefix = $"{EhrenamtsbankEintragImageStorageConsumer.KeyPrefix}/";
        if (!imageKey.StartsWith(keyPrefix, StringComparison.Ordinal)
            || !ObjectStorageController.IsObjectId(imageKey[keyPrefix.Length..])
            || await db.EhrenamtsbankEintraege.AnyAsync(e => e.ImageKey == imageKey && !e.IsDeleted, ct)
            || await db.IsObjectDeletionPendingAsync(imageKey, ct)
            || !await objectStorage.ExistsAsync(imageKey, ct)) {
            throw new EintragValidationException("Das Bild existiert nicht oder wurde bereits gelöscht.");
        }
    }

    private static async Task ValidateGemeinde(DomainContext db, Guid untereinheitId, CancellationToken ct) {
        var untereinheit = await db.Untereinheit.FirstOrDefaultAsync(u => u.Id == untereinheitId, ct);
        if (untereinheit is not { IsGemeinde: true }) {
            throw new EintragValidationException("Der Ort muss eine Gemeinde sein.");
        }
    }

    private static async Task<EintragActor> ResolveActor(
        CurrentUserAccessor currentUserAccessor, EhrenamtsbankEintrag eintrag) {
        var user = await currentUserAccessor.User();
        if (user is Buerger buerger) {
            if (buerger.Id != eintrag.OwnerId) {
                throw new NotAllowedException("Kein Zugriff auf fremde Einträge.");
            }

            return EintragActor.Owner;
        }

        var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Ehrenamtsbank).Fordern();
        return EintragActor.Moderator;
    }
}
