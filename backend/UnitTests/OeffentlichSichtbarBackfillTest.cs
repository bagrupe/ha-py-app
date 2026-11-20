using API.Features;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

/// <summary>#430: the backfill marks the app-visible slots of public processes and nothing else.</summary>
[Collection("Api Tests")]
public class OeffentlichSichtbarBackfillTest(BackendApiFactory factory) : GraphQLTests(factory) {
    [Fact]
    public async Task Backfill_marks_listed_slots_of_public_processes_only() {
        var publicFelder = await SeedProzess(isPublic: true);
        var privateFelder = await SeedProzess(isPublic: false);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await db.Database.ExecuteSqlRawAsync(OeffentlichSichtbarBackfill.Sql);

        Assert.True(await FlagOf(db, publicFelder["titel"]));
        Assert.True(await FlagOf(db, publicFelder["bilder"]));
        Assert.False(await FlagOf(db, publicFelder["vorname"]));
        Assert.False(await FlagOf(db, privateFelder["titel"]));
    }

    private static Task<bool> FlagOf(DomainContext db, Guid feldId) =>
        db.Set<FormularFeld>().Where(f => f.Id == feldId).Select(f => f.OeffentlichSichtbar).SingleAsync();

    private async Task<Dictionary<string, Guid>> SeedProzess(bool isPublic) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var instant = Instant.FromUtc(2026, 6, 30, 12, 0, 0);
        var prozessId = Guid.NewGuid();
        var tag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Mängelmelder" };
        var feldIds = new Dictionary<string, Guid> {
            ["titel"] = Guid.NewGuid(),
            ["bilder"] = Guid.NewGuid(),
            ["vorname"] = Guid.NewGuid(),
        };

        var formularSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            Titel = "Meldung",
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = [
                new StringFormularFeld { Id = feldIds["titel"], SlotName = "titel", Order = 0, Encrypted = false },
                new UploadFormularFeld { Id = feldIds["bilder"], SlotName = "bilder", Order = 1, Encrypted = false },
                new StringFormularFeld { Id = feldIds["vorname"], SlotName = "vorname", Order = 2, Encrypted = false },
            ],
        };

        db.ProzessVersionen.Add(new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = new Prozess {
                Id = prozessId,
                Name = isPublic ? "#430 backfill public" : "#430 backfill private",
                KommuneId = KommuneSeeder.LandkreisHaPy.Id,
                Tags = isPublic ? [tag] : [],
                TagHistorie = isPublic
                    ? [new ProzessTagHistorieEintrag { Id = Guid.NewGuid(), ProzessId = prozessId, TagId = tag.Id, ZugewiesenAm = instant }]
                    : [],
            },
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = new StringExpression("slot('titel')"),
            Schritte = [formularSchritt],
        });
        await db.SaveChangesAsync();
        return feldIds;
    }
}
