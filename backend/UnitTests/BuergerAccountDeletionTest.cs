using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Ehrenamtsbank;
using API.Features.Prozess;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class BuergerAccountDeletionTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string DeleteMutation = """
        mutation Delete($input: DeleteEhrenamtsbankAccountInput!) {
            deleteEhrenamtsbankAccount(input: $input) {
                result { buergerId token }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    private const string LoginWeakMutation = """
        mutation Login($input: LoginBuergerWeakInput!) {
            loginBuergerWeak(input: $input) {
                loginPayload { result token }
            }
        }
    """;

    private async Task<(Dictionary<string, object?> Input, string DerivedPassword)> NewWeakLoginInput() {
        const string clientPassword = "TestDelete123!";
        const string email = "delete-account-test@example.com";
        var personalKeyPair = await crypto.GenerateKeyPair();
        var encryptedPersonalKey = await crypto.EncryptPersonalKey(clientPassword, email, personalKeyPair);
        var derivedPassword = crypto.GetServerLoginPassword(clientPassword, email);
        var input = new Dictionary<string, object?> {
            ["derivedPassword"] = derivedPassword,
            ["publicKey"] = await crypto.ExportPublicKey(personalKeyPair),
            ["encryptedPrivateKey"] = new EncryptedValue(
                encryptedPersonalKey.Encrypted.Nonce,
                encryptedPersonalKey.Encrypted.Tag,
                encryptedPersonalKey.Encrypted.Cipher),
            ["personalDataKeyForBuerger"] = "test-personal-data-key",
            ["salt"] = encryptedPersonalKey.Salt,
        };
        return (input, derivedPassword);
    }

    private static Dictionary<string, object?> DeleteInput(Dictionary<string, object?> weakLoginInput) =>
        new() { ["input"] = weakLoginInput };

    private static async Task<EhrenamtsbankAnfrage> SeedAnfrage(
        DomainContext db,
        Guid eintragId,
        Guid interessentId,
        EhrenamtsbankAnfrageStatus status,
        string? nachricht = null) {
        var now = Instant.FromUtc(2026, 1, 1, 0, 0);
        var anfrage = new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintragId,
            InteressentId = interessentId,
            Status = status,
            Nachricht = nachricht,
            CreatedAt = now,
            UpdatedAt = now,
            VereinbartAt = status == EhrenamtsbankAnfrageStatus.Vereinbart ? now : null,
        };
        db.EhrenamtsbankAnfragen.Add(anfrage);
        await db.SaveChangesAsync();
        return anfrage;
    }

    private static async Task<EhrenamtsbankTransaktion> SeedTransaktion(
        TestSeeder seeder,
        DomainContext db,
        Guid giverId,
        Guid receiverId,
        int minutes,
        string? note = null) {
        var eintrag = await seeder.CreateEintrag(db, receiverId, EhrenamtsbankEintragStatus.Completed);
        var now = Instant.FromUtc(2026, 1, 1, 0, 0);
        var anfrage = new EhrenamtsbankAnfrage {
            Id = Guid.NewGuid(),
            EintragId = eintrag.Id,
            InteressentId = giverId,
            Status = EhrenamtsbankAnfrageStatus.Erledigt,
            CreatedAt = now,
            UpdatedAt = now,
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
            Status = EhrenamtsbankTransaktionStatus.Confirmed,
            Note = note,
            CreatedAt = now,
            CreatedBy = EhrenamtsbankTransaktionCreatedBy.System,
        };
        db.EhrenamtsbankTransaktionen.Add(transaktion);
        await db.SaveChangesAsync();
        return transaktion;
    }

    [Fact]
    public async Task DeleteEhrenamtsbankAccount_ErsetztRegistriertenBuergerDurchNeueSchwacheIdentitaet() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var oldBuerger = await testSeeder.CreateBuerger(db, registered: true, phone: "+49170123456789");
        var eintrag = await testSeeder.CreateEintrag(db, oldBuerger.Id, EhrenamtsbankEintragStatus.Active);
        var other = await testSeeder.CreateBuerger(db, registered: true);
        var otherEintrag = await testSeeder.CreateEintrag(db, other.Id, EhrenamtsbankEintragStatus.Active);
        var openAnfrage = await SeedAnfrage(
            db, otherEintrag.Id, oldBuerger.Id, EhrenamtsbankAnfrageStatus.Offen, "Hallo");

        var (prozessVersionId, startSchritt, _) = await testSeeder.CreateMinimalProzess(db);
        var ausfuehrung = new Ausfuehrung {
            ProzessVersionId = prozessVersionId,
            UserId = oldBuerger.Id,
            CreatedAt = Instant.FromUtc(2022, 1, 1, 0, 0),
            Status = AusfuehrungStatus.Abgeschlossen,
            SharedKeyEncryptedForBuerger = "foo",
            SharedKeyEncryptedForKommune = "bar",
            SchrittId = startSchritt.Id
        };
        await db.Ausfuehrungen.AddAsync(ausfuehrung);
        await db.SaveChangesAsync();
        var ausfuehrungId = ausfuehrung.Id;

        var oldBuergerPassword = oldBuerger.Password;

        var (weakLoginInput, derivedPassword) = await NewWeakLoginInput();
        var deleteResult = await ExecuteGraphqlAsync(
            Principal(oldBuerger.Id), DeleteMutation, DeleteInput(weakLoginInput));
        var payload = Payload(deleteResult, "deleteEhrenamtsbankAccount");
        Assert.Null(payload["errors"]);
        var result = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(payload["result"]);
        var newBuergerId = Guid.Parse(result["buergerId"]!.ToString()!);
        var token = Assert.IsType<string>(result["token"]);
        Assert.NotEqual(oldBuerger.Id, newBuergerId);

        var handler = new JwtSecurityTokenHandler();
        var jwt = handler.ReadJwtToken(token);
        Assert.Equal(
            newBuergerId.ToString(),
            jwt.Claims.First(c => c.Type == ClaimTypes.NameIdentifier).Value);
        Assert.Equal("false", jwt.Claims.First(c => c.Type == "is_registered").Value);

        await db.Entry(oldBuerger).ReloadAsync();
        Assert.True(oldBuerger.IsDeleted);
        Assert.False(oldBuerger.IsRegistered);
        Assert.Null(oldBuerger.PhoneHash);
        Assert.Null(oldBuerger.Vorname);
        Assert.Null(oldBuerger.PublicKey);
        Assert.Null(oldBuerger.PersonalPrivateKey);
        Assert.Empty(oldBuerger.PersonalDataKeyEncryptedForBuerger);
        Assert.NotEqual(oldBuergerPassword, oldBuerger.Password);

        var reloadedEintrag = await db.EhrenamtsbankEintraege.AsNoTracking().SingleAsync(e => e.Id == eintrag.Id);
        Assert.True(reloadedEintrag.IsDeleted);

        await db.Entry(openAnfrage).ReloadAsync();
        Assert.Equal(EhrenamtsbankAnfrageStatus.Zurueckgezogen, openAnfrage.Status);
        Assert.Null(openAnfrage.Nachricht);

        var softDeletedAusfuehrung = await db.Ausfuehrungen.AsNoTracking().SingleAsync(a => a.Id == ausfuehrungId);
        Assert.NotNull(softDeletedAusfuehrung.GeloeschtAm);
        Assert.Equal(BuergerAccountDeletionService.AntragLoeschgrund, softDeletedAusfuehrung.Loeschgrund);

        var newBuergerAusfuehrungen = await db.Ausfuehrungen.AsNoTracking()
            .Where(a => a.UserId == newBuergerId)
            .ToListAsync();
        Assert.Empty(newBuergerAusfuehrungen);

        var loginResult = await ExecuteQuery(null, LoginWeakMutation, new Dictionary<string, object?> {
            ["buergerId"] = newBuergerId,
            ["password"] = derivedPassword,
        });
        Assert.Null(loginResult.Errors);
        var loginPayload = loginResult.Data!["loginBuergerWeak"] as IReadOnlyDictionary<string, object>;
        var loginData = loginPayload!["loginPayload"] as IReadOnlyDictionary<string, object>;
        Assert.Equal("SUCCESS", loginData!["result"]!.ToString());
    }

    [Fact]
    public async Task DeleteEhrenamtsbankAccount_BuergerPersonalData() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, registered: true);
        buerger.PersonalData.Add(new BuergerPersonalData { Key = "Key", Value = new EncryptedValue("nonce", "tag", "cipher") });
        await db.SaveChangesAsync();
        Assert.NotNull(buerger.PersonalData);
        var (weakLoginInput, derivedPassword) = await NewWeakLoginInput();
        var deleteResult = await ExecuteGraphqlAsync(
            Principal(buerger.Id), DeleteMutation, DeleteInput(weakLoginInput));

        Assert.False(await db.Set<BuergerPersonalData>().AnyAsync(p => p.BuergerId == buerger.Id));
    }

    [Fact]
    public async Task DeleteEhrenamtsbankAccount_BlockiertBeiNegativemZeitkontoSaldo() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var options = scope.ServiceProvider.GetRequiredService<IOptions<EhrenamtsbankZeitkontoOptions>>().Value;

        var buerger = await testSeeder.CreateBuerger(db, registered: true);
        var other = await testSeeder.CreateBuerger(db, registered: true);
        await SeedTransaktion(testSeeder, db, other.Id, buerger.Id, options.StartCreditMinutes + 30);

        var (weakLoginInput, _) = await NewWeakLoginInput();
        var deleteResult = await ExecuteGraphqlAsync(
            Principal(buerger.Id), DeleteMutation, DeleteInput(weakLoginInput));

        AssertMutationError(deleteResult, "deleteEhrenamtsbankAccount", "NegativeZeitkontoSaldoError");
        await db.Entry(buerger).ReloadAsync();
        Assert.False(buerger.IsDeleted);
    }

    [Fact]
    public async Task DeleteEhrenamtsbankAccount_BlockiertBeiVereinbarterAnfrageAlsInteressent() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, registered: true);
        var interessent = await testSeeder.CreateBuerger(db, registered: true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        await SeedAnfrage(db, eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Vereinbart);

        var (weakLoginInput, _) = await NewWeakLoginInput();
        var deleteResult = await ExecuteGraphqlAsync(
            Principal(interessent.Id), DeleteMutation, DeleteInput(weakLoginInput));

        AssertMutationError(deleteResult, "deleteEhrenamtsbankAccount", "VereinbarteAnfragenError");
    }

    [Fact]
    public async Task DeleteEhrenamtsbankAccount_BlockiertBeiVereinbarterAnfrageAlsOwner() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var owner = await testSeeder.CreateBuerger(db, registered: true);
        var interessent = await testSeeder.CreateBuerger(db, registered: true);
        var eintrag = await testSeeder.CreateEintrag(db, owner.Id, EhrenamtsbankEintragStatus.Assigned);
        await SeedAnfrage(db, eintrag.Id, interessent.Id, EhrenamtsbankAnfrageStatus.Vereinbart);

        var (weakLoginInput, _) = await NewWeakLoginInput();
        var deleteResult = await ExecuteGraphqlAsync(
            Principal(owner.Id), DeleteMutation, DeleteInput(weakLoginInput));

        AssertMutationError(deleteResult, "deleteEhrenamtsbankAccount", "VereinbarteAnfragenError");
    }

    [Fact]
    public async Task DeleteEhrenamtsbankAccount_BehältTransaktionenAufGeloeschtemBuerger() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, registered: true);
        var other = await testSeeder.CreateBuerger(db, registered: true);
        await SeedTransaktion(testSeeder, db, buerger.Id, other.Id, 45, "Notiz mit PII");

        var (weakLoginInput, _) = await NewWeakLoginInput();
        var deleteResult = await ExecuteGraphqlAsync(
            Principal(buerger.Id), DeleteMutation, DeleteInput(weakLoginInput));
        Assert.Null(Payload(deleteResult, "deleteEhrenamtsbankAccount")["errors"]);

        Assert.True(await db.EhrenamtsbankTransaktionen.AnyAsync(t => t.GiverId == buerger.Id));
        Assert.All(
            await db.EhrenamtsbankTransaktionen.Where(t => t.GiverId == buerger.Id).ToListAsync(),
            t => Assert.Null(t.Note));
    }

    [Fact]
    public async Task DeleteEhrenamtsbankAccount_TelefonnummerKannAufNeuemBuergerWiederverwendetWerden() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        const string phone = "+491709876543";

        var oldBuerger = await testSeeder.CreateBuerger(db, registered: true, phone: phone);
        var (weakLoginInput, _) = await NewWeakLoginInput();
        var deleteResult = await ExecuteGraphqlAsync(
            Principal(oldBuerger.Id), DeleteMutation, DeleteInput(weakLoginInput));
        var payload = Payload(deleteResult, "deleteEhrenamtsbankAccount");
        var newBuergerId = Guid.Parse(
            (Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(payload["result"]))["buergerId"]!.ToString()!);

        await db.Entry(oldBuerger).ReloadAsync();
        Assert.Null(oldBuerger.PhoneHash);

        var newBuerger = await db.Buerger.AsTracking().SingleAsync(b => b.Id == newBuergerId);
        newBuerger.Phone = phone;
        await db.SaveChangesAsync();

        var phoneHash = PhoneHashingService.ComputeHash(phone);
        Assert.Equal(phoneHash, newBuerger.PhoneHash);
        Assert.Single(await db.Buerger.Where(b => b.PhoneHash == phoneHash && !b.IsDeleted).ToListAsync());
    }

    [Fact]
    public async Task DeleteEhrenamtsbankAccount_OffeneAusfuehrungenCheck() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = await testSeeder.CreateBuerger(db, registered: true);
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (prozessVersionId, startSchritt, _) = await testSeeder.CreateMinimalProzess(db);
        var ausfuehrung = new Ausfuehrung {
            ProzessVersionId = prozessVersionId,
            UserId = buerger.Id,
            CreatedAt = Instant.FromUtc(2022, 1, 1, 0, 0),
            Status = AusfuehrungStatus.BearbeitungDurchKommune,
            SharedKeyEncryptedForBuerger = "foo",
            SharedKeyEncryptedForKommune = "bar",
            SchrittId = startSchritt.Id
        };
        await db.Ausfuehrungen.AddAsync(ausfuehrung);
        await db.SaveChangesAsync();
        var (weakLoginInput, _) = await NewWeakLoginInput();
        var deleteResult = await ExecuteGraphqlAsync(
            Principal(buerger.Id), DeleteMutation, DeleteInput(weakLoginInput));

        AssertMutationError(deleteResult, "deleteEhrenamtsbankAccount", "OffeneAusfuehrungenError");
    }
}
