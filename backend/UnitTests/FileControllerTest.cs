using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text.Json.Nodes;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Prozess;
using API.Infrastructure;
using API.Options;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// Regression coverage for the authorization gap flagged in review on MR !255: <c>FileController</c> used to
/// serve any slot value's image purely by knowing its (unguessable) id, regardless of
/// <see cref="SlotValue.IstFreigegeben"/> or who was asking. It now requires either an approved image, or that the
/// caller is the Ausführung's own Bürger or a Backoffice-Nutzer of the responsible Kommune.
/// </summary>
[Collection("Api Tests")]
public class FileControllerTest(BackendApiFactory factory) : GraphQLTests(factory) {
    [Fact]
    public async Task Get_ohne_Freigabe_und_ohne_Auth_liefert_NotFound() {
        var (slotValueId, _) = await SeedBildSlotValue(istFreigegeben: false);

        var response = await Factory.CreateClient().GetAsync($"/api/file/{slotValueId}/100");

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task Get_ohne_Freigabe_als_Ersteller_liefert_Bild() {
        var (slotValueId, ownerToken) = await SeedBildSlotValue(istFreigegeben: false);

        var client = Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ownerToken);
        var response = await client.GetAsync($"/api/file/{slotValueId}/100");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Get_ohne_Freigabe_als_fremder_Buerger_liefert_NotFound() {
        var (slotValueId, _) = await SeedBildSlotValue(istFreigegeben: false);
        var fremderToken = await CreateBuergerTokenAsync();

        var client = Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", fremderToken);
        var response = await client.GetAsync($"/api/file/{slotValueId}/100");

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task Get_ohne_Freigabe_als_zustaendiges_Backoffice_liefert_Bild() {
        var (slotValueId, _) = await SeedBildSlotValue(istFreigegeben: false);
        var backofficeToken = await CreateBackofficeTokenAsync(KommuneSeeder.LandkreisHaPy.Id);

        var client = Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", backofficeToken);
        var response = await client.GetAsync($"/api/file/{slotValueId}/100");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Get_ohne_Freigabe_als_Backoffice_fremder_Kommune_liefert_NotFound() {
        var (slotValueId, _) = await SeedBildSlotValue(istFreigegeben: false);
        var fremdeKommuneId = Guid.NewGuid();
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            db.Kommunen.Add(new API.Features.Kommune.Kommune {
                Id = fremdeKommuneId,
                Name = $"Fremde Kommune {Guid.NewGuid():N}",
            });
            await db.SaveChangesAsync();
        }
        var backofficeToken = await CreateBackofficeTokenAsync(fremdeKommuneId);

        var client = Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", backofficeToken);
        var response = await client.GetAsync($"/api/file/{slotValueId}/100");

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task Get_mit_Freigabe_liefert_Bild_auch_ohne_Auth() {
        var (slotValueId, _) = await SeedBildSlotValue(istFreigegeben: true);

        var response = await Factory.CreateClient().GetAsync($"/api/file/{slotValueId}/100");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Get_mit_Freigabe_aber_nicht_oeffentlich_sichtbar_ohne_Auth_liefert_NotFound() {
        var (slotValueId, _) = await SeedBildSlotValue(istFreigegeben: true, oeffentlichSichtbar: false);

        var response = await Factory.CreateClient().GetAsync($"/api/file/{slotValueId}/100");

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task Get_mit_Freigabe_aber_nicht_oeffentlich_sichtbar_als_Ersteller_liefert_Bild() {
        var (slotValueId, ownerToken) = await SeedBildSlotValue(istFreigegeben: true, oeffentlichSichtbar: false);

        var client = Factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", ownerToken);
        var response = await client.GetAsync($"/api/file/{slotValueId}/100");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    private async Task<string> CreateBuergerTokenAsync() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;

        var buerger = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        await db.SaveChangesAsync();

        return new JwtSecurityTokenHandler().WriteToken(buerger.GetToken(jwtOptions));
    }

    private async Task<string> CreateBackofficeTokenAsync(Guid kommuneId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;

        var backofficeUser = new BackofficeUser {
            EMail = $"{Guid.NewGuid():N}@example.com",
            KommuneId = kommuneId,
            Art = BackofficeNutzerArt.Nutzer,
            OrganisationPrivateKey = "placeholder",
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        db.BackofficeUser.Add(backofficeUser);
        await db.SaveChangesAsync();

        return new JwtSecurityTokenHandler().WriteToken(backofficeUser.GetToken(jwtOptions));
    }

    /// <summary>
    /// Seeds a minimal Ideenmelder Ausführung with a single "bilder" PlainSlotValue and returns its id together
    /// with a bearer token for the Bürger that created it.
    /// </summary>
    private async Task<(Guid slotValueId, string ownerToken)> SeedBildSlotValue(
        bool istFreigegeben, bool oeffentlichSichtbar = true) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;

        var owner = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(owner);
        await db.SaveChangesAsync();

        var fileControllerTestProzessId = Guid.NewGuid();
        var ideenmelderTag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Ideenmelder" };
        var prozess = new Prozess {
            Id = fileControllerTestProzessId,
            Name = "FileControllerTest Prozess",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Tags = [ideenmelderTag],
            TagHistorie = [
                new ProzessTagHistorieEintrag {
                    Id = Guid.NewGuid(),
                    ProzessId = fileControllerTestProzessId,
                    TagId = ideenmelderTag.Id,
                    ZugewiesenAm = SystemClock.Instance.GetCurrentInstant(),
                }
            ],
        };

        var bildSchrittId = Guid.NewGuid();
        var bildSchritt = new FormularSchritt {
            Id = bildSchrittId,
            Titel = "Bild",
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = [
                new UploadFormularFeld {
                    Id = Guid.NewGuid(),
                    SlotName = "bilder",
                    Order = 0,
                    Encrypted = false,
                    OeffentlichSichtbar = oeffentlichSichtbar,
                },
            ],
        };
        var endeSchrittId = Guid.NewGuid();
        var endeSchritt = new EndeSchritt {
            Id = endeSchrittId,
            Titel = "Ende",
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var verbindung = new Verbindung {
            Id = Guid.NewGuid(),
            Von = bildSchritt,
            Nach = endeSchritt,
            StatusAenderung = "weiter",
        };
        bildSchritt.Verbindungen.Add(verbindung);

        var instant = SystemClock.Instance.GetCurrentInstant();
        var version = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = "test",
            Schritte = [bildSchritt, endeSchritt],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        // ProzessVersion.StartId and Schritt.ProzessVersionId reference each other, so both can't be
        // inserted in the same batch (circular FK) - set StartId only after the initial insert,
        // mirroring AusfuehrungQueriesTest.EnsureTestProzessVersionUndSchritt.
        await db.SaveChangesAsync();
        version.StartId = bildSchrittId;

        var sharedKey = RandomNumberGenerator.GetBytes(32);
        var slotValueId = Guid.NewGuid();

        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = Guid.NewGuid(),
            ProzessVersionId = version.Id,
            UserId = owner.Id,
            CreatedAt = instant,
            Status = AusfuehrungStatus.BearbeitungDurchKommune,
            SchrittId = endeSchrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Followers = [],
            Bearbeitungen = [
                new Bearbeitung {
                    Id = Guid.NewGuid(),
                    SchrittId = bildSchrittId,
                    UserId = owner.Id,
                    CreatedAt = instant,
                    NextVerbindungId = verbindung.Id,
                    WarZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
                    SlotValues = [
                        new PlainSlotValue {
                            Id = slotValueId,
                            SlotName = "bilder",
                            Value = new JsonArray {
                                JsonValue.Create(Convert.ToBase64String("not-a-real-image"u8.ToArray())),
                            }.ToJsonElement(),
                            IstFreigegeben = istFreigegeben,
                        },
                    ],
                },
            ],
        });

        await db.SaveChangesAsync();

        var ownerToken = new JwtSecurityTokenHandler().WriteToken(owner.GetToken(jwtOptions));
        return (slotValueId, ownerToken);
    }
}
