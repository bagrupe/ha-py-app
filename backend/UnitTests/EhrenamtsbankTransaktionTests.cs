using API.Features;
using API.Features.Auth;
using API.Features.Ehrenamtsbank;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using NodaTime.Text;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankTransaktionTests(BackendApiFactory factory) : GraphQLTests(factory) {
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
                ehrenamtsbankAnfrage {
                    id
                    status
                    transaktion {
                        id
                        anfrageId
                        eintragId
                        giverId
                        receiverId
                        minutes
                        performedOn
                        status
                        note
                        createdBy
                    }
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

    private static Dictionary<string, object?> ConfirmInput(Guid anfrageId) =>
        new() {
            ["input"] = new Dictionary<string, object?> { ["anfrageId"] = anfrageId.ToString() }
        };

    private static string Yesterday() => LocalDatePattern.Iso.Format(API.Utils.DateTime.Today().PlusDays(-1));

    private static async Task<EhrenamtsbankAnfrage> SeedAnfrage(
        DomainContext db, Guid eintragId, Guid interessentId,
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

    private async Task<(Buerger Owner, Buerger Interessent, EhrenamtsbankEintrag Eintrag, EhrenamtsbankAnfrage Anfrage)>
        SeedVereinbarteAnfrage(DomainContext db, EhrenamtsbankEintragTyp typ = EhrenamtsbankEintragTyp.Gesuch) {
        var owner = await testSeeder.CreateBuerger(db, true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned, typ);
        var interessent = await testSeeder.CreateBuerger(db, true);
        var anfrage = await SeedAnfrage(db, eintrag.Id, interessent.Id);
        return (owner, interessent, eintrag, anfrage);
    }

    private async Task Propose(Guid buergerId, Guid anfrageId, int minutes, string date, string? note = null) {
        var result = await ExecuteGraphqlAsync(
            Principal(buergerId), ProposeMutation, ProposeInput(anfrageId, minutes, date, note));
        Assert.Null(Payload(result, "proposeEhrenamtsbankAbschluss")["errors"]);
    }

    [Fact]
    public async Task Bestaetigung_BuchtTransaktion() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (owner, interessent, eintrag, anfrage) = await SeedVereinbarteAnfrage(db);
        var date = Yesterday();
        await Propose(owner.Id, anfrage.Id, 90, date, "Hecke geschnitten");

        var result = await ExecuteGraphqlAsync(
            Principal(interessent.Id), ConfirmMutation, ConfirmInput(anfrage.Id));

        var payload = Payload(result, "confirmEhrenamtsbankAbschluss");
        Assert.Null(payload["errors"]);
        var updated = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankAnfrage"]);
        Assert.Equal("ERLEDIGT", updated["status"]!.ToString());

        var transaktion = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            updated["transaktion"]);
        Assert.Equal(anfrage.Id.ToString(), transaktion["anfrageId"]!.ToString());
        Assert.Equal(eintrag.Id.ToString(), transaktion["eintragId"]!.ToString());
        Assert.Equal(interessent.Id.ToString(), transaktion["giverId"]!.ToString());
        Assert.Equal(owner.Id.ToString(), transaktion["receiverId"]!.ToString());
        Assert.Equal(90, transaktion["minutes"]);
        Assert.Equal(date, transaktion["performedOn"]!.ToString());
        Assert.Equal("CONFIRMED", transaktion["status"]!.ToString());
        Assert.Equal("Hecke geschnitten", transaktion["note"]);
        Assert.Equal("SYSTEM", transaktion["createdBy"]!.ToString());

        await db.Entry(anfrage).ReloadAsync();
        Assert.Equal(EhrenamtsbankAnfrageStatus.Erledigt, anfrage.Status);
        await db.Entry(eintrag).ReloadAsync();
        Assert.Equal(EhrenamtsbankEintragStatus.Completed, eintrag.Status);

        var row = await db.EhrenamtsbankTransaktionen.SingleAsync(t => t.AnfrageId == anfrage.Id);
        Assert.Equal(90, row.Minutes);
        Assert.Equal(LocalDatePattern.Iso.Parse(date).Value, row.PerformedOn);
        Assert.Equal(EhrenamtsbankTransaktionCreatedBy.System, row.CreatedBy);
    }

    [Fact]
    public async Task Angebot_DrehtGiverUndReceiver() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (owner, interessent, _, anfrage) =
            await SeedVereinbarteAnfrage(db, EhrenamtsbankEintragTyp.Angebot);
        await Propose(interessent.Id, anfrage.Id, 60, Yesterday());

        var result = await ExecuteGraphqlAsync(
            Principal(owner.Id), ConfirmMutation, ConfirmInput(anfrage.Id));
        Assert.Null(Payload(result, "confirmEhrenamtsbankAbschluss")["errors"]);

        var row = await db.EhrenamtsbankTransaktionen.SingleAsync(t => t.AnfrageId == anfrage.Id);
        Assert.Equal(owner.Id, row.GiverId);
        Assert.Equal(interessent.Id, row.ReceiverId);
    }

    [Fact]
    public async Task Vorschlagender_DarfNichtSelbstBestaetigen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (owner, _, _, anfrage) = await SeedVereinbarteAnfrage(db);
        await Propose(owner.Id, anfrage.Id, 90, Yesterday());

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), ConfirmMutation, ConfirmInput(anfrage.Id)),
            "confirmEhrenamtsbankAbschluss", "AbschlussSelfConfirmError");
        Assert.False(await db.EhrenamtsbankTransaktionen.AnyAsync(t => t.AnfrageId == anfrage.Id));
    }

    [Fact]
    public async Task OhneVorschlag_KeineBestaetigung() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (owner, _, _, anfrage) = await SeedVereinbarteAnfrage(db);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(owner.Id), ConfirmMutation, ConfirmInput(anfrage.Id)),
            "confirmEhrenamtsbankAbschluss", "AbschlussNoProposalError");
    }

    [Fact]
    public async Task ZweiteBestaetigung_BuchtNichtErneut() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (owner, interessent, _, anfrage) = await SeedVereinbarteAnfrage(db);
        await Propose(owner.Id, anfrage.Id, 90, Yesterday());

        var first = await ExecuteGraphqlAsync(
            Principal(interessent.Id), ConfirmMutation, ConfirmInput(anfrage.Id));
        Assert.Null(Payload(first, "confirmEhrenamtsbankAbschluss")["errors"]);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(interessent.Id), ConfirmMutation, ConfirmInput(anfrage.Id)),
            "confirmEhrenamtsbankAbschluss", "AbschlussNotVereinbartError");
        Assert.Equal(1, await db.EhrenamtsbankTransaktionen.CountAsync(t => t.AnfrageId == anfrage.Id));
    }

    [Fact]
    public async Task GleichzeitigeBestaetigung_BuchtNurEinmal() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (owner, interessent, eintrag, anfrage) = await SeedVereinbarteAnfrage(db);
        await Propose(owner.Id, anfrage.Id, 90, Yesterday());

        db.EhrenamtsbankTransaktionen.Add(new EhrenamtsbankTransaktion {
            Id = Guid.NewGuid(),
            AnfrageId = anfrage.Id,
            EintragId = eintrag.Id,
            GiverId = interessent.Id,
            ReceiverId = owner.Id,
            Minutes = 90,
            PerformedOn = API.Utils.DateTime.Today().PlusDays(-1),
            Status = EhrenamtsbankTransaktionStatus.Confirmed,
            CreatedAt = SystemClock.Instance.GetCurrentInstant(),
            CreatedBy = EhrenamtsbankTransaktionCreatedBy.System
        });
        await db.SaveChangesAsync();

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(interessent.Id), ConfirmMutation, ConfirmInput(anfrage.Id)),
            "confirmEhrenamtsbankAbschluss", "AbschlussAlreadyBookedError");
        Assert.Equal(1, await db.EhrenamtsbankTransaktionen.CountAsync(t => t.AnfrageId == anfrage.Id));
    }

    [Fact]
    public async Task Fremder_DarfNichtBestaetigen() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (owner, _, _, anfrage) = await SeedVereinbarteAnfrage(db);
        await Propose(owner.Id, anfrage.Id, 90, Yesterday());
        var stranger = await testSeeder.CreateBuerger(db, true);

        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(stranger.Id), ConfirmMutation, ConfirmInput(anfrage.Id)),
            "confirmEhrenamtsbankAbschluss", "NotAllowedError");

        var unregistered = await testSeeder.CreateBuerger(db, false);
        AssertMutationError(
            await ExecuteGraphqlAsync(Principal(unregistered.Id), ConfirmMutation, ConfirmInput(anfrage.Id)),
            "confirmEhrenamtsbankAbschluss", "NotAllowedError");
        Assert.False(await db.EhrenamtsbankTransaktionen.AnyAsync(t => t.AnfrageId == anfrage.Id));
    }
}
