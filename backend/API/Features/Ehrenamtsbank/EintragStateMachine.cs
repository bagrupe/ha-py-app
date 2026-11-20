namespace API.Features.Ehrenamtsbank;

/// <summary>Wer eine Statusänderung anstößt.</summary>
public enum EintragActor {
    /// <summary>Der Bürger, dem der Eintrag gehört.</summary>
    Owner,
    /// <summary>Backoffice mit der globalen Funktionsberechtigung Ehrenamtsbank.</summary>
    Moderator
}

/// <summary>Ergebnis einer Übergangsprüfung.</summary>
public record EintragTransition(bool Allowed, bool SetsReviewedAt) {
    public static readonly EintragTransition Denied = new(false, false);
}

/// <summary>
/// Geschlossene Übergangstabelle des Status-Lebenszyklus. Alles, was hier nicht
/// explizit erlaubt ist, ist verboten; Completed und Closed sind Endzustände
/// ohne jeden Ausgang — auch nicht voneinander.
/// </summary>
public static class EintragStateMachine {
    private static readonly HashSet<(EhrenamtsbankEintragStatus, EhrenamtsbankEintragStatus, EintragActor)> ReviewedAtTransitions =
        new() {
            (EhrenamtsbankEintragStatus.PendingReview, EhrenamtsbankEintragStatus.Active, EintragActor.Moderator),
            (EhrenamtsbankEintragStatus.PendingReview, EhrenamtsbankEintragStatus.Draft, EintragActor.Moderator),
        };

    private static readonly HashSet<(EhrenamtsbankEintragStatus, EhrenamtsbankEintragStatus, EintragActor)> AllowedTransitions =
        new() {
            (EhrenamtsbankEintragStatus.Draft, EhrenamtsbankEintragStatus.PendingReview, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.PendingReview, EhrenamtsbankEintragStatus.Active, EintragActor.Moderator),
            (EhrenamtsbankEintragStatus.PendingReview, EhrenamtsbankEintragStatus.Draft, EintragActor.Moderator),
            (EhrenamtsbankEintragStatus.Active, EhrenamtsbankEintragStatus.Paused, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Paused, EhrenamtsbankEintragStatus.Active, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Active, EhrenamtsbankEintragStatus.Completed, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Paused, EhrenamtsbankEintragStatus.Completed, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Draft, EhrenamtsbankEintragStatus.Closed, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.PendingReview, EhrenamtsbankEintragStatus.Closed, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Active, EhrenamtsbankEintragStatus.Closed, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Paused, EhrenamtsbankEintragStatus.Closed, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Active, EhrenamtsbankEintragStatus.Closed, EintragActor.Moderator),
            (EhrenamtsbankEintragStatus.Paused, EhrenamtsbankEintragStatus.Closed, EintragActor.Moderator),
            (EhrenamtsbankEintragStatus.Assigned, EhrenamtsbankEintragStatus.Closed, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Assigned, EhrenamtsbankEintragStatus.Closed, EintragActor.Moderator),
        };

    private static readonly HashSet<(EhrenamtsbankEintragStatus, EhrenamtsbankEintragStatus, EintragActor)> SkipReviewTransitions =
        new() {
            (EhrenamtsbankEintragStatus.Draft, EhrenamtsbankEintragStatus.Active, EintragActor.Owner),
            (EhrenamtsbankEintragStatus.Active, EhrenamtsbankEintragStatus.Draft, EintragActor.Owner),
        };

    /// <summary>
    /// Prüft einen ausdrücklich angeforderten Statuswechsel. Deckt nur die Übergänge ab,
    /// die ein Aufrufer selbst auslösen darf — T8 gehört bewusst nicht dazu.
    /// </summary>
    public static EintragTransition Check(
        EhrenamtsbankEintragStatus from, EhrenamtsbankEintragStatus to, EintragActor actor,
        bool skipReview = false) {
        if (AllowedTransitions.Contains((from, to, actor))) {
            return new EintragTransition(true, ReviewedAtTransitions.Contains((from, to, actor)));
        }

        return skipReview && SkipReviewTransitions.Contains((from, to, actor))
            ? new EintragTransition(true, false)
            : EintragTransition.Denied;
    }

    public static EhrenamtsbankEintragStatus InitialStatus(bool skipReview) =>
        skipReview ? EhrenamtsbankEintragStatus.Active : EhrenamtsbankEintragStatus.Draft;

    public static EhrenamtsbankEintragStatus AfterVereinbart => EhrenamtsbankEintragStatus.Assigned;

    /// <summary>
    /// T8: Status, den ein Eintrag nach einer inhaltlichen Bearbeitung durch den Inhaber
    /// annimmt. Das ist eine Nebenwirkung des Bearbeitens, kein anforderbarer Übergang —
    /// deshalb steht er nicht in <see cref="AllowedTransitions"/> und ist über
    /// updateEhrenamtsbankEintragStatus nicht erreichbar. Null bedeutet: in diesem Status
    /// darf gar nicht mehr bearbeitet werden.
    /// </summary>
    public static EhrenamtsbankEintragStatus? AfterContentEdit(
        EhrenamtsbankEintragStatus from, bool skipReview = false) =>
        from switch {
            EhrenamtsbankEintragStatus.Draft or EhrenamtsbankEintragStatus.PendingReview => from,
            EhrenamtsbankEintragStatus.Active or EhrenamtsbankEintragStatus.Paused =>
                skipReview ? from : EhrenamtsbankEintragStatus.PendingReview,
            _ => null,
        };
}
