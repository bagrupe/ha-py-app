using API.Features;
using API.Features.Ehrenamtsbank;
using API.Infrastructure;
using HotChocolate.Execution;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankAnfrageTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string MeineAnfragenQuery = """
    query {
        meineEhrenamtsbankAnfragen(skip: 0, take: 50) {
            totalCount
            items {
                id
                eintragId
                nachricht
                status
                createdAt
                updatedAt
                typ
                interessent {
                    id
                    vorname
                    nachname
                    phoneVerified
                    clearanceVerified
                    phone
                }
            } } }
    """;

    private const string AnfragenFuerEhrenamtsbankEintragQuery = """
        query AnfragenFuerEintrag($id: UUID!) {
        anfragenFuerEhrenamtsbankEintrag(id: $id, skip: 0, take: 50) {
            totalCount
            items {
            id
            status
            createdAt
            updatedAt
            eintragId
            nachricht
            interessent {
                id
                vorname
                nachname
                phoneVerified
                clearanceVerified
                phone
            }

            }
        }
        }
    """;

    [Fact]
    public async Task AnonymousDoesNotSeeAnfragen() {
        var result = await ExecuteQuery(null, MeineAnfragenQuery, null);
        Assert.NotNull(result.Errors);
    }

    private static IReadOnlyList<IReadOnlyDictionary<string, object?>> Items(IQueryResult result, string field) {
        var data = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(result.Data);
        var page = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(data[field]);
        var items = Assert.IsAssignableFrom<IReadOnlyList<object?>>(page["items"]);
        return items.Select(i => Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(i)).ToList();
    }

    private static IReadOnlyDictionary<string, object?> InteressentProfil(
        IReadOnlyDictionary<string, object?> anfrage) =>
        Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(anfrage["interessent"]);

    [Fact]
    public async Task MeineAnfragen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var eintragErsteller = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, eintragErsteller.Id, API.Features.Ehrenamtsbank.EhrenamtsbankEintragStatus.Active);
        var interessent = await testSeeder.CreateBuerger(db, true, phone: "+4917012345678");

        db.EhrenamtsbankAnfragen.Add(new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintrag.Id,
            InteressentId = interessent.Id,
            Interessent = interessent
        });
        await db.SaveChangesAsync();
        var result = await ExecuteQuery(Principal(interessent.Id), MeineAnfragenQuery, null);
        Assert.Null(result.Errors);
        var items = Items(result, "meineEhrenamtsbankAnfragen");
        var item = Assert.Single(items);
        Assert.Equal(eintrag.Id.ToString(), item["eintragId"]!.ToString());
        Assert.Equal("EIGENE_ANFRAGE", item["typ"]!.ToString());
        var profil = InteressentProfil(item);
        Assert.Equal(interessent.Id.ToString(), profil["id"]!.ToString());
        Assert.Equal("Magdalena", profil["vorname"]);
        Assert.Equal("Schmidt", profil["nachname"]);
        Assert.Equal(true, profil["phoneVerified"]);
        Assert.Equal(false, profil["clearanceVerified"]);
        Assert.Equal("+4917012345678", profil["phone"]);

        var erstellerResult = await ExecuteQuery(Principal(eintragErsteller.Id), MeineAnfragenQuery, null);
        Assert.Null(erstellerResult.Errors);
        var erstellerItems = Items(erstellerResult, "meineEhrenamtsbankAnfragen");
        var erstellerItem = Assert.Single(erstellerItems);
        Assert.Equal(eintrag.Id.ToString(), erstellerItem["eintragId"]!.ToString());
        Assert.Equal("EMPFANGENE_ANFRAGE", erstellerItem["typ"]!.ToString());
        var erstellerProfil = InteressentProfil(erstellerItem);
        Assert.Equal(interessent.Id.ToString(), erstellerProfil["id"]!.ToString());
        Assert.Equal("+4917012345678", erstellerProfil["phone"]);
    }

    [Fact]
    public async Task EinstellerUndInteressentSiehtAnfragen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var eintragErsteller = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, eintragErsteller.Id, API.Features.Ehrenamtsbank.EhrenamtsbankEintragStatus.Active);
        var interessent = await testSeeder.CreateBuerger(db, true, phone: "+491709998877");

        var interessent2 = await testSeeder.CreateBuerger(db, true, phone: "+4917099988778");

        db.EhrenamtsbankAnfragen.Add(new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            Eintrag = eintrag,
            Interessent = interessent
        });
        db.EhrenamtsbankAnfragen.Add(new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            Eintrag = eintrag,
            Interessent = interessent2
        });

        await db.SaveChangesAsync();

        var einstellerResult = await ExecuteGraphqlAsync(Principal(eintragErsteller.Id), AnfragenFuerEhrenamtsbankEintragQuery, new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() });
        Assert.Null(einstellerResult.Errors);
        var anfragen = Items(einstellerResult, "anfragenFuerEhrenamtsbankEintrag");
        Assert.Equal(2, anfragen.Count);

        var byInteressentId = anfragen.ToDictionary(a => InteressentProfil(a)["id"]!.ToString()!);
        Assert.True(byInteressentId.ContainsKey(interessent.Id.ToString()));
        Assert.True(byInteressentId.ContainsKey(interessent2.Id.ToString()));

        var profil = InteressentProfil(byInteressentId[interessent.Id.ToString()]);
        Assert.Equal("Magdalena", profil["vorname"]);
        Assert.Equal("Schmidt", profil["nachname"]);
        Assert.Equal(true, profil["phoneVerified"]);
        Assert.Equal("+491709998877", profil["phone"]);

        var interessentResult = await ExecuteGraphqlAsync(Principal(interessent.Id), AnfragenFuerEhrenamtsbankEintragQuery, new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() });
        Assert.Null(interessentResult.Errors);
        var interessentAnfragen = Items(interessentResult, "anfragenFuerEhrenamtsbankEintrag");

        var interessentAnfrage = Assert.Single(interessentAnfragen);
        var interessentProfil = InteressentProfil(interessentAnfrage);
        Assert.Equal(interessent.Id.ToString(), interessentProfil["id"]!.ToString());

        var unbeteiligt = await testSeeder.CreateBuerger(db, true, phone: "+491100101");
        var unbeteiligtResult = await ExecuteGraphqlAsync(Principal(unbeteiligt.Id), AnfragenFuerEhrenamtsbankEintragQuery, new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() });
        Assert.Empty(Items(unbeteiligtResult, "anfragenFuerEhrenamtsbankEintrag"));
    }

    [Fact]
    public async Task Interessent_PhoneHiddenWhenUnverified() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var interessent = await testSeeder.CreateBuerger(
            db, true, phone: "+4917000000001", phoneVerified: false);

        db.EhrenamtsbankAnfragen.Add(new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintrag.Id,
            InteressentId = interessent.Id,
        });
        await db.SaveChangesAsync();

        var result = await ExecuteQuery(Principal(owner.Id), MeineAnfragenQuery, null);
        Assert.Null(result.Errors);
        var profil = InteressentProfil(Assert.Single(Items(result, "meineEhrenamtsbankAnfragen")));
        Assert.Equal(false, profil["phoneVerified"]);
        Assert.Null(profil["phone"]);
    }

    private const string AnfrageQuery = """
        query Anfrage($id: UUID!) {
            ehrenamtsbankAnfrage(id: $id) {
                id
                eintragId
                nachricht
                status
                typ
                interessent {
                    id
                    vorname
                    nachname
                }
            }
        }
    """;

    [Fact]
    public async Task Anfrage_VisibilityRules() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var stranger = await testSeeder.CreateBuerger(db, true);
        var unregistered = await testSeeder.CreateBuerger(db, false);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);
        anfrage.Nachricht = "Hallo";
        await db.SaveChangesAsync();

        var variables = new Dictionary<string, object?> { ["id"] = anfrage.Id.ToString() };

        var asInteressent = await ExecuteGraphqlAsync(Principal(interessent.Id), AnfrageQuery, variables);
        Assert.Null(asInteressent.Errors);
        var interessentData = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(asInteressent.Data);
        var interessentAnfrage = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            interessentData["ehrenamtsbankAnfrage"]);
        Assert.Equal(anfrage.Id.ToString(), interessentAnfrage["id"]!.ToString());
        Assert.Equal(eintrag.Id.ToString(), interessentAnfrage["eintragId"]!.ToString());
        Assert.Equal("Hallo", interessentAnfrage["nachricht"]);
        Assert.Equal("OFFEN", interessentAnfrage["status"]!.ToString());
        Assert.Equal("EIGENE_ANFRAGE", interessentAnfrage["typ"]!.ToString());

        var asOwner = await ExecuteGraphqlAsync(Principal(owner.Id), AnfrageQuery, variables);
        Assert.Null(asOwner.Errors);
        var ownerData = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(asOwner.Data);
        var ownerAnfrage = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            ownerData["ehrenamtsbankAnfrage"]);
        Assert.Equal(anfrage.Id.ToString(), ownerAnfrage["id"]!.ToString());
        Assert.Equal("EMPFANGENE_ANFRAGE", ownerAnfrage["typ"]!.ToString());

        var asStranger = await ExecuteGraphqlAsync(Principal(stranger.Id), AnfrageQuery, variables);
        Assert.NotNull(asStranger.Errors);
        Assert.Equal("ANFRAGE_NOT_FOUND", Assert.Single(asStranger.Errors).Code);

        var missing = await ExecuteGraphqlAsync(
            Principal(owner.Id), AnfrageQuery,
            new Dictionary<string, object?> { ["id"] = Guid.NewGuid().ToString() });
        Assert.NotNull(missing.Errors);
        Assert.Equal("ANFRAGE_NOT_FOUND", Assert.Single(missing.Errors).Code);

        var anonymous = await ExecuteGraphqlAsync(Anonymous(), AnfrageQuery, variables);
        Assert.NotNull(anonymous.Errors);
        Assert.Equal("AUTH_NOT_AUTHORIZED", Assert.Single(anonymous.Errors).Code);

        var asUnregistered = await ExecuteGraphqlAsync(Principal(unregistered.Id), AnfrageQuery, variables);
        Assert.NotNull(asUnregistered.Errors);
        Assert.Equal("NOT_ALLOWED", Assert.Single(asUnregistered.Errors).Code);

        eintrag.IsDeleted = true;
        await db.SaveChangesAsync();

        var interessentAfterDelete = await ExecuteGraphqlAsync(
            Principal(interessent.Id), AnfrageQuery, variables);
        Assert.Null(interessentAfterDelete.Errors);

        var ownerAfterDelete = await ExecuteGraphqlAsync(Principal(owner.Id), AnfrageQuery, variables);
        Assert.NotNull(ownerAfterDelete.Errors);
        Assert.Equal("ANFRAGE_NOT_FOUND", Assert.Single(ownerAfterDelete.Errors).Code);
    }

    private const string MeineAnfrageFuerEintragQuery = """
        query MeineAnfrageFuerEintrag($eintragId: UUID!) {
            meineEhrenamtsbankAnfrageFuerEintrag(eintragId: $eintragId) {
                id
                eintragId
                nachricht
                status
                typ
            }
        }
    """;

    [Fact]
    public async Task MeineAnfrageFuerEintrag_VisibilityRules() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var stranger = await testSeeder.CreateBuerger(db, true);
        var unregistered = await testSeeder.CreateBuerger(db, false);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);
        anfrage.Nachricht = "Hallo";
        await db.SaveChangesAsync();

        var variables = new Dictionary<string, object?> { ["eintragId"] = eintrag.Id.ToString() };

        var asInteressent = await ExecuteGraphqlAsync(
            Principal(interessent.Id), MeineAnfrageFuerEintragQuery, variables);
        Assert.Null(asInteressent.Errors);
        var interessentData = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(asInteressent.Data);
        var interessentAnfrage = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            interessentData["meineEhrenamtsbankAnfrageFuerEintrag"]);
        Assert.Equal(anfrage.Id.ToString(), interessentAnfrage["id"]!.ToString());
        Assert.Equal(eintrag.Id.ToString(), interessentAnfrage["eintragId"]!.ToString());
        Assert.Equal("Hallo", interessentAnfrage["nachricht"]);
        Assert.Equal("OFFEN", interessentAnfrage["status"]!.ToString());
        Assert.Equal("EIGENE_ANFRAGE", interessentAnfrage["typ"]!.ToString());

        var asOwner = await ExecuteGraphqlAsync(Principal(owner.Id), MeineAnfrageFuerEintragQuery, variables);
        Assert.Null(asOwner.Errors);
        var ownerData = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(asOwner.Data);
        Assert.Null(ownerData["meineEhrenamtsbankAnfrageFuerEintrag"]);

        var asStranger = await ExecuteGraphqlAsync(
            Principal(stranger.Id), MeineAnfrageFuerEintragQuery, variables);
        Assert.Null(asStranger.Errors);
        var strangerData = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(asStranger.Data);
        Assert.Null(strangerData["meineEhrenamtsbankAnfrageFuerEintrag"]);

        var noAnfrage = await ExecuteGraphqlAsync(
            Principal(interessent.Id), MeineAnfrageFuerEintragQuery,
            new Dictionary<string, object?> { ["eintragId"] = Guid.NewGuid().ToString() });
        Assert.Null(noAnfrage.Errors);
        var noAnfrageData = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(noAnfrage.Data);
        Assert.Null(noAnfrageData["meineEhrenamtsbankAnfrageFuerEintrag"]);

        var anonymous = await ExecuteGraphqlAsync(Anonymous(), MeineAnfrageFuerEintragQuery, variables);
        Assert.NotNull(anonymous.Errors);
        Assert.Equal("AUTH_NOT_AUTHORIZED", Assert.Single(anonymous.Errors).Code);

        var asUnregistered = await ExecuteGraphqlAsync(
            Principal(unregistered.Id), MeineAnfrageFuerEintragQuery, variables);
        Assert.NotNull(asUnregistered.Errors);
        Assert.Equal("NOT_ALLOWED", Assert.Single(asUnregistered.Errors).Code);
    }

    private const string CreateMutation = """
        mutation Create($input: CreateEhrenamtsbankAnfrageInput!) {
            createEhrenamtsbankAnfrage(input: $input) {
                ehrenamtsbankAnfrage { id status }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    [Fact]
    public async Task CreateAnfrage() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var eintragErsteller = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, eintragErsteller.Id, API.Features.Ehrenamtsbank.EhrenamtsbankEintragStatus.Active);
        var interessent = await testSeeder.CreateBuerger(db, true);

        const string nachricht = "Will ich machen";
        var createResult = await ExecuteQuery(Principal(interessent.Id), CreateMutation, new Dictionary<string, object?> {
            {"eintragId", eintrag.Id.ToString()},
            {"nachricht", nachricht}
        });

        Assert.Null(createResult.Errors);

        var newAnfrage = await db.EhrenamtsbankAnfragen.FirstOrDefaultAsync(a => a.EintragId == eintrag.Id && a.InteressentId == interessent.Id);
        Assert.NotNull(newAnfrage);
        Assert.Equal(EhrenamtsbankAnfrageStatus.Offen, newAnfrage.Status);
        Assert.Equal(newAnfrage.CreatedAt, newAnfrage.CreatedAt);
        Assert.Equal(nachricht, newAnfrage.Nachricht);
    }

    [Fact]
    public async Task CreateAnfrageFehler() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var eintragErsteller = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, eintragErsteller.Id, API.Features.Ehrenamtsbank.EhrenamtsbankEintragStatus.Active);

        // Unregistrierter Buerger darf keine Anfrage senden
        {
            var interessentUnregistriert = await testSeeder.CreateBuerger(db, false);

            var result = await ExecuteQuery(Principal(interessentUnregistriert.Id), CreateMutation, new Dictionary<string, object?> {
            {"eintragId", eintrag.Id.ToString()},
            });
            Assert.Null(result.Errors);
            AssertMutationError(result, "createEhrenamtsbankAnfrage", "NotAllowedError");
        }

        // Anfrage an eigenen Eintrag nicht möglich
        {
            var result = await ExecuteQuery(Principal(eintragErsteller.Id), CreateMutation, new Dictionary<string, object?> {
            {"eintragId", eintrag.Id.ToString()},
            });
            Assert.Null(result.Errors);
            AssertMutationError(result, "createEhrenamtsbankAnfrage", "AnfrageForItselfError");
        }

        // nur für aktive Einträge möglich
        {
            var interessentRegistriert = await testSeeder.CreateBuerger(db, true);
            foreach (var status in Enum.GetValues<EhrenamtsbankEintragStatus>()) {
                eintrag.Status = status;
                await db.SaveChangesAsync();
                var result = await ExecuteQuery(Principal(interessentRegistriert.Id), CreateMutation, new Dictionary<string, object?> {
                    {"eintragId", eintrag.Id.ToString()},
                });
                Assert.Null(result.Errors);

                if (status != EhrenamtsbankEintragStatus.Active) {
                    AssertMutationError(result, "createEhrenamtsbankAnfrage", "EintragNotActiveError");
                }
            }
        }

        // nur eine Anfrage pro Eintrag
        {
            var newEintrag = await testSeeder.CreateEintrag(db, eintragErsteller.Id, API.Features.Ehrenamtsbank.EhrenamtsbankEintragStatus.Active);

            var interessentRegistriert = await testSeeder.CreateBuerger(db, true);
            var result1 = await ExecuteQuery(Principal(interessentRegistriert.Id), CreateMutation, new Dictionary<string, object?> {
                    {"eintragId", newEintrag.Id.ToString()},
                });
            DenyMutationError(result1, "createEhrenamtsbankAnfrage");

            var result2 = await ExecuteQuery(Principal(interessentRegistriert.Id), CreateMutation, new Dictionary<string, object?> {
                    {"eintragId", newEintrag.Id.ToString()},
                });
            AssertMutationError(result2, "createEhrenamtsbankAnfrage", "MultipleAnfrageError");

        }
    }

    private const string UpdateStatusMutation = """
        mutation UpdateStatus($input: UpdateEhrenamtsbankAnfrageStatusInput!) {
            updateEhrenamtsbankAnfrageStatus(input: $input) {
                ehrenamtsbankAnfrage { id status updatedAt vereinbartAt }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    private static Dictionary<string, object?> StatusInput(Guid anfrageId, string status) =>
        new() {
            ["input"] = new Dictionary<string, object?> {
                ["anfrageId"] = anfrageId.ToString(),
                ["status"] = status
            }
        };

    private static async Task<EhrenamtsbankAnfrage> SeedAnfrage(
        DomainContext db,
        Guid eintragId,
        Guid interessentId,
        EhrenamtsbankAnfrageStatus status = EhrenamtsbankAnfrageStatus.Offen) {
        var now = Instant.FromUtc(2026, 1, 1, 0, 0);
        var anfrage = new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintragId,
            InteressentId = interessentId,
            Status = status,
            CreatedAt = now,
            UpdatedAt = now,
        };
        db.EhrenamtsbankAnfragen.Add(anfrage);
        await db.SaveChangesAsync();
        return anfrage;
    }

    [Fact]
    public async Task Interessent_KannOffeneAnfrageZurueckziehen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);

        var result = await ExecuteGraphqlAsync(
            Principal(interessent.Id), UpdateStatusMutation, StatusInput(anfrage.Id, "ZURUECKGEZOGEN"));

        var payload = Payload(result, "updateEhrenamtsbankAnfrageStatus");
        Assert.Null(payload["errors"]);
        var updated = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(payload["ehrenamtsbankAnfrage"]);
        Assert.Equal("ZURUECKGEZOGEN", updated["status"]!.ToString());

        await db.Entry(anfrage).ReloadAsync();
        Assert.Equal(EhrenamtsbankAnfrageStatus.Zurueckgezogen, anfrage.Status);
        Assert.True(anfrage.UpdatedAt > anfrage.CreatedAt);
    }

    [Fact]
    public async Task Owner_KannOffeneAnfrageAkzeptierenUndAblehnen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var interessentA = await testSeeder.CreateBuerger(db, true);
        var interessentB = await testSeeder.CreateBuerger(db, true);
        var toAccept = await SeedAnfrage(db, eintrag.Id, interessentA.Id);
        var toReject = await SeedAnfrage(db, eintrag.Id, interessentB.Id);

        var acceptResult = await ExecuteGraphqlAsync(
            Principal(owner.Id), UpdateStatusMutation, StatusInput(toAccept.Id, "AKZEPTIERT"));
        var acceptPayload = Payload(acceptResult, "updateEhrenamtsbankAnfrageStatus");
        Assert.Null(acceptPayload["errors"]);
        Assert.Equal("AKZEPTIERT",
            Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
                acceptPayload["ehrenamtsbankAnfrage"])["status"]!.ToString());

        var rejectResult = await ExecuteGraphqlAsync(
            Principal(owner.Id), UpdateStatusMutation, StatusInput(toReject.Id, "ABGELEHNT"));
        var rejectPayload = Payload(rejectResult, "updateEhrenamtsbankAnfrageStatus");
        Assert.Null(rejectPayload["errors"]);
        Assert.Equal("ABGELEHNT",
            Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
                rejectPayload["ehrenamtsbankAnfrage"])["status"]!.ToString());

        await db.Entry(toAccept).ReloadAsync();
        await db.Entry(toReject).ReloadAsync();
        Assert.Equal(EhrenamtsbankAnfrageStatus.Akzeptiert, toAccept.Status);
        Assert.Equal(EhrenamtsbankAnfrageStatus.Abgelehnt, toReject.Status);
    }

    [Fact]
    public async Task Owner_KannAkzeptierteAnfrageAblehnen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Akzeptiert);

        var result = await ExecuteGraphqlAsync(
            Principal(owner.Id), UpdateStatusMutation, StatusInput(anfrage.Id, "ABGELEHNT"));

        var payload = Payload(result, "updateEhrenamtsbankAnfrageStatus");
        Assert.Null(payload["errors"]);
        Assert.Equal("ABGELEHNT",
            Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
                payload["ehrenamtsbankAnfrage"])["status"]!.ToString());

        await db.Entry(anfrage).ReloadAsync();
        Assert.Equal(EhrenamtsbankAnfrageStatus.Abgelehnt, anfrage.Status);
    }

    [Fact]
    public async Task Owner_Vereinbart_LehntAndereAnfragenAb() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var i1 = await testSeeder.CreateBuerger(db, true);
        var i2 = await testSeeder.CreateBuerger(db, true);
        var i3 = await testSeeder.CreateBuerger(db, true);

        var i4 = await testSeeder.CreateBuerger(db, true);

        var accepted = await SeedAnfrage(db, eintrag.Id, i1.Id, EhrenamtsbankAnfrageStatus.Akzeptiert);
        var siblingA = await SeedAnfrage(db, eintrag.Id, i2.Id, EhrenamtsbankAnfrageStatus.Offen);
        var siblingB = await SeedAnfrage(db, eintrag.Id, i3.Id, EhrenamtsbankAnfrageStatus.Offen);
        var siblingTerminal = await SeedAnfrage(
            db, eintrag.Id, i4.Id, EhrenamtsbankAnfrageStatus.Zurueckgezogen);

        var result = await ExecuteGraphqlAsync(
            Principal(owner.Id), UpdateStatusMutation, StatusInput(accepted.Id, "VEREINBART"));

        var payload = Payload(result, "updateEhrenamtsbankAnfrageStatus");
        Assert.Null(payload["errors"]);
        var updated = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankAnfrage"]);
        Assert.Equal("VEREINBART", updated["status"]!.ToString());
        Assert.NotNull(updated["vereinbartAt"]);

        await db.Entry(accepted).ReloadAsync();
        await db.Entry(siblingA).ReloadAsync();
        await db.Entry(siblingB).ReloadAsync();
        await db.Entry(siblingTerminal).ReloadAsync();
        Assert.Equal(EhrenamtsbankAnfrageStatus.Vereinbart, accepted.Status);
        Assert.NotNull(accepted.VereinbartAt);
        Assert.Equal(EhrenamtsbankAnfrageStatus.Abgelehnt, siblingA.Status);
        Assert.Equal(EhrenamtsbankAnfrageStatus.Abgelehnt, siblingB.Status);
        Assert.True(siblingA.UpdatedAt > siblingA.CreatedAt);
        Assert.True(siblingB.UpdatedAt > siblingB.CreatedAt);
        Assert.Equal(EhrenamtsbankAnfrageStatus.Zurueckgezogen, siblingTerminal.Status);
        Assert.Equal(siblingTerminal.CreatedAt, siblingTerminal.UpdatedAt);
    }

    [Fact]
    public async Task Interessent_Vereinbart_LehntAndereAnfragenAb() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var i1 = await testSeeder.CreateBuerger(db, true);
        var i2 = await testSeeder.CreateBuerger(db, true);
        var i3 = await testSeeder.CreateBuerger(db, true);

        var accepted = await SeedAnfrage(db, eintrag.Id, i1.Id, EhrenamtsbankAnfrageStatus.Akzeptiert);
        var sibling = await SeedAnfrage(db, eintrag.Id, i2.Id, EhrenamtsbankAnfrageStatus.Offen);
        var siblingTerminal = await SeedAnfrage(
            db, eintrag.Id, i3.Id, EhrenamtsbankAnfrageStatus.Abgelehnt);

        var result = await ExecuteGraphqlAsync(
            Principal(i1.Id), UpdateStatusMutation, StatusInput(accepted.Id, "VEREINBART"));

        var payload = Payload(result, "updateEhrenamtsbankAnfrageStatus");
        Assert.Null(payload["errors"]);
        var updated = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankAnfrage"]);
        Assert.Equal("VEREINBART", updated["status"]!.ToString());
        Assert.NotNull(updated["vereinbartAt"]);

        await db.Entry(accepted).ReloadAsync();
        await db.Entry(sibling).ReloadAsync();
        await db.Entry(siblingTerminal).ReloadAsync();
        Assert.Equal(EhrenamtsbankAnfrageStatus.Vereinbart, accepted.Status);
        Assert.NotNull(accepted.VereinbartAt);
        Assert.Equal(EhrenamtsbankAnfrageStatus.Abgelehnt, sibling.Status);
        Assert.True(sibling.UpdatedAt > sibling.CreatedAt);
        Assert.Equal(siblingTerminal.CreatedAt, siblingTerminal.UpdatedAt);
    }

    [Fact]
    public async Task UpdateStatus_RejectsInvalidTransitions() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var stranger = await testSeeder.CreateBuerger(db, true);
        var offen = await SeedAnfrage(db, eintrag.Id, interessent.Id);
        var interessentAkzeptiert = await testSeeder.CreateBuerger(db, true);
        var akzeptiert = await SeedAnfrage(
            db, eintrag.Id, interessentAkzeptiert.Id, EhrenamtsbankAnfrageStatus.Akzeptiert);
        var abgelehnt = await SeedAnfrage(
            db, eintrag.Id, (await testSeeder.CreateBuerger(db, true)).Id, EhrenamtsbankAnfrageStatus.Abgelehnt);

        // Interessent darf nur Offen → Zurueckgezogen
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(interessent.Id), UpdateStatusMutation, StatusInput(offen.Id, "AKZEPTIERT")),
            "updateEhrenamtsbankAnfrageStatus", "AnfrageStatusTransitionError");
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(interessentAkzeptiert.Id), UpdateStatusMutation, StatusInput(akzeptiert.Id, "ZURUECKGEZOGEN")),
            "updateEhrenamtsbankAnfrageStatus", "AnfrageStatusTransitionError");

        // Owner: Offen nur → Akzeptiert/Abgelehnt
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(offen.Id, "VEREINBART")),
            "updateEhrenamtsbankAnfrageStatus", "AnfrageStatusTransitionError");
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(offen.Id, "ZURUECKGEZOGEN")),
            "updateEhrenamtsbankAnfrageStatus", "AnfrageStatusTransitionError");

        // Owner: Akzeptiert nur → Vereinbart/Abgelehnt
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(akzeptiert.Id, "OFFEN")),
            "updateEhrenamtsbankAnfrageStatus", "AnfrageStatusTransitionError");
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(akzeptiert.Id, "ERLEDIGT")),
            "updateEhrenamtsbankAnfrageStatus", "AnfrageStatusTransitionError");

        // Owner: Terminalzustände (noch) nicht weiterführbar
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(abgelehnt.Id, "OFFEN")),
            "updateEhrenamtsbankAnfrageStatus", "AnfrageStatusTransitionError");

        // Fremder darf nicht
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(stranger.Id), UpdateStatusMutation, StatusInput(offen.Id, "AKZEPTIERT")),
            "updateEhrenamtsbankAnfrageStatus", "NotAllowedError");

        // Unregistrierter Bürger
        var unregistered = await testSeeder.CreateBuerger(db, false);
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(unregistered.Id), UpdateStatusMutation, StatusInput(offen.Id, "ZURUECKGEZOGEN")),
            "updateEhrenamtsbankAnfrageStatus", "NotAllowedError");
    }

    [Fact]
    public async Task UpdateStatus_RejectsMissingInactiveDeleted() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Active);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(Guid.NewGuid(), "AKZEPTIERT")),
            "updateEhrenamtsbankAnfrageStatus", "AnfrageNotFoundError");

        eintrag.IsDeleted = true;
        await db.SaveChangesAsync();
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(anfrage.Id, "AKZEPTIERT")),
            "updateEhrenamtsbankAnfrageStatus", "EintragNotFoundError");

        eintrag.IsDeleted = false;
        await db.SaveChangesAsync();

        foreach (var status in Enum.GetValues<EhrenamtsbankEintragStatus>()) {
            if (status == EhrenamtsbankEintragStatus.Active) {
                continue;
            }

            eintrag.Status = status;
            await db.SaveChangesAsync();
            AssertMutationError(
                await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation, StatusInput(anfrage.Id, "AKZEPTIERT")),
                "updateEhrenamtsbankAnfrageStatus", "EintragNotActiveError");
        }
    }

}
