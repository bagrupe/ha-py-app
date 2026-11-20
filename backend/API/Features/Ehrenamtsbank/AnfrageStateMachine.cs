namespace API.Features.Ehrenamtsbank;

/// <summary>Wer eine Statusänderung an einer Anfrage anstößt.</summary>
public enum AnfrageActor {
    /// <summary>Der Bürger, der die Anfrage gestellt hat.</summary>
    Interessent,
    /// <summary>Der Bürger, dem der zugehörige Eintrag gehört.</summary>
    Owner
}

/// <summary>Ergebnis einer Übergangsprüfung.</summary>
public record AnfrageTransition(bool Allowed, bool RejectsSiblingAnfragen) {
    public static readonly AnfrageTransition Denied = new(false, false);
}

/// <summary>
/// Geschlossene Übergangstabelle des Anfrage-Lebenszyklus. Alles, was hier nicht
/// explizit erlaubt ist, ist verboten. Erledigt ist kein anforderbarer Übergang, sondern
/// nur Nebeneffekt von confirmEhrenamtsbankAbschluss.
/// </summary>
public static class AnfrageStateMachine {
    private static readonly IReadOnlySet<(EhrenamtsbankAnfrageStatus From, EhrenamtsbankAnfrageStatus To, AnfrageActor Actor)> SiblingRejectTransitions =
        new HashSet<(EhrenamtsbankAnfrageStatus, EhrenamtsbankAnfrageStatus, AnfrageActor)> {
            (EhrenamtsbankAnfrageStatus.Akzeptiert, EhrenamtsbankAnfrageStatus.Vereinbart, AnfrageActor.Owner),
            (EhrenamtsbankAnfrageStatus.Akzeptiert, EhrenamtsbankAnfrageStatus.Vereinbart, AnfrageActor.Interessent),
        };

    private static readonly IReadOnlySet<(EhrenamtsbankAnfrageStatus From, EhrenamtsbankAnfrageStatus To, AnfrageActor Actor)> AllowedTransitions =
        new HashSet<(EhrenamtsbankAnfrageStatus, EhrenamtsbankAnfrageStatus, AnfrageActor)> {
            (EhrenamtsbankAnfrageStatus.Offen, EhrenamtsbankAnfrageStatus.Zurueckgezogen, AnfrageActor.Interessent),
            (EhrenamtsbankAnfrageStatus.Offen, EhrenamtsbankAnfrageStatus.Akzeptiert, AnfrageActor.Owner),
            (EhrenamtsbankAnfrageStatus.Offen, EhrenamtsbankAnfrageStatus.Abgelehnt, AnfrageActor.Owner),
            (EhrenamtsbankAnfrageStatus.Akzeptiert, EhrenamtsbankAnfrageStatus.Vereinbart, AnfrageActor.Owner),
            (EhrenamtsbankAnfrageStatus.Akzeptiert, EhrenamtsbankAnfrageStatus.Vereinbart, AnfrageActor.Interessent),
            (EhrenamtsbankAnfrageStatus.Akzeptiert, EhrenamtsbankAnfrageStatus.Abgelehnt, AnfrageActor.Owner),
        };

    public static readonly EhrenamtsbankAnfrageStatus[] NonTerminal = [
        EhrenamtsbankAnfrageStatus.Offen,
        EhrenamtsbankAnfrageStatus.Akzeptiert,
        EhrenamtsbankAnfrageStatus.Vereinbart,
    ];

    /// <summary>
    /// Prüft einen ausdrücklich angeforderten Statuswechsel. Deklariert nur die Übergänge,
    /// die ein Aufrufer selbst auslösen darf.
    /// </summary>
    public static AnfrageTransition Check(
        EhrenamtsbankAnfrageStatus from, EhrenamtsbankAnfrageStatus to, AnfrageActor actor) {
        return AllowedTransitions.Contains((from, to, actor))
            ? new AnfrageTransition(true, SiblingRejectTransitions.Contains((from, to, actor)))
            : AnfrageTransition.Denied;
    }
}
