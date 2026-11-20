using System.Security.Claims;
using API.Features;
using API.Features.Auth;
using API.Features.Ehrenamtsbank;
using API.Features.Ehrenamtsbank.Queries;
using API.Features.Untereinheit;
using API.Options;
using API.Seeders;
using HotChocolate;
using HotChocolate.Execution;
using HotChocolate.Types;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EhrenamtsbankEintragTests(BackendApiFactory factory) : EhrenamtsbankEintragTestBase(factory) {
    private readonly BackendApiFactory _factory = factory;

    // ---------- helpers ----------

    // private static ClaimsPrincipal Principal(Guid userId) =>
    //     new(new ClaimsIdentity([new Claim(ClaimTypes.NameIdentifier, userId.ToString())], "TestAuthType"));

    // /// <summary>Authentifizierungsloser Aufrufer. Ein leerer Principal (statt null) stellt sicher,
    // /// dass der geteilte HttpContext nicht den Nutzer des vorherigen Tests behält.</summary>
    // private static ClaimsPrincipal Anonymous() => new(new ClaimsIdentity());

    private async Task<Guid> CreateNonGemeindeUntereinheit() {
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var einheit = new Untereinheit {
            Id = Guid.NewGuid(),
            Name = "Fachbereich (kein Ort)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = false,
        };
        db.Untereinheit.Add(einheit);
        await db.SaveChangesAsync();
        return einheit.Id;
    }

    private const string EntriesQuery = """
        query Entries($filter: EhrenamtsbankEintragFilterInput) {
            ehrenamtsbankEintraege(filter: $filter, skip: 0, take: 50) {
                totalCount
                items {
                    id typ status title
                    owner { vorname nachname phone phoneVerified clearanceVerified }
                }
            }
        }
    """;

    private static IReadOnlyList<IReadOnlyDictionary<string, object?>> Items(IQueryResult result, string field) {
        var data = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(result.Data);
        var page = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(data[field]);
        var items = Assert.IsAssignableFrom<IReadOnlyList<object?>>(page["items"]);
        return items.Select(i => Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(i)).ToList();
    }

    private static HashSet<Guid> ItemIds(IQueryResult result, string field) =>
        Items(result, field).Select(i => Guid.Parse(i["id"]!.ToString()!)).ToHashSet();

    // ---------- queries ----------

    [Fact]
    public async Task Entries_ReturnsOnlyActiveNonDeleted() {
        var owner = await CreateBuerger(registered: true);
        var active = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var draft = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        var pending = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.PendingReview);
        var deleted = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active, isDeleted: true);

        var result = await ExecuteGraphqlAsync(Anonymous(), EntriesQuery);

        Assert.Null(result.Errors);
        var ids = ItemIds(result, "ehrenamtsbankEintraege");
        Assert.Contains(active.Id, ids);
        Assert.DoesNotContain(draft.Id, ids);
        Assert.DoesNotContain(pending.Id, ids);
        Assert.DoesNotContain(deleted.Id, ids);
    }

    [Fact]
    public async Task Entries_SortedByCreatedAtDescending() {
        var owner = await CreateBuerger(registered: true);
        var now = SystemClock.Instance.GetCurrentInstant();
        var older = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active,
            title: "Alt", createdAt: now.Minus(Duration.FromHours(2)));
        var newer = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active,
            title: "Neu", createdAt: now.Minus(Duration.FromMinutes(1)));

        var result = await ExecuteGraphqlAsync(Anonymous(), EntriesQuery);

        Assert.Null(result.Errors);
        var orderedIds = Items(result, "ehrenamtsbankEintraege")
            .Select(i => Guid.Parse(i["id"]!.ToString()!)).ToList();
        Assert.True(orderedIds.IndexOf(newer.Id) < orderedIds.IndexOf(older.Id));
    }

    [Fact]
    public async Task Entries_FiltersCompose() {
        var owner = await CreateBuerger(registered: true);
        var kategorieA = await CreateKategorie();
        var kategorieB = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();
        var match = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active,
            typ: EhrenamtsbankEintragTyp.Gesuch, kategorieId: kategorieA.Id,
            untereinheitId: gemeinde, title: "Rasen mähen im Vorgarten");
        var wrongTyp = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active,
            typ: EhrenamtsbankEintragTyp.Angebot, kategorieId: kategorieA.Id,
            untereinheitId: gemeinde, title: "Rasen mähen als Angebot");
        var wrongKategorie = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active,
            typ: EhrenamtsbankEintragTyp.Gesuch, kategorieId: kategorieB.Id,
            untereinheitId: gemeinde, title: "Rasen mähen woanders");
        var wrongText = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active,
            typ: EhrenamtsbankEintragTyp.Gesuch, kategorieId: kategorieA.Id,
            untereinheitId: gemeinde, title: "Einkaufshilfe", description: "Supermarkt");

        var result = await ExecuteGraphqlAsync(Anonymous(), EntriesQuery, new Dictionary<string, object?> {
            ["filter"] = new Dictionary<string, object?> {
                ["typ"] = "GESUCH",
                ["kategorieIds"] = new[] { kategorieA.Id.ToString() },
                ["untereinheitIds"] = new[] { gemeinde.ToString() },
                ["searchText"] = "rasen",
            }
        });

        Assert.Null(result.Errors);
        var ids = ItemIds(result, "ehrenamtsbankEintraege");
        Assert.Contains(match.Id, ids);
        Assert.DoesNotContain(wrongTyp.Id, ids);
        Assert.DoesNotContain(wrongKategorie.Id, ids);
        Assert.DoesNotContain(wrongText.Id, ids);
    }

    [Fact]
    public async Task Entries_StatusFilterRequiresPermission() {
        var owner = await CreateBuerger(registered: true);
        var pending = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.PendingReview);
        var statusFilter = new Dictionary<string, object?> {
            ["filter"] = new Dictionary<string, object?> { ["status"] = "PENDING_REVIEW" }
        };

        var anonymous = await ExecuteGraphqlAsync(Anonymous(), EntriesQuery, statusFilter);
        Assert.NotNull(anonymous.Errors);

        var asBuerger = await ExecuteGraphqlAsync(Principal(owner.Id), EntriesQuery, statusFilter);
        Assert.NotNull(asBuerger.Errors);

        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var asModerator = await ExecuteGraphqlAsync(superadmin, EntriesQuery, statusFilter);
        Assert.Null(asModerator.Errors);
        Assert.Contains(pending.Id, ItemIds(asModerator, "ehrenamtsbankEintraege"));
    }

    [Fact]
    public async Task MyEntries_ReturnsAllOwnStatuses() {
        var owner = await CreateBuerger(registered: true);
        var other = await CreateBuerger(registered: true);
        var ownDraft = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        var ownClosed = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Closed);
        var ownDeleted = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active, isDeleted: true);
        var foreign = await CreateEintrag(other.Id, EhrenamtsbankEintragStatus.Active);

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), """
            query { meineEhrenamtsbankEintraege(skip: 0, take: 50) { totalCount items { id status } } }
        """);

        Assert.Null(result.Errors);
        var ids = ItemIds(result, "meineEhrenamtsbankEintraege");
        Assert.Contains(ownDraft.Id, ids);
        Assert.Contains(ownClosed.Id, ids);
        Assert.DoesNotContain(ownDeleted.Id, ids);
        Assert.DoesNotContain(foreign.Id, ids);
    }

    private const string EntryQuery = """
        query Entry($id: UUID!) {
            ehrenamtsbankEintrag(id: $id) {
                id status title urgency estimatedDurationMinutes availability tags
                owner { vorname nachname phone phoneVerified clearanceVerified }
            }
        }
    """;

    [Fact]
    public async Task Entry_VisibilityRules() {
        var owner = await CreateBuerger(registered: true);
        var stranger = await CreateBuerger(registered: true);
        var active = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var draft = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);

        var anonActive = await ExecuteGraphqlAsync(Anonymous(), EntryQuery,
            new Dictionary<string, object?> { ["id"] = active.Id.ToString() });
        Assert.Null(anonActive.Errors);

        var ownDraft = await ExecuteGraphqlAsync(Principal(owner.Id), EntryQuery,
            new Dictionary<string, object?> { ["id"] = draft.Id.ToString() });
        Assert.Null(ownDraft.Errors);

        var foreignDraft = await ExecuteGraphqlAsync(Principal(stranger.Id), EntryQuery,
            new Dictionary<string, object?> { ["id"] = draft.Id.ToString() });
        Assert.NotNull(foreignDraft.Errors);

        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var moderatorDraft = await ExecuteGraphqlAsync(superadmin, EntryQuery,
            new Dictionary<string, object?> { ["id"] = draft.Id.ToString() });
        Assert.Null(moderatorDraft.Errors);
    }

    [Fact]
    public async Task Owner_PhoneGating() {
        var owner = await CreateBuerger(registered: true, phone: "+491701234567");
        var registered = await CreateBuerger(registered: true);
        var unregistered = await CreateBuerger(registered: false);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var variables = new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() };

        var anonymous = await ExecuteGraphqlAsync(Anonymous(), EntryQuery, variables);
        Assert.Null(anonymous.Errors);
        var anonData = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(anonymous.Data);
        var anonEntry = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(anonData["ehrenamtsbankEintrag"]);
        var anonOwner = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(anonEntry["owner"]);
        Assert.Equal("Magdalena", anonOwner["vorname"]);
        Assert.Equal("Schmidt", anonOwner["nachname"]);
        Assert.Equal(true, anonOwner["phoneVerified"]);
        Assert.Null(anonOwner["phone"]);

        var asUnregistered = await ExecuteGraphqlAsync(Principal(unregistered.Id), EntryQuery, variables);
        var unregOwner = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
                Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(asUnregistered.Data!)
                    ["ehrenamtsbankEintrag"])["owner"]);
        Assert.Null(unregOwner["phone"]);

        var asRegistered = await ExecuteGraphqlAsync(Principal(registered.Id), EntryQuery, variables);
        var regOwner = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
                Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(asRegistered.Data!)
                    ["ehrenamtsbankEintrag"])["owner"]);
        Assert.Equal("+491701234567", regOwner["phone"]);
    }

    [Fact]
    public async Task Owner_PhoneHiddenWhenUnverified() {
        var owner = await CreateBuerger(registered: true, phone: "+491700000000", phoneVerified: false);
        var registered = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var variables = new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() };

        var asRegistered = await ExecuteGraphqlAsync(Principal(registered.Id), EntryQuery, variables);
        var regOwner = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
                Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(asRegistered.Data!)
                    ["ehrenamtsbankEintrag"])["owner"]);
        Assert.Equal(false, regOwner["phoneVerified"]);
        Assert.Null(regOwner["phone"]);
    }

    // ---------- mutations ----------

    private static void AssertAuthenticationError(IQueryResult result) {
        var error = Assert.Single(result.Errors!);
        Assert.Equal("AUTH_NOT_AUTHORIZED", error.Code);
    }

    [Fact]
    public async Task Create_RequiresRegistered() {
        var unregistered = await CreateBuerger(registered: false);
        var registered = await CreateBuerger(registered: true);
        var kategorie = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();

        var denied = await ExecuteGraphqlAsync(Principal(unregistered.Id), CreateMutation,
            new Dictionary<string, object?> { ["input"] = CreateInput(kategorie.Id, gemeinde) });
        AssertMutationError(denied, "createEhrenamtsbankEintrag", "NotAllowedError");

        Assert.True(EhrenamtsbankOptions().EintragSkipReview,
            "Ehrenamtsbank:EintragSkipReview must be enabled in appsettings for this test.");
        var created = await ExecuteGraphqlAsync(Principal(registered.Id), CreateMutation,
            new Dictionary<string, object?> { ["input"] = CreateInput(kategorie.Id, gemeinde) });
        var payload = Payload(created, "createEhrenamtsbankEintrag");
        var eintrag = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(payload["ehrenamtsbankEintrag"]);
        Assert.Equal("ACTIVE", eintrag["status"]!.ToString());
        Assert.Equal("GESUCH", eintrag["typ"]!.ToString());
    }

    [Fact]
    public async Task Create_ClearanceGate() {
        var withoutClearance = await CreateBuerger(registered: true, clearance: false);
        var withClearance = await CreateBuerger(registered: true, clearance: true);
        var protectedRoot = await CreateKategorie(clearance: true);
        var protectedChild = await CreateKategorie(clearance: false, parentId: protectedRoot.Id);
        var gemeinde = await EnsureGemeinde();
        var angebotInput = new Dictionary<string, object?> {
            ["input"] = CreateInput(protectedChild.Id, gemeinde, typ: "ANGEBOT")
        };

        var denied = await ExecuteGraphqlAsync(Principal(withoutClearance.Id), CreateMutation, angebotInput);
        AssertMutationError(denied, "createEhrenamtsbankEintrag", "NotAllowedError");

        var allowed = await ExecuteGraphqlAsync(Principal(withClearance.Id), CreateMutation, angebotInput);
        var payload = Payload(allowed, "createEhrenamtsbankEintrag");
        Assert.NotNull(payload["ehrenamtsbankEintrag"]);

        // Gate gilt nur für Angebote: Gesuch in derselben Kategorie ohne Clearance ist erlaubt.
        var gesuch = await ExecuteGraphqlAsync(Principal(withoutClearance.Id), CreateMutation,
            new Dictionary<string, object?> { ["input"] = CreateInput(protectedChild.Id, gemeinde) });
        var gesuchPayload = Payload(gesuch, "createEhrenamtsbankEintrag");
        Assert.NotNull(gesuchPayload["ehrenamtsbankEintrag"]);
    }

    [Fact]
    public async Task Create_ValidationErrors() {
        var buerger = await CreateBuerger(registered: true);
        var kategorie = await CreateKategorie();
        var inactiveKategorie = await CreateKategorie(active: false);
        var gemeinde = await EnsureGemeinde();
        var nonGemeinde = await CreateNonGemeindeUntereinheit();

        // Typ-Exklusivität: Angebot mit Gesuch-Feld.
        var mixed = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
            new Dictionary<string, object?> {
                ["input"] = CreateInput(kategorie.Id, gemeinde, typ: "ANGEBOT",
                    overrides: new Dictionary<string, object?> { ["urgency"] = "HOCH" })
            });
        AssertMutationError(mixed, "createEhrenamtsbankEintrag", "EintragValidationError");

        // Untereinheit ist keine Gemeinde.
        var wrongOrt = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
            new Dictionary<string, object?> { ["input"] = CreateInput(kategorie.Id, nonGemeinde) });
        AssertMutationError(wrongOrt, "createEhrenamtsbankEintrag", "EintragValidationError");

        // Inaktive Kategorie.
        var inactive = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
            new Dictionary<string, object?> { ["input"] = CreateInput(inactiveKategorie.Id, gemeinde) });
        AssertMutationError(inactive, "createEhrenamtsbankEintrag", "EintragValidationError");

        // Titel über 150 Zeichen.
        var longTitle = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
            new Dictionary<string, object?> {
                ["input"] = CreateInput(kategorie.Id, gemeinde,
                    overrides: new Dictionary<string, object?> { ["title"] = new string('x', 151) })
            });
        AssertMutationError(longTitle, "createEhrenamtsbankEintrag", "EintragValidationError");

        // Beschreibung ist Pflicht — leer und reiner Whitespace sind beide ungültig.
        foreach (var leer in new[] { "", "   " }) {
            var emptyDescription = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
                new Dictionary<string, object?> {
                    ["input"] = CreateInput(kategorie.Id, gemeinde,
                        overrides: new Dictionary<string, object?> { ["description"] = leer })
                });
            AssertMutationError(emptyDescription, "createEhrenamtsbankEintrag", "EintragValidationError");
        }
    }

    private static Guid CreatedEntryId(IQueryResult result) {
        var payload = Payload(result, "createEhrenamtsbankEintrag");
        Assert.Null(payload["errors"]);
        var eintrag = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(payload["ehrenamtsbankEintrag"]);
        return Guid.Parse(eintrag["id"]!.ToString()!);
    }

    [Fact]
    public async Task Create_WithoutLocation_PersistsNoPrivateLocation() {
        var buerger = await CreateBuerger(registered: true);
        var kategorie = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();

        var created = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
            new Dictionary<string, object?> { ["input"] = CreateInput(kategorie.Id, gemeinde) });

        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var row = await db.EhrenamtsbankEintraege.FirstAsync(e => e.Id == CreatedEntryId(created));
        Assert.Null(row.Address);
        Assert.Null(row.Latitude);
        Assert.Null(row.Longitude);
    }

    [Fact]
    public async Task Create_WithLocation_PersistsTrimmedAddressAndCoordinates() {
        var buerger = await CreateBuerger(registered: true);
        var kategorie = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();

        var created = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
            new Dictionary<string, object?> {
                ["input"] = CreateInput(kategorie.Id, gemeinde, overrides: new Dictionary<string, object?> {
                    ["location"] = LocationInput("  Musterstraße 12  ")
                })
            });

        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var row = await db.EhrenamtsbankEintraege.FirstAsync(e => e.Id == CreatedEntryId(created));
        Assert.Equal("Musterstraße 12", row.Address);
        Assert.Equal(52.1039, row.Latitude);
        Assert.Equal(9.3564, row.Longitude);
    }

    [Fact]
    public async Task Create_RejectsInvalidLocationWithTypedError() {
        var buerger = await CreateBuerger(registered: true);
        var kategorie = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();

        Dictionary<string, object?>[] ungueltig = [
            LocationInput(address: ""),
            LocationInput(address: "   "),
            LocationInput(address: new string('x', 251)),
            LocationInput(latitude: 90.0001),
            LocationInput(latitude: -90.0001),
            LocationInput(longitude: 180.0001),
            LocationInput(longitude: -180.0001),
        ];

        foreach (var location in ungueltig) {
            var result = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
                new Dictionary<string, object?> {
                    ["input"] = CreateInput(kategorie.Id, gemeinde,
                        overrides: new Dictionary<string, object?> { ["location"] = location })
                });
            AssertMutationError(result, "createEhrenamtsbankEintrag", "EintragValidationError");
        }
    }

    /// <summary>NaN/Infinity kommen nicht bis zur Anwendungsvalidierung: der Float-Skalar lehnt
    /// sie schon bei der Variablen-Koerzierung ab. Wichtig ist, dass nichts gespeichert wird.</summary>
    [Fact]
    public async Task Create_RejectsNonFiniteCoordinates() {
        var buerger = await CreateBuerger(registered: true);
        var kategorie = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();
        var titel = $"Nichtendliche Koordinate {Guid.NewGuid():N}";

        foreach (var (latitude, longitude) in new[] {
            (double.NaN, 9.3564), (52.1039, double.PositiveInfinity), (double.NegativeInfinity, 9.3564)
        }) {
            var result = await ExecuteGraphqlAsync(Principal(buerger.Id), CreateMutation,
                new Dictionary<string, object?> {
                    ["input"] = CreateInput(kategorie.Id, gemeinde, overrides: new Dictionary<string, object?> {
                        ["title"] = titel,
                        ["location"] = LocationInput(latitude: latitude, longitude: longitude)
                    })
                });
            Assert.NotNull(result.Errors);
        }

        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.EhrenamtsbankEintraege.AnyAsync(e => e.Title == titel));
    }

    /// <summary>Adresse und Koordinaten sind Schreib-, aber keine Leseinformation: sie dürfen
    /// nur im Create-Input auftauchen, niemals auf dem öffentlichen Ausgabetyp.</summary>
    [Fact]
    public async Task Schema_KeepsPrivateLocationOffTheOutputType() {
        var executor = await _factory.Services.GetRequiredService<IRequestExecutorResolver>()
            .GetRequestExecutorAsync();

        var eintrag = executor.Schema.GetType<IObjectType>("EhrenamtsbankEintrag");
        foreach (var feld in new[] { "address", "latitude", "longitude" }) {
            Assert.False(eintrag.Fields.ContainsField(feld),
                $"EhrenamtsbankEintrag darf kein Feld '{feld}' veröffentlichen.");
        }

        var createInput = executor.Schema.GetType<IInputObjectType>("CreateEhrenamtsbankEintragInput");
        var locationFeld = Assert.Single(createInput.Fields.Where(f => f.Name == "location"));
        Assert.Equal("EhrenamtsbankLocationInput", locationFeld.Type.NamedType().Name);

        var locationInput = executor.Schema.GetType<IInputObjectType>("EhrenamtsbankLocationInput");
        Assert.Equal(
            ["address", "latitude", "longitude"],
            locationInput.Fields.Select(f => f.Name).OrderBy(name => name, StringComparer.Ordinal));
    }

    [Fact]
    public async Task Update_OwnerOnly() {
        var owner = await CreateBuerger(registered: true);
        var stranger = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);

        var denied = await ExecuteGraphqlAsync(Principal(stranger.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(eintrag, "Gekapert") });
        AssertMutationError(denied, "updateEhrenamtsbankEintrag", "NotAllowedError");
    }

    [Fact]
    public async Task Update_RequiresDescription() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);

        foreach (var leer in new[] { "", "   " }) {
            var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
                new Dictionary<string, object?> {
                    ["input"] = UpdateInput(eintrag, "Titel bleibt", description: leer)
                });
            AssertMutationError(result, "updateEhrenamtsbankEintrag", "EintragValidationError");
        }
    }

    [Fact]
    public async Task Update_EnforcesClearanceOnUnchangedCategory() {
        var buerger = await CreateBuerger(registered: true, clearance: true);
        var protectedKat = await CreateKategorie(clearance: true);
        var gemeinde = await EnsureGemeinde();
        var eintrag = await CreateEintrag(buerger.Id, EhrenamtsbankEintragStatus.Active,
            typ: EhrenamtsbankEintragTyp.Angebot, kategorieId: protectedKat.Id, untereinheitId: gemeinde);

        // Führungszeugnis wird nach dem Anlegen entzogen.
        using (var scope = _factory.Services.CreateScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var b = await db.Buerger.AsTracking().FirstAsync(x => x.Id == buerger.Id);
            b.RequiresClearanceVerified = false;
            await db.SaveChangesAsync();
        }

        // Bearbeitung derselben (unveränderten) Kategorie muss jetzt scheitern.
        var result = await ExecuteGraphqlAsync(Principal(buerger.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(eintrag, "Geänderter Titel") });
        AssertMutationError(result, "updateEhrenamtsbankEintrag", "NotAllowedError");
    }

    [Fact]
    public async Task Update_RejectsNegativeRadiusAndDuration() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);

        var negativeRadius = UpdateInput(eintrag, "Titel");
        negativeRadius["radiusKm"] = -1;
        AssertMutationError(await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = negativeRadius }),
            "updateEhrenamtsbankEintrag", "EintragValidationError");

        var negativeDuration = UpdateInput(eintrag, "Titel");
        negativeDuration["estimatedDurationMinutes"] = -30;
        AssertMutationError(await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = negativeDuration }),
            "updateEhrenamtsbankEintrag", "EintragValidationError");
    }

    // ---------- Standort-Patch beim Bearbeiten ----------

    [Fact]
    public async Task Update_OmittedLocation_PreservesPersistedValues() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        await PersistLocation(eintrag.Id);

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(eintrag, "Titel ohne Standortangabe") });

        Assert.Null(Payload(result, "updateEhrenamtsbankEintrag")["errors"]);
        AssertLocation(await ReadEintrag(eintrag.Id), "Bahnhofstraße 3", 52.1039, 9.3564);
    }

    [Fact]
    public async Task Update_ExplicitNullLocation_ClearsAllThreeValues() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        await PersistLocation(eintrag.Id);

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> {
                ["input"] = UpdateInput(eintrag, "Standort entfernt",
                    overrides: new Dictionary<string, object?> { ["location"] = null })
            });

        Assert.Null(Payload(result, "updateEhrenamtsbankEintrag")["errors"]);
        AssertLocation(await ReadEintrag(eintrag.Id), null, null, null);
    }

    [Fact]
    public async Task Update_SuppliedLocation_ReplacesAllThreeValues() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        await PersistLocation(eintrag.Id);

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> {
                ["input"] = UpdateInput(eintrag, "Umgezogen", overrides: new Dictionary<string, object?> {
                    ["location"] = LocationInput("  Marktplatz 1  ", 51.9, 9.1)
                })
            });

        Assert.Null(Payload(result, "updateEhrenamtsbankEintrag")["errors"]);
        AssertLocation(await ReadEintrag(eintrag.Id), "Marktplatz 1", 51.9, 9.1);
    }

    /// <summary>Die Prüfung läuft vor jeder Änderung an der geladenen Zeile: eine abgelehnte
    /// Ersetzung darf weder teilweise geschrieben werden noch den alten Standort verlieren.</summary>
    [Fact]
    public async Task Update_InvalidLocation_LeavesPersistedLocationUntouched() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        await PersistLocation(eintrag.Id);

        Dictionary<string, object?>[] ungueltig = [
            LocationInput(address: "   "),
            LocationInput(address: new string('x', 251)),
            LocationInput(latitude: 90.0001),
            LocationInput(longitude: -180.0001),
        ];

        foreach (var location in ungueltig) {
            var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
                new Dictionary<string, object?> {
                    ["input"] = UpdateInput(eintrag, "Ungültiger Standort",
                        overrides: new Dictionary<string, object?> { ["location"] = location })
                });
            AssertMutationError(result, "updateEhrenamtsbankEintrag", "EintragValidationError");

            var row = await ReadEintrag(eintrag.Id);
            AssertLocation(row, "Bahnhofstraße 3", 52.1039, 9.3564);
            Assert.Equal("Hecken schneiden", row.Title);
        }
    }

    /// <summary>Eine Bearbeitung ohne Standortangabe verhält sich exakt wie vor dem Patch-Feld:
    /// kein zusätzlicher Statuswechsel, kein Verlust des gespeicherten Standorts.</summary>
    [Fact]
    public async Task Update_UnrelatedEdit_OmittingLocation_ChangesNothingExtra() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        await PersistLocation(eintrag.Id);

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(eintrag, "Nur der Titel ändert sich") });

        var payload = Payload(result, "updateEhrenamtsbankEintrag");
        Assert.Null(payload["errors"]);
        Assert.Equal("DRAFT", Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            payload["ehrenamtsbankEintrag"])["status"]!.ToString());

        var updated = await ReadEintrag(eintrag.Id);
        Assert.Equal("Nur der Titel ändert sich", updated.Title);
        AssertLocation(updated, "Bahnhofstraße 3", 52.1039, 9.3564);
    }

    [Fact]
    public async Task Update_NonOwnerCannotReplaceOrClearLocation() {
        var owner = await CreateBuerger(registered: true);
        var stranger = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        await PersistLocation(eintrag.Id);

        object?[] fremdeVersuche = [LocationInput("Fremdadresse 1", 50.0, 8.0), null];
        foreach (var location in fremdeVersuche) {
            var result = await ExecuteGraphqlAsync(Principal(stranger.Id), UpdateMutation,
                new Dictionary<string, object?> {
                    ["input"] = UpdateInput(eintrag, "Gekapert",
                        overrides: new Dictionary<string, object?> { ["location"] = location })
                });
            AssertMutationError(result, "updateEhrenamtsbankEintrag", "NotAllowedError");
            AssertLocation(await ReadEintrag(eintrag.Id), "Bahnhofstraße 3", 52.1039, 9.3564);
        }
    }

    /// <summary>Bestandsoperationen kennen das Feld gar nicht. Wäre es pflichtig statt auslassbar,
    /// scheiterte schon die Dokumentvalidierung.</summary>
    [Fact]
    public async Task Update_OperationWithoutLocationField_StillValid() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);
        await PersistLocation(eintrag.Id);

        var result = await ExecuteGraphqlAsync(Principal(owner.Id), """
            mutation UpdateOhneLocation(
                $id: UUID!, $title: String!, $description: String!,
                $kategorieId: UUID!, $untereinheitId: UUID!) {
                updateEhrenamtsbankEintrag(input: {
                    id: $id, title: $title, description: $description,
                    kategorieId: $kategorieId, untereinheitId: $untereinheitId
                }) {
                    ehrenamtsbankEintrag { id status title }
                    errors { __typename ... on Error { message } }
                }
            }
        """, new Dictionary<string, object?> {
            ["id"] = eintrag.Id.ToString(),
            ["title"] = "Bestandsoperation",
            ["description"] = eintrag.Description,
            ["kategorieId"] = eintrag.KategorieId.ToString(),
            ["untereinheitId"] = eintrag.UntereinheitId.ToString(),
        });

        Assert.Null(Payload(result, "updateEhrenamtsbankEintrag")["errors"]);
        var updated = await ReadEintrag(eintrag.Id);
        Assert.Equal("Bestandsoperation", updated.Title);
        AssertLocation(updated, "Bahnhofstraße 3", 52.1039, 9.3564);
    }

    /// <summary>Nullable und ohne Default: nur so bleiben Auslassen (Standort behalten) und
    /// explizites null (Standort löschen) im Schema überhaupt unterscheidbar.</summary>
    [Fact]
    public async Task Schema_UpdateLocationIsNullableAndOmittable() {
        var executor = await _factory.Services.GetRequiredService<IRequestExecutorResolver>()
            .GetRequestExecutorAsync();

        var updateInput = executor.Schema.GetType<IInputObjectType>("UpdateEhrenamtsbankEintragInput");
        var locationFeld = Assert.Single(updateInput.Fields.Where(f => f.Name == "location"));
        Assert.Equal("EhrenamtsbankLocationInput", locationFeld.Type.NamedType().Name);
        Assert.False(locationFeld.Type.IsNonNullType());
        Assert.Null(locationFeld.DefaultValue);
    }

    [Fact]
    public async Task UpdateStatus_RejectsInvalidAndForeign() {
        var owner = await CreateBuerger(registered: true);
        var stranger = await CreateBuerger(registered: true);
        var superadmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        // Owner darf nicht selbst freigeben.
        var pending = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.PendingReview);
        var selfApprove = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation,
            StatusInput(pending.Id, "ACTIVE"));
        AssertMutationError(selfApprove, "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");

        // Fremder Bürger ist gar nicht berechtigt.
        var foreign = await ExecuteGraphqlAsync(Principal(stranger.Id), UpdateStatusMutation,
            StatusInput(pending.Id, "CLOSED"));
        AssertMutationError(foreign, "updateEhrenamtsbankEintragStatus", "NotAllowedError");

        // Endzustand hat keinen Ausgang.
        var completed = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Completed);
        var reopen = await ExecuteGraphqlAsync(Principal(owner.Id), UpdateStatusMutation,
            StatusInput(completed.Id, "ACTIVE"));
        AssertMutationError(reopen, "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");

        // Moderation darf keine Owner-Aktion (Completed) ausführen.
        var active = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        var moderatorComplete = await ExecuteGraphqlAsync(superadmin, UpdateStatusMutation,
            StatusInput(active.Id, "COMPLETED"));
        AssertMutationError(moderatorComplete, "updateEhrenamtsbankEintragStatus", "EintragStatusTransitionError");
    }

    private const string DeleteMutation = """
        mutation Delete($input: DeleteEhrenamtsbankEintragInput!) {
            deleteEhrenamtsbankEintrag(input: $input) {
                deletedId
                errors { __typename ... on Error { message } }
            }
        }
    """;

    [Fact]
    public async Task Mutations_RejectAnonymousCallers() {
        var owner = await CreateBuerger(registered: true);
        var kategorie = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Draft);

        var created = await ExecuteGraphqlAsync(Anonymous(), CreateMutation,
            new Dictionary<string, object?> { ["input"] = CreateInput(kategorie.Id, gemeinde) });
        AssertAuthenticationError(created);

        var updated = await ExecuteGraphqlAsync(Anonymous(), UpdateMutation,
            new Dictionary<string, object?> { ["input"] = UpdateInput(eintrag, "Anonym") });
        AssertAuthenticationError(updated);

        var statusChanged = await ExecuteGraphqlAsync(Anonymous(), UpdateStatusMutation,
            StatusInput(eintrag.Id, "PENDING_REVIEW"));
        AssertAuthenticationError(statusChanged);

        var deleted = await ExecuteGraphqlAsync(Anonymous(), DeleteMutation,
            new Dictionary<string, object?> {
                ["input"] = new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() }
            });
        AssertAuthenticationError(deleted);
    }

    /// <summary>Inhaber-Bearbeitung und Moderationsentscheidung greifen auf dieselbe Zeile zu.
    /// Ohne Nebenläufigkeits-Token würde der zweite Save die fremde Statusänderung behalten und
    /// damit ungeprüfte Inhalte im Status Active veröffentlichen.</summary>
    [Fact]
    public async Task ConcurrentEdit_DoesNotPublishUnreviewedContent() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.PendingReview);

        using var ownerScope = _factory.Services.CreateScope();
        using var moderatorScope = _factory.Services.CreateScope();
        var ownerDb = ownerScope.ServiceProvider.GetRequiredService<DomainContext>();
        var moderatorDb = moderatorScope.ServiceProvider.GetRequiredService<DomainContext>();

        var ownerCopy = await ownerDb.EhrenamtsbankEintraege.AsTracking().FirstAsync(e => e.Id == eintrag.Id);
        var moderatorCopy = await moderatorDb.EhrenamtsbankEintraege.AsTracking().FirstAsync(e => e.Id == eintrag.Id);

        moderatorCopy.Status = EhrenamtsbankEintragStatus.Active;
        await moderatorDb.SaveChangesAsync();

        ownerCopy.Title = "Nachträglich geänderter Inhalt";
        await Assert.ThrowsAsync<DbUpdateConcurrencyException>(() => ownerDb.SaveChangesAsync());

        using var verifyScope = _factory.Services.CreateScope();
        var verifyDb = verifyScope.ServiceProvider.GetRequiredService<DomainContext>();
        var row = await verifyDb.EhrenamtsbankEintraege.FirstAsync(e => e.Id == eintrag.Id);
        Assert.Equal(EhrenamtsbankEintragStatus.Active, row.Status);
        Assert.Equal("Hecken schneiden", row.Title);
    }

    [Fact]
    public async Task Delete_SoftAndInvisible() {
        var owner = await CreateBuerger(registered: true);
        var stranger = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        Dictionary<string, object?> DeleteInput() =>
            new() { ["input"] = new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() } };

        var denied = await ExecuteGraphqlAsync(Principal(stranger.Id), DeleteMutation, DeleteInput());
        AssertMutationError(denied, "deleteEhrenamtsbankEintrag", "NotAllowedError");

        var deleted = await ExecuteGraphqlAsync(Principal(owner.Id), DeleteMutation, DeleteInput());
        var payload = Payload(deleted, "deleteEhrenamtsbankEintrag");
        Assert.Equal(eintrag.Id, Guid.Parse(payload["deletedId"]!.ToString()!));

        // Zeile bleibt bestehen, ist aber überall unsichtbar.
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var row = await db.EhrenamtsbankEintraege.FirstAsync(e => e.Id == eintrag.Id);
        Assert.True(row.IsDeleted);

        var search = await ExecuteGraphqlAsync(Anonymous(), EntriesQuery);
        Assert.DoesNotContain(eintrag.Id, ItemIds(search, "ehrenamtsbankEintraege"));

        var detail = await ExecuteGraphqlAsync(Principal(owner.Id), EntryQuery,
            new Dictionary<string, object?> { ["id"] = eintrag.Id.ToString() });
        Assert.NotNull(detail.Errors);
    }

    // ---------- öffentliche Entfernung ----------

    private const string DistanceQuery = """
        query Distance($id: UUID!, $origin: GeoCoordinateInput) {
            ehrenamtsbankEintrag(id: $id) { id distanceKm(origin: $origin) }
        }
    """;

    private static Dictionary<string, object?> Origin(double latitude, double longitude) =>
        new() { ["latitude"] = latitude, ["longitude"] = longitude };

    /// <summary>Nord-Süd-Versatz für eine Zielentfernung. Bei gleichem Längengrad ist die
    /// Haversine-Distanz exakt Erdradius mal Breitendifferenz im Bogenmaß, die gewünschte
    /// Rohdistanz also ohne Suchverfahren konstruierbar.</summary>
    private static double LatitudeOffsetForKm(double distanceKm) =>
        distanceKm * 180 / (Math.PI * GeoDistance.EarthRadiusKm);

    private async Task<IQueryResult> QueryDistance(
        Guid eintragId, Dictionary<string, object?>? origin) =>
        await ExecuteGraphqlAsync(Anonymous(), DistanceQuery, new Dictionary<string, object?> {
            ["id"] = eintragId.ToString(),
            ["origin"] = origin,
        });

    private static object? DistanceValue(IQueryResult result) {
        var data = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(result.Data);
        var eintrag = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(
            data["ehrenamtsbankEintrag"]);
        return eintrag["distanceKm"];
    }

    [Fact]
    public async Task Distance_AnonymousCallerGetsRoundedKilometres() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        await PersistLocation(eintrag.Id, latitude: 52.3759, longitude: 9.7320);

        var result = await QueryDistance(eintrag.Id, Origin(52.1039, 9.3564));

        Assert.Null(result.Errors);
        Assert.Equal(40, DistanceValue(result));
    }

    [Fact]
    public async Task Distance_NullOriginResolvesToNull() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        await PersistLocation(eintrag.Id);

        var result = await QueryDistance(eintrag.Id, origin: null);

        Assert.Null(result.Errors);
        Assert.Null(DistanceValue(result));
    }

    [Fact]
    public async Task Distance_EntryWithoutCoordinatesResolvesToNull() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);

        var result = await QueryDistance(eintrag.Id, Origin(52.1039, 9.3564));

        Assert.Null(result.Errors);
        Assert.Null(DistanceValue(result));
    }

    /// <summary>Ein Standort außerhalb des Wertebereichs darf nie stillschweigend in die
    /// Rechnung gehen; der Aufrufer bekommt den typisierten Domänen-Fehlercode.</summary>
    [Theory]
    [InlineData(90.0001, 9.3564)]
    [InlineData(-90.0001, 9.3564)]
    [InlineData(52.1039, 180.0001)]
    [InlineData(52.1039, -180.0001)]
    public async Task Distance_RejectsOutOfRangeOrigin(double latitude, double longitude) {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        await PersistLocation(eintrag.Id);

        var result = await QueryDistance(eintrag.Id, Origin(latitude, longitude));

        var error = Assert.Single(result.Errors!);
        Assert.Equal("EINTRAG_VALIDATION", error.Code);
        Assert.Equal(["distanceKm"], error.Path!.ToList().TakeLast(1));
        Assert.Null(DistanceValue(result));
    }

    /// <summary>Die Prüfung hängt nicht an fremden Daten: auch ohne hinterlegte Koordinaten
    /// bleibt ein ungültiger Standort ein Fehler und wird nicht zu einem stillen null.</summary>
    [Fact]
    public async Task Distance_RejectsInvalidOriginEvenWithoutStoredCoordinates() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);

        var result = await QueryDistance(eintrag.Id, Origin(91, 9.3564));

        Assert.Equal("EINTRAG_VALIDATION", Assert.Single(result.Errors!).Code);
    }

    /// <summary>NaN/Infinity erreichen die Anwendungsvalidierung nicht: der Float-Skalar
    /// lehnt sie schon bei der Variablen-Koerzierung ab.</summary>
    [Theory]
    [InlineData(double.NaN, 9.3564)]
    [InlineData(52.1039, double.PositiveInfinity)]
    [InlineData(double.NegativeInfinity, 9.3564)]
    public async Task Distance_RejectsNonFiniteOrigin(double latitude, double longitude) {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        await PersistLocation(eintrag.Id);

        var result = await QueryDistance(eintrag.Id, Origin(latitude, longitude));

        Assert.NotNull(result.Errors);
    }

    [Theory]
    [InlineData(0.4999, 0)]
    [InlineData(0.5001, 1)]
    [InlineData(1.4999, 1)]
    [InlineData(1.5001, 2)]
    public async Task Distance_RoundingBoundaryThroughResolver(double rohKm, int erwartet) {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        await PersistLocation(eintrag.Id, latitude: 52 + LatitudeOffsetForKm(rohKm), longitude: 9);

        var result = await QueryDistance(eintrag.Id, Origin(52, 9));

        Assert.Null(result.Errors);
        Assert.Equal(erwartet, DistanceValue(result));
    }

    /// <summary>Die Entfernung ist die einzige öffentliche Ableitung des Standorts: weder die
    /// Adresse noch die gespeicherten Koordinaten dürfen in der Antwort auftauchen.</summary>
    [Fact]
    public async Task Distance_ResponseNeverContainsStoredLocation() {
        var owner = await CreateBuerger(registered: true);
        var eintrag = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active);
        await PersistLocation(eintrag.Id, "Bahnhofstraße 3", 52.3759, 9.7320);

        var result = await QueryDistance(eintrag.Id, Origin(52.1039, 9.3564));

        Assert.Null(result.Errors);
        var json = result.ToJson();
        Assert.DoesNotContain("Bahnhofstraße", json);
        Assert.DoesNotContain("52.3759", json);
        Assert.DoesNotContain("9.732", json);
    }

    [Fact]
    public async Task Schema_DistanceIsPublicAndTakesGeoCoordinateInput() {
        var executor = await _factory.Services.GetRequiredService<IRequestExecutorResolver>()
            .GetRequestExecutorAsync();

        var eintrag = executor.Schema.GetType<IObjectType>("EhrenamtsbankEintrag");
        var distance = eintrag.Fields["distanceKm"];
        Assert.Equal("Int", distance.Type.NamedType().Name);
        Assert.False(distance.Type.IsNonNullType());
        Assert.False(distance.Directives.ContainsDirective("authorize"));

        var origin = Assert.Single(distance.Arguments.Where(a => a.Name == "origin"));
        Assert.Equal("GeoCoordinateInput", origin.Type.NamedType().Name);
        Assert.False(origin.Type.IsNonNullType());

        var geoInput = executor.Schema.GetType<IInputObjectType>("GeoCoordinateInput");
        Assert.Equal(
            ["latitude", "longitude"],
            geoInput.Fields.Select(f => f.Name).OrderBy(name => name, StringComparer.Ordinal));
        Assert.All(geoInput.Fields, f => Assert.Equal("Float", f.Type.NamedType().Name));
    }

    // ---------- Entfernungsfilter der Suche ----------

    private const string NearbyEntriesQuery = """
        query Nearby($filter: EhrenamtsbankEintragFilterInput, $origin: GeoCoordinateInput, $take: Int!) {
            ehrenamtsbankEintraege(filter: $filter, skip: 0, take: $take) {
                totalCount
                items { id distanceKm(origin: $origin) }
            }
        }
    """;

    /// <summary>Eigener Textmarker je Test. Die Testdatenbank wird zwischen den Tests nicht
    /// geleert; ohne Marker liefe die Suche über die Einträge aller anderen Tests mit.</summary>
    private static string SearchMarker() => $"Marker{Guid.NewGuid():N}";

    private async Task<EhrenamtsbankEintrag> CreateEintragAt(
        Guid ownerId, double latitude, double longitude,
        EhrenamtsbankEintragTyp typ = EhrenamtsbankEintragTyp.Gesuch,
        Guid? kategorieId = null, Guid? untereinheitId = null,
        string title = "Hecken schneiden", string description = "Werkzeug ist vorhanden.",
        Instant? createdAt = null) {
        var eintrag = await CreateEintrag(ownerId, EhrenamtsbankEintragStatus.Active, typ,
            kategorieId, untereinheitId, title, description, createdAt: createdAt);
        await PersistLocation(eintrag.Id, latitude: latitude, longitude: longitude);
        return eintrag;
    }

    private async Task<IQueryResult> QueryNearby(
        Dictionary<string, object?>? origin, double? maxDistanceKm, string? searchText = null,
        int take = 50, IReadOnlyDictionary<string, object?>? weitereFilter = null) {
        var filter = new Dictionary<string, object?>();
        if (weitereFilter is not null) {
            foreach (var (name, value) in weitereFilter) {
                filter[name] = value;
            }
        }

        if (origin is not null) {
            filter["origin"] = origin;
        }

        if (maxDistanceKm is { } max) {
            filter["maxDistanceKm"] = max;
        }

        if (searchText is not null) {
            filter["searchText"] = searchText;
        }

        return await ExecuteGraphqlAsync(Anonymous(), NearbyEntriesQuery, new Dictionary<string, object?> {
            ["filter"] = filter,
            ["origin"] = origin,
            ["take"] = take,
        });
    }

    private static int TotalCount(IQueryResult result, string field) {
        var data = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(result.Data);
        var page = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(data[field]);
        return Convert.ToInt32(page["totalCount"]);
    }

    /// <summary>Ein Meter Abstand zur Schwelle: Ein grob gerundeter oder ungenau übersetzter
    /// Vergleich fiele hier auf, eine gültige Gleitkomma-Abweichung liegt Größenordnungen darunter.</summary>
    [Fact]
    public async Task EntriesFilter_IncludesNearEntry_ExcludesEntryJustOutsideThreshold() {
        var owner = await CreateBuerger(registered: true);
        var marker = SearchMarker();
        var near = await CreateEintragAt(owner.Id, 48 + LatitudeOffsetForKm(9.999), 11,
            description: marker);
        var far = await CreateEintragAt(owner.Id, 48 + LatitudeOffsetForKm(10.001), 11,
            description: marker);

        var result = await QueryNearby(Origin(48, 11), maxDistanceKm: 10, searchText: marker);

        Assert.Null(result.Errors);
        var ids = ItemIds(result, "ehrenamtsbankEintraege");
        Assert.Contains(near.Id, ids);
        Assert.DoesNotContain(far.Id, ids);
        Assert.Equal(1, TotalCount(result, "ehrenamtsbankEintraege"));
    }

    /// <summary>10,4 km rundet auf die Schwelle 10 und fiele bei gerundetem Vergleich hinein.</summary>
    [Fact]
    public async Task EntriesFilter_ComparesUnroundedDistanceWhileOutputStaysRounded() {
        var owner = await CreateBuerger(registered: true);
        var marker = SearchMarker();
        var eintrag = await CreateEintragAt(owner.Id, 46 + LatitudeOffsetForKm(10.4), 11,
            description: marker);

        var gefiltert = await QueryNearby(Origin(46, 11), maxDistanceKm: 10, searchText: marker);
        Assert.Null(gefiltert.Errors);
        Assert.DoesNotContain(eintrag.Id, ItemIds(gefiltert, "ehrenamtsbankEintraege"));

        var ungefiltert = await QueryNearby(Origin(46, 11), maxDistanceKm: null, searchText: marker);
        Assert.Null(ungefiltert.Errors);
        var item = Assert.Single(Items(ungefiltert, "ehrenamtsbankEintraege"));
        Assert.Equal(eintrag.Id, Guid.Parse(item["id"]!.ToString()!));
        Assert.Equal(10, item["distanceKm"]);
    }

    [Fact]
    public async Task EntriesFilter_EntryWithoutCoordinates_ExcludedOnlyWhileFilterActive() {
        var owner = await CreateBuerger(registered: true);
        var marker = SearchMarker();
        var ohneKoordinaten = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active,
            description: marker);
        var mitKoordinaten = await CreateEintragAt(owner.Id, 44 + LatitudeOffsetForKm(1), 11,
            description: marker);

        var gefiltert = await QueryNearby(Origin(44, 11), maxDistanceKm: 10, searchText: marker);
        Assert.Null(gefiltert.Errors);
        var gefilterteIds = ItemIds(gefiltert, "ehrenamtsbankEintraege");
        Assert.Contains(mitKoordinaten.Id, gefilterteIds);
        Assert.DoesNotContain(ohneKoordinaten.Id, gefilterteIds);

        var ungefiltert = await QueryNearby(origin: null, maxDistanceKm: null, searchText: marker);
        Assert.Null(ungefiltert.Errors);
        var ungefilterteIds = ItemIds(ungefiltert, "ehrenamtsbankEintraege");
        Assert.Contains(mitKoordinaten.Id, ungefilterteIds);
        Assert.Contains(ohneKoordinaten.Id, ungefilterteIds);
    }

    [Fact]
    public async Task EntriesFilter_MaxDistanceWithoutOrigin_IsRejected() {
        var owner = await CreateBuerger(registered: true);
        await CreateEintragAt(owner.Id, 48, 11);

        var result = await QueryNearby(origin: null, maxDistanceKm: 10);

        Assert.Equal("EINTRAG_VALIDATION", Assert.Single(result.Errors!).Code);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-1)]
    [InlineData(-0.0001)]
    public async Task EntriesFilter_RejectsNonPositiveMaxDistance(double maxDistanceKm) {
        var result = await QueryNearby(Origin(48, 11), maxDistanceKm);

        Assert.Equal("EINTRAG_VALIDATION", Assert.Single(result.Errors!).Code);
    }

    /// <summary>NaN/Infinity erreichen die Anwendungsvalidierung nicht: der Float-Skalar
    /// lehnt sie schon bei der Variablen-Koerzierung ab.</summary>
    [Theory]
    [InlineData(double.NaN)]
    [InlineData(double.PositiveInfinity)]
    [InlineData(double.NegativeInfinity)]
    public async Task EntriesFilter_RejectsNonFiniteMaxDistance(double maxDistanceKm) {
        var result = await QueryNearby(Origin(48, 11), maxDistanceKm);

        Assert.NotNull(result.Errors);
    }

    [Theory]
    [InlineData(90.0001, 11)]
    [InlineData(-90.0001, 11)]
    [InlineData(48, 180.0001)]
    [InlineData(48, -180.0001)]
    public async Task EntriesFilter_RejectsInvalidOrigin(double latitude, double longitude) {
        var mitGrenze = await QueryNearby(Origin(latitude, longitude), maxDistanceKm: 10);
        Assert.Equal("EINTRAG_VALIDATION", Assert.Single(mitGrenze.Errors!).Code);

        var ohneGrenze = await QueryNearby(Origin(latitude, longitude), maxDistanceKm: null);
        Assert.Equal("EINTRAG_VALIDATION", Assert.Single(ohneGrenze.Errors!).Code);
    }

    /// <summary>Ein Standort allein dient nur der Ausgabe; er darf die Treffermenge nicht
    /// verkleinern, auch nicht um Einträge ohne Koordinaten.</summary>
    [Fact]
    public async Task EntriesFilter_OriginWithoutMaxDistance_DoesNotNarrowResults() {
        var owner = await CreateBuerger(registered: true);
        var marker = SearchMarker();
        var ohneKoordinaten = await CreateEintrag(owner.Id, EhrenamtsbankEintragStatus.Active,
            description: marker);
        var weitEntfernt = await CreateEintragAt(owner.Id, 42 + LatitudeOffsetForKm(500), 11,
            description: marker);

        var result = await QueryNearby(Origin(42, 11), maxDistanceKm: null, searchText: marker);

        Assert.Null(result.Errors);
        var ids = ItemIds(result, "ehrenamtsbankEintraege");
        Assert.Contains(ohneKoordinaten.Id, ids);
        Assert.Contains(weitEntfernt.Id, ids);
        Assert.Equal(2, TotalCount(result, "ehrenamtsbankEintraege"));
    }

    [Fact]
    public async Task EntriesFilter_DistanceComposesWithExistingFilters() {
        var owner = await CreateBuerger(registered: true);
        var kategorieA = await CreateKategorie();
        var kategorieB = await CreateKategorie();
        var gemeinde = await EnsureGemeinde();
        var andereEinheit = await CreateNonGemeindeUntereinheit();
        var suchbegriff = $"Rasen{Guid.NewGuid():N}";
        var nah = 40 + LatitudeOffsetForKm(2);
        var fern = 40 + LatitudeOffsetForKm(50);

        var match = await CreateEintragAt(owner.Id, nah, 11, EhrenamtsbankEintragTyp.Gesuch,
            kategorieA.Id, gemeinde, $"{suchbegriff} mähen im Vorgarten");
        var falscherTyp = await CreateEintragAt(owner.Id, nah, 11, EhrenamtsbankEintragTyp.Angebot,
            kategorieA.Id, gemeinde, $"{suchbegriff} mähen als Angebot");
        var falscheKategorie = await CreateEintragAt(owner.Id, nah, 11, EhrenamtsbankEintragTyp.Gesuch,
            kategorieB.Id, gemeinde, $"{suchbegriff} mähen woanders");
        var falscheEinheit = await CreateEintragAt(owner.Id, nah, 11, EhrenamtsbankEintragTyp.Gesuch,
            kategorieA.Id, andereEinheit, $"{suchbegriff} mähen im Nachbarort");
        var falscherText = await CreateEintragAt(owner.Id, nah, 11, EhrenamtsbankEintragTyp.Gesuch,
            kategorieA.Id, gemeinde, "Einkaufshilfe");
        var zuWeit = await CreateEintragAt(owner.Id, fern, 11, EhrenamtsbankEintragTyp.Gesuch,
            kategorieA.Id, gemeinde, $"{suchbegriff} mähen im Nachbarkreis");

        var result = await QueryNearby(Origin(40, 11), maxDistanceKm: 10, searchText: suchbegriff,
            weitereFilter: new Dictionary<string, object?> {
                ["typ"] = "GESUCH",
                ["kategorieIds"] = new[] { kategorieA.Id.ToString() },
                ["untereinheitIds"] = new[] { gemeinde.ToString() },
            });

        Assert.Null(result.Errors);
        var ids = ItemIds(result, "ehrenamtsbankEintraege");
        Assert.Contains(match.Id, ids);
        Assert.DoesNotContain(falscherTyp.Id, ids);
        Assert.DoesNotContain(falscheKategorie.Id, ids);
        Assert.DoesNotContain(falscheEinheit.Id, ids);
        Assert.DoesNotContain(falscherText.Id, ids);
        Assert.DoesNotContain(zuWeit.Id, ids);
        Assert.Equal(1, TotalCount(result, "ehrenamtsbankEintraege"));
    }

    /// <summary>Der weiter entfernte Eintrag ist der neuere und stünde bei Sortierung vor dem
    /// nahen. Käme der Filter erst nach der Seite, lieferte take: 1 eine leere Seite.</summary>
    [Fact]
    public async Task EntriesFilter_AppliedBeforePaging() {
        var owner = await CreateBuerger(registered: true);
        var marker = SearchMarker();
        var now = SystemClock.Instance.GetCurrentInstant();
        var fernUndNeuer = await CreateEintragAt(owner.Id, 38 + LatitudeOffsetForKm(500), 11,
            description: marker, createdAt: now);
        var nahUndAelter = await CreateEintragAt(owner.Id, 38 + LatitudeOffsetForKm(5), 11,
            description: marker, createdAt: now.Minus(Duration.FromHours(2)));

        var result = await QueryNearby(Origin(38, 11), maxDistanceKm: 10, searchText: marker, take: 1);

        Assert.Null(result.Errors);
        var item = Assert.Single(Items(result, "ehrenamtsbankEintraege"));
        Assert.Equal(nahUndAelter.Id, Guid.Parse(item["id"]!.ToString()!));
        Assert.Equal(5, item["distanceKm"]);
        Assert.Equal(1, TotalCount(result, "ehrenamtsbankEintraege"));
        Assert.NotEqual(fernUndNeuer.Id, Guid.Parse(item["id"]!.ToString()!));
    }

    /// <summary>Sichert die Datenbank-Auswertung ab: fiele der Ausdruck je auf clientseitige
    /// Auswertung zurück, stünde hier kein SQL-Rechenausdruck mehr.</summary>
    [Fact]
    public async Task EntriesFilter_DistancePredicateIsTranslatedToSql() {
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var currentUserAccessor = scope.ServiceProvider.GetRequiredService<CurrentUserAccessor>();

        var query = await new EintragQueries().GetEhrenamtsbankEintraege(
            new EhrenamtsbankEintragFilterInput(null, null, null, null, null,
                new GeoCoordinateInput(48, 11), 10),
            db, currentUserAccessor);

        var sql = query.ToQueryString();
        Assert.Contains("asin(", sql);
        Assert.Contains("sin(", sql);
        Assert.Contains("cos(", sql);
        Assert.Contains("sqrt(", sql);
        Assert.Contains("LEAST(", sql);
        Assert.Contains("GREATEST(", sql);
        Assert.Contains("ORDER BY e.\"CreatedAt\" DESC, e.\"Id\"", sql);
    }
}
