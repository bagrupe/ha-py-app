using API.Features.Ehrenamtsbank;

namespace UnitTests;

using Status = EhrenamtsbankAnfrageStatus;

public class EhrenamtsbankAnfrageLogicTest {
    [Theory]
    [InlineData(Status.Offen, Status.Zurueckgezogen, false)]
    [InlineData(Status.Akzeptiert, Status.Vereinbart, true)]
    public void StateMachine_AllowsDefinedInteressentTransitions(Status from, Status to, bool rejectsSiblings) {
        var result = AnfrageStateMachine.Check(from, to, AnfrageActor.Interessent);
        Assert.True(result.Allowed);
        Assert.Equal(rejectsSiblings, result.RejectsSiblingAnfragen);
    }

    [Theory]
    [InlineData(Status.Offen, Status.Akzeptiert, false)]
    [InlineData(Status.Offen, Status.Abgelehnt, false)]
    [InlineData(Status.Akzeptiert, Status.Vereinbart, true)]
    [InlineData(Status.Akzeptiert, Status.Abgelehnt, false)]
    public void StateMachine_AllowsDefinedOwnerTransitions(Status from, Status to, bool rejectsSiblings) {
        var result = AnfrageStateMachine.Check(from, to, AnfrageActor.Owner);
        Assert.True(result.Allowed);
        Assert.Equal(rejectsSiblings, result.RejectsSiblingAnfragen);
    }

    [Theory]
    [InlineData(Status.Offen, Status.Akzeptiert, AnfrageActor.Interessent)]
    [InlineData(Status.Offen, Status.Abgelehnt, AnfrageActor.Interessent)]
    [InlineData(Status.Offen, Status.Vereinbart, AnfrageActor.Interessent)]
    [InlineData(Status.Offen, Status.Vereinbart, AnfrageActor.Owner)]
    [InlineData(Status.Offen, Status.Zurueckgezogen, AnfrageActor.Owner)]
    [InlineData(Status.Akzeptiert, Status.Offen, AnfrageActor.Owner)]
    [InlineData(Status.Akzeptiert, Status.Erledigt, AnfrageActor.Owner)]
    [InlineData(Status.Akzeptiert, Status.Zurueckgezogen, AnfrageActor.Interessent)]
    public void StateMachine_RejectsUndefinedTransitions(Status from, Status to, AnfrageActor actor) {
        Assert.False(AnfrageStateMachine.Check(from, to, actor).Allowed);
    }

    [Fact]
    public void StateMachine_RejectsActorMismatch() {
        Assert.False(AnfrageStateMachine.Check(Status.Offen, Status.Zurueckgezogen, AnfrageActor.Owner).Allowed);
        Assert.False(AnfrageStateMachine.Check(Status.Offen, Status.Akzeptiert, AnfrageActor.Interessent).Allowed);
        Assert.False(AnfrageStateMachine.Check(Status.Akzeptiert, Status.Abgelehnt, AnfrageActor.Interessent).Allowed);
    }

    [Fact]
    public void StateMachine_TerminalStatesHaveNoExits() {
        foreach (var from in new[] { Status.Vereinbart, Status.Erledigt, Status.Abgelehnt, Status.Zurueckgezogen })
            foreach (var to in Enum.GetValues<Status>())
                foreach (var actor in Enum.GetValues<AnfrageActor>()) {
                    Assert.False(AnfrageStateMachine.Check(from, to, actor).Allowed);
                }
    }
}
