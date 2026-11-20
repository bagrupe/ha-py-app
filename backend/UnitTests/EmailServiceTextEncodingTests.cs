using API.Features;
using API.Features.Email;
using API.Features.Email.Templates;
using API.Seeders;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class EmailServiceTextEncodingTests(BackendApiFactory factory) {
    [Fact]
    public async Task Text_part_is_decoded_while_the_html_part_stays_encoded() {
        await using var scope = factory.Services.CreateAsyncScope();
        var emailService = scope.ServiceProvider.GetRequiredService<EmailService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        await emailService.AddMailToOutboxAsync<MaengelMeldungEmail, MaengelMeldungEmailText>(
            db,
            ["empfaenger@example.com"],
            "Betreff",
            KommuneSeeder.LandkreisHaPy.Id,
            new Dictionary<string, object> {
                ["Message"] = "Nachricht",
                ["ProzessName"] = "Mängelmelder & Co",
                ["Organisationseinheit"] = "Hameln",
                ["Abteilung"] = "Abt. 53",
                ["Datum"] = "04.11.2026",
            });

        var item = Assert.Single(db.ChangeTracker.Entries<EmailOutboxItem>()).Entity;

        Assert.Contains("Mängelmelder & Co", item.Text);
        Assert.DoesNotContain("&#x", item.Text);
        Assert.DoesNotContain("&amp;", item.Text);
        Assert.Contains("M&#xE4;ngelmelder &amp; Co", item.Html);
    }

    [Fact]
    public async Task A_value_that_looks_like_an_entity_is_decoded_only_once() {
        await using var scope = factory.Services.CreateAsyncScope();
        var emailService = scope.ServiceProvider.GetRequiredService<EmailService>();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        await emailService.AddMailToOutboxAsync<MaengelMeldungEmail, MaengelMeldungEmailText>(
            db,
            ["empfaenger@example.com"],
            "Betreff",
            KommuneSeeder.LandkreisHaPy.Id,
            new Dictionary<string, object> {
                ["Message"] = "Nachricht",
                ["ProzessName"] = "A &amp; B",
                ["Organisationseinheit"] = "Hameln",
                ["Abteilung"] = "Abt. 53",
                ["Datum"] = "04.11.2026",
            });

        var item = Assert.Single(db.ChangeTracker.Entries<EmailOutboxItem>()).Entity;

        Assert.Contains("A &amp; B", item.Text);
        Assert.Contains("A &amp;amp; B", item.Html);
    }
}
