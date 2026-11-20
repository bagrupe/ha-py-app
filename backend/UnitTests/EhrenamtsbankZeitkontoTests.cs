using System.Security.Claims;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Ehrenamtsbank;
using API.Features.Ehrenamtsbank.Queries;
using API.Features.Funktionsberechtigungen;
using API.Options;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;
using NodaTime.Text;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankZeitkontoTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string ZeitkontoQuery = """
        query Zeitkonto {
            meinEhrenamtsbankZeitkonto {
                startCreditMinutes
                creditMinutes
                debitMinutes
                balanceMinutes
            }
        }
    """;

    private const string TransaktionenQuery = """
        query Transaktionen($filter: EhrenamtsbankTransaktionFilterInput, $skip: Int, $take: Int) {
            meineEhrenamtsbankTransaktionen(filter: $filter, skip: $skip, take: $take) {
                totalCount
                items { id minutes status giverId receiverId }
            }
        }
    """;

    private const string TransaktionenNutzerQuery = """
        query TransaktionenNutzer($userId: UUID!) {
            ehrenamtsbankTransaktionenNutzer(userId: $userId) {
                totalCount
                items { id minutes giverId receiverId }
            }
        }
    """;

    private const string ProposeMutation = """
        mutation Propose($input: ProposeEhrenamtsbankAbschlussInput!) {
            proposeEhrenamtsbankAbschluss(input: $input) {
                ehrenamtsbankAnfrage { id }
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

    private int StartCreditMinutes {
        get {
            using var scope = Factory.Services.CreateScope();
            return scope.ServiceProvider
                .GetRequiredService<IOptions<EhrenamtsbankZeitkontoOptions>>().Value.StartCreditMinutes;
        }
    }

    private async Task<IReadOnlyDictionary<string, object?>> Zeitkonto(Guid buergerId) =>
        Payload(await ExecuteGraphqlAsync(Principal(buergerId), ZeitkontoQuery), "meinEhrenamtsbankZeitkonto");

    private async Task<IReadOnlyDictionary<string, object?>> Transaktionen(
        Guid buergerId, object? filter = null, int? skip = null, int? take = null) {
        var variables = new Dictionary<string, object?> {
            ["filter"] = filter,
            ["skip"] = skip,
            ["take"] = take
        };
        return Payload(
            await ExecuteGraphqlAsync(Principal(buergerId), TransaktionenQuery, variables),
            "meineEhrenamtsbankTransaktionen");
    }

    private static IReadOnlyList<IReadOnlyDictionary<string, object?>> Items(
        IReadOnlyDictionary<string, object?> collection) =>
        Assert.IsAssignableFrom<IReadOnlyList<object?>>(collection["items"])
            .Select(item => Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(item)).ToList();

    private async Task<EhrenamtsbankTransaktion> SeedTransaktion(
        DomainContext db, Guid giverId, Guid receiverId, int minutes,
        EhrenamtsbankTransaktionStatus status = EhrenamtsbankTransaktionStatus.Confirmed,
        Instant? createdAt = null) {
        var eintrag = await testSeeder.CreateEintrag(db, receiverId, EhrenamtsbankEintragStatus.Completed);
        var now = createdAt ?? Instant.FromUtc(2026, 1, 1, 0, 0);
        var anfrage = new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintrag.Id,
            InteressentId = giverId,
            Status = EhrenamtsbankAnfrageStatus.Erledigt,
            CreatedAt = now,
            UpdatedAt = now
        };
        db.EhrenamtsbankAnfragen.Add(anfrage);

        var transaktion = new EhrenamtsbankTransaktion {
            Id = Guid.NewGuid(),
            AnfrageId = anfrage.Id,
            EintragId = eintrag.Id,
            GiverId = giverId,
            ReceiverId = receiverId,
            Minutes = minutes,
            PerformedOn = new LocalDate(2026, 1, 1),
            Status = status,
            CreatedAt = now,
            CreatedBy = EhrenamtsbankTransaktionCreatedBy.System
        };
        db.EhrenamtsbankTransaktionen.Add(transaktion);
        await db.SaveChangesAsync();
        return transaktion;
    }

    [Fact]
    public async Task Buchung_IstGutschriftBeimGeberUndBelastungBeimEmpfaenger() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var now = Instant.FromUtc(2026, 1, 1, 0, 0);
        var anfrage = new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintrag.Id,
            InteressentId = interessent.Id,
            Status = EhrenamtsbankAnfrageStatus.Vereinbart,
            CreatedAt = now,
            UpdatedAt = now,
            VereinbartAt = now
        };
        db.EhrenamtsbankAnfragen.Add(anfrage);
        await db.SaveChangesAsync();

        var proposeInput = new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> {
                ["anfrageId"] = anfrage.Id.ToString(),
                ["minutes"] = 90,
                ["date"] = LocalDatePattern.Iso.Format(API.Utils.DateTime.Today().PlusDays(-1)),
                ["note"] = null
            }
        };
        Assert.Null(Payload(
            await ExecuteGraphqlAsync(Principal(owner.Id), ProposeMutation, proposeInput),
            "proposeEhrenamtsbankAbschluss")["errors"]);

        var confirmInput = new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> { ["anfrageId"] = anfrage.Id.ToString() }
        };
        Assert.Null(Payload(
            await ExecuteGraphqlAsync(Principal(interessent.Id), ConfirmMutation, confirmInput),
            "confirmEhrenamtsbankAbschluss")["errors"]);

        var giverKonto = await Zeitkonto(interessent.Id);
        Assert.Equal(StartCreditMinutes, giverKonto["startCreditMinutes"]);
        Assert.Equal(90, giverKonto["creditMinutes"]);
        Assert.Equal(0, giverKonto["debitMinutes"]);
        Assert.Equal(StartCreditMinutes + 90, giverKonto["balanceMinutes"]);

        var receiverKonto = await Zeitkonto(owner.Id);
        Assert.Equal(0, receiverKonto["creditMinutes"]);
        Assert.Equal(90, receiverKonto["debitMinutes"]);
        Assert.Equal(StartCreditMinutes - 90, receiverKonto["balanceMinutes"]);
    }

    [Fact]
    public async Task Zeitkonto_IgnoriertCancelledUndFremdeBuchungen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);
        var other = await testSeeder.CreateBuerger(db, true);
        var stranger = await testSeeder.CreateBuerger(db, true);

        await SeedTransaktion(db, buerger.Id, other.Id, 60);
        await SeedTransaktion(db, buerger.Id, other.Id, 30, EhrenamtsbankTransaktionStatus.Adjusted);
        await SeedTransaktion(db, buerger.Id, other.Id, 999, EhrenamtsbankTransaktionStatus.Cancelled);
        await SeedTransaktion(db, other.Id, buerger.Id, 45);
        await SeedTransaktion(db, other.Id, buerger.Id, 999, EhrenamtsbankTransaktionStatus.Cancelled);
        await SeedTransaktion(db, stranger.Id, other.Id, 500);

        var konto = await Zeitkonto(buerger.Id);
        Assert.Equal(90, konto["creditMinutes"]);
        Assert.Equal(45, konto["debitMinutes"]);
        Assert.Equal(StartCreditMinutes + 45, konto["balanceMinutes"]);
    }

    [Fact]
    public async Task Zeitkonto_OhneBuchungen_LiefertStartguthaben() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);

        var konto = await Zeitkonto(buerger.Id);
        Assert.Equal(0, konto["creditMinutes"]);
        Assert.Equal(0, konto["debitMinutes"]);
        Assert.Equal(StartCreditMinutes, konto["balanceMinutes"]);
    }

    [Fact]
    public async Task Zeitkonto_NichtRegistriert_WirdAbgelehnt() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var unregistered = await testSeeder.CreateBuerger(db, false);

        var result = await ExecuteGraphqlAsync(Principal(unregistered.Id), ZeitkontoQuery);
        Assert.NotNull(result.Errors);
        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors).Code);
    }

    [Fact]
    public async Task MeineTransaktionen_LiefertNurEigeneZeilen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);
        var other = await testSeeder.CreateBuerger(db, true);
        var stranger = await testSeeder.CreateBuerger(db, true);

        var own = await SeedTransaktion(db, buerger.Id, other.Id, 60);
        var foreign = await SeedTransaktion(db, stranger.Id, other.Id, 120);

        var collection = await Transaktionen(buerger.Id);
        Assert.Equal(1, collection["totalCount"]);
        var ids = Items(collection).Select(i => i["id"]!.ToString()).ToList();
        Assert.Contains(own.Id.ToString(), ids);
        Assert.DoesNotContain(foreign.Id.ToString(), ids);
    }

    [Fact]
    public async Task MeineTransaktionen_FiltertNachStatus() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);
        var other = await testSeeder.CreateBuerger(db, true);

        var confirmed = await SeedTransaktion(db, buerger.Id, other.Id, 60);
        var cancelled = await SeedTransaktion(
            db, buerger.Id, other.Id, 30, EhrenamtsbankTransaktionStatus.Cancelled);

        Assert.Equal(2, (await Transaktionen(buerger.Id))["totalCount"]);

        var nurCancelled = await Transaktionen(
            buerger.Id, new Dictionary<string, object?> { ["status"] = "CANCELLED" });
        var item = Assert.Single(Items(nurCancelled));
        Assert.Equal(cancelled.Id.ToString(), item["id"]!.ToString());
        Assert.Equal("CANCELLED", item["status"]!.ToString());

        var nurConfirmed = await Transaktionen(
            buerger.Id, new Dictionary<string, object?> { ["status"] = "CONFIRMED" });
        Assert.Equal(confirmed.Id.ToString(), Assert.Single(Items(nurConfirmed))["id"]!.ToString());
    }

    [Fact]
    public async Task MeineTransaktionen_FiltertNachRolle() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);
        var other = await testSeeder.CreateBuerger(db, true);

        var gegeben = await SeedTransaktion(db, buerger.Id, other.Id, 60);
        var erhalten = await SeedTransaktion(db, other.Id, buerger.Id, 45);

        var alsGiver = await Transaktionen(
            buerger.Id, new Dictionary<string, object?> { ["role"] = "GIVER" });
        Assert.Equal(gegeben.Id.ToString(), Assert.Single(Items(alsGiver))["id"]!.ToString());

        var alsReceiver = await Transaktionen(
            buerger.Id, new Dictionary<string, object?> { ["role"] = "RECEIVER" });
        Assert.Equal(erhalten.Id.ToString(), Assert.Single(Items(alsReceiver))["id"]!.ToString());
    }

    [Fact]
    public async Task MeineTransaktionen_SortiertNeuesteZuerstUndPaginiert() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);
        var other = await testSeeder.CreateBuerger(db, true);

        var oldest = await SeedTransaktion(
            db, buerger.Id, other.Id, 10, createdAt: Instant.FromUtc(2026, 1, 1, 0, 0));
        var middle = await SeedTransaktion(
            db, buerger.Id, other.Id, 20, createdAt: Instant.FromUtc(2026, 2, 1, 0, 0));
        var newest = await SeedTransaktion(
            db, buerger.Id, other.Id, 30, createdAt: Instant.FromUtc(2026, 3, 1, 0, 0));

        var firstPage = await Transaktionen(buerger.Id, take: 2);
        Assert.Equal(3, firstPage["totalCount"]);
        Assert.Equal(
            new[] { newest.Id.ToString(), middle.Id.ToString() },
            Items(firstPage).Select(i => i["id"]!.ToString()).ToArray());

        var secondPage = await Transaktionen(buerger.Id, skip: 2, take: 2);
        Assert.Equal(oldest.Id.ToString(), Assert.Single(Items(secondPage))["id"]!.ToString());
    }

    [Fact]
    public async Task TransaktionenNutzer_MitFunktionsberechtigung_LiefertFremdeBuchungen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);
        var other = await testSeeder.CreateBuerger(db, true);
        var stranger = await testSeeder.CreateBuerger(db, true);

        var gegeben = await SeedTransaktion(db, buerger.Id, other.Id, 60);
        var erhalten = await SeedTransaktion(db, other.Id, buerger.Id, 45);
        var fremd = await SeedTransaktion(db, stranger.Id, other.Id, 120);

        var backofficeUser = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.Ehrenamtsbank]);

        var collection = Payload(
            await ExecuteGraphqlAsync(backofficeUser, TransaktionenNutzerQuery,
                new Dictionary<string, object?> { ["userId"] = buerger.Id.ToString() }),
            "ehrenamtsbankTransaktionenNutzer");

        Assert.Equal(2, collection["totalCount"]);
        var ids = Items(collection).Select(i => i["id"]!.ToString()).ToList();
        Assert.Contains(gegeben.Id.ToString(), ids);
        Assert.Contains(erhalten.Id.ToString(), ids);
        Assert.DoesNotContain(fremd.Id.ToString(), ids);
    }

    [Fact]
    public async Task TransaktionenNutzer_OhneFunktionsberechtigung_WirdAbgelehnt() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);
        var backofficeUser = await CreateBackofficeUserWithPrincipalAsync([]);

        var result = await ExecuteGraphqlAsync(backofficeUser, TransaktionenNutzerQuery,
            new Dictionary<string, object?> { ["userId"] = buerger.Id.ToString() });

        Assert.NotNull(result.Errors);
        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors).Code);
    }

    [Fact]
    public async Task TransaktionenNutzer_AlsBuerger_WirdAbgelehnt() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, true);

        var result = await ExecuteGraphqlAsync(Principal(buerger.Id), TransaktionenNutzerQuery,
            new Dictionary<string, object?> { ["userId"] = buerger.Id.ToString() });

        Assert.NotNull(result.Errors);
        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors).Code);
    }

    private async Task<ClaimsPrincipal> CreateBackofficeUserWithPrincipalAsync(
        List<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"zeitkonto-test-{Guid.NewGuid():N}@test.local",
            Vorname = "Zeitkonto",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
            Funktionsberechtigungen = globaleFunktionsberechtigungen,
            Gruppen = [],
            UntereinheitPermissions = [],
        };

        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        TestUserCrypto.InitializeMitarbeiterCrypto(
            user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);

        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        return new ClaimsPrincipal(new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt"));
    }

    [Fact]
    public void StatusFilter_WirdVonEfNachSqlUebersetzt() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var sql = db.EhrenamtsbankTransaktionen
            .Where(ZeitkontoQueries.CountsTowardBalance)
            .Select(t => t.Minutes)
            .ToQueryString();

        Assert.Contains("WHERE", sql);
        Assert.Contains("\"Status\"", sql);
    }
}
