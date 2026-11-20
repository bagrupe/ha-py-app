using System.Security.Claims;
using System.Text.Json.Nodes;
using API.Features;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Infrastructure;
using API.Seeders;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// #430: a third party (neither applicant nor backoffice) must not read personal slot values of a public
/// (Mängelmelder/Ideenmelder) Ausführung, and must not reach a non-public Ausführung at all.
/// </summary>
[Collection("Api Tests")]
public class OeffentlicheSlotSichtbarkeitTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string QueryMangelAusfuehrung = """
        query Mangel($kommuneId: UUID!, $id: UUID!) {
          kommune(kommuneId: $kommuneId) {
            mangelAusfuehrung(id: $id) {
              id
              titel: slotValue(names: "titel") { ... on PlainSlotValue { value } }
              vorname: slotValue(names: "vorname") { ... on PlainSlotValue { value } }
              slotValues { slotName }
              beschreibungstextSlotValues { slotName }
            }
          }
        }
        """;

    private const string QueryMaengelKarte = """
        query Karte($kommuneId: UUID!, $filter: SlotValueFilterInput) {
          kommune(kommuneId: $kommuneId) {
            maengelAusfuehrungen {
              id
              slotValues(where: $filter) { slotName }
            }
          }
        }
        """;

    private const string QueryAusfuehrung = """
        query Ausfuehrung($id: UUID!) {
          ausfuehrung(id: $id) {
            id
            slotValues { slotName }
          }
        }
        """;

    [Fact]
    public async Task Stranger_does_not_receive_personal_slots_of_a_public_Ausfuehrung() {
        var (ausfuehrungId, _, stranger) = await SeedAusfuehrung(isPublic: true);

        var mangel = await QueryMangel(stranger, ausfuehrungId);

        Assert.NotNull(mangel);
        Assert.Null(mangel["vorname"]);
    }

    [Fact]
    public async Task Stranger_does_not_receive_personal_slots_via_slotValues() {
        var (ausfuehrungId, _, stranger) = await SeedAusfuehrung(isPublic: true);

        var mangel = await QueryMangel(stranger, ausfuehrungId);

        Assert.NotNull(mangel);
        Assert.DoesNotContain("vorname", SlotNames(mangel["slotValues"]));
    }

    [Fact]
    public async Task Stranger_does_not_receive_personal_slots_via_beschreibungstextSlotValues() {
        var (ausfuehrungId, _, stranger) = await SeedAusfuehrung(isPublic: true);

        var mangel = await QueryMangel(stranger, ausfuehrungId);

        Assert.NotNull(mangel);
        Assert.DoesNotContain("vorname", SlotNames(mangel["beschreibungstextSlotValues"]));
    }

    [Fact]
    public async Task Stranger_still_receives_the_public_slot_of_a_public_Ausfuehrung() {
        var (ausfuehrungId, _, stranger) = await SeedAusfuehrung(isPublic: true);

        var mangel = await QueryMangel(stranger, ausfuehrungId);

        Assert.NotNull(mangel);
        Assert.NotNull(mangel["titel"]);
        Assert.Contains("titel", SlotNames(mangel["slotValues"]));
        Assert.Contains("titel", SlotNames(mangel["beschreibungstextSlotValues"]));
    }

    [Fact]
    public async Task Stranger_cannot_reach_personal_slots_via_the_map_slotValues_filter() {
        var (ausfuehrungId, _, stranger) = await SeedAusfuehrung(isPublic: true);

        var vornameSlots = await QueryKartenSlotNames(stranger, ausfuehrungId, "vorname");
        var titelSlots = await QueryKartenSlotNames(stranger, ausfuehrungId, "titel");

        Assert.Empty(vornameSlots);
        Assert.Equal(["titel"], titelSlots);
    }

    [Fact]
    public async Task Owner_receives_personal_slots_via_the_map_slotValues_filter() {
        var (ausfuehrungId, owner, _) = await SeedAusfuehrung(isPublic: true);

        var vornameSlots = await QueryKartenSlotNames(owner, ausfuehrungId, "vorname");

        Assert.Equal(["vorname"], vornameSlots);
    }

    [Fact]
    public async Task Owner_receives_all_slots_of_a_public_Ausfuehrung() {
        var (ausfuehrungId, owner, _) = await SeedAusfuehrung(isPublic: true);

        var mangel = await QueryMangel(owner, ausfuehrungId);

        Assert.NotNull(mangel);
        Assert.NotNull(mangel["vorname"]);
        Assert.Contains("vorname", SlotNames(mangel["slotValues"]));
    }

    [Fact]
    public async Task Stranger_cannot_reach_a_non_public_Ausfuehrung_via_mangelAusfuehrung() {
        var (ausfuehrungId, _, stranger) = await SeedAusfuehrung(isPublic: false);

        var mangel = await QueryMangel(stranger, ausfuehrungId);

        Assert.Null(mangel);
    }

    [Fact]
    public async Task Stranger_cannot_reach_a_non_public_Ausfuehrung_via_ausfuehrung() {
        var (ausfuehrungId, _, stranger) = await SeedAusfuehrung(isPublic: false);

        var result = await ExecuteGraphqlAsync(stranger, QueryAusfuehrung,
            new Dictionary<string, object?> { ["id"] = ausfuehrungId });

        Assert.NotNull(result.Errors);
        Assert.Null(result.Data?["ausfuehrung"]);
    }

    private async Task<IReadOnlyDictionary<string, object?>?> QueryMangel(ClaimsPrincipal user, Guid ausfuehrungId) {
        var result = await ExecuteGraphqlAsync(user, QueryMangelAusfuehrung, new Dictionary<string, object?> {
            ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
            ["id"] = ausfuehrungId,
        });

        Assert.Null(result.Errors);
        var kommune = (IReadOnlyDictionary<string, object?>)result.Data!["kommune"]!;
        return kommune["mangelAusfuehrung"] as IReadOnlyDictionary<string, object?>;
    }

    private async Task<List<string>> QueryKartenSlotNames(ClaimsPrincipal user, Guid ausfuehrungId, string slotName) {
        var result = await ExecuteGraphqlAsync(user, QueryMaengelKarte, new Dictionary<string, object?> {
            ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
            ["filter"] = new Dictionary<string, object?> { ["slotName"] = new Dictionary<string, object?> { ["eq"] = slotName } },
        });

        Assert.Null(result.Errors);
        var kommune = (IReadOnlyDictionary<string, object?>)result.Data!["kommune"]!;
        var ausfuehrung = ((IEnumerable<object>)kommune["maengelAusfuehrungen"]!)
            .Cast<IReadOnlyDictionary<string, object?>>()
            .Single(a => a["id"]!.ToString() == ausfuehrungId.ToString());
        return SlotNames(ausfuehrung["slotValues"]).ToList();
    }

    private static IEnumerable<string> SlotNames(object? slotValues) =>
        ((IEnumerable<object>)slotValues!)
        .Cast<IReadOnlyDictionary<string, object?>>()
        .Select(sv => (string)sv["slotName"]!);

    private async Task<(Guid AusfuehrungId, ClaimsPrincipal Owner, ClaimsPrincipal Stranger)> SeedAusfuehrung(
        bool isPublic) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (owner, ownerPrincipal) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);
        var (_, strangerPrincipal) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);

        var instant = Instant.FromUtc(2026, 6, 30, 12, 0, 0);
        var prozessId = Guid.NewGuid();
        // Must be exactly "Mängelmelder": GetMangelById and OnlyPublic match on the tag name.
        var tag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Mängelmelder" };
        var prozess = new Prozess {
            Id = prozessId,
            Name = isPublic ? "#430 public Mängelmelder" : "#430 non-public Prozess",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Tags = isPublic ? [tag] : [],
            TagHistorie = isPublic
                ? [new ProzessTagHistorieEintrag { Id = Guid.NewGuid(), ProzessId = prozessId, TagId = tag.Id, ZugewiesenAm = instant }]
                : [],
        };

        var formularSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            Titel = "Meldung",
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = [
                new StringFormularFeld { SlotName = "titel", Order = 0, Encrypted = false, OeffentlichSichtbar = true },
                new StringFormularFeld { SlotName = "vorname", Order = 1, Encrypted = false },
            ],
        };
        var endeSchritt = new EndeSchritt {
            Id = Guid.NewGuid(),
            Titel = "Ende",
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var verbindung = new Verbindung {
            Id = Guid.NewGuid(),
            Von = formularSchritt,
            Nach = endeSchritt,
            StatusAenderung = "weiter",
        };
        formularSchritt.Verbindungen.Add(verbindung);

        var version = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = new StringExpression("slot('vorname') + ': ' + slot('titel')"),
            Schritte = [formularSchritt, endeSchritt],
        };
        db.ProzessVersionen.Add(version);
        // StartId and Schritt.ProzessVersionId reference each other (circular FK): set StartId after the insert.
        await db.SaveChangesAsync();
        version.StartId = formularSchritt.Id;

        var ausfuehrungId = Guid.NewGuid();
        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = ausfuehrungId,
            ProzessVersionId = version.Id,
            UserId = owner.Id,
            CreatedAt = instant,
            Status = AusfuehrungStatus.BearbeitungDurchKommune,
            SchrittId = endeSchritt.Id,
            SharedKeyEncryptedForBuerger = "foo",
            SharedKeyEncryptedForKommune = "bar",
            IstZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Followers = [],
            Bearbeitungen = [
                new Bearbeitung {
                    Id = Guid.NewGuid(),
                    SchrittId = formularSchritt.Id,
                    UserId = owner.Id,
                    CreatedAt = instant,
                    NextVerbindungId = verbindung.Id,
                    WarZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
                    // IstFreigegeben = true mirrors SlotValuesInput.ToSlotValue for every non-upload field.
                    SlotValues = [
                        new PlainSlotValue {
                            SlotName = "titel", Value = JsonValue.Create("Schlagloch")!.ToJsonElement(), IstFreigegeben = true,
                        },
                        new PlainSlotValue {
                            SlotName = "vorname", Value = JsonValue.Create("Erika")!.ToJsonElement(), IstFreigegeben = true,
                        },
                    ],
                },
            ],
        });
        await db.SaveChangesAsync();

        return (ausfuehrungId, ownerPrincipal, strangerPrincipal);
    }
}
