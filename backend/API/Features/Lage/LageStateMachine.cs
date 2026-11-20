namespace API.Features.Lage;

public static class LageStateMachine {
    public static bool CanClose(LageStatus current, IEnumerable<LageGebietStatus> gebietStatuses) =>
        current != LageStatus.Closed
        && gebietStatuses.All(s => s is LageGebietStatus.Inactive or LageGebietStatus.Ended or LageGebietStatus.Done);
}

public static class LageGebietStateMachine {
    private static readonly HashSet<(LageGebietStatus From, LageGebietStatus To)> AllowedTransitions = [
        (LageGebietStatus.Inactive, LageGebietStatus.CalledOut),
        (LageGebietStatus.CalledOut, LageGebietStatus.Ready),
        (LageGebietStatus.Ready, LageGebietStatus.Live),
        (LageGebietStatus.CalledOut, LageGebietStatus.Ended),
        (LageGebietStatus.Ready, LageGebietStatus.Ended),
        (LageGebietStatus.Live, LageGebietStatus.Ended),
        (LageGebietStatus.Ended, LageGebietStatus.Done),
    ];

    public static bool IsAllowed(LageGebietStatus from, LageGebietStatus to) =>
        AllowedTransitions.Contains((from, to));

    public static bool AcceptsMeldungen(LageGebietStatus status) => status == LageGebietStatus.Live;

    /// <summary>Must match the filter of the unique index IX_LageGebiete_LageId_GebietId_Open.</summary>
    public static bool IsOpen(LageGebietStatus status) =>
        status is LageGebietStatus.Inactive or LageGebietStatus.CalledOut or LageGebietStatus.Ready
            or LageGebietStatus.Live;
}
