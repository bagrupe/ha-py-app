using System.Security.Claims;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.BundId;
using API.Features.Auth.Mutations;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class UpdateMyProfileMutationTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string Query = """
        mutation UpdateMyProfile($input: UpdateMyProfileInput!) {
            updateMyProfile(input: $input) {
                boolean
            }
        }
        """;

    private async Task<(Buerger Entity, ClaimsPrincipal Principal)> CreateBuergerPrincipalAsync(
        DomainContext db, IServiceProvider services, bool linkBundId, bool isRegistered = true) {
        var buerger = new Buerger {
            PersonalDataKeyEncryptedForBuerger = "foo",
            IsRegistered = isRegistered,
        };
        await db.Users.AddAsync(buerger);
        await db.SaveChangesAsync();

        if (linkBundId) {
            db.ExternalIdentities.Add(new ExternalIdentity {
                Id = Guid.NewGuid(),
                BuergerId = buerger.Id,
                Provider = "bundid",
                Issuer = "https://test-issuer",
                SubjectHash = Guid.NewGuid().ToString(),
                LinkedAt = Instant.FromUtc(2026, 1, 1, 0, 0, 0),
                LastAuthenticatedAt = Instant.FromUtc(2026, 1, 1, 0, 0, 0),
            });
            await db.SaveChangesAsync();
        }

        var jwtOptions = services.GetRequiredService<IOptions<JWTOptions>>().Value;
        var jwtToken = buerger.GetToken(jwtOptions);
        var identity = new ClaimsIdentity(jwtToken.Claims, "jwt");
        return (buerger, new ClaimsPrincipal(identity));
    }

    [Fact]
    public async Task UpdateMyProfile_AllowsEditing_ForBuergerWithoutBundId() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, principal) = await CreateBuergerPrincipalAsync(db, scope.ServiceProvider, linkBundId: false);

        var result = await ExecuteQuery(principal, Query, new Dictionary<string, object?> {
            { "vorname", "Neuer Vorname" },
        });

        Assert.Null(result.Errors);

        var updated = await db.Buerger.AsNoTracking().FirstAsync(b => b.Id == buerger.Id);
        Assert.Equal("Neuer Vorname", updated.Vorname);
    }

    [Fact]
    public async Task My_ReturnsOwnProfileFields_ForBuergerHimself() {
        // Regression coverage für die GraphQLIgnore/Self-Check-Härtung der Profilfelder: der
        // Bürger selbst muss sie über `my` weiterhin lesen können (siehe
        // BuergerQueryExtensions.Vorname etc.). Ein reiner DB-Assert (wie in den anderen Tests
        // dieser Datei) würde diesen Lesepfad gar nicht prüfen, da er GraphQL umgeht.
        const string myQuery = """
            query {
                my {
                    ... on Buerger {
                        vorname
                        nachname
                        emailAddress
                        street
                        postalCode
                        city
                        country
                        phoneVerified
                        hasBundId
                    }
                }
            }
            """;

        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (_, principal) = await CreateBuergerPrincipalAsync(db, scope.ServiceProvider, linkBundId: false);

        var updateResult = await ExecuteQuery(principal, Query, new Dictionary<string, object?> {
            { "vorname", "Anna" },
            { "nachname", "Schmidt" },
            { "email", "anna@example.com" },
            { "street", "Musterstr. 1" },
            { "postalCode", "12345" },
            { "city", "Musterstadt" },
            { "country", "DE" },
        });
        Assert.Null(updateResult.Errors);

        var readResult = await ExecuteQuery(principal, myQuery, new Dictionary<string, object?>());

        Assert.Null(readResult.Errors);
        var my = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(readResult.Data!["my"]);
        Assert.Equal("Anna", my["vorname"]);
        Assert.Equal("Schmidt", my["nachname"]);
        Assert.Equal("anna@example.com", my["emailAddress"]);
        Assert.Equal("Musterstr. 1", my["street"]);
        Assert.Equal("12345", my["postalCode"]);
        Assert.Equal("Musterstadt", my["city"]);
        Assert.Equal("DE", my["country"]);
        Assert.Equal(false, my["phoneVerified"]);
        Assert.Equal(false, my["hasBundId"]);
    }

    [Fact]
    public async Task UpdateMyProfile_ThrowsForBuergerWithBundId() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, principal) = await CreateBuergerPrincipalAsync(db, scope.ServiceProvider, linkBundId: true);

        var result = await ExecuteQuery(principal, Query, new Dictionary<string, object?> {
            { "vorname", "Sollte Nicht Ankommen" },
        });

        Assert.NotNull(result.Errors);
        var error = Assert.Single(result.Errors);
        Assert.Equal("PROFILE_MANAGED_BY_BUND_ID", error.Code);

        var updated = await db.Buerger.AsNoTracking().FirstAsync(b => b.Id == buerger.Id);
        Assert.Null(updated.Vorname);
    }

    [Fact]
    public async Task UpdateMyProfile_ThrowsForUnregisteredBuerger() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (buerger, principal) = await CreateBuergerPrincipalAsync(
            db, scope.ServiceProvider, linkBundId: false, isRegistered: false);

        var result = await ExecuteQuery(principal, Query, new Dictionary<string, object?> {
            { "vorname", "Sollte Nicht Ankommen" },
        });

        Assert.NotNull(result.Errors);
        var error = Assert.Single(result.Errors);
        Assert.Equal("PROFILE_REQUIRES_REGISTRATION", error.Code);

        var updated = await db.Buerger.AsNoTracking().FirstAsync(b => b.Id == buerger.Id);
        Assert.Null(updated.Vorname);
    }

    [Fact]
    public async Task UpdateMyProfile_AllowsNoOpCall_EvenForUnregisteredBuerger() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (_, principal) = await CreateBuergerPrincipalAsync(
            db, scope.ServiceProvider, linkBundId: false, isRegistered: false);

        // Wie beim BundID-Lock: ein Aufruf ohne geänderte Felder darf nicht am
        // Registrierungs-Check scheitern, nur ein echter Änderungsversuch.
        var result = await ExecuteQuery(principal, Query, new Dictionary<string, object?>());

        Assert.Null(result.Errors);
    }

    [Fact]
    public async Task UpdateMyProfile_AllowsUnrelatedFields_EvenForBuergerWithBundId() {
        using var scope = Factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var (_, principal) = await CreateBuergerPrincipalAsync(db, scope.ServiceProvider, linkBundId: true);

        // A request with no changed fields at all must not trip the BundID lock (only a genuine
        // attempt to change a protected field should).
        var result = await ExecuteQuery(principal, Query, new Dictionary<string, object?>());

        Assert.Null(result.Errors);
    }
}
