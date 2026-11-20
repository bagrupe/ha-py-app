using System.Net;
using System.Security.Claims;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Features.PushNotifications;
using API.Infrastructure;
using API.Options;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class AusfuehrungPushNotificationsTest(BackendApiFactory factory) : GraphQLTests(factory) {
    public const string AusfuehrungErstellenMutation =
        """
        mutation AusfuehrungErstellen($input: AusfuehrungCreateInput!) {
          ausfuehrungCreate(input: $input) {
            ausfuehrungResult {
              ausfuehrung {
                id
                prozessVersion {
                  prozess {
                    kommune {
                      maengelAusfuehrungen {
                        id
                      }
                    }
                  }
                }
              }
              shouldContinue
            }
          }
        }
        """;

    private const string AusfuehrungContinueMutation =
        """
        mutation AusfuehrungContinue($input: AusfuehrungContinueInput!) {
        ausfuehrungContinue(input: $input) {
            ausfuehrungResult {
            ausfuehrung {
                id
            }
            }
        }
        }
        """;

    private const string AusfuehrungUpdateZugewiesenePersonMutation =
        """
        mutation AusfuehrungUpdateZugewiesenePerson(
          $ausfuehrungId: UUID!
          $userId: UUID!
        ) {
          ausfuehrungUpdateZugewiesenePerson(
            input: { ausfuehrungId: $ausfuehrungId, userId: $userId }
          ) {
            ausfuehrung {
              id
            }
          }
        }
        """;

    [Fact]
    public async Task MaengelMelderSubscriptionAndPush() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (buergerEntity, buergerPrincipal) =
            await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var prozessVersionId = Guid.NewGuid();
        var prozessId = Guid.NewGuid();
        var endeSchrittId = Guid.NewGuid();

        var maengelTag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Mängelmelder" };
        var prozess = new Prozess {
            Id = prozessId,
            Name = "Push notification test (Mängelmelder)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        prozess.Tags.Add(maengelTag);
        prozess.TagHistorie.Add(new ProzessTagHistorieEintrag {
            Id = Guid.NewGuid(),
            ProzessId = prozessId,
            TagId = maengelTag.Id,
            ZugewiesenAm = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
        });

        var prozessVersion = new ProzessVersion {
            Id = prozessVersionId,
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            Beschreibungstext = (StringExpression)"Antrag",
        };

        var startSchritt = new FormularSchritt {
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    SlotName = "foo",
                    Order = 0
                }
            }
        };


        var endeSchritt = new EndeSchritt {
            Id = endeSchrittId,
            ProzessVersion = prozessVersion,
            ProzessVersionId = prozessVersionId,
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };

        prozessVersion.Schritte.Add(startSchritt);
        prozessVersion.Schritte.Add(endeSchritt);


        var verbindung = new Verbindung {
            Von = startSchritt,
            Nach = endeSchritt,
            StatusAenderung = "Status Änderung",
            StatusAenderungBeschreibung = "Status Änderung Beschreibung"
        };

        startSchritt.Verbindungen.Add(verbindung);

        await db.ProzessVersionen.AddAsync(prozessVersion);
        await db.SaveChangesAsync();

        prozessVersion.Start = startSchritt;
        await db.SaveChangesAsync();

        var input = new Dictionary<string, object?> {
            ["prozessVersionId"] = prozessVersionId,
            ["sharedKeyEncryptedForBuerger"] = "foo",
            ["sharedKeyEncryptedForKommune"] = "bar",
            ["bearbeitungen"] = new List<Dictionary<string, object?>>(),
        };

        var firebase = Factory.Services.GetService<IFirebasePushMessagingService>() as RecordingFirebasePushMessagingService;
        firebase!.Reset();

        var result = await ExecuteQuery(buergerPrincipal, AusfuehrungErstellenMutation, input);
        Assert.Null(result.Errors);
        var aufuehrungCreateResult = result.Data!["ausfuehrungCreate"] as IReadOnlyDictionary<string, object>;
        var ausfuehrungResult = aufuehrungCreateResult!["ausfuehrungResult"] as IReadOnlyDictionary<string, object>;
        var ausfuehrung = ausfuehrungResult!["ausfuehrung"] as IReadOnlyDictionary<string, object>;
        var ausfuehrungId = Guid.Parse(ausfuehrung!["id"].ToString());

        var environmentOptions = Factory.Services.GetService<IOptions<EnvironmentOptions>>();
        var topic = new PushTopic.Mangel(environmentOptions!.Value.Name, ausfuehrungId).ToString();

        Assert.Contains(buergerEntity.PushNotificationTokens[0], firebase!.Subscriptions[topic]);


        var continueInput = new Dictionary<string, object?> {
            ["ausfuehrungId"] = ausfuehrungId,
            ["bearbeitungen"] = new List<Dictionary<string, object?>>(),
        };
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        // var continueResult = await ExecuteQuery(superAdmin, AusfuehrungContinueMutation, continueInput);


        var continueResult = await ExecuteQuery(superAdmin, AusfuehrungContinueMutation, new Dictionary<string, object?> {
            ["ausfuehrungId"] = ausfuehrungId,
            ["bearbeitungen"] = new List<Dictionary<string, object?>> {
                new() {
                    ["nextVerbindungId"] = verbindung.Id,
                    ["schrittId"] = startSchritt.Id,
                    ["slotValues"] = new List<Dictionary<string, object?>>(),
                },
            },
            ["naechsteIstZustaendigkeit"] = null,
        });
        Assert.Null(continueResult.Errors);


        var message = Assert.Single(firebase.Messages);
        Assert.Equal(topic, message.Topic);
        Assert.Equal(verbindung.StatusAenderung, message.Notification.Title);
        Assert.Equal(verbindung.StatusAenderungBeschreibung, message.Notification.Body);
    }

    [Fact]
    public async Task PushForOtherAntraege() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var (prozessVersionId, startSchritt, verbindung) = await testSeeder.CreateProzess(db, "Statusänderung");

        var (buergerEntity, buergerPrincipal) =
        await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var (firebase, ausfuehrungId) = await CreateAusfuehrung(prozessVersionId, buergerPrincipal);

        var environmentOptions = Factory.Services.GetService<IOptions<EnvironmentOptions>>();
        var topic = new PushTopic.Ausfuehrung(environmentOptions!.Value.Name, ausfuehrungId).ToString();

        Assert.Contains(buergerEntity.PushNotificationTokens[0], firebase!.Subscriptions[topic]);

        await ContinueAusfuehrung(db, startSchritt, verbindung, ausfuehrungId);

        var message = firebase.Messages.Last();
        Assert.Equal(topic, message.Topic);
        Assert.Equal(verbindung.StatusAenderung, message.Notification.Title);
        Assert.Equal(verbindung.StatusAenderungBeschreibung, message.Notification.Body);
    }

    [Fact]
    public async Task NoPushForOtherAntraegeWithoutStatusaenderung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var (prozessVersionId, startSchritt, verbindung) = await testSeeder.CreateProzess(db, "");

        var (buergerEntity, buergerPrincipal) =
        await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);

        var (firebase, ausfuehrungId) = await CreateAusfuehrung(prozessVersionId, buergerPrincipal);

        var environmentOptions = Factory.Services.GetService<IOptions<EnvironmentOptions>>();
        var topic = new PushTopic.Ausfuehrung(environmentOptions!.Value.Name, ausfuehrungId).ToString();

        Assert.Contains(buergerEntity.PushNotificationTokens[0], firebase!.Subscriptions[topic]);

        await ContinueAusfuehrung(db, startSchritt, verbindung, ausfuehrungId);

        Assert.Empty(firebase.Messages);
    }


    private async Task ContinueAusfuehrung(DomainContext db, FormularSchritt startSchritt, Verbindung verbindung, Guid ausfuehrungId) {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);

        var zugewiesenResult = await ExecuteGraphqlAsync(superAdmin, AusfuehrungUpdateZugewiesenePersonMutation,
            new Dictionary<string, object?> {
                ["ausfuehrungId"] = ausfuehrungId,
                ["userId"] = superAdminEntity.Id,
            });
        Assert.Null(zugewiesenResult.Errors);

        // status Änderung: FormularSchritt → Verbindung → EndeSchritt
        var continueResult = await ExecuteQuery(superAdmin, AusfuehrungContinueMutation, new Dictionary<string, object?> {
            ["ausfuehrungId"] = ausfuehrungId,
            ["bearbeitungen"] = new List<Dictionary<string, object?>> {
                new() {
                    ["nextVerbindungId"] = verbindung.Id,
                    ["schrittId"] = startSchritt.Id,
                    ["slotValues"] = new List<Dictionary<string, object?>>(),
                },
            },
            ["naechsteIstZustaendigkeit"] = null,
        });
        Assert.Null(continueResult.Errors);
    }

    private async Task<(RecordingFirebasePushMessagingService firebase, Guid ausfuehrungId)> CreateAusfuehrung(Guid prozessVersionId, ClaimsPrincipal buergerPrincipal) {
        var input = new Dictionary<string, object?> {
            ["prozessVersionId"] = prozessVersionId,
            ["sharedKeyEncryptedForBuerger"] = "foo",
            ["sharedKeyEncryptedForKommune"] = "bar",
            ["bearbeitungen"] = new List<Dictionary<string, object?>>(),
        };

        var firebase = Factory.Services.GetService<IFirebasePushMessagingService>() as RecordingFirebasePushMessagingService;
        firebase!.Reset();

        var result = await ExecuteQuery(buergerPrincipal, AusfuehrungErstellenMutation, input);
        Assert.Null(result.Errors);
        var aufuehrungCreateResult = result.Data!["ausfuehrungCreate"] as IReadOnlyDictionary<string, object>;
        var ausfuehrungResult = aufuehrungCreateResult!["ausfuehrungResult"] as IReadOnlyDictionary<string, object>;
        var ausfuehrung = ausfuehrungResult!["ausfuehrung"] as IReadOnlyDictionary<string, object>;
        var ausfuehrungId = Guid.Parse(ausfuehrung!["id"].ToString());
        return (firebase, ausfuehrungId);
    }

}
