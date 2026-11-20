using System.Security.Claims;
using API.Features;
using API.Features.Ehrenamtsbank;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

public class ReviewFlowApiFactory : BackendApiFactory {
    protected override IReadOnlyDictionary<string, string?> ConfigurationOverrides =>
        new Dictionary<string, string?> { ["Ehrenamtsbank:EintragSkipReview"] = "false" };

    protected override bool ResetsTestDatabase => false;
}

[Collection("Api Tests")]
public class EhrenamtsbankEintragReviewFlowTests(ReviewFlowApiFactory factory)
    : EhrenamtsbankEintragTestBase(factory), IClassFixture<ReviewFlowApiFactory> {

    [Fact]
    public void Host_RunsWithReviewEnabled() {
        Assert.False(EhrenamtsbankOptions().EintragSkipReview);
    }

    [Fact]
    public async Task Update_ActiveTriggersReReview() {
        var owner = await CreateBuerger(registered: true);
        var draft = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        var active = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);

        var draftResult = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(draft, "Neuer Titel") });
        var draftPayload = Payload(draftResult, "updateEhrenamtsbankEintrag");
        var updatedDraft = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(draftPayload["ehrenamtsbankEintrag"]);
        Assert.Equal("DRAFT", updatedDraft["status"]!.ToString());
        Assert.Equal("Neuer Titel", updatedDraft["title"]);

        var activeResult = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(active, "Editierter Titel") });
        var activePayload = Payload(activeResult, "updateEhrenamtsbankEintrag");
        var updatedActive = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(activePayload["ehrenamtsbankEintrag"]);
        Assert.Equal("PENDING_REVIEW", updatedActive["status"]!.ToString());
        Assert.Equal("Editierter Titel", updatedActive["title"]);
    }

    [Fact]
    public async Task Update_ClearsReviewedAtWhenBouncedToReview() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);

        using (var scope = Factory.Services.CreateScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var row = await db.EhrenamtsbankEintraege.AsTracking().FirstAsync(e => e.Id == eintrag.Id);
            row.ReviewedAt = SystemClock.Instance.GetCurrentInstant();
            await db.SaveChangesAsync();
        }

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(eintrag, "Inhaltlich geändert") });
        var payload = Payload(result, "updateEhrenamtsbankEintrag");
        Assert.Equal("PENDING_REVIEW", Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankEintrag"])["status"]!.ToString());

        using var verify = Factory.Services.CreateScope();
        var verifyDb = verify.ServiceProvider.GetRequiredService<DomainContext>();
        var updated = await verifyDb.EhrenamtsbankEintraege.FirstAsync(e => e.Id == eintrag.Id);
        Assert.Null(updated.ReviewedAt);
    }

    [Fact]
    public async Task Update_LocationChangeOnActive_ReturnsToPendingReview() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        await PersistLocation(eintrag.Id);

        using (var scope = Factory.Services.CreateScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var row = await db.EhrenamtsbankEintraege.AsTracking().FirstAsync(e => e.Id == eintrag.Id);
            row.ReviewedAt = SystemClock.Instance.GetCurrentInstant();
            await db.SaveChangesAsync();
        }

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> {
                ["input"] = UpdateInput(eintrag, "Hecken schneiden", overrides: new Dictionary<string, object?> {
                    ["location"] = LocationInput("Neue Straße 7", 52.2, 9.4)
                })
            });

        var payload = Payload(result, "updateEhrenamtsbankEintrag");
        Assert.Null(payload["errors"]);
        Assert.Equal("PENDING_REVIEW", Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankEintrag"])["status"]!.ToString());

        var updated = await ReadEintrag(eintrag.Id);
        Assert.Null(updated.ReviewedAt);
        AssertLocation(updated, "Neue Straße 7", 52.2, 9.4);
    }

    [Fact]
    public async Task UpdateStatus_FullLifecycleRoundtrip() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        async Task<IReadOnlyDictionary<string, object?>> Transition(ClaimsPrincipal actor, string status) {
            var result = await ExecuteGraphqlAsync(actor, UpdateStatusMutation, StatusInput(eintrag.Id, status));
            var payload = Payload(result, "updateEhrenamtsbankEintragStatus");
            Assert.Null(payload["errors"]);
            return Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(payload["ehrenamtsbankEintrag"]);
        }

        var submitted = await Transition(Principal(owner.Id), "PENDING_REVIEW");
        Assert.Null(submitted["reviewedAt"]);

        var approved = await Transition(superadmin, "ACTIVE");
        Assert.NotNull(approved["reviewedAt"]);

        var paused = await Transition(Principal(owner.Id), "PAUSED");
        Assert.Equal("PAUSED", paused["status"]!.ToString());

        var resumed = await Transition(Principal(owner.Id), "ACTIVE");
        Assert.Equal("ACTIVE", resumed["status"]!.ToString());

        var completed = await Transition(Principal(owner.Id), "COMPLETED");
        Assert.Equal("COMPLETED", completed["status"]!.ToString());
    }

    [Fact]
    public async Task UpdateStatus_DoesNotExposeContentEditTransition() {
        var owner = await CreateBuerger(registered: true);
        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        foreach (var status in new[] { EhrenamtsbankEintragStatus.Active, EhrenamtsbankEintragStatus.Paused }) {
            var eintrag = await CreateEintrag(owner.Id, status);

            var asOwner = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation,
                StatusInput(eintrag.Id, "PENDING_REVIEW"));
            AssertMutationError(asOwner, "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");

            var asModerator = await ExecuteGraphqlAsync(superadmin, UpdateStatusMutation,
                StatusInput(eintrag.Id, "PENDING_REVIEW"));
            AssertMutationError(asModerator, "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");
        }

        var bearbeitet = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var update = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(bearbeitet, "Inhaltlich geändert") });
        var payload = Payload(update, "updateEhrenamtsbankEintrag");
        var aktualisiert = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(payload["ehrenamtsbankEintrag"]);
        Assert.Equal("PENDING_REVIEW", aktualisiert["status"]!.ToString());
    }
}
