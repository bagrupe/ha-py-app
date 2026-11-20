using API.Features.Ehrenamtsbank;
using API.Features.Ehrenamtsbank.Mutations;

namespace UnitTests;

using Status = EhrenamtsbankEintragStatus;

public class EhrenamtsbankEintragLogicTest {
    // ---------- state machine ----------

    [Theory]
    [InlineData(Status.Draft, Status.PendingReview)]
    [InlineData(Status.Active, Status.Paused)]
    [InlineData(Status.Paused, Status.Active)]
    [InlineData(Status.Active, Status.Completed)]
    [InlineData(Status.Paused, Status.Completed)]
    [InlineData(Status.Draft, Status.Closed)]
    [InlineData(Status.PendingReview, Status.Closed)]
    [InlineData(Status.Active, Status.Closed)]
    [InlineData(Status.Paused, Status.Closed)]
    public void StateMachine_AllowsDefinedOwnerTransitions(Status from, Status to) {
        var result = EintragStateMachine.Check(from, to, EintragActor.Owner);
        Assert.True(result.Allowed);
        Assert.False(result.SetsReviewedAt);
    }

    [Theory]
    [InlineData(Status.PendingReview, Status.Active, true)]   // approve
    [InlineData(Status.PendingReview, Status.Draft, true)]    // reject
    [InlineData(Status.Active, Status.Closed, false)]         // takedown
    [InlineData(Status.Paused, Status.Closed, false)]
    public void StateMachine_AllowsDefinedBackofficeTransitions(Status from, Status to, bool setsReviewedAt) {
        var result = EintragStateMachine.Check(from, to, EintragActor.Moderator);
        Assert.True(result.Allowed);
        Assert.Equal(setsReviewedAt, result.SetsReviewedAt);
    }

    [Theory]
    [InlineData(Status.Draft, Status.Active, EintragActor.Owner)]
    [InlineData(Status.Draft, Status.Paused, EintragActor.Owner)]
    [InlineData(Status.Draft, Status.Completed, EintragActor.Owner)]
    [InlineData(Status.PendingReview, Status.Paused, EintragActor.Owner)]
    [InlineData(Status.PendingReview, Status.Completed, EintragActor.Owner)]
    [InlineData(Status.Completed, Status.Active, EintragActor.Owner)]
    [InlineData(Status.Draft, Status.Draft, EintragActor.Owner)]
    // T8 ist eine Nebenwirkung des Bearbeitens und darf nicht direkt anforderbar sein:
    [InlineData(Status.Active, Status.PendingReview, EintragActor.Owner)]
    [InlineData(Status.Paused, Status.PendingReview, EintragActor.Owner)]
    [InlineData(Status.Active, Status.PendingReview, EintragActor.Moderator)]
    [InlineData(Status.Paused, Status.PendingReview, EintragActor.Moderator)]
    public void StateMachine_RejectsUndefinedTransitions(Status from, Status to, EintragActor actor) {
        Assert.False(EintragStateMachine.Check(from, to, actor).Allowed);
    }

    [Theory]
    [InlineData(Status.Draft, Status.Draft)]
    [InlineData(Status.PendingReview, Status.PendingReview)]
    [InlineData(Status.Active, Status.PendingReview)]
    [InlineData(Status.Paused, Status.PendingReview)]
    public void AfterContentEdit_ReQueuesApprovedContent(Status from, Status expected) {
        Assert.Equal(expected, EintragStateMachine.AfterContentEdit(from));
    }

    [Theory]
    [InlineData(Status.Completed)]
    [InlineData(Status.Closed)]
    public void AfterContentEdit_RefusesTerminalStates(Status from) {
        Assert.Null(EintragStateMachine.AfterContentEdit(from));
    }

    [Fact]
    public void StateMachine_RejectsActorMismatch() {
        // Owner darf sich nicht selbst freigeben oder ablehnen.
        Assert.False(EintragStateMachine.Check(Status.PendingReview, Status.Active, EintragActor.Owner).Allowed);
        Assert.False(EintragStateMachine.Check(Status.PendingReview, Status.Draft, EintragActor.Owner).Allowed);
        // Moderation ersetzt keine Owner-Aktionen.
        Assert.False(EintragStateMachine.Check(Status.Draft, Status.PendingReview, EintragActor.Moderator).Allowed);
        Assert.False(EintragStateMachine.Check(Status.Active, Status.Completed, EintragActor.Moderator).Allowed);
        Assert.False(EintragStateMachine.Check(Status.Active, Status.Paused, EintragActor.Moderator).Allowed);
    }

    [Fact]
    public void StateMachine_TerminalStatesHaveNoExits() {
        foreach (var from in new[] { Status.Completed, Status.Closed })
            foreach (var to in Enum.GetValues<Status>())
                foreach (var actor in Enum.GetValues<EintragActor>()) {
                    Assert.False(EintragStateMachine.Check(from, to, actor).Allowed);
                }
    }

    // ---------- Assigned ----------

    [Theory]
    [InlineData(Status.Draft, EintragActor.Owner)]
    [InlineData(Status.Draft, EintragActor.Moderator)]
    [InlineData(Status.PendingReview, EintragActor.Owner)]
    [InlineData(Status.PendingReview, EintragActor.Moderator)]
    [InlineData(Status.Active, EintragActor.Owner)]
    [InlineData(Status.Active, EintragActor.Moderator)]
    [InlineData(Status.Paused, EintragActor.Owner)]
    [InlineData(Status.Paused, EintragActor.Moderator)]
    [InlineData(Status.Completed, EintragActor.Owner)]
    [InlineData(Status.Completed, EintragActor.Moderator)]
    [InlineData(Status.Closed, EintragActor.Owner)]
    [InlineData(Status.Closed, EintragActor.Moderator)]
    [InlineData(Status.Assigned, EintragActor.Owner)]
    [InlineData(Status.Assigned, EintragActor.Moderator)]
    public void StateMachine_AssignedIsNotRequestable(Status from, EintragActor actor) {
        Assert.False(EintragStateMachine.Check(from, Status.Assigned, actor, skipReview: false).Allowed);
        Assert.False(EintragStateMachine.Check(from, Status.Assigned, actor, skipReview: true).Allowed);
    }

    [Theory]
    [InlineData(EintragActor.Owner)]
    [InlineData(EintragActor.Moderator)]
    public void StateMachine_AssignedClosesForBothActors(EintragActor actor) {
        var result = EintragStateMachine.Check(Status.Assigned, Status.Closed, actor);
        Assert.True(result.Allowed);
        Assert.False(result.SetsReviewedAt);

        var skipping = EintragStateMachine.Check(Status.Assigned, Status.Closed, actor, skipReview: true);
        Assert.True(skipping.Allowed);
        Assert.False(skipping.SetsReviewedAt);
    }

    [Theory]
    [InlineData(Status.Active, EintragActor.Owner)]
    [InlineData(Status.Active, EintragActor.Moderator)]
    [InlineData(Status.Paused, EintragActor.Owner)]
    [InlineData(Status.Paused, EintragActor.Moderator)]
    [InlineData(Status.Draft, EintragActor.Owner)]
    [InlineData(Status.Draft, EintragActor.Moderator)]
    [InlineData(Status.PendingReview, EintragActor.Owner)]
    [InlineData(Status.PendingReview, EintragActor.Moderator)]
    [InlineData(Status.Completed, EintragActor.Owner)]
    [InlineData(Status.Completed, EintragActor.Moderator)]
    public void StateMachine_AssignedHasNoExitButClosed(Status to, EintragActor actor) {
        Assert.False(EintragStateMachine.Check(Status.Assigned, to, actor, skipReview: false).Allowed);
        Assert.False(EintragStateMachine.Check(Status.Assigned, to, actor, skipReview: true).Allowed);
    }

    [Theory]
    [InlineData(true)]
    [InlineData(false)]
    public void AfterContentEdit_RefusesAssigned(bool skipReview) {
        Assert.Null(EintragStateMachine.AfterContentEdit(Status.Assigned, skipReview));
    }

    // ---------- EintragSkipReview ----------

    [Theory]
    [InlineData(Status.Draft, Status.Active)]
    [InlineData(Status.Active, Status.Draft)]
    public void StateMachine_SkipReview_OwnerTogglesDraftAndActiveDirectly(Status from, Status to) {
        var result = EintragStateMachine.Check(from, to, EintragActor.Owner, skipReview: true);
        Assert.True(result.Allowed);
        Assert.False(result.SetsReviewedAt);
    }

    [Theory]
    [InlineData(Status.Draft, Status.Active)]
    [InlineData(Status.Active, Status.Draft)]
    public void StateMachine_WithoutSkipReview_OwnerCannotToggleDraftAndActive(Status from, Status to) {
        Assert.False(EintragStateMachine.Check(from, to, EintragActor.Owner, skipReview: false).Allowed);
    }

    [Theory]
    [InlineData(true, Status.Active)]
    [InlineData(false, Status.Draft)]
    public void InitialStatus_FollowsSkipReviewFlag(bool skipReview, Status expected) {
        Assert.Equal(expected, EintragStateMachine.InitialStatus(skipReview));
    }

    [Theory]
    [InlineData(Status.Draft, Status.Draft)]
    [InlineData(Status.PendingReview, Status.PendingReview)]
    [InlineData(Status.Active, Status.Active)]
    [InlineData(Status.Paused, Status.Paused)]
    public void AfterContentEdit_SkipReview_KeepsStatus(Status from, Status expected) {
        Assert.Equal(expected, EintragStateMachine.AfterContentEdit(from, skipReview: true));
    }

    [Theory]
    [InlineData(Status.Draft, Status.Draft)]
    [InlineData(Status.PendingReview, Status.PendingReview)]
    [InlineData(Status.Active, Status.PendingReview)]
    [InlineData(Status.Paused, Status.PendingReview)]
    public void AfterContentEdit_WithoutSkipReview_ReQueuesApprovedContent(Status from, Status expected) {
        Assert.Equal(expected, EintragStateMachine.AfterContentEdit(from, skipReview: false));
    }

    [Theory]
    [InlineData(Status.Completed)]
    [InlineData(Status.Closed)]
    public void AfterContentEdit_SkipReview_StillRefusesTerminalStates(Status from) {
        Assert.Null(EintragStateMachine.AfterContentEdit(from, skipReview: true));
    }

    // ---------- type validation ----------

    [Fact]
    public void Validation_GesuchForbidsAngebotFields() {
        Assert.NotNull(EintragTypValidation.Validate(
            EhrenamtsbankEintragTyp.Gesuch, null, null, availability: "abends"));
        // Gesuch-Felder sind optional:
        Assert.Null(EintragTypValidation.Validate(
            EhrenamtsbankEintragTyp.Gesuch, null, null, null));
        Assert.Null(EintragTypValidation.Validate(
            EhrenamtsbankEintragTyp.Gesuch, EhrenamtsbankDringlichkeit.Hoch, 90, null));
    }

    [Fact]
    public void Validation_AngebotForbidsGesuchFields() {
        Assert.NotNull(EintragTypValidation.Validate(
            EhrenamtsbankEintragTyp.Angebot, EhrenamtsbankDringlichkeit.Mittel, null, null));
        Assert.NotNull(EintragTypValidation.Validate(
            EhrenamtsbankEintragTyp.Angebot, null, estimatedDurationMinutes: 60, null));
        // Angebots-Feld ist optional:
        Assert.Null(EintragTypValidation.Validate(
            EhrenamtsbankEintragTyp.Angebot, null, null, null));
        Assert.Null(EintragTypValidation.Validate(
            EhrenamtsbankEintragTyp.Angebot, null, null, "Wochentags flexibel"));
    }

    // ---------- clearance cascade ----------

    private static EhrenamtsbankKategorie Kategorie(Guid id, bool clearance, Guid? parentId = null) =>
        new() { Id = id, Name = id.ToString(), Active = true, RequiresClearance = clearance, ParentId = parentId };

    [Fact]
    public void Clearance_InheritsFromAncestors() {
        var root = Kategorie(Guid.NewGuid(), clearance: true);
        var child = Kategorie(Guid.NewGuid(), clearance: false, parentId: root.Id);
        var grandchild = Kategorie(Guid.NewGuid(), clearance: false, parentId: child.Id);
        var all = new[] { root, child, grandchild };

        Assert.True(KategorieTree.RequiresEffectiveClearance(root.Id, all));
        Assert.True(KategorieTree.RequiresEffectiveClearance(child.Id, all));
        Assert.True(KategorieTree.RequiresEffectiveClearance(grandchild.Id, all));
    }

    [Fact]
    public void Clearance_FlagOnLeafDoesNotAffectSiblings() {
        var root = Kategorie(Guid.NewGuid(), clearance: false);
        var flaggedLeaf = Kategorie(Guid.NewGuid(), clearance: true, parentId: root.Id);
        var sibling = Kategorie(Guid.NewGuid(), clearance: false, parentId: root.Id);
        var all = new[] { root, flaggedLeaf, sibling };

        Assert.True(KategorieTree.RequiresEffectiveClearance(flaggedLeaf.Id, all));
        Assert.False(KategorieTree.RequiresEffectiveClearance(sibling.Id, all));
        Assert.False(KategorieTree.RequiresEffectiveClearance(root.Id, all));
    }

    [Fact]
    public void Clearance_FalseWhenNoAncestorFlag() {
        var root = Kategorie(Guid.NewGuid(), clearance: false);
        var child = Kategorie(Guid.NewGuid(), clearance: false, parentId: root.Id);

        Assert.False(KategorieTree.RequiresEffectiveClearance(child.Id, [root, child]));
    }

    [Fact]
    public void Clearance_CycleGuard() {
        var a = Kategorie(Guid.NewGuid(), clearance: false);
        var b = Kategorie(Guid.NewGuid(), clearance: false, parentId: a.Id);
        a.ParentId = b.Id;

        // Muss terminieren; ein Zyklus ohne Flag ergibt false.
        Assert.False(KategorieTree.RequiresEffectiveClearance(a.Id, [a, b]));

        // Unbekannte Kategorie-Id → false (kein Werfen im reinen Helfer).
        Assert.False(KategorieTree.RequiresEffectiveClearance(Guid.NewGuid(), [a, b]));
    }

    private static EhrenamtsbankLocationInput LocationInput(
        string address = "Musterstraße 12", double latitude = 52.1039, double longitude = 9.3564) =>
        new(address, latitude, longitude);

    [Fact]
    public void Location_TrimsAddressAndKeepsCoordinates() {
        var normalisiert = EhrenamtsbankLocationValidation.Normalize(
            LocationInput("  Musterstraße 12\n"));

        Assert.Equal("Musterstraße 12", normalisiert.Address);
        Assert.Equal(52.1039, normalisiert.Latitude);
        Assert.Equal(9.3564, normalisiert.Longitude);
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData("\t\n")]
    public void Location_RejectsBlankAddress(string address) {
        Assert.Throws<EintragValidationException>(
            () => EhrenamtsbankLocationValidation.Normalize(LocationInput(address)));
    }

    [Fact]
    public void Location_LengthLimitAppliesAfterTrim() {
        var gerade250 = EhrenamtsbankLocationValidation.Normalize(
            LocationInput($"  {new string('x', 250)}  "));
        Assert.Equal(250, gerade250.Address.Length);

        Assert.Throws<EintragValidationException>(
            () => EhrenamtsbankLocationValidation.Normalize(LocationInput(new string('x', 251))));
    }

    [Theory]
    [InlineData(double.NaN, 9.3564)]
    [InlineData(52.1039, double.NaN)]
    [InlineData(double.PositiveInfinity, 9.3564)]
    [InlineData(52.1039, double.NegativeInfinity)]
    public void Location_RejectsNonFiniteCoordinates(double latitude, double longitude) {
        Assert.Throws<EintragValidationException>(
            () => EhrenamtsbankLocationValidation.Normalize(LocationInput(latitude: latitude, longitude: longitude)));
        Assert.Throws<EintragValidationException>(
            () => EhrenamtsbankLocationValidation.ValidateCoordinates(latitude, longitude));
    }

    [Theory]
    [InlineData(90.0001, 9.3564)]
    [InlineData(-90.0001, 9.3564)]
    [InlineData(52.1039, 180.0001)]
    [InlineData(52.1039, -180.0001)]
    public void Location_RejectsOutOfRangeCoordinates(double latitude, double longitude) {
        Assert.Throws<EintragValidationException>(
            () => EhrenamtsbankLocationValidation.Normalize(LocationInput(latitude: latitude, longitude: longitude)));
        Assert.Throws<EintragValidationException>(
            () => EhrenamtsbankLocationValidation.ValidateCoordinates(latitude, longitude));
    }

    [Theory]
    [InlineData(90, 180)]
    [InlineData(-90, -180)]
    [InlineData(0, 0)]
    public void Location_AcceptsRangeBoundaries(double latitude, double longitude) {
        EhrenamtsbankLocationValidation.ValidateCoordinates(latitude, longitude);
        var normalisiert = EhrenamtsbankLocationValidation.Normalize(
            LocationInput(latitude: latitude, longitude: longitude));
        Assert.Equal(latitude, normalisiert.Latitude);
        Assert.Equal(longitude, normalisiert.Longitude);
    }

    // ---------- Entfernung (Haversine) ----------

    [Theory]
    [InlineData(52.1039, 9.3564)]
    [InlineData(0, 0)]
    [InlineData(-33.8688, 151.2093)]
    public void Distance_SamePointIsZero(double latitude, double longitude) {
        Assert.Equal(0, GeoDistance.CalculateKm(latitude, longitude, latitude, longitude));
    }

    /// <summary>Ein Längengrad am Äquator ist der Umfang durch 360 und damit der einfachste
    /// unabhängig nachrechenbare Prüfwert für den gewählten Erdradius.</summary>
    [Fact]
    public void Distance_OneDegreeAtEquator() {
        Assert.Equal(111.1951, GeoDistance.CalculateKm(0, 0, 0, 1), tolerance: 0.001);
    }

    [Theory]
    [InlineData(52.1039, 9.3564, 52.3759, 9.7320, 39.6085)]  // Hameln → Hannover
    [InlineData(52.1039, 9.3564, 51.9847, 9.2519, 15.0585)]  // Hameln → Bad Pyrmont
    [InlineData(52.1039, 9.3564, 52.0450, 9.2650, 9.0507)]   // Hameln → Aerzen
    public void Distance_MatchesKnownValuesInTheHamelnArea(
        double lat1, double lon1, double lat2, double lon2, double erwartetKm) {
        Assert.Equal(erwartetKm, GeoDistance.CalculateKm(lat1, lon1, lat2, lon2), tolerance: 0.001);
    }

    [Theory]
    [InlineData(52.1039, 9.3564, 52.3759, 9.7320)]
    [InlineData(0, 0, 0, 1)]
    [InlineData(-33.8688, 151.2093, 52.1039, 9.3564)]
    public void Distance_IsSymmetric(double lat1, double lon1, double lat2, double lon2) {
        Assert.Equal(
            GeoDistance.CalculateKm(lat1, lon1, lat2, lon2),
            GeoDistance.CalculateKm(lat2, lon2, lat1, lon1),
            tolerance: 1e-9);
    }

    /// <summary>Der halbe Kilometer muss aufrunden. Die Standardrundung von .NET rundet zur
    /// geraden Zahl und lieferte hier 0, 2 und 2 statt 1, 2 und 3.</summary>
    [Theory]
    [InlineData(0.0, 0)]
    [InlineData(0.4999, 0)]
    [InlineData(0.5, 1)]
    [InlineData(1.4999, 1)]
    [InlineData(1.5, 2)]
    [InlineData(2.5, 3)]
    [InlineData(39.6085, 40)]
    public void Distance_RoundsMidpointAwayFromZero(double roh, int erwartet) {
        Assert.Equal(erwartet, EintragExtensions.ToWholeKilometres(roh));
    }
}
