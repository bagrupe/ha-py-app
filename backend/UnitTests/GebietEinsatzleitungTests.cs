using System.Security.Claims;
using System.Text.Json.Nodes;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Lage;
using HotChocolate;
using HotChocolate.Execution;
using static IntegrationTests.GebietEinsatzleitungSeeder;

namespace IntegrationTests;

[Collection("Api Tests")]
public class GebietEinsatzleitungTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private readonly GebietEinsatzleitungSeeder seeder = new(factory);

    private Task<ClaimsPrincipal> LageHelfer() =>
        testSeeder.CreateBackofficeUserPrincipal(funktionsberechtigungen: [GlobaleFunktionsberechtigung.LageHelfer]);

    private async Task<IQueryResult> QueryGebiete(ClaimsPrincipal caller, string arguments = "") {
        var argumentList = arguments == "" ? "" : $"({arguments})";
        return await ExecuteGraphqlAsync(caller, $$"""
            query {
                gebiete{{argumentList}} {
                    id
                    einsatzleitungen { id }
                }
            }
        """);
    }

    private static JsonArray LoadedGebiete(IQueryResult result) {
        Assert.Null(result.Errors);
        return JsonNode.Parse(result.ToJson())!["data"]!["gebiete"]!.AsArray();
    }

    private static HashSet<Guid> GebietIds(IQueryResult result) =>
        LoadedGebiete(result).Select(g => g!["id"]!.GetValue<Guid>()).ToHashSet();

    private static IEnumerable<Guid> EinsatzleitungIdsOf(IQueryResult result, Guid gebietId) =>
        LoadedGebiete(result)
            .Single(g => g!["id"]!.GetValue<Guid>() == gebietId)!["einsatzleitungen"]!.AsArray()
            .Select(e => e!["id"]!.GetValue<Guid>())
            .Order();

    private const string AddField = "addGebietEinsatzleitung";
    private const string RemoveField = "removeGebietEinsatzleitung";

    private Task<IQueryResult> AddEinsatzleitung(ClaimsPrincipal caller, Gebiet gebiet, MitarbeiterGruppe gruppe) =>
        MutateEinsatzleitung(AddField, caller, gebiet, gruppe);

    private Task<IQueryResult> RemoveEinsatzleitung(ClaimsPrincipal caller, Gebiet gebiet, MitarbeiterGruppe gruppe) =>
        MutateEinsatzleitung(RemoveField, caller, gebiet, gruppe);

    private async Task<IQueryResult> MutateEinsatzleitung(
        string field, ClaimsPrincipal caller, Gebiet gebiet, MitarbeiterGruppe gruppe) =>
        await ExecuteGraphqlAsync(caller, $$"""
            mutation {
                {{field}}(input: { gebietId: "{{gebiet.Id}}", mitarbeiterGruppeId: "{{gruppe.Id}}" }) {
                    gebiet {
                        id
                        einsatzleitungen { id }
                    }
                    errors { __typename ... on Error { message } }
                }
            }
        """);

    private static IEnumerable<Guid> PayloadEinsatzleitungIds(IQueryResult result, string field, Guid gebietId) {
        Assert.True(result.Errors is null, result.ToJson());
        DenyMutationError(result, field);
        var gebiet = JsonNode.Parse(result.ToJson())!["data"]![field]!["gebiet"]!;
        Assert.Equal(gebietId, gebiet["id"]!.GetValue<Guid>());
        return gebiet["einsatzleitungen"]!.AsArray().Select(e => e!["id"]!.GetValue<Guid>()).Order();
    }

    private static void AssertRejected(IQueryResult result, string field, string expectedErrorTypename) {
        Assert.True(result.Errors is null, result.ToJson());
        AssertMutationError(result, field, expectedErrorTypename);
    }

    [Fact]
    public async Task Gebiet_can_have_multiple_Einsatzleitungen() {
        var owner = await seeder.SeedUntereinheit();
        var firstGruppe = NewMitarbeiterGruppe(owner);
        var secondGruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, firstGruppe, secondGruppe);
        await seeder.SeedGebiet(gebiet, firstGruppe, secondGruppe);

        var result = await QueryGebiete(await LageHelfer());

        Assert.Equal(new[] { firstGruppe.Id, secondGruppe.Id }.Order(), EinsatzleitungIdsOf(result, gebiet.Id));
    }

    [Fact]
    public async Task MitarbeiterGruppe_can_be_Einsatzleitung_of_multiple_Gebiete() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var firstGebiet = NewGebiet(owner.Id);
        var secondGebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(firstGebiet, gruppe);
        await seeder.SeedGebiet(secondGebiet, gruppe);

        var result = await QueryGebiete(await LageHelfer());

        Assert.Equal([gruppe.Id], EinsatzleitungIdsOf(result, firstGebiet.Id));
        Assert.Equal([gruppe.Id], EinsatzleitungIdsOf(result, secondGebiet.Id));
    }

    [Fact]
    public async Task Gebiet_assigned_Einsatzleitung_can_be_queried() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var assignedGebiet = NewGebiet(owner.Id);
        var unassignedGebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(assignedGebiet, gruppe);
        await seeder.SeedGebiet(unassignedGebiet);
        var lageHelfer = await LageHelfer();

        var all = await QueryGebiete(lageHelfer);
        var withoutEinsatzleitung = GebietIds(await QueryGebiete(lageHelfer, "withoutEinsatzleitung: true"));

        Assert.Equal([gruppe.Id], EinsatzleitungIdsOf(all, assignedGebiet.Id));
        Assert.DoesNotContain(assignedGebiet.Id, withoutEinsatzleitung);
        Assert.Contains(unassignedGebiet.Id, withoutEinsatzleitung);
    }

    [Fact]
    public async Task AddGebietEinsatzleitung_makes_MitarbeiterGruppe_of_owner_Untereinheit_Einsatzleitung() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet);

        var result = await AddEinsatzleitung(await LageHelfer(), gebiet, gruppe);

        Assert.Equal([gruppe.Id], PayloadEinsatzleitungIds(result, AddField, gebiet.Id));
        Assert.Equal([gruppe.Id], await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
    }

    [Fact]
    public async Task AddGebietEinsatzleitung_rejects_MitarbeiterGruppe_of_other_Untereinheit_in_same_Kommune() {
        var owner = await seeder.SeedUntereinheit();
        var otherUntereinheit = await seeder.SeedUntereinheit();
        var foreignGruppe = NewMitarbeiterGruppe(otherUntereinheit);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(otherUntereinheit, foreignGruppe);
        await seeder.SeedGebiet(gebiet);

        var result = await AddEinsatzleitung(await LageHelfer(), gebiet, foreignGruppe);

        AssertRejected(result, AddField, "MitarbeiterGruppeOfOtherUntereinheitError");
        Assert.Empty(await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
    }

    [Fact]
    public async Task AddGebietEinsatzleitung_rejects_deleted_MitarbeiterGruppe() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet);
        await seeder.DeleteMitarbeiterGruppe(gruppe.Id);

        var result = await AddEinsatzleitung(await LageHelfer(), gebiet, gruppe);

        AssertRejected(result, AddField, "MitarbeiterGruppeDeletedError");
        Assert.Empty(await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
    }

    [Fact]
    public async Task RemoveGebietEinsatzleitung_keeps_other_Einsatzleitungen_of_Gebiet() {
        var owner = await seeder.SeedUntereinheit();
        var removedGruppe = NewMitarbeiterGruppe(owner);
        var keptGruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, removedGruppe, keptGruppe);
        await seeder.SeedGebiet(gebiet, removedGruppe, keptGruppe);

        var result = await RemoveEinsatzleitung(await LageHelfer(), gebiet, removedGruppe);

        Assert.Equal([keptGruppe.Id], PayloadEinsatzleitungIds(result, RemoveField, gebiet.Id));
        Assert.Equal([keptGruppe.Id], await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
    }

    [Fact]
    public async Task RemoveGebietEinsatzleitung_keeps_Einsatzleitung_of_other_Gebiet_with_same_MitarbeiterGruppe() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        var otherGebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet, gruppe);
        await seeder.SeedGebiet(otherGebiet, gruppe);

        var result = await RemoveEinsatzleitung(await LageHelfer(), gebiet, gruppe);

        Assert.Empty(PayloadEinsatzleitungIds(result, RemoveField, gebiet.Id));
        Assert.Empty(await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
        Assert.Equal([gruppe.Id], await seeder.StoredEinsatzleitungIdsIncludingDeleted(otherGebiet.Id));
    }

    [Fact]
    public async Task Gebiet_appears_as_without_Einsatzleitung_after_last_one_is_removed() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet, gruppe);
        var lageHelfer = await LageHelfer();

        var beforeRemoval = GebietIds(await QueryGebiete(lageHelfer, "withoutEinsatzleitung: true"));
        var result = await RemoveEinsatzleitung(lageHelfer, gebiet, gruppe);
        var afterRemoval = GebietIds(await QueryGebiete(lageHelfer, "withoutEinsatzleitung: true"));

        Assert.Empty(PayloadEinsatzleitungIds(result, RemoveField, gebiet.Id));
        Assert.Empty(await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
        Assert.DoesNotContain(gebiet.Id, beforeRemoval);
        Assert.Contains(gebiet.Id, afterRemoval);
    }

    [Fact]
    public async Task Gebiet_appears_as_without_Einsatzleitung_after_its_only_MitarbeiterGruppe_is_deleted() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet, gruppe);
        var lageHelfer = await LageHelfer();

        var beforeDeletion = GebietIds(await QueryGebiete(lageHelfer, "withoutEinsatzleitung: true"));
        await seeder.DeleteMitarbeiterGruppe(gruppe.Id);
        var afterDeletion = GebietIds(await QueryGebiete(lageHelfer, "withoutEinsatzleitung: true"));

        Assert.DoesNotContain(gebiet.Id, beforeDeletion);
        Assert.Contains(gebiet.Id, afterDeletion);
    }

    [Fact]
    public async Task Gebiet_appears_as_without_Einsatzleitung_after_its_only_MitarbeiterGruppe_leaves_its_Untereinheit() {
        var owner = await seeder.SeedUntereinheit();
        var otherUntereinheit = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        gruppe.Organisationseinheiten.Add(otherUntereinheit);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet, gruppe);
        var lageHelfer = await LageHelfer();

        var beforeRemoval = GebietIds(await QueryGebiete(lageHelfer, "withoutEinsatzleitung: true"));
        await seeder.RemoveOrganisationseinheit(gruppe.Id, owner.Id);
        var afterRemoval = await QueryGebiete(lageHelfer);
        var withoutEinsatzleitung = GebietIds(await QueryGebiete(lageHelfer, "withoutEinsatzleitung: true"));

        Assert.DoesNotContain(gebiet.Id, beforeRemoval);
        Assert.Contains(gebiet.Id, withoutEinsatzleitung);
        Assert.Empty(EinsatzleitungIdsOf(afterRemoval, gebiet.Id));
    }

    [Fact]
    public async Task Gebiete_does_not_return_Gebiet_of_other_Kommune() {
        var otherKommune = await seeder.SeedKommune();
        var ownGebiet = NewGebiet((await seeder.SeedUntereinheit()).Id);
        var foreignGebiet = NewGebiet((await seeder.SeedUntereinheit(otherKommune.Id)).Id);
        await seeder.SeedGebiet(ownGebiet);
        await seeder.SeedGebiet(foreignGebiet);

        var gebietIds = GebietIds(await QueryGebiete(await LageHelfer()));

        Assert.Contains(ownGebiet.Id, gebietIds);
        Assert.DoesNotContain(foreignGebiet.Id, gebietIds);
    }

    [Fact]
    public async Task AddGebietEinsatzleitung_rejects_caller_from_other_Kommune() {
        var otherKommune = await seeder.SeedKommune();
        var foreignOwner = await seeder.SeedUntereinheit(otherKommune.Id);
        var foreignGruppe = NewMitarbeiterGruppe(foreignOwner);
        var foreignGebiet = NewGebiet(foreignOwner.Id);
        await seeder.SeedMitarbeiterGruppen(foreignOwner, foreignGruppe);
        await seeder.SeedGebiet(foreignGebiet);

        var result = await AddEinsatzleitung(await LageHelfer(), foreignGebiet, foreignGruppe);

        AssertRejected(result, AddField, "GebietNotFoundError");
        Assert.Empty(await seeder.StoredEinsatzleitungIdsIncludingDeleted(foreignGebiet.Id));
    }

    [Fact]
    public async Task RemoveGebietEinsatzleitung_rejects_caller_from_other_Kommune() {
        var otherKommune = await seeder.SeedKommune();
        var foreignOwner = await seeder.SeedUntereinheit(otherKommune.Id);
        var foreignGruppe = NewMitarbeiterGruppe(foreignOwner);
        var foreignGebiet = NewGebiet(foreignOwner.Id);
        await seeder.SeedMitarbeiterGruppen(foreignOwner, foreignGruppe);
        await seeder.SeedGebiet(foreignGebiet, foreignGruppe);

        var result = await RemoveEinsatzleitung(await LageHelfer(), foreignGebiet, foreignGruppe);

        AssertRejected(result, RemoveField, "GebietNotFoundError");
        Assert.Equal([foreignGruppe.Id], await seeder.StoredEinsatzleitungIdsIncludingDeleted(foreignGebiet.Id));
    }

    [Fact]
    public async Task Gebiete_rejects_caller_without_LageHelfer() {
        var caller = await testSeeder.CreateBackofficeUserPrincipal();

        var result = await QueryGebiete(caller);

        Assert.NotNull(result.Errors);
        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors).Code);
    }

    [Fact]
    public async Task AddGebietEinsatzleitung_rejects_caller_without_LageHelfer() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet);
        var caller = await testSeeder.CreateBackofficeUserPrincipal();

        var result = await AddEinsatzleitung(caller, gebiet, gruppe);

        AssertRejected(result, AddField, "NotAllowedError");
        Assert.Empty(await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
    }

    [Fact]
    public async Task RemoveGebietEinsatzleitung_rejects_caller_without_LageHelfer() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet, gruppe);
        var caller = await testSeeder.CreateBackofficeUserPrincipal();

        var result = await RemoveEinsatzleitung(caller, gebiet, gruppe);

        AssertRejected(result, RemoveField, "NotAllowedError");
        Assert.Equal([gruppe.Id], await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
    }

    [Fact]
    public async Task AddGebietEinsatzleitung_succeeds_without_duplicating_existing_Einsatzleitung() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet, gruppe);

        var result = await AddEinsatzleitung(await LageHelfer(), gebiet, gruppe);

        Assert.Equal([gruppe.Id], PayloadEinsatzleitungIds(result, AddField, gebiet.Id));
        Assert.Equal([gruppe.Id], await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
    }

    [Fact]
    public async Task RemoveGebietEinsatzleitung_succeeds_when_MitarbeiterGruppe_is_not_Einsatzleitung() {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(gebiet);

        var result = await RemoveEinsatzleitung(await LageHelfer(), gebiet, gruppe);

        Assert.Empty(PayloadEinsatzleitungIds(result, RemoveField, gebiet.Id));
        Assert.Empty(await seeder.StoredEinsatzleitungIdsIncludingDeleted(gebiet.Id));
    }

    [Fact]
    public async Task Einsatzleitungen_leaves_out_deleted_MitarbeiterGruppen() {
        var owner = await seeder.SeedUntereinheit();
        var activeGruppe = NewMitarbeiterGruppe(owner);
        var deletedGruppe = NewMitarbeiterGruppe(owner);
        var gebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, activeGruppe, deletedGruppe);
        await seeder.SeedGebiet(gebiet, activeGruppe, deletedGruppe);
        await seeder.DeleteMitarbeiterGruppe(deletedGruppe.Id);

        var result = await QueryGebiete(await LageHelfer());

        Assert.Equal([activeGruppe.Id], EinsatzleitungIdsOf(result, gebiet.Id));
    }

    [Theory]
    [InlineData("withoutEinsatzleitung: false")]
    [InlineData("")]
    public async Task Gebiete_returns_all_Gebiete_when_withoutEinsatzleitung_is_false_or_omitted(string arguments) {
        var owner = await seeder.SeedUntereinheit();
        var gruppe = NewMitarbeiterGruppe(owner);
        var assignedGebiet = NewGebiet(owner.Id);
        var unassignedGebiet = NewGebiet(owner.Id);
        await seeder.SeedMitarbeiterGruppen(owner, gruppe);
        await seeder.SeedGebiet(assignedGebiet, gruppe);
        await seeder.SeedGebiet(unassignedGebiet);

        var gebietIds = GebietIds(await QueryGebiete(await LageHelfer(), arguments));

        Assert.Contains(assignedGebiet.Id, gebietIds);
        Assert.Contains(unassignedGebiet.Id, gebietIds);
    }
}
