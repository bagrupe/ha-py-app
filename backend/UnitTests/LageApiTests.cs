using System.Security.Claims;
using System.Text.Json.Nodes;
using System.Text.RegularExpressions;
using API.Features.Funktionsberechtigungen;
using API.Features.Lage;
using HotChocolate;
using HotChocolate.Execution;
using HotChocolate.Types;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using NodaTime.Testing;
using static IntegrationTests.GebietEinsatzleitungSeeder;

namespace IntegrationTests;

[Collection("Api Tests")]
public class LageApiTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private readonly GebietEinsatzleitungSeeder gebietSeeder = new(factory);
    private readonly LageSeeder lageSeeder = new(factory);

    private const string LageFields = """
        id
        title
        note
        status
        gebiete { status gebiet { id } }
    """;

    private Task<ClaimsPrincipal> LageHelfer() =>
        testSeeder.CreateBackofficeUserPrincipal(funktionsberechtigungen: [GlobaleFunktionsberechtigung.LageHelfer]);

    private Task<ClaimsPrincipal> CallerWithoutLageHelfer() => testSeeder.CreateBackofficeUserPrincipal();

    private static Guid UserIdOf(ClaimsPrincipal principal) =>
        Guid.Parse(principal.Claims.First(c => c.Type == ClaimTypes.NameIdentifier).Value);

    private static string Unique(string prefix) => $"{prefix} {Guid.NewGuid():N}";

    private Task<IQueryResult> CreateLage(ClaimsPrincipal caller, Guid untereinheitId, string title, string? note,
        params Guid[] gebietIds) =>
        ExecuteGraphqlAsync(caller, $$"""
            mutation($input: CreateLageInput!) {
                createLage(input: $input) {
                    lage { {{LageFields}} }
                    errors { __typename ... on Error { message } }
                }
            }
        """, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> {
                ["untereinheitId"] = untereinheitId,
                ["title"] = title,
                ["note"] = note,
                ["gebietIds"] = gebietIds.ToList(),
            },
        });

    private Task<IQueryResult> UpdateLage(ClaimsPrincipal caller, Guid lageId, string title, string? note) =>
        ExecuteGraphqlAsync(caller, $$"""
            mutation($input: UpdateLageInput!) {
                updateLage(input: $input) {
                    lage { {{LageFields}} }
                    errors { __typename ... on Error { message } }
                }
            }
        """, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> {
                ["lageId"] = lageId,
                ["title"] = title,
                ["note"] = note,
            },
        });

    private Task<IQueryResult> AddGebieteToLage(ClaimsPrincipal caller, Guid lageId, params Guid[] gebietIds) =>
        ExecuteGraphqlAsync(caller, $$"""
            mutation($input: AddGebieteToLageInput!) {
                addGebieteToLage(input: $input) {
                    lage { {{LageFields}} }
                    errors { __typename ... on Error { message } }
                }
            }
        """, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> {
                ["lageId"] = lageId,
                ["gebietIds"] = gebietIds.ToList(),
            },
        });

    private Task<IQueryResult> SetLageGebietStatus(ClaimsPrincipal caller, Guid lageId, Guid gebietId,
        LageGebietStatus status) =>
        ExecuteGraphqlAsync(caller, $$"""
            mutation($input: SetLageGebietStatusInput!) {
                setLageGebietStatus(input: $input) {
                    lage { {{LageFields}} }
                    errors { __typename ... on Error { message } }
                }
            }
        """, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> {
                ["lageId"] = lageId,
                ["gebietId"] = gebietId,
                ["status"] = GraphQLName(status),
            },
        });

    private static string GraphQLName(LageGebietStatus status) =>
        Regex.Replace(status.ToString(), "(?<!^)([A-Z])", "_$1").ToUpperInvariant();

    private static (Instant? At, Guid? ById) StampOf(LageGebiet pass, LageGebietStatus status) => status switch {
        LageGebietStatus.CalledOut => (pass.CalledOutAt, pass.CalledOutById),
        LageGebietStatus.Ready => (pass.ReadyAt, pass.ReadyById),
        LageGebietStatus.Live => (pass.LiveAt, pass.LiveById),
        LageGebietStatus.Ended => (pass.EndedAt, pass.EndedById),
        LageGebietStatus.Done => (pass.DoneAt, pass.DoneById),
        _ => throw new ArgumentOutOfRangeException(nameof(status), status, null),
    };

    private static List<JsonNode> GebieteEntries(JsonNode lage, Guid gebietId) =>
        lage["gebiete"]!.AsArray().Where(g => g!["gebiet"]!["id"]!.GetValue<Guid>() == gebietId).ToList()!;

    private static string GebietStatusIn(JsonNode lage, Guid gebietId) =>
        Assert.Single(GebieteEntries(lage, gebietId))["status"]!.GetValue<string>();

    private async Task WithFrozenClock(Func<FakeClock, Task> act) {
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var originalAutoAdvance = clock.AutoAdvance;
        try {
            clock.AutoAdvance = Duration.Zero;
            await act(clock);
        } finally {
            clock.AutoAdvance = originalAutoAdvance;
        }
    }

    private Task<IQueryResult> QueryLagen(ClaimsPrincipal caller, string? status = null) =>
        ExecuteGraphqlAsync(caller, $$"""
            query {
                lagen{{(status is null ? "" : $"(status: {status})")}} { {{LageFields}} }
            }
        """);

    private Task<IQueryResult> QueryLage(ClaimsPrincipal caller, Guid id) =>
        ExecuteGraphqlAsync(caller, $$"""
            query {
                lage(id: "{{id}}") { {{LageFields}} }
            }
        """);

    private static JsonNode Data(IQueryResult result) {
        Assert.True(result.Errors is null, result.ToJson());
        return JsonNode.Parse(result.ToJson())!["data"]!;
    }

    private static JsonNode PayloadLage(IQueryResult result, string field) {
        DenyMutationError(result, field);
        return Data(result)[field]!["lage"]!;
    }

    private static HashSet<Guid> LagenIds(IQueryResult result) =>
        Data(result)["lagen"]!.AsArray().Select(l => l!["id"]!.GetValue<Guid>()).ToHashSet();

    private static void AssertMutationRejected(IQueryResult result, string field, string expectedErrorTypename) {
        Assert.True(result.Errors is null, result.ToJson());
        AssertMutationError(result, field, expectedErrorTypename);
    }

    private static void AssertQueryNotAllowed(IQueryResult result) {
        Assert.NotNull(result.Errors);
        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors).Code);
    }

    [Fact]
    public async Task CreateLage_returns_status_Created_with_title_note_and_creator() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var caller = await LageHelfer();
        var title = Unique("Hochwasser");

        var lage = PayloadLage(await CreateLage(caller, untereinheit.Id, title, "intern"), "createLage");

        Assert.Equal(title, lage["title"]!.GetValue<string>());
        Assert.Equal("intern", lage["note"]!.GetValue<string>());
        Assert.Equal("CREATED", lage["status"]!.GetValue<string>());
        Assert.Empty(lage["gebiete"]!.AsArray());
        var stored = await lageSeeder.StoredLage(lage["id"]!.GetValue<Guid>());
        Assert.NotNull(stored);
        Assert.Equal(UserIdOf(caller), stored.CreatedById);
        Assert.NotEqual(default, stored.CreatedAt);
    }

    [Fact]
    public async Task CreateLage_with_Gebiete_links_them_as_Inactive() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var gebiet = NewGebiet(untereinheit.Id);
        await gebietSeeder.SeedGebiet(gebiet);

        var lage = PayloadLage(
            await CreateLage(await LageHelfer(), untereinheit.Id, Unique("Sturm"), null, gebiet.Id), "createLage");

        var linked = Assert.Single(lage["gebiete"]!.AsArray())!;
        Assert.Equal(gebiet.Id, linked["gebiet"]!["id"]!.GetValue<Guid>());
        Assert.Equal("INACTIVE", linked["status"]!.GetValue<string>());
    }

    [Fact]
    public async Task UpdateLage_changes_title_and_note() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"));
        var newTitle = Unique("Hochwasser Weser");

        var lage = PayloadLage(await UpdateLage(await LageHelfer(), seeded.Id, newTitle, "neue Notiz"), "updateLage");

        Assert.Equal(newTitle, lage["title"]!.GetValue<string>());
        Assert.Equal("neue Notiz", lage["note"]!.GetValue<string>());
        var stored = (await lageSeeder.StoredLage(seeded.Id))!;
        Assert.Equal(newTitle, stored.Title);
        Assert.Equal("neue Notiz", stored.Note);
        Assert.True(stored.UpdatedAt > seeded.UpdatedAt);
    }

    [Theory]
    [InlineData(null, new[] { "created", "active", "closed" })]
    [InlineData("CREATED", new[] { "created" })]
    [InlineData("ACTIVE", new[] { "active" })]
    [InlineData("CLOSED", new[] { "closed" })]
    public async Task Lagen_can_be_filtered_by_status(string? status, string[] expected) {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = new Dictionary<string, Guid> {
            ["created"] = (await lageSeeder.SeedLage(untereinheit.Id, Unique("created"))).Id,
            ["active"] = (await lageSeeder.SeedLage(untereinheit.Id, Unique("active"), false, "CalledOut,Ready,Live")).Id,
            ["closed"] = (await lageSeeder.SeedLage(untereinheit.Id, Unique("closed"), true)).Id,
        };

        var ids = LagenIds(await QueryLagen(await LageHelfer(), status));

        var returned = seeded.Where(s => ids.Contains(s.Value)).Select(s => s.Key).Order();
        Assert.Equal(expected.Order(), returned);
    }

    [Fact]
    public async Task Lage_detail_returns_Gebiete_with_their_status() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), false, "", "CalledOut,Ready");

        var lage = Data(await QueryLage(await LageHelfer(), seeded.Id))["lage"]!;

        var statusByGebiet = lage["gebiete"]!.AsArray().ToDictionary(
            g => g!["gebiet"]!["id"]!.GetValue<Guid>(),
            g => g!["status"]!.GetValue<string>());
        var expected = seeded.LageGebiete.ToDictionary(
            lg => lg.GebietId,
            lg => lg.Status == API.Features.Lage.LageGebietStatus.Inactive ? "INACTIVE" : "READY");
        Assert.Equal(expected, statusByGebiet);
    }

    [Theory]
    [InlineData("CREATED")]
    [InlineData("CREATED", "")]
    [InlineData("CREATED", "CalledOut")]
    [InlineData("CREATED", "CalledOut,Ready")]
    [InlineData("CREATED", "CalledOut,Ended")]
    [InlineData("ACTIVE", "CalledOut,Ready,Live")]
    [InlineData("ACTIVE", "", "CalledOut,Ready,Live")]
    [InlineData("ACTIVE", "CalledOut,Ready,Live,Ended")]
    public async Task Lage_becomes_Active_once_a_Gebiet_goes_Live(string expected, params string[] gebietPaths) {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), false, gebietPaths);

        var lage = Data(await QueryLage(await LageHelfer(), seeded.Id))["lage"]!;

        Assert.Equal(expected, lage["status"]!.GetValue<string>());
    }

    [Fact]
    public async Task Closed_Lage_stays_Closed_after_a_Gebiet_was_Live() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(
            untereinheit.Id, Unique("Hochwasser"), true, "CalledOut,Ready,Live,Ended");

        var lage = Data(await QueryLage(await LageHelfer(), seeded.Id))["lage"]!;

        Assert.Equal("CLOSED", lage["status"]!.GetValue<string>());
    }

    [Theory]
    [InlineData("createLage")]
    [InlineData("updateLage")]
    [InlineData("addGebieteToLage")]
    [InlineData("setLageGebietStatus")]
    public async Task Lage_mutations_without_LageHelfer_return_NotAllowed(string field) {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), false, "");
        var linkedGebietId = seeded.LageGebiete.Single().GebietId;
        var unlinkedGebiet = NewGebiet(untereinheit.Id);
        await gebietSeeder.SeedGebiet(unlinkedGebiet);
        var caller = await CallerWithoutLageHelfer();
        var attemptedTitle = Unique("Abgelehnt");

        var result = field switch {
            "createLage" => await CreateLage(caller, untereinheit.Id, attemptedTitle, null),
            "updateLage" => await UpdateLage(caller, seeded.Id, attemptedTitle, null),
            "addGebieteToLage" => await AddGebieteToLage(caller, seeded.Id, unlinkedGebiet.Id),
            _ => await SetLageGebietStatus(caller, seeded.Id, linkedGebietId, LageGebietStatus.CalledOut),
        };

        AssertMutationRejected(result, field, "NotAllowedError");
        Assert.False(await lageSeeder.AnyLageTitled(attemptedTitle));
        Assert.Empty(await lageSeeder.StoredPasses(seeded.Id, unlinkedGebiet.Id));
        Assert.Equal(LageGebietStatus.Inactive,
            Assert.Single(await lageSeeder.StoredPasses(seeded.Id, linkedGebietId)).Status);
    }

    [Theory]
    [InlineData("lagen")]
    [InlineData("lage")]
    public async Task Lage_queries_without_LageHelfer_return_NotAllowed(string field) {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"));
        var caller = await CallerWithoutLageHelfer();

        var result = field == "lagen" ? await QueryLagen(caller) : await QueryLage(caller, seeded.Id);

        AssertQueryNotAllowed(result);
    }

    [Fact]
    public async Task Lagen_excludes_Lagen_of_other_Kommune() {
        var otherKommune = await gebietSeeder.SeedKommune();
        var own = await lageSeeder.SeedLage((await gebietSeeder.SeedUntereinheit()).Id, Unique("eigene"));
        var foreign = await lageSeeder.SeedLage(
            (await gebietSeeder.SeedUntereinheit(otherKommune.Id)).Id, Unique("fremde"));

        var ids = LagenIds(await QueryLagen(await LageHelfer()));

        Assert.Contains(own.Id, ids);
        Assert.DoesNotContain(foreign.Id, ids);
    }

    [Fact]
    public async Task Lage_of_other_Kommune_is_not_returned() {
        var otherKommune = await gebietSeeder.SeedKommune();
        var foreign = await lageSeeder.SeedLage(
            (await gebietSeeder.SeedUntereinheit(otherKommune.Id)).Id, Unique("fremde"));

        var lage = Data(await QueryLage(await LageHelfer(), foreign.Id))["lage"];

        Assert.Null(lage);
    }

    [Fact]
    public async Task UpdateLage_of_other_Kommune_returns_LageNotFound() {
        var otherKommune = await gebietSeeder.SeedKommune();
        var foreignTitle = Unique("fremde");
        var foreign = await lageSeeder.SeedLage(
            (await gebietSeeder.SeedUntereinheit(otherKommune.Id)).Id, foreignTitle);

        var result = await UpdateLage(await LageHelfer(), foreign.Id, Unique("übernommen"), null);

        AssertMutationRejected(result, "updateLage", "LageNotFoundError");
        Assert.Equal(foreignTitle, (await lageSeeder.StoredLage(foreign.Id))!.Title);
    }

    [Fact]
    public async Task Gebiet_lifecycle_stamps_time_and_person_per_transition() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), false, "");
        var gebietId = seeded.LageGebiete.Single().GebietId;
        var caller = await LageHelfer();

        await WithFrozenClock(async clock => {
            foreach (var target in new[] {
                         LageGebietStatus.CalledOut, LageGebietStatus.Ready, LageGebietStatus.Live,
                         LageGebietStatus.Ended, LageGebietStatus.Done,
                     }) {
                clock.Advance(Duration.FromMinutes(1));
                var expectedAt = clock.GetCurrentInstant();

                var lage = PayloadLage(
                    await SetLageGebietStatus(caller, seeded.Id, gebietId, target), "setLageGebietStatus");

                Assert.Equal(GraphQLName(target), GebietStatusIn(lage, gebietId));
                var pass = Assert.Single(await lageSeeder.StoredPasses(seeded.Id, gebietId));
                Assert.Equal(target, pass.Status);
                Assert.Equal((expectedAt, UserIdOf(caller)), StampOf(pass, target));
            }
        });
    }

    [Fact]
    public async Task Readding_ended_Gebiet_creates_new_pass() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), false, "CalledOut,Ended");
        var endedPass = seeded.LageGebiete.Single();

        PayloadLage(await AddGebieteToLage(await LageHelfer(), seeded.Id, endedPass.GebietId), "addGebieteToLage");

        var passes = await lageSeeder.StoredPasses(seeded.Id, endedPass.GebietId);
        Assert.Equal(2, passes.Count);
        var oldPass = Assert.Single(passes, p => p.Id == endedPass.Id);
        Assert.Equal(LageGebietStatus.Ended, oldPass.Status);
        Assert.Equal((endedPass.CalledOutAt, endedPass.CalledOutById), (oldPass.CalledOutAt, oldPass.CalledOutById));
        Assert.Equal((endedPass.EndedAt, endedPass.EndedById), (oldPass.EndedAt, oldPass.EndedById));
        var newPass = Assert.Single(passes, p => p.Id != endedPass.Id);
        Assert.Equal(LageGebietStatus.Inactive, newPass.Status);
    }

    [Fact]
    public async Task Adding_Gebiet_with_open_pass_is_rejected() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), false, "CalledOut");
        var gebietId = seeded.LageGebiete.Single().GebietId;

        var result = await AddGebieteToLage(await LageHelfer(), seeded.Id, gebietId);

        AssertMutationRejected(result, "addGebieteToLage", "GebietAlreadyInLageError");
        Assert.Single(await lageSeeder.StoredPasses(seeded.Id, gebietId));
    }

    [Fact]
    public async Task Invalid_transition_is_rejected() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), false, "");
        var gebietId = seeded.LageGebiete.Single().GebietId;

        var result = await SetLageGebietStatus(await LageHelfer(), seeded.Id, gebietId, LageGebietStatus.Live);

        AssertMutationRejected(result, "setLageGebietStatus", "InvalidLageGebietTransitionError");
        Assert.Equal(LageGebietStatus.Inactive,
            Assert.Single(await lageSeeder.StoredPasses(seeded.Id, gebietId)).Status);
    }

    [Fact]
    public async Task Multiple_Gebiete_can_be_Live() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(
            untereinheit.Id, Unique("Hochwasser"), false, "CalledOut,Ready", "CalledOut,Ready");
        var gebietIds = seeded.LageGebiete.Select(lg => lg.GebietId).ToList();
        var caller = await LageHelfer();

        JsonNode lage = null!;
        foreach (var gebietId in gebietIds) {
            lage = PayloadLage(
                await SetLageGebietStatus(caller, seeded.Id, gebietId, LageGebietStatus.Live), "setLageGebietStatus");
        }

        Assert.All(gebietIds, id => Assert.Equal("LIVE", GebietStatusIn(lage, id)));
        Assert.Equal("ACTIVE", lage["status"]!.GetValue<string>());
    }

    [Fact]
    public async Task Lage_query_returns_current_pass_per_Gebiet() {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), false, "CalledOut,Ended");
        var gebietId = seeded.LageGebiete.Single().GebietId;
        var caller = await LageHelfer();
        PayloadLage(await AddGebieteToLage(caller, seeded.Id, gebietId), "addGebieteToLage");

        var lage = Data(await QueryLage(caller, seeded.Id))["lage"]!;

        Assert.Equal("INACTIVE", GebietStatusIn(lage, gebietId));
    }

    [Fact]
    public async Task Adding_Gebiet_of_other_Untereinheit_is_rejected() {
        var seeded = await lageSeeder.SeedLage((await gebietSeeder.SeedUntereinheit()).Id, Unique("Hochwasser"));
        var foreignGebiet = NewGebiet((await gebietSeeder.SeedUntereinheit()).Id);
        await gebietSeeder.SeedGebiet(foreignGebiet);

        var result = await AddGebieteToLage(await LageHelfer(), seeded.Id, foreignGebiet.Id);

        AssertMutationRejected(result, "addGebieteToLage", "GebietOfOtherUntereinheitError");
        Assert.Empty(await lageSeeder.StoredPasses(seeded.Id, foreignGebiet.Id));
    }

    [Theory]
    [InlineData("addGebieteToLage")]
    [InlineData("setLageGebietStatus")]
    public async Task Closed_Lage_rejects_Gebiet_changes(string field) {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var seeded = await lageSeeder.SeedLage(untereinheit.Id, Unique("Hochwasser"), true, "");
        var linkedGebietId = seeded.LageGebiete.Single().GebietId;
        var unlinkedGebiet = NewGebiet(untereinheit.Id);
        await gebietSeeder.SeedGebiet(unlinkedGebiet);
        var caller = await LageHelfer();

        var result = field == "addGebieteToLage"
            ? await AddGebieteToLage(caller, seeded.Id, unlinkedGebiet.Id)
            : await SetLageGebietStatus(caller, seeded.Id, linkedGebietId, LageGebietStatus.CalledOut);

        AssertMutationRejected(result, field, "LageClosedError");
        Assert.Empty(await lageSeeder.StoredPasses(seeded.Id, unlinkedGebiet.Id));
        Assert.Equal(LageGebietStatus.Inactive,
            Assert.Single(await lageSeeder.StoredPasses(seeded.Id, linkedGebietId)).Status);
        Assert.Equal(LageStatus.Closed, (await lageSeeder.StoredLage(seeded.Id))!.Status);
    }

    [Theory]
    [InlineData("addGebieteToLage")]
    [InlineData("setLageGebietStatus")]
    public async Task Gebiet_mutations_on_Lage_of_other_Kommune_return_LageNotFound(string field) {
        var foreignUntereinheit = await gebietSeeder.SeedUntereinheit((await gebietSeeder.SeedKommune()).Id);
        var foreign = await lageSeeder.SeedLage(foreignUntereinheit.Id, Unique("fremde"), false, "");
        var linkedGebietId = foreign.LageGebiete.Single().GebietId;
        var unlinkedGebiet = NewGebiet(foreignUntereinheit.Id);
        await gebietSeeder.SeedGebiet(unlinkedGebiet);
        var caller = await LageHelfer();

        var result = field == "addGebieteToLage"
            ? await AddGebieteToLage(caller, foreign.Id, unlinkedGebiet.Id)
            : await SetLageGebietStatus(caller, foreign.Id, linkedGebietId, LageGebietStatus.CalledOut);

        AssertMutationRejected(result, field, "LageNotFoundError");
        Assert.Empty(await lageSeeder.StoredPasses(foreign.Id, unlinkedGebiet.Id));
        Assert.Equal(LageGebietStatus.Inactive,
            Assert.Single(await lageSeeder.StoredPasses(foreign.Id, linkedGebietId)).Status);
    }

    [Fact]
    public async Task Schema_has_no_mutation_deleting_a_Lage() {
        var executor = await Factory.Services.GetRequiredService<IRequestExecutorResolver>().GetRequestExecutorAsync();

        var mutationNames = executor.Schema.MutationType!.Fields.Select(f => f.Name);

        Assert.DoesNotContain(mutationNames, name =>
            name.Contains("delete", StringComparison.OrdinalIgnoreCase)
            && name.Contains("lage", StringComparison.OrdinalIgnoreCase));
    }
}
