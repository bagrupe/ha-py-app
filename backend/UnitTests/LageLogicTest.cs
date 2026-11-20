using API.Features.Lage;
using NodaTime;

namespace UnitTests;

using Status = LageGebietStatus;

public class LageLogicTest {
    [Theory]
    [InlineData(Status.Inactive, Status.CalledOut)]
    [InlineData(Status.CalledOut, Status.Ready)]
    [InlineData(Status.Ready, Status.Live)]
    [InlineData(Status.Live, Status.Ended)]
    [InlineData(Status.CalledOut, Status.Ended)]
    [InlineData(Status.Ready, Status.Ended)]
    [InlineData(Status.Ended, Status.Done)]
    public void GebietStateMachine_AllowsDefinedTransitions(Status from, Status to) {
        Assert.True(LageGebietStateMachine.IsAllowed(from, to));
    }

    private static readonly HashSet<(Status, Status)> AllowedPairs = [
        (Status.Inactive, Status.CalledOut),
        (Status.CalledOut, Status.Ready),
        (Status.Ready, Status.Live),
        (Status.CalledOut, Status.Ended),
        (Status.Ready, Status.Ended),
        (Status.Live, Status.Ended),
        (Status.Ended, Status.Done),
    ];

    public static TheoryData<Status, Status> RefusedPairs() {
        var data = new TheoryData<Status, Status>();
        foreach (var from in Enum.GetValues<Status>()) {
            foreach (var to in Enum.GetValues<Status>()) {
                if (!AllowedPairs.Contains((from, to))) {
                    data.Add(from, to);
                }
            }
        }
        return data;
    }

    public static TheoryData<Status> AllStatuses() {
        var data = new TheoryData<Status>();
        foreach (var status in Enum.GetValues<Status>()) {
            data.Add(status);
        }
        return data;
    }

    [Theory]
    [MemberData(nameof(AllStatuses))]
    public void AcceptsMeldungen_only_when_Live(Status status) {
        Assert.Equal(status == Status.Live, LageGebietStateMachine.AcceptsMeldungen(status));
    }

    [Fact]
    public void RefusedPairs_CoverEveryCombinationExceptTheAllowedOnes() {
        var statusCount = Enum.GetValues<Status>().Length;
        Assert.Equal(statusCount * statusCount - AllowedPairs.Count, RefusedPairs().Count());
    }

    [Theory]
    [MemberData(nameof(RefusedPairs))]
    public void GebietStateMachine_RejectsEveryOtherPair(Status from, Status to) {
        Assert.False(LageGebietStateMachine.IsAllowed(from, to));
    }

    [Theory]
    [InlineData(new[] { Status.Inactive, Status.Ended }, true)]
    [InlineData(new[] { Status.Done, Status.Ended, Status.Inactive }, true)]
    [InlineData(new Status[0], true)]
    [InlineData(new[] { Status.Ended, Status.CalledOut }, false)]
    [InlineData(new[] { Status.Ended, Status.Ready }, false)]
    [InlineData(new[] { Status.Ended, Status.Live }, false)]
    public void Lage_ClosesOnlyWhenNoGebietIsInProgress(Status[] gebietStatuses, bool allowed) {
        Assert.Equal(allowed, LageStateMachine.CanClose(LageStatus.Created, gebietStatuses));
    }

    [Fact]
    public void Active_Lage_can_be_closed() {
        Assert.True(LageStateMachine.CanClose(LageStatus.Active, [Status.Ended]));
    }

    [Fact]
    public void Lage_CannotBeClosedTwice() {
        Assert.False(LageStateMachine.CanClose(LageStatus.Closed, []));
    }

    [Fact]
    public void Create_AddsEveryGebietOfTheUntereinheitAsInactive() {
        var untereinheitId = Guid.NewGuid();
        var gebiete = new[] { NewGebiet(untereinheitId), NewGebiet(untereinheitId) };

        var createdById = Guid.NewGuid();

        var lage = Lage.Create(untereinheitId, "Sturm", gebiete, createdById, Instant.FromUnixTimeSeconds(0));

        Assert.Equal(LageStatus.Created, lage.Status);
        Assert.Equal(createdById, lage.CreatedById);
        Assert.Equal(gebiete.Select(g => g.Id).Order(), lage.LageGebiete.Select(lg => lg.GebietId).Order());
        Assert.All(lage.LageGebiete, lg => {
            Assert.Equal(lage.Id, lg.LageId);
            Assert.Equal(Status.Inactive, lg.Status);
        });
    }

    [Fact]
    public void Create_RejectsGebietOfAnotherUntereinheit() {
        var foreignGebiet = NewGebiet(Guid.NewGuid());

        Assert.Throws<ArgumentException>(() =>
            Lage.Create(Guid.NewGuid(), "Sturm", [foreignGebiet], Guid.NewGuid(),
                Instant.FromUnixTimeSeconds(0)));
    }

    [Fact]
    public void TransitionTo_SetsOnlyTheMatchingPairAndKeepsEarlierOnes() {
        var lageGebiet = new LageGebiet();
        var calledOutBy = Guid.NewGuid();
        var readyBy = Guid.NewGuid();
        var liveBy = Guid.NewGuid();
        var endedBy = Guid.NewGuid();
        var calledOutAt = Instant.FromUnixTimeSeconds(1);
        var readyAt = Instant.FromUnixTimeSeconds(2);
        var liveAt = Instant.FromUnixTimeSeconds(3);
        var endedAt = Instant.FromUnixTimeSeconds(4);

        lageGebiet.TransitionTo(Status.CalledOut, calledOutBy, calledOutAt);
        Assert.Equal(Status.CalledOut, lageGebiet.Status);
        Assert.Equal((calledOutAt, calledOutBy), (lageGebiet.CalledOutAt, lageGebiet.CalledOutById));
        Assert.Null(lageGebiet.ReadyAt);
        Assert.Null(lageGebiet.LiveAt);
        Assert.Null(lageGebiet.EndedAt);

        lageGebiet.TransitionTo(Status.Ready, readyBy, readyAt);
        Assert.Equal(Status.Ready, lageGebiet.Status);
        Assert.Equal((readyAt, readyBy), (lageGebiet.ReadyAt, lageGebiet.ReadyById));
        Assert.Equal((calledOutAt, calledOutBy), (lageGebiet.CalledOutAt, lageGebiet.CalledOutById));
        Assert.Null(lageGebiet.LiveAt);
        Assert.Null(lageGebiet.EndedAt);

        lageGebiet.TransitionTo(Status.Live, liveBy, liveAt);
        Assert.Equal(Status.Live, lageGebiet.Status);
        Assert.Equal((liveAt, liveBy), (lageGebiet.LiveAt, lageGebiet.LiveById));
        Assert.Equal((readyAt, readyBy), (lageGebiet.ReadyAt, lageGebiet.ReadyById));
        Assert.Equal((calledOutAt, calledOutBy), (lageGebiet.CalledOutAt, lageGebiet.CalledOutById));
        Assert.Null(lageGebiet.EndedAt);

        lageGebiet.TransitionTo(Status.Ended, endedBy, endedAt);
        Assert.Equal(Status.Ended, lageGebiet.Status);
        Assert.Equal((endedAt, endedBy), (lageGebiet.EndedAt, lageGebiet.EndedById));
        Assert.Equal((liveAt, liveBy), (lageGebiet.LiveAt, lageGebiet.LiveById));
        Assert.Equal((readyAt, readyBy), (lageGebiet.ReadyAt, lageGebiet.ReadyById));
        Assert.Equal((calledOutAt, calledOutBy), (lageGebiet.CalledOutAt, lageGebiet.CalledOutById));
    }

    [Fact]
    public void TransitionTo_EndedSkippingLiveLeavesLiveUntouched() {
        var lageGebiet = new LageGebiet { Status = Status.CalledOut };
        var endedBy = Guid.NewGuid();

        lageGebiet.TransitionTo(Status.Ended, endedBy, Instant.FromUnixTimeSeconds(5));

        Assert.Equal(Status.Ended, lageGebiet.Status);
        Assert.Equal(endedBy, lageGebiet.EndedById);
        Assert.Null(lageGebiet.LiveAt);
        Assert.Null(lageGebiet.LiveById);
    }

    [Theory]
    [MemberData(nameof(RefusedPairs))]
    public void TransitionTo_RefusedTransitionThrowsAndChangesNothing(Status from, Status to) {
        var lageGebiet = new LageGebiet { Status = from };

        Assert.Throws<InvalidOperationException>(() =>
            lageGebiet.TransitionTo(to, Guid.NewGuid(), Instant.FromUnixTimeSeconds(9)));

        Assert.Equal(from, lageGebiet.Status);
        Assert.Null(lageGebiet.CalledOutAt);
        Assert.Null(lageGebiet.CalledOutById);
        Assert.Null(lageGebiet.ReadyAt);
        Assert.Null(lageGebiet.ReadyById);
        Assert.Null(lageGebiet.LiveAt);
        Assert.Null(lageGebiet.LiveById);
        Assert.Null(lageGebiet.EndedAt);
        Assert.Null(lageGebiet.EndedById);
    }

    private static Gebiet NewGebiet(Guid untereinheitId) => new() {
        Id = Guid.NewGuid(),
        UntereinheitId = untereinheitId,
        Name = "Hameln",
        Geometry = "{}",
    };

    [Theory]
    [InlineData(new[] { Status.CalledOut }, LageStatus.Created)]
    [InlineData(new[] { Status.CalledOut, Status.Ready }, LageStatus.Created)]
    [InlineData(new[] { Status.CalledOut, Status.Ended }, LageStatus.Created)]
    [InlineData(new[] { Status.CalledOut, Status.Ready, Status.Live }, LageStatus.Active)]
    [InlineData(new[] { Status.CalledOut, Status.Ready, Status.Live, Status.Ended }, LageStatus.Active)]
    public void TransitionGebiet_makes_Lage_Active_once_a_Gebiet_goes_Live(Status[] path, LageStatus expected) {
        var gebiet = NewGebiet(Guid.NewGuid());
        var lage = Lage.Create(gebiet.UntereinheitId, "Sturm", [gebiet], Guid.NewGuid(), Instant.FromUnixTimeSeconds(0));

        foreach (var to in path) {
            lage.TransitionGebiet(gebiet.Id, to, Guid.NewGuid(), Instant.FromUnixTimeSeconds(1));
        }

        Assert.Equal(expected, lage.Status);
    }

    [Fact]
    public void TransitionGebiet_keeps_Lage_Active_when_a_second_Gebiet_goes_Live() {
        var untereinheitId = Guid.NewGuid();
        var first = NewGebiet(untereinheitId);
        var second = NewGebiet(untereinheitId);
        var lage = Lage.Create(untereinheitId, "Sturm", [first, second], Guid.NewGuid(), Instant.FromUnixTimeSeconds(0));

        foreach (var gebiet in new[] { first, second }) {
            foreach (var to in new[] { Status.CalledOut, Status.Ready, Status.Live }) {
                lage.TransitionGebiet(gebiet.Id, to, Guid.NewGuid(), Instant.FromUnixTimeSeconds(1));
            }
        }

        Assert.Equal(LageStatus.Active, lage.Status);
    }

    [Fact]
    public void TransitionGebiet_rejects_closed_Lage_and_changes_nothing() {
        var gebiet = NewGebiet(Guid.NewGuid());
        var lage = Lage.Create(gebiet.UntereinheitId, "Sturm", [gebiet], Guid.NewGuid(), Instant.FromUnixTimeSeconds(0));
        lage.Status = LageStatus.Closed;

        Assert.Throws<InvalidOperationException>(() =>
            lage.TransitionGebiet(gebiet.Id, Status.CalledOut, Guid.NewGuid(), Instant.FromUnixTimeSeconds(1)));
        Assert.Equal(LageStatus.Closed, lage.Status);
        Assert.Equal(Status.Inactive, lage.LageGebiete.Single().Status);
    }
}
