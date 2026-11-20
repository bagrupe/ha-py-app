using API.Features;
using API.Features.Ehrenamtsbank;
using API.Options;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;
using NodaTime.Text;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankAbschlussTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string ProposeMutation = """
        mutation Propose($input: ProposeEhrenamtsbankAbschlussInput!) {
            proposeEhrenamtsbankAbschluss(input: $input) {
                ehrenamtsbankAnfrage {
                    id
                    proposedMinutes
                    proposedDate
                    proposedNote
                    proposedById
                }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    private static Dictionary<string, object?> ProposeInput(
        Guid anfrageId, int minutes, string date, string? note = null) =>
        new() {
            ["input"] = new Dictionary<string, object?> {
                ["anfrageId"] = anfrageId.ToString(),
                ["minutes"] = minutes,
                ["date"] = date,
                ["note"] = note
            }
        };

    private EhrenamtsbankZeitkontoOptions Options() =>
        Factory.Services.GetRequiredService<IOptions<EhrenamtsbankZeitkontoOptions>>().Value;

    private static async Task<EhrenamtsbankAnfrage> SeedAnfrage(
        DomainContext db,
        Guid eintragId,
        Guid interessentId,
        EhrenamtsbankAnfrageStatus status = EhrenamtsbankAnfrageStatus.Vereinbart) {
        var now = Instant.FromUtc(2026, 1, 1, 0, 0);
        var anfrage = new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintragId,
            InteressentId = interessentId,
            Status = status,
            CreatedAt = now,
            UpdatedAt = now,
            VereinbartAt = status == EhrenamtsbankAnfrageStatus.Vereinbart ? now : null
        };
        db.EhrenamtsbankAnfragen.Add(anfrage);
        await db.SaveChangesAsync();
        return anfrage;
    }

    private static string Iso(LocalDate date) => LocalDatePattern.Iso.Format(date);

    private static string Yesterday() => Iso(API.Utils.DateTime.Today().PlusDays(-1));

    [Fact]
    public async Task Owner_SchlaegtAbschlussVor() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);

        var date = Yesterday();
        var result = await ExecuteGraphqlAsync(
            Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id, 90, date, "Alles erledigt"));

        var payload = Payload(result, "proposeEhrenamtsbankAbschluss");
        Assert.Null(payload["errors"]);
        var updated = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankAnfrage"]);
        Assert.Equal(90, updated["proposedMinutes"]);
        Assert.Equal(date, updated["proposedDate"]!.ToString());
        Assert.Equal("Alles erledigt", updated["proposedNote"]);
        Assert.Equal(owner.Id.ToString(), updated["proposedById"]!.ToString());

        await db.Entry(anfrage).ReloadAsync();
        Assert.Equal(90, anfrage.ProposedMinutes);
        Assert.Equal(LocalDatePattern.Iso.Parse(date).Value, anfrage.ProposedDate);
        Assert.Equal("Alles erledigt", anfrage.ProposedNote);
        Assert.Equal(owner.Id, anfrage.ProposedById);
        Assert.True(anfrage.UpdatedAt > anfrage.CreatedAt);
    }

    [Fact]
    public async Task Interessent_UeberschreibtVorschlag() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);

        var firstDate = Iso(API.Utils.DateTime.Today().PlusDays(-3));
        var firstResult = await ExecuteGraphqlAsync(
            Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id, 90, firstDate, "Erster Vorschlag"));
        Assert.Null(Payload(firstResult, "proposeEhrenamtsbankAbschluss")["errors"]);

        var counterDate = Yesterday();
        var counterResult = await ExecuteGraphqlAsync(
            Principal(interessent.Id), ProposeMutation,
            ProposeInput(anfrage.Id, 120, counterDate, "Hat länger gedauert"));
        Assert.Null(Payload(counterResult, "proposeEhrenamtsbankAbschluss")["errors"]);

        await db.Entry(anfrage).ReloadAsync();
        Assert.Equal(120, anfrage.ProposedMinutes);
        Assert.Equal(LocalDatePattern.Iso.Parse(counterDate).Value, anfrage.ProposedDate);
        Assert.Equal("Hat länger gedauert", anfrage.ProposedNote);
        Assert.Equal(interessent.Id, anfrage.ProposedById);
    }

    [Fact]
    public async Task Fremder_DarfNichtVorschlagen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var stranger = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);

        AssertMutationError(
            await ExecuteGraphqlAsync(
                Principal(stranger.Id), ProposeMutation, ProposeInput(anfrage.Id, 60, Yesterday())),
            "proposeEhrenamtsbankAbschluss", "NotAllowedError");

        var unregistered = await testSeeder.CreateBuerger(db, false);
        AssertMutationError(
            await ExecuteGraphqlAsync(
                Principal(unregistered.Id), ProposeMutation, ProposeInput(anfrage.Id, 60, Yesterday())),
            "proposeEhrenamtsbankAbschluss", "NotAllowedError");
    }

    [Fact]
    public async Task NurVereinbarteAnfragen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);

        foreach (var status in Enum.GetValues<EhrenamtsbankAnfrageStatus>()) {
            if (status == EhrenamtsbankAnfrageStatus.Vereinbart) {
                continue;
            }

            var interessent = await testSeeder.CreateBuerger(db, true);
            var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id, status);
            AssertMutationError(
                await ExecuteGraphqlAsync(
                    Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id, 60, Yesterday())),
                "proposeEhrenamtsbankAbschluss", "AbschlussNotVereinbartError");
        }
    }

    [Fact]
    public async Task MinutenAusserhalbDerGrenzen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);
        var max = Options().MaxTransactionMinutes;

        AssertMutationError(
            await ExecuteGraphqlAsync(
                Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id, 0, Yesterday())),
            "proposeEhrenamtsbankAbschluss", "AbschlussMinutesOutOfRangeError");
        AssertMutationError(
            await ExecuteGraphqlAsync(
                Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id, max + 1, Yesterday())),
            "proposeEhrenamtsbankAbschluss", "AbschlussMinutesOutOfRangeError");

        var maxResult = await ExecuteGraphqlAsync(
            Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id, max, Yesterday()));
        Assert.Null(Payload(maxResult, "proposeEhrenamtsbankAbschluss")["errors"]);
    }

    [Fact]
    public async Task DatumDarfNichtInDerZukunftLiegen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);

        var tomorrow = Iso(API.Utils.DateTime.Today().PlusDays(1));
        AssertMutationError(
            await ExecuteGraphqlAsync(
                Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id, 60, tomorrow)),
            "proposeEhrenamtsbankAbschluss", "AbschlussDateInFutureError");

        var today = Iso(API.Utils.DateTime.Today());
        var todayResult = await ExecuteGraphqlAsync(
            Principal(owner.Id), ProposeMutation, ProposeInput(anfrage.Id, 60, today));
        Assert.Null(Payload(todayResult, "proposeEhrenamtsbankAbschluss")["errors"]);
    }

    [Fact]
    public async Task NotizZuLang() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);
        var maxNoteLength = Options().MaxNoteLength;

        AssertMutationError(
            await ExecuteGraphqlAsync(
                Principal(owner.Id), ProposeMutation,
                ProposeInput(anfrage.Id, 60, Yesterday(), new string('a', maxNoteLength + 1))),
            "proposeEhrenamtsbankAbschluss", "AbschlussNoteTooLongError");

        var maxResult = await ExecuteGraphqlAsync(
            Principal(owner.Id), ProposeMutation,
            ProposeInput(anfrage.Id, 60, Yesterday(), new string('a', maxNoteLength)));
        Assert.Null(Payload(maxResult, "proposeEhrenamtsbankAbschluss")["errors"]);
    }
}
