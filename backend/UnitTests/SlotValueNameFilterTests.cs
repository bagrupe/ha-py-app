using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text.Json.Nodes;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Prozess;
using API.Features.Prozess.Queries;
using API.Infrastructure;
using API.Options;
using API.Seeders;
using HotChocolate.Execution;
using HotChocolate.Language;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class SlotValueNameFilterTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string KarteQuery = """
        query Karte($kommuneId: UUID!, $filter: SlotValueFilterInput) {
          kommune(kommuneId: $kommuneId) {
            maengelAusfuehrungen {
              id
              slotValues(where: $filter) {
                slotName
                ... on PlainSlotValue { value }
              }
            }
          }
        }
        """;

    private const string EinzelQuery = """
        query Einzel($kommuneId: UUID!) {
          kommune(kommuneId: $kommuneId) {
            maengelAusfuehrungen {
              id
              adresse: slotValue(names: "adresse") { slotName ... on PlainSlotValue { value } }
              bilder: slotValue(names: "bilder") { slotName ... on PlainSlotValue { value } }
            }
          }
        }
        """;

    [Fact]
    public async Task Namensfilter_als_or_Liste_liefert_nur_den_Slot_mit_dem_letzten_Wert() {
        var seed = await SeedMangel();

        var slots = await QuerySlotValues(seed.OwnerToken, seed.AusfuehrungId, OrEq("adresse"));

        var adresse = Assert.Single(slots);
        Assert.Equal("adresse", adresse.SlotName);
        Assert.Equal("\"neu\"", adresse.Value);
    }

    [Fact]
    public async Task Namensfilter_in_liefert_alle_genannten_Slots() {
        var seed = await SeedMangel();

        var slots = await QuerySlotValues(seed.OwnerToken, seed.AusfuehrungId,
            new Dictionary<string, object?> { ["slotName"] = new Dictionary<string, object?> { ["in"] = new[] { "adresse", "bilder" } } });

        Assert.Equal(["adresse", "bilder"], slots.Select(s => s.SlotName).OrderBy(n => n));
    }

    [Fact]
    public async Task Fremder_sieht_nicht_freigegebenen_Slot_auch_mit_Namensfilter_nicht() {
        var seed = await SeedMangel(adresseFreigegeben: false);
        var fremderToken = await CreateBuergerToken();

        var fremd = await QuerySlotValues(fremderToken, seed.AusfuehrungId, OrEq("adresse"));
        var besitzer = await QuerySlotValues(seed.OwnerToken, seed.AusfuehrungId, OrEq("adresse"));

        Assert.Empty(fremd);
        Assert.Single(besitzer);
    }

    [Fact]
    public async Task Fremder_sieht_freigegebenen_Slot_mit_Namensfilter() {
        var seed = await SeedMangel(adresseFreigegeben: true);
        var fremderToken = await CreateBuergerToken();

        var fremd = await QuerySlotValues(fremderToken, seed.AusfuehrungId, OrEq("adresse"));

        Assert.Equal("adresse", Assert.Single(fremd).SlotName);
    }

    [Fact]
    public async Task Anderer_Filter_laeuft_weiter_ueber_den_vollen_Pfad() {
        var seed = await SeedMangel();

        var slots = await QuerySlotValues(seed.OwnerToken, seed.AusfuehrungId,
            new Dictionary<string, object?> { ["istFreigegeben"] = new Dictionary<string, object?> { ["eq"] = true } });

        Assert.Equal(["adresse", "bilder"], slots.Select(s => s.SlotName).OrderBy(n => n));
    }

    [Fact]
    public async Task Ohne_Filter_werden_alle_Slots_geliefert() {
        var seed = await SeedMangel();

        var slots = await QuerySlotValues(seed.OwnerToken, seed.AusfuehrungId, null);

        Assert.Equal(["adresse", "bilder"], slots.Select(s => s.SlotName).OrderBy(n => n));
    }

    [Fact]
    public async Task Mehrere_Maengel_in_einer_Abfrage_bekommen_jeweils_ihren_eigenen_Wert() {
        var a = await SeedMangel(adresseNeu: "adresse-a");
        var b = await SeedMangel(adresseNeu: "adresse-b");

        var result = await ExecuteGraphqlAsync(PrincipalFor(a.OwnerToken), KarteQuery, new Dictionary<string, object?> {
            ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
            ["filter"] = OrEq("adresse"),
        });

        Assert.Null(result.Errors);
        var maengel = AlleMaengel(result).ToDictionary(m => Guid.Parse((string)m["id"]));
        string AdresseVon(Guid id) => ((IEnumerable<object>)maengel[id]["slotValues"])
            .Cast<IReadOnlyDictionary<string, object>>().Single()["value"].ToString()!;
        Assert.Equal("adresse-a", AdresseVon(a.AusfuehrungId));
        Assert.Equal("adresse-b", AdresseVon(b.AusfuehrungId));
    }

    [Fact]
    public async Task Verschluesselter_Slot_wird_mit_Namensfilter_geliefert() {
        var seed = await SeedMangel(mitVerschluesseltem: true);

        var slots = await QuerySlotValues(seed.OwnerToken, seed.AusfuehrungId,
            new Dictionary<string, object?> { ["slotName"] = new Dictionary<string, object?> { ["in"] = new[] { "adresse", "geheim" } } });

        Assert.Equal(["adresse", "geheim"], slots.Select(s => s.SlotName).OrderBy(n => n));
    }

    [Fact]
    public async Task Inline_geschriebener_Filter_ohne_Variable_wird_ebenfalls_vorgefiltert() {
        var seed = await SeedMangel();
        const string query = """
            query($kommuneId: UUID!) {
              kommune(kommuneId: $kommuneId) {
                maengelAusfuehrungen {
                  id
                  slotValues(where: { or: [{ slotName: { eq: "adresse" } }] }) { slotName }
                }
              }
            }
            """;

        var result = await ExecuteGraphqlAsync(PrincipalFor(seed.OwnerToken), query,
            new Dictionary<string, object?> { ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id });

        Assert.Null(result.Errors);
        var eintrag = AlleMaengel(result).Single(m => Guid.Parse((string)m["id"]) == seed.AusfuehrungId);
        var slot = Assert.Single((IEnumerable<object>)eintrag["slotValues"]);
        Assert.Equal("adresse", ((IReadOnlyDictionary<string, object>)slot)["slotName"]);
    }

    [Fact]
    public async Task SlotValue_names_liefert_den_letzten_Wert_je_Name() {
        var seed = await SeedMangel();

        var result = await ExecuteGraphqlAsync(PrincipalFor(seed.OwnerToken), EinzelQuery,
            new Dictionary<string, object?> { ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id });

        Assert.Null(result.Errors);
        var eintrag = AlleMaengel(result).Single(m => Guid.Parse((string)m["id"]) == seed.AusfuehrungId);
        Assert.Equal("neu", ((IReadOnlyDictionary<string, object>)eintrag["adresse"])["value"]?.ToString());
        Assert.Equal("[\"foto\"]", NormalizeJson(((IReadOnlyDictionary<string, object>)eintrag["bilder"])["value"]));
    }

    [Fact]
    public async Task Dataloader_laedt_nur_angefragte_Slots_und_liefert_nur_angefragte_Schluessel() {
        var seed = await SeedMangel();
        await using var scope = Factory.Services.CreateAsyncScope();
        var factory = scope.ServiceProvider.GetRequiredService<IDbContextFactory<DomainContext>>();

        var result = await AusfuehrungExtensions.GetSlotValuesByAusfuehrungAndNameId(
            [(seed.AusfuehrungId, "adresse")], factory, CancellationToken.None);

        var (key, wert) = Assert.Single(result);
        Assert.Equal((seed.AusfuehrungId, "adresse"), key);
        Assert.Equal("neu", ((PlainSlotValue)wert).Value.GetString());
    }

    [Fact]
    public async Task Dataloader_ignoriert_Schluessel_ohne_Treffer() {
        var seed = await SeedMangel();
        await using var scope = Factory.Services.CreateAsyncScope();
        var factory = scope.ServiceProvider.GetRequiredService<IDbContextFactory<DomainContext>>();

        var result = await AusfuehrungExtensions.GetSlotValuesByAusfuehrungAndNameId(
            [(seed.AusfuehrungId, "gibt-es-nicht"), (Guid.NewGuid(), "adresse")], factory, CancellationToken.None);

        Assert.Empty(result);
    }

    [Theory]
    [InlineData("{ or: [{ slotName: { eq: \"adresse\" } }] }", new[] { "adresse" })]
    [InlineData("{ slotName: { eq: \"a\" } }", new[] { "a" })]
    [InlineData("{ slotName: { in: [\"a\", \"b\"] } }", new[] { "a", "b" })]
    [InlineData("{ or: [{ slotName: { eq: \"a\" } }, { slotName: { eq: \"b\" } }] }", new[] { "a", "b" })]
    [InlineData("{ or: [{ slotName: { eq: \"a\" } }, { slotName: { eq: \"a\" } }] }", new[] { "a" })]
    public void TryExtractNames_erkennt_reine_Namensfilter(string where, string[] erwartet) {
        var names = SlotNameFilter.TryExtractNames(Utf8GraphQLParser.Syntax.ParseValueLiteral(where));

        Assert.Equal(erwartet, names);
    }

    [Theory]
    [InlineData("{ and: [{ slotName: { eq: \"a\" } }] }")]
    [InlineData("{ slotName: { contains: \"a\" } }")]
    [InlineData("{ slotName: { eq: \"a\" }, istFreigegeben: { eq: true } }")]
    [InlineData("{ or: [{ slotName: { eq: \"a\" } }, { istFreigegeben: { eq: true } }] }")]
    [InlineData("{ or: [] }")]
    [InlineData("{ slotName: { in: [] } }")]
    [InlineData("{ slotName: { in: [1, 2] } }")]
    [InlineData("{ slotName: { eq: null } }")]
    [InlineData("{ istFreigegeben: { eq: true } }")]
    [InlineData("null")]
    public void TryExtractNames_gibt_null_bei_allem_anderen(string where) {
        Assert.Null(SlotNameFilter.TryExtractNames(Utf8GraphQLParser.Syntax.ParseValueLiteral(where)));
    }

    [Fact]
    public void TryExtractNames_gibt_null_ohne_Argument() {
        Assert.Null(SlotNameFilter.TryExtractNames(null));
    }

    private static Dictionary<string, object?> OrEq(string name) => new() {
        ["or"] = new[] {
            new Dictionary<string, object?> {
                ["slotName"] = new Dictionary<string, object?> { ["eq"] = name },
            },
        },
    };

    private record SlotErgebnis(string SlotName, string? Value);

    private async Task<List<SlotErgebnis>> QuerySlotValues(string token, Guid ausfuehrungId, Dictionary<string, object?>? filter) {
        var result = await ExecuteGraphqlAsync(PrincipalFor(token), KarteQuery, new Dictionary<string, object?> {
            ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
            ["filter"] = filter,
        });

        Assert.Null(result.Errors);
        var eintrag = AlleMaengel(result).Single(m => Guid.Parse((string)m["id"]) == ausfuehrungId);
        return ((IEnumerable<object>)eintrag["slotValues"])
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(s => new SlotErgebnis((string)s["slotName"], s.TryGetValue("value", out var v) ? NormalizeValue(v) : null))
            .ToList();
    }

    private static IEnumerable<IReadOnlyDictionary<string, object>> AlleMaengel(IQueryResult result) {
        var kommune = (IReadOnlyDictionary<string, object>)result.Data!["kommune"]!;
        return ((IEnumerable<object>)kommune["maengelAusfuehrungen"]).Cast<IReadOnlyDictionary<string, object>>();
    }

    private static string? NormalizeValue(object? v) => v is string s ? s : NormalizeJson(v);

    private static string NormalizeJson(object? v) => JsonSerializer.Serialize(v);

    private ClaimsPrincipal PrincipalFor(string token) {
        var jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);
        return new ClaimsPrincipal(new ClaimsIdentity(jwt.Claims, "jwt"));
    }

    private async Task<string> CreateBuergerToken() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        var buerger = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        await db.SaveChangesAsync();
        return new JwtSecurityTokenHandler().WriteToken(buerger.GetToken(jwtOptions));
    }

    private record Seed(Guid AusfuehrungId, string OwnerToken);

    private async Task<Seed> SeedMangel(bool adresseFreigegeben = true, string adresseNeu = "neu", bool mitVerschluesseltem = false) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;

        var owner = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(owner);
        await db.SaveChangesAsync();

        var prozessId = Guid.NewGuid();
        var tag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Mängelmelder" };
        var prozess = new Prozess {
            Id = prozessId,
            Name = "SlotValueNameFilterTests Prozess",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Tags = [tag],
            TagHistorie = [
                new ProzessTagHistorieEintrag {
                    Id = Guid.NewGuid(),
                    ProzessId = prozessId,
                    TagId = tag.Id,
                    ZugewiesenAm = SystemClock.Instance.GetCurrentInstant(),
                }
            ],
        };

        var formularSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            Titel = "Meldung",
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = [
                new StringFormularFeld { SlotName = "adresse", Order = 0, Encrypted = false, OeffentlichSichtbar = true },
            ],
        };
        var endeSchritt = new EndeSchritt {
            Id = Guid.NewGuid(),
            Titel = "Ende",
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var verbindung = new Verbindung { Id = Guid.NewGuid(), Von = formularSchritt, Nach = endeSchritt, StatusAenderung = "weiter" };
        formularSchritt.Verbindungen.Add(verbindung);

        var jetzt = SystemClock.Instance.GetCurrentInstant();
        var version = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = jetzt,
            PublishedAt = jetzt,
            Beschreibungstext = "test",
            Schritte = [formularSchritt, endeSchritt],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();
        version.StartId = formularSchritt.Id;

        var sharedKey = RandomNumberGenerator.GetBytes(32);
        var ausfuehrungId = Guid.NewGuid();

        Bearbeitung Bearbeitung(Instant zeit, params SlotValue[] slotValues) => new() {
            Id = Guid.NewGuid(),
            SchrittId = formularSchritt.Id,
            UserId = owner.Id,
            CreatedAt = zeit,
            NextVerbindungId = verbindung.Id,
            WarZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            SlotValues = slotValues,
        };

        PlainSlotValue Plain(string name, JsonNode wert, bool freigegeben) => new() {
            Id = Guid.NewGuid(),
            SlotName = name,
            Value = wert.ToJsonElement(),
            IstFreigegeben = freigegeben,
        };

        SlotValue[] verschluesselt = mitVerschluesseltem
            ? [new EncryptedSlotValue { Id = Guid.NewGuid(), SlotName = "geheim", Value = new EncryptedValue("n", "t", "c"), IstFreigegeben = true }]
            : [];

        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = ausfuehrungId,
            ProzessVersionId = version.Id,
            UserId = owner.Id,
            CreatedAt = jetzt,
            Status = AusfuehrungStatus.BearbeitungDurchKommune,
            SchrittId = endeSchritt.Id,
            SharedKeyEncryptedForBuerger = Convert.ToBase64String(
                BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune = Convert.ToBase64String(
                KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Followers = [],
            Bearbeitungen = [
                Bearbeitung(jetzt - Duration.FromMinutes(10), [
                    Plain("adresse", JsonValue.Create("alt")!, adresseFreigegeben),
                    Plain("bilder", new JsonArray { JsonValue.Create("foto") }, true),
                    .. verschluesselt,
                ]),
                Bearbeitung(jetzt - Duration.FromMinutes(5),
                    Plain("adresse", JsonValue.Create(adresseNeu)!, adresseFreigegeben)),
            ],
        });
        await db.SaveChangesAsync();

        return new Seed(ausfuehrungId, new JwtSecurityTokenHandler().WriteToken(owner.GetToken(jwtOptions)));
    }
}
