using API.Features;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

/// <summary>Proves <see cref="StringFormularFeldOption.IstRelevant"/> survives a real jsonb round trip via a fresh <see cref="DomainContext"/> (bypassing the change tracker), not just an in-memory echo.</summary>
[Collection("Api Tests")]
public class StringFormularFeldOptionIstRelevantTest(BackendApiFactory factory) : GraphQLTests(factory) {
    [Fact]
    public async Task IstRelevant_on_an_option_round_trips_through_the_jsonb_column() {
        var prozessId = Guid.NewGuid();
        var schrittId = Guid.NewGuid();
        const string expression = "isInside('BadMuender', slot('adresse')) == false";

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

            var prozess = new Prozess { Id = prozessId, Name = "IstRelevant-Option-Test", KommuneId = KommuneSeeder.LandkreisHaPy.Id };
            var prozessVersion = new ProzessVersion {
                Id = Guid.NewGuid(),
                Prozess = prozess,
                CreatedAt = Instant.FromUtc(2026, 9, 18, 0, 0, 0),
                Beschreibungstext = (StringExpression)"Test",
            };
            var schritt = new FormularSchritt {
                Id = schrittId,
                Titel = "Kategorie",
                NodePosition = new NodePosition { X = 0, Y = 0 },
                SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
                Felder = new List<FormularFeld> {
                    new StringFormularFeld {
                        SlotName = "kategorie", AngezeigterName = "Kategorie", Order = 0, Encrypted = false,
                        Options = [
                            new StringFormularFeldOption("Grünflächen", "Grünflächen", new BoolExpression(expression)),
                            new StringFormularFeldOption("Straßen"),
                        ],
                    },
                },
            };
            prozessVersion.Schritte.Add(schritt);
            db.Prozesse.Add(prozess);
            db.ProzessVersionen.Add(prozessVersion);
            await db.SaveChangesAsync();
        }

        await using var freshScope = Factory.Services.CreateAsyncScope();
        var freshDb = freshScope.ServiceProvider.GetRequiredService<DomainContext>();

        var reloaded = await freshDb.FormularSchritte
            .Where(s => s.Id == schrittId)
            .Select(s => s.Felder.OfType<StringFormularFeld>().First())
            .FirstAsync();

        var mitAusdruck = reloaded.Options.Single(o => o.Key == "Grünflächen");
        var ohneAusdruck = reloaded.Options.Single(o => o.Key == "Straßen");

        Assert.NotNull(mitAusdruck.IstRelevant);
        Assert.Equal(expression, mitAusdruck.IstRelevant!.ExpressionString);
        Assert.Null(ohneAusdruck.IstRelevant);
    }
}
