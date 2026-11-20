using API.Features;
using API.Features.Auth;
using API.Features.Ehrenamtsbank;
using API.Options;
using API.Seeders;
using HotChocolate.Execution;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

public abstract class EhrenamtsbankEintragTestBase(BackendApiFactory factory) : GraphQLTests(factory) {
    protected async Task<Buerger> CreateBuerger(
        bool registered, bool clearance = false, string? phone = null, bool? phoneVerified = null) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var buerger = new Buerger {
            PersonalDataKeyEncryptedForBuerger = "test",
            IsRegistered = registered,
            RequiresClearanceVerified = clearance,
            Vorname = "Magdalena",
            Nachname = "Schmidt",
            Phone = phone,
            PhoneVerified = phoneVerified ?? phone != null,
        };
        db.Buerger.Add(buerger);
        await db.SaveChangesAsync();
        return buerger;
    }

    protected async Task<EhrenamtsbankKategorie> CreateKategorie(
        bool clearance = false, Guid? parentId = null, bool active = true) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var kategorie = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = $"Test {Guid.NewGuid():N}",
            Active = active,
            RequiresClearance = clearance,
            ParentId = parentId,
        };
        db.EhrenamtsbankKategorien.Add(kategorie);
        await db.SaveChangesAsync();
        return kategorie;
    }

    protected EhrenamtsbankOptions EhrenamtsbankOptions() =>
        Factory.Services.GetRequiredService<IOptions<EhrenamtsbankOptions>>().Value;

    protected async Task<Guid> EnsureGemeinde() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        return KommuneSeeder.AerzenOrganisationseinheitId;
    }

    protected async Task<EhrenamtsbankEintrag> CreateEintrag(
        Guid ownerId, EhrenamtsbankEintragStatus status,
        EhrenamtsbankEintragTyp typ = EhrenamtsbankEintragTyp.Gesuch,
        Guid? kategorieId = null, Guid? untereinheitId = null,
        string title = "Hecken schneiden", string description = "Werkzeug ist vorhanden.",
        bool isDeleted = false, Instant? createdAt = null) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        return await testSeeder.CreateEintrag(db, ownerId, status, typ, kategorieId, untereinheitId, title, description, isDeleted, createdAt);
    }

    protected const string CreateMutation = """
        mutation Create($input: CreateEhrenamtsbankEintragInput!) {
            createEhrenamtsbankEintrag(input: $input) {
                ehrenamtsbankEintrag { id status typ urgency estimatedDurationMinutes tags }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    protected Dictionary<string, object?> CreateInput(Guid kategorieId, Guid untereinheitId,
        string typ = "GESUCH", Dictionary<string, object?>? overrides = null) {
        var input = new Dictionary<string, object?> {
            ["typ"] = typ,
            ["title"] = "Hecken schneiden",
            ["description"] = "Werkzeug ist vorhanden.",
            ["kategorieId"] = kategorieId.ToString(),
            ["untereinheitId"] = untereinheitId.ToString(),
            ["radiusKm"] = 10,
            ["urgency"] = typ == "GESUCH" ? "MITTEL" : null,
            ["estimatedDurationMinutes"] = typ == "GESUCH" ? 90 : null,
            ["availability"] = typ == "ANGEBOT" ? "Wochentags flexibel" : null,
            ["imageKey"] = null,
            ["tags"] = new[] { "Werkzeug vorhanden" },
        };
        foreach (var (key, value) in overrides ?? []) {
            input[key] = value;
        }

        return input;
    }

    protected static void AssertMutationError(IQueryResult result, string field, string expectedErrorTypename) {
        var payload = Payload(result, field);
        var errors = Assert.IsAssignableFrom<IReadOnlyList<object?>>(payload["errors"]);
        var first = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(Assert.Single(errors));
        Assert.Equal(expectedErrorTypename, first["__typename"]);
    }

    protected static Dictionary<string, object?> LocationInput(
        string address = "Musterstraße 12", double latitude = 52.1039, double longitude = 9.3564) =>
        new() { ["address"] = address, ["latitude"] = latitude, ["longitude"] = longitude };

    protected const string UpdateMutation = """
        mutation Update($input: UpdateEhrenamtsbankEintragInput!) {
            updateEhrenamtsbankEintrag(input: $input) {
                ehrenamtsbankEintrag { id status title }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    protected Dictionary<string, object?> UpdateInput(
        EhrenamtsbankEintrag eintrag, string title, string? description = null,
        Dictionary<string, object?>? overrides = null) {
        var input = new Dictionary<string, object?> {
            ["id"] = eintrag.Id.ToString(),
            ["title"] = title,
            ["description"] = description ?? eintrag.Description,
            ["kategorieId"] = eintrag.KategorieId.ToString(),
            ["untereinheitId"] = eintrag.UntereinheitId.ToString(),
            ["radiusKm"] = eintrag.RadiusKm,
            ["urgency"] = eintrag.Urgency switch {
                EhrenamtsbankDringlichkeit.Niedrig => "NIEDRIG",
                EhrenamtsbankDringlichkeit.Mittel => "MITTEL",
                EhrenamtsbankDringlichkeit.Hoch => "HOCH",
                null => null,
            },
            ["estimatedDurationMinutes"] = eintrag.EstimatedDurationMinutes,
            ["availability"] = eintrag.Availability,
            ["imageKey"] = eintrag.ImageKey,
            ["tags"] = eintrag.Tags.ToArray(),
        };
        foreach (var (key, value) in overrides ?? []) {
            input[key] = value;
        }

        return input;
    }

    protected async Task PersistLocation(
        Guid eintragId, string address = "Bahnhofstraße 3", double latitude = 52.1039,
        double longitude = 9.3564) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var row = await db.EhrenamtsbankEintraege.AsTracking().FirstAsync(e => e.Id == eintragId);
        row.Address = address;
        row.Latitude = latitude;
        row.Longitude = longitude;
        await db.SaveChangesAsync();
    }

    protected async Task<EhrenamtsbankEintrag> ReadEintrag(Guid eintragId) {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        return await db.EhrenamtsbankEintraege.FirstAsync(e => e.Id == eintragId);
    }

    protected static void AssertLocation(
        EhrenamtsbankEintrag row, string? address, double? latitude, double? longitude) {
        Assert.Equal(address, row.Address);
        Assert.Equal(latitude, row.Latitude);
        Assert.Equal(longitude, row.Longitude);
    }

    protected const string UpdateStatusMutation = """
        mutation UpdateStatus($input: UpdateEhrenamtsbankEintragStatusInput!) {
            updateEhrenamtsbankEintragStatus(input: $input) {
                ehrenamtsbankEintrag { id status reviewedAt }
                errors { __typename ... on Error { message } }
            }
        }
    """;

    protected static Dictionary<string, object?> StatusInput(Guid id, string status) =>
        new() { ["input"] = new Dictionary<string, object?> { ["id"] = id.ToString(), ["status"] = status } };
}
