using API.Features;
using API.Features.Ehrenamtsbank;
using HotChocolate.Execution;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using NodaTime.Text;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankAssignedTests(BackendApiFactory factory) : EhrenamtsbankEintragTestBase(factory) {
    private const string CreateAnfrageMutation = """
        mutation Create($input: CreateEhrenamtsbankAnfrageInput!) {
            createEhrenamtsbankAnfrage(input: $input) {
                ehrenamtsbankAnfrage { id status }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    private const string UpdateAnfrageStatusMutation = """
        mutation UpdateStatus($input: UpdateEhrenamtsbankAnfrageStatusInput!) {
            updateEhrenamtsbankAnfrageStatus(input: $input) {
                ehrenamtsbankAnfrage { id status vereinbartAt }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    private const string ProposeMutation = """
        mutation Propose($input: ProposeEhrenamtsbankAbschlussInput!) {
            proposeEhrenamtsbankAbschluss(input: $input) {
                ehrenamtsbankAnfrage { id proposedMinutes }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    private const string ConfirmMutation = """
        mutation Confirm($input: ConfirmEhrenamtsbankAbschlussInput!) {
            confirmEhrenamtsbankAbschluss(input: $input) {
                ehrenamtsbankAnfrage { id status }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    private const string EntriesQuery = """
        query Entries($filter: EhrenamtsbankEintragFilterInput) {
            ehrenamtsbankEintraege(filter: $filter, skip: 0, take: 50) {
                totalCount
                items { id status }
            }
        }
    """;

    private const string EntryQuery = """
        query Entry($id: UUID!) {
            ehrenamtsbankEintrag(id: $id) { id status title }
        }
    """;

    private static Dictionary<string, object?> AnfrageStatusInput(Guid anfrageId, string status) =>
        new() {
            ["input"] = new Dictionary<string, object?> {
                ["anfrageId"] = anfrageId.ToString(),
                ["status"] = status
            }
        };

    private static Dictionary<string, object?> AnfrageIdInput(Guid anfrageId) =>
        new() { ["input"] = new Dictionary<string, object?> { ["anfrageId"] = anfrageId.ToString() } };

    private static Dictionary<string, object?> ProposeInput(Guid anfrageId, int minutes = 90) =>
        new() {
            ["input"] = new Dictionary<string, object?> {
                ["anfrageId"] = anfrageId.ToString(),
                ["minutes"] = minutes,
                ["date"] = LocalDatePattern.Iso.Format(API.Utils.DateTime.Today().PlusDays(-1)),
                ["note"] = null
            }
        };

    private async Task<EhrenamtsbankAnfrage> SeedAnfrage(
        Guid eintragId, Guid interessentId,
        EhrenamtsbankAnfrageStatus status = EhrenamtsbankAnfrageStatus.Offen) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var now = Instant.FromUtc(2026, 1, 1, 0, 0);
        var anfrage = new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintragId,
            InteressentId = interessentId,
            Status = status,
            CreatedAt = now,
            UpdatedAt = now,
            VereinbartAt = status == EhrenamtsbankAnfrageStatus.Vereinbart ? now : null,
        };
        db.EhrenamtsbankAnfragen.Add(anfrage);
        await db.SaveChangesAsync();
        return anfrage;
    }

    private async Task<EhrenamtsbankAnfrage> ReadAnfrage(Guid anfrageId) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        return await db.EhrenamtsbankAnfragen.FirstAsync(a => a.Id == anfrageId);
    }

    /// <summary>Setzt den Status an der Zustandsmaschine vorbei, um Ausgangslagen herzustellen,
    /// die über die Mutationen (noch) nicht erreichbar sind.</summary>
    private async Task ForceEintragStatus(Guid eintragId, EhrenamtsbankEintragStatus status) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var row = await db.EhrenamtsbankEintraege.AsTracking().FirstAsync(e => e.Id == eintragId);
        row.Status = status;
        await db.SaveChangesAsync();
    }

    private static void AssertEintragNotFound(IQueryResult result) =>
        Assert.Equal("EINTRAG_NOT_FOUND", Assert.Single(result.Errors!).Code);

    private static IReadOnlyDictionary<string, object?> AnfragePayload(IQueryResult result, string field) {
        var payload = Payload(result, field);
        Assert.Null(payload["errors"]);
        return Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(payload["ehrenamtsbankAnfrage"]);
    }

    // ---------- Anfrage: Vereinbaren vergibt den Eintrag ----------

    [Fact]
    public async Task Vereinbart_DurchOwner_SetztEintragAufVergeben() {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var competitor = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var acceptedAnfrage = await SeedAnfrage(eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Akzeptiert);
        var sibling = await SeedAnfrage(eintrag.Id, competitor.Id, EhrenamtsbankAnfrageStatus.Offen);

        var updated = AnfragePayload(
            await ExecuteGraphqlAsync(
                Principal(owner.Id), UpdateAnfrageStatusMutation,
                AnfrageStatusInput(acceptedAnfrage.Id, "VEREINBART")),
            "updateEhrenamtsbankAnfrageStatus");
        Assert.Equal("VEREINBART", updated["status"]!.ToString());
        Assert.NotNull(updated["vereinbartAt"]);

        Assert.Equal(EhrenamtsbankEintragStatus.Assigned, (await ReadEintrag(eintrag.Id)).Status);
        Assert.Equal(EhrenamtsbankAnfrageStatus.Abgelehnt, (await ReadAnfrage(sibling.Id)).Status);
        Assert.NotNull((await ReadAnfrage(acceptedAnfrage.Id)).VereinbartAt);
    }

    [Fact]
    public async Task Vereinbart_DurchInteressent_SetztEintragAufVergeben() {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var competitor = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var acceptedAnfrage = await SeedAnfrage(eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Akzeptiert);
        var sibling = await SeedAnfrage(eintrag.Id, competitor.Id, EhrenamtsbankAnfrageStatus.Offen);

        var updated = AnfragePayload(
            await ExecuteGraphqlAsync(
                Principal(interessent.Id), UpdateAnfrageStatusMutation,
                AnfrageStatusInput(acceptedAnfrage.Id, "VEREINBART")),
            "updateEhrenamtsbankAnfrageStatus");
        Assert.Equal("VEREINBART", updated["status"]!.ToString());

        Assert.Equal(EhrenamtsbankEintragStatus.Assigned, (await ReadEintrag(eintrag.Id)).Status);
        Assert.Equal(EhrenamtsbankAnfrageStatus.Abgelehnt, (await ReadAnfrage(sibling.Id)).Status);
    }

    [Theory]
    [InlineData(EhrenamtsbankAnfrageStatus.Offen, "AKZEPTIERT", true)]
    [InlineData(EhrenamtsbankAnfrageStatus.Offen, "ABGELEHNT", true)]
    [InlineData(EhrenamtsbankAnfrageStatus.Offen, "ZURUECKGEZOGEN", false)]
    [InlineData(EhrenamtsbankAnfrageStatus.Akzeptiert, "ABGELEHNT", true)]
    public async Task AndereUebergaenge_LassenEintragAktiv(
        EhrenamtsbankAnfrageStatus from, string to, bool alsOwner) {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var anfrage = await SeedAnfrage(eintrag.Id, interessent.Id, from);

        var result = await ExecuteGraphqlAsync(
            Principal(alsOwner ? owner.Id : interessent.Id), UpdateAnfrageStatusMutation,
            AnfrageStatusInput(anfrage.Id, to));
        Assert.Equal(to, AnfragePayload(result, "updateEhrenamtsbankAnfrageStatus")["status"]!.ToString());

        Assert.Equal(EhrenamtsbankEintragStatus.Active, (await ReadEintrag(eintrag.Id)).Status);
    }

    [Fact]
    public async Task CreateAnfrage_AufVergebenenEintrag_Abgelehnt() {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);

        AssertMutationError(
            await ExecuteQuery(Principal(interessent.Id), CreateAnfrageMutation,
                new Dictionary<string, object?> { ["eintragId"] = eintrag.Id.ToString() }),
            "createEhrenamtsbankAnfrage", "EintragNotActiveError");
    }

    // ---------- Eintrag: Assigned ist nur über die Anfrage erreichbar ----------

    [Theory]
    [InlineData(EhrenamtsbankEintragStatus.Draft)]
    [InlineData(EhrenamtsbankEintragStatus.PendingReview)]
    [InlineData(EhrenamtsbankEintragStatus.Active)]
    [InlineData(EhrenamtsbankEintragStatus.Paused)]
    [InlineData(EhrenamtsbankEintragStatus.Completed)]
    [InlineData(EhrenamtsbankEintragStatus.Closed)]
    public async Task UpdateStatus_KannVergebenNichtAnfordern(EhrenamtsbankEintragStatus from) {
        var owner = await CreateBuerger(registered: true);
        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var eintrag = await CreateEintrag(owner.Id, from);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation,
                StatusInput(eintrag.Id, "ASSIGNED")),
            "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");
        AssertMutationError(
            await ExecuteGraphqlAsync(superadmin, UpdateStatusMutation,
                StatusInput(eintrag.Id, "ASSIGNED")),
            "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");
    }

    [Fact]
    public async Task UpdateStatus_OwnerSchliesstVergebenenEintrag() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);

        var result = await ExecuteGraphqlAsync(
            Principal(owner.Id), UpdateStatusMutation, StatusInput(eintrag.Id, "CLOSED"));
        var payload = Payload(result, "updateEhrenamtsbankEintragStatus");
        Assert.Null(payload["errors"]);
        var updated = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankEintrag"]);
        Assert.Equal("CLOSED", updated["status"]!.ToString());
        Assert.Null(updated["reviewedAt"]);

        Assert.Equal(EhrenamtsbankEintragStatus.Closed, (await ReadEintrag(eintrag.Id)).Status);
    }

    [Fact]
    public async Task UpdateStatus_ModerationSchliesstVergebenenEintrag() {
        var owner = await CreateBuerger(registered: true);
        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);

        var result = await ExecuteGraphqlAsync(
            superadmin, UpdateStatusMutation, StatusInput(eintrag.Id, "CLOSED"));
        var payload = Payload(result, "updateEhrenamtsbankEintragStatus");
        Assert.Null(payload["errors"]);
        var updated = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankEintrag"]);
        Assert.Equal("CLOSED", updated["status"]!.ToString());
        Assert.Null(updated["reviewedAt"]);

        Assert.Equal(EhrenamtsbankEintragStatus.Closed, (await ReadEintrag(eintrag.Id)).Status);
    }

    [Theory]
    [InlineData("ACTIVE")]
    [InlineData("PAUSED")]
    [InlineData("DRAFT")]
    [InlineData("PENDING_REVIEW")]
    [InlineData("COMPLETED")]
    public async Task UpdateStatus_VergebenHatNurClosedAlsAusgang(string to) {
        var owner = await CreateBuerger(registered: true);
        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(eintrag.Id, to)),
            "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");
        AssertMutationError(
            await ExecuteGraphqlAsync(superadmin, UpdateStatusMutation, StatusInput(eintrag.Id, to)),
            "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");
    }

    [Fact]
    public async Task Update_VergebenerEintragIstNichtBearbeitbar() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
                new Dictionary<string, object?> { ["input"] = UpdateInput(eintrag, "Neuer Titel") }),
            "updateEhrenamtsbankEintrag", "NotAllowedError");

        Assert.Equal("Hecken schneiden", (await ReadEintrag(eintrag.Id)).Title);
    }

    private static readonly EhrenamtsbankAnfrageStatus[] NonTerminalAnfrageStatuses = [
        EhrenamtsbankAnfrageStatus.Offen,
        EhrenamtsbankAnfrageStatus.Akzeptiert,
        EhrenamtsbankAnfrageStatus.Vereinbart,
    ];

    private static readonly EhrenamtsbankAnfrageStatus[] TerminalAnfrageStatuses = [
        EhrenamtsbankAnfrageStatus.Erledigt,
        EhrenamtsbankAnfrageStatus.Abgelehnt,
        EhrenamtsbankAnfrageStatus.Zurueckgezogen,
    ];

    private async Task<Dictionary<EhrenamtsbankAnfrageStatus, Guid>> SeedAnfragePerStatus(Guid eintragId) {
        var anfragen = new Dictionary<EhrenamtsbankAnfrageStatus, Guid>();
        foreach (var status in NonTerminalAnfrageStatuses.Concat(TerminalAnfrageStatuses)) {
            var interessent = await CreateBuerger(registered: true);
            anfragen[status] = (await SeedAnfrage(eintragId, interessent.Id, status)).Id;
        }

        return anfragen;
    }

    private async Task AssertNonTerminalRejected(Dictionary<EhrenamtsbankAnfrageStatus, Guid> anfragen) {
        foreach (var status in NonTerminalAnfrageStatuses) {
            var rejected = await ReadAnfrage(anfragen[status]);
            Assert.Equal(EhrenamtsbankAnfrageStatus.Abgelehnt, rejected.Status);
            Assert.True(rejected.UpdatedAt > rejected.CreatedAt);
        }

        foreach (var status in TerminalAnfrageStatuses) {
            var unchanged = await ReadAnfrage(anfragen[status]);
            Assert.Equal(status, unchanged.Status);
            Assert.Equal(unchanged.CreatedAt, unchanged.UpdatedAt);
        }
    }

    [Theory]
    [InlineData(EhrenamtsbankEintragStatus.Active, false)]
    [InlineData(EhrenamtsbankEintragStatus.Active, true)]
    [InlineData(EhrenamtsbankEintragStatus.Paused, false)]
    [InlineData(EhrenamtsbankEintragStatus.Paused, true)]
    [InlineData(EhrenamtsbankEintragStatus.Assigned, false)]
    [InlineData(EhrenamtsbankEintragStatus.Assigned, true)]
    public async Task Schliessen_LehntNonTerminalAnfrageStatusesAb(
        EhrenamtsbankEintragStatus from, bool alsModerator) {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, from);
        var anfragen = await SeedAnfragePerStatus(eintrag.Id);

        var actor = alsModerator
            ? await GetUserToken(SuperAdminEmail, SuperAdminPassword)
            : Principal(owner.Id);
        var payload = Payload(
            await ExecuteGraphqlAsync(actor, UpdateStatusMutation, StatusInput(eintrag.Id, "CLOSED")),
            "updateEhrenamtsbankEintragStatus");
        Assert.Null(payload["errors"]);
        Assert.Equal(EhrenamtsbankEintragStatus.Closed, (await ReadEintrag(eintrag.Id)).Status);

        await AssertNonTerminalRejected(anfragen);
    }

    [Theory]
    [InlineData(EhrenamtsbankEintragStatus.Active)]
    [InlineData(EhrenamtsbankEintragStatus.Paused)]
    public async Task Abschliessen_LehntNonTerminalAnfrageStatusesAb(EhrenamtsbankEintragStatus from) {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, from);
        var anfragen = await SeedAnfragePerStatus(eintrag.Id);

        var payload = Payload(
            await ExecuteGraphqlAsync(
                Principal(owner.Id), UpdateStatusMutation, StatusInput(eintrag.Id, "COMPLETED")),
            "updateEhrenamtsbankEintragStatus");
        Assert.Null(payload["errors"]);
        Assert.Equal(EhrenamtsbankEintragStatus.Completed, (await ReadEintrag(eintrag.Id)).Status);

        await AssertNonTerminalRejected(anfragen);
    }

    [Theory]
    [InlineData(EhrenamtsbankEintragStatus.Active)]
    [InlineData(EhrenamtsbankEintragStatus.Assigned)]
    public async Task Loeschen_LehntNonTerminalAnfrageStatusesAb(EhrenamtsbankEintragStatus from) {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, from);
        var anfragen = await SeedAnfragePerStatus(eintrag.Id);

        var payload = Payload(
            await ExecuteGraphqlAsync(Principal(owner.Id), DeleteMutation, DeleteInput(eintrag.Id)),
            "deleteEhrenamtsbankEintrag");
        Assert.Null(payload["errors"]);

        await AssertNonTerminalRejected(anfragen);
    }

    private static Dictionary<string, object?> DeleteInput(Guid id) =>
        new() { ["input"] = new Dictionary<string, object?> { ["id"] = id.ToString() } };

    private const string DeleteMutation = """
        mutation Delete($input: DeleteEhrenamtsbankEintragInput!) {
            deleteEhrenamtsbankEintrag(input: $input) {
                deletedId
                errors { __typename ... on Error { message } }
            }
        }
    """;

    // ---------- Sichtbarkeit ----------

    [Fact]
    public async Task Suche_LiefertKeineVergebenenEintraege() {
        var owner = await CreateBuerger(registered: true);
        var assignedEintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var activeEintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);

        var result = await ExecuteGraphqlAsync(Anonymous(), EntriesQuery);

        Assert.Null(result.Errors);
        var data = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(result.Data);
        var page = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(data["ehrenamtsbankEintraege"]);
        var items = Assert.IsAssignableFrom<IReadOnlyList<object?>>(page["items"]);
        var ids = items
            .Select(i => Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(i))
            .Select(i => Guid.Parse(i["id"]!.ToString()!))
            .ToHashSet();
        Assert.Contains(activeEintrag.Id, ids);
        Assert.DoesNotContain(assignedEintrag.Id, ids);
    }

    [Fact]
    public async Task Einzelansicht_VergebenNurFuerBeteiligteUndModeration() {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var stranger = await CreateBuerger(registered: true);
        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);
        await SeedAnfrage(eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Vereinbart);
        var variables = new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() };

        Assert.Null((await ExecuteGraphqlAsync(Principal(owner.Id), EntryQuery, variables)).Errors);
        Assert.Null((await ExecuteGraphqlAsync(superadmin, EntryQuery, variables)).Errors);
        AssertEintragNotFound(await ExecuteGraphqlAsync(Anonymous(), EntryQuery, variables));
        AssertEintragNotFound(await ExecuteGraphqlAsync(Principal(stranger.Id), EntryQuery, variables));
    }

    [Theory]
    [InlineData(EhrenamtsbankEintragStatus.Assigned, EhrenamtsbankAnfrageStatus.Vereinbart)]
    [InlineData(EhrenamtsbankEintragStatus.Paused, EhrenamtsbankAnfrageStatus.Offen)]
    [InlineData(EhrenamtsbankEintragStatus.Completed, EhrenamtsbankAnfrageStatus.Vereinbart)]
    [InlineData(EhrenamtsbankEintragStatus.Closed, EhrenamtsbankAnfrageStatus.Abgelehnt)]
    public async Task Einzelansicht_InteressentSiehtEintragInJedemStatus(
        EhrenamtsbankEintragStatus eintragStatus, EhrenamtsbankAnfrageStatus anfrageStatus) {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, eintragStatus);
        await SeedAnfrage(eintrag.Id, interessent.Id, anfrageStatus);

        var result = await ExecuteGraphqlAsync(Principal(interessent.Id), EntryQuery,
            new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() });

        Assert.Null(result.Errors);
    }

    [Fact]
    public async Task Einzelansicht_AnfrageAufAnderemEintragGibtKeinenZugriff() {
        var owner = await CreateBuerger(registered: true);
        var strangerInteressent = await CreateBuerger(registered: true);
        var assignedEintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var otherEintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        await SeedAnfrage(otherEintrag.Id, strangerInteressent.Id, EhrenamtsbankAnfrageStatus.Offen);

        AssertEintragNotFound(await ExecuteGraphqlAsync(Principal(strangerInteressent.Id), EntryQuery,
            new Dictionary<string, object?> { ["id"] = assignedEintrag.Id.ToString() }));
    }

    // ---------- Abschluss ----------

    [Fact]
    public async Task Abschluss_VollerDurchlaufVonAktivBisCompleted() {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var anfrage = await SeedAnfrage(eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Akzeptiert);

        AnfragePayload(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateAnfrageStatusMutation,
                AnfrageStatusInput(anfrage.Id, "VEREINBART")),
            "updateEhrenamtsbankAnfrageStatus");
        Assert.Equal(EhrenamtsbankEintragStatus.Assigned, (await ReadEintrag(eintrag.Id)).Status);

        Assert.Null(Payload(
            await ExecuteGraphqlAsync(Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id)),
            "proposeEhrenamtsbankAbschluss")["errors"]);

        var confirmed = AnfragePayload(
            await ExecuteGraphqlAsync(Principal(interessent.Id), ConfirmMutation, AnfrageIdInput(anfrage.Id)),
            "confirmEhrenamtsbankAbschluss");
        Assert.Equal("ERLEDIGT", confirmed["status"]!.ToString());

        Assert.Equal(EhrenamtsbankAnfrageStatus.Erledigt, (await ReadAnfrage(anfrage.Id)).Status);
        Assert.Equal(EhrenamtsbankEintragStatus.Completed, (await ReadEintrag(eintrag.Id)).Status);
    }

    [Fact]
    public async Task Abschluss_VorschlagAufGeschlossenemEintragAbgelehnt() {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Closed);
        var anfrage = await SeedAnfrage(eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Vereinbart);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id)),
            "proposeEhrenamtsbankAbschluss", "AbschlussEintragNotAssignedError");
    }

    [Fact]
    public async Task Abschluss_BestaetigungAufGeschlossenemEintragAbgelehnt() {
        var owner = await CreateBuerger(registered: true);
        var interessent = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var anfrage = await SeedAnfrage(eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Vereinbart);

        Assert.Null(Payload(
            await ExecuteGraphqlAsync(Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id)),
            "proposeEhrenamtsbankAbschluss")["errors"]);

        await ForceEintragStatus(eintrag.Id, EhrenamtsbankEintragStatus.Closed);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(interessent.Id), ConfirmMutation, AnfrageIdInput(anfrage.Id)),
            "confirmEhrenamtsbankAbschluss", "AbschlussEintragNotAssignedError");

        Assert.Equal(EhrenamtsbankAnfrageStatus.Vereinbart, (await ReadAnfrage(anfrage.Id)).Status);
        Assert.Equal(EhrenamtsbankEintragStatus.Closed, (await ReadEintrag(eintrag.Id)).Status);
    }
}
