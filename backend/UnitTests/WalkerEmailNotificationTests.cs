using System.Text.Json.Nodes;
using API.Features;
using API.Features.Auth;
using API.Features.Dienstleistungen;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// Covers department (#357), Dienstleister and runtime-resolved (#256) recipients by walking a minimal Prozess.
/// </summary>
[Collection("Api Tests")]
public class WalkerEmailNotificationTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid KommuneId = KommuneSeeder.LandkreisHaPy.Id;

    [Fact]
    public async Task Step_creates_one_outbox_item_per_address_on_the_abteilung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var organisationseinheit = AddOrganisationseinheit(db);
        var testGruppe = AddMitarbeiterGruppe(db, ["erste@example.com", "zweite@example.com"]);

        await StepFromBuergerStartInto(scope, db, new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = organisationseinheit.Id,
                MitarbeiterGruppeId = testGruppe.Id,
            },
        }, null, true, "erste@example.com", "zweite@example.com");
    }

    [Fact]
    public async Task Step_mails_the_dienstleister_of_a_dienstleister_schritt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var dienstleister = AddDienstleister(db, ["dienstleister-a@example.com", "dienstleister-b@example.com"]);

        await StepFromBuergerStartInto(scope, db, new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Dienstleister,
                DienstleisterId = dienstleister.Id,
            },
        }, null, true, "dienstleister-a@example.com", "dienstleister-b@example.com");
    }

    [Fact]
    public async Task SaveChanges_mails_an_intermediate_schritt_after_a_later_step_in_the_same_walker() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var organisationseinheit = AddOrganisationseinheit(db);
        var gruppe = AddMitarbeiterGruppe(db, ["zwischen-schritt@example.com"]);

        var startSchritt = BuergerFormularSchritt();
        var mailedSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = organisationseinheit.Id,
                MitarbeiterGruppeId = gruppe.Id,
            },
        };
        var laterSchritt = BuergerFormularSchritt();

        var toMailed = new Verbindung { Von = startSchritt, Nach = mailedSchritt };
        var toLater = new Verbindung { Von = mailedSchritt, Nach = laterSchritt };
        startSchritt.Verbindungen.Add(toMailed);
        mailedSchritt.Verbindungen.Add(toLater);

        var prozessVersion = await AddProzessVersion(db, [startSchritt, mailedSchritt, laterSchritt], startSchritt.Id);

        await using var walker = await StartAusfuehrung(scope, prozessVersion);
        walker.Step(walker.Ausfuehrung.UserId, toMailed.Id, [], null);
        walker.Step(walker.Ausfuehrung.UserId, toLater.Id, [], null);
        await walker.SaveChangesAsync();

        Assert.Equal(["zwischen-schritt@example.com"], await SentAddresses(prozessVersion.Prozess.Name));
    }

    [Fact]
    public async Task Step_without_SaveChanges_does_not_queue_mail() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var organisationseinheit = AddOrganisationseinheit(db);
        var gruppe = AddMitarbeiterGruppe(db, ["unpersistiert@example.com"]);

        await StepFromBuergerStartInto(scope, db, new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = organisationseinheit.Id,
                MitarbeiterGruppeId = gruppe.Id,
            },
        }, null, saveChanges: false);
    }

    [Fact]
    public async Task EvaluateSendMail_mails_the_dienstleister_chosen_at_runtime_on_a_dynamic_schritt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var dienstleister = AddDienstleister(db, ["dynamisch-dienstleister@example.com"]);

        await StepIntoDynamicSchritt(scope, db, [ZustaendigkeitArt.Dienstleister], new Zustaendigkeit {
            Art = ZustaendigkeitArt.Dienstleister,
            DienstleisterId = dienstleister.Id,
        }, "dynamisch-dienstleister@example.com");
    }

    [Fact]
    public async Task EvaluateSendMail_mails_the_abteilung_chosen_at_runtime_on_a_dynamic_schritt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var organisationseinheit = AddOrganisationseinheit(db);
        var gruppe = AddMitarbeiterGruppe(db, ["dynamisch-abteilung@example.com"]);

        await StepIntoDynamicSchritt(scope, db, [ZustaendigkeitArt.Organisationseinheit], new Zustaendigkeit {
            Art = ZustaendigkeitArt.Organisationseinheit,
            OrganisationseinheitId = organisationseinheit.Id,
            MitarbeiterGruppeId = gruppe.Id,
        }, "dynamisch-abteilung@example.com");
    }

    [Fact]
    public async Task Mail_names_the_responsible_organisationseinheit_and_abteilung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var organisationseinheit = AddOrganisationseinheit(db);
        var gruppe = AddMitarbeiterGruppe(db, ["namen@example.com"]);

        var prozessName = await StepFromBuergerStartIntoAndReturnProzessName(scope, db, new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = organisationseinheit.Id,
                MitarbeiterGruppeId = gruppe.Id,
            },
        });

        var html = Assert.Single(await SentHtml(prozessName));
        Assert.Contains(organisationseinheit.Name, html);
        Assert.Contains(gruppe.Name, html);
        Assert.Contains("/impressum\"", html);
        Assert.Contains("/datenschutz\"", html);
        Assert.DoesNotContain("cid:", html);
    }

    [Fact]
    public async Task Mail_names_the_dienstleister_when_a_dienstleister_is_responsible() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var dienstleister = AddDienstleister(db, ["dienstleister-name@example.com"]);

        var prozessName = await StepFromBuergerStartIntoAndReturnProzessName(scope, db, new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Dienstleister,
                DienstleisterId = dienstleister.Id,
            },
        });

        Assert.Contains(dienstleister.Name, Assert.Single(await SentHtml(prozessName)));
    }

    [Fact]
    public async Task Mail_lists_only_public_unencrypted_fields_and_never_other_stored_values() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var organisationseinheit = AddOrganisationseinheit(db);
        var gruppe = AddMitarbeiterGruppe(db, ["angaben@example.com"]);

        var startSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld> {
                new StringFormularFeld {
                    AngezeigterName = "Titel", SlotName = "titel", Order = 0, Encrypted = false,
                    OeffentlichSichtbar = true,
                },
                new StringFormularFeld {
                    AngezeigterName = "IBAN", SlotName = "iban", Order = 1, Encrypted = false,
                },
                new StringFormularFeld {
                    AngezeigterName = "Geheim", SlotName = "geheim", Order = 2, Encrypted = true,
                    OeffentlichSichtbar = true,
                },
            },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var nextSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = organisationseinheit.Id,
                MitarbeiterGruppeId = gruppe.Id,
            },
        };
        var verbindung = new Verbindung { Von = startSchritt, Nach = nextSchritt };
        startSchritt.Verbindungen.Add(verbindung);
        var prozessVersion = await AddProzessVersion(db, [startSchritt, nextSchritt], startSchritt.Id);

        await using var walker = await StartAusfuehrung(scope, prozessVersion);
        walker.Step(walker.Ausfuehrung.UserId, verbindung.Id, [
            new SlotValuesInput("titel", JsonValue.Create("Schlagloch Hauptstrasse")),
            new SlotValuesInput("iban", JsonValue.Create("DE00123456789")),
            new SlotValuesInput("geheim", new EncryptedValue("nonce", "tag", "cipher")),
        ], null);
        await walker.SaveChangesAsync();

        var html = Assert.Single(await SentHtml(prozessVersion.Prozess.Name));
        Assert.Contains("Schlagloch Hauptstrasse", html);
        Assert.DoesNotContain("DE00123456789", html);
        Assert.DoesNotContain("IBAN", html);
        Assert.DoesNotContain("Geheim", html);
    }

    [Fact]
    public async Task Mail_truncates_long_angaben_and_lists_a_slot_used_by_two_steps_once() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var organisationseinheit = AddOrganisationseinheit(db);
        var gruppe = AddMitarbeiterGruppe(db, ["abschneiden@example.com"]);

        StringFormularFeld TitelFeld() => new() {
            AngezeigterName = "Titel",
            SlotName = "titel",
            Order = 0,
            Encrypted = false,
            OeffentlichSichtbar = true,
            Pflichtfeld = false,
        };
        var ersterSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld> { TitelFeld() },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var zweiterSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld> { TitelFeld() },
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = organisationseinheit.Id,
                MitarbeiterGruppeId = gruppe.Id,
            },
        };
        var verbindung = new Verbindung { Von = ersterSchritt, Nach = zweiterSchritt };
        ersterSchritt.Verbindungen.Add(verbindung);
        var prozessVersion = await AddProzessVersion(db, [ersterSchritt, zweiterSchritt], ersterSchritt.Id);

        await using var walker = await StartAusfuehrung(scope, prozessVersion);
        walker.Step(walker.Ausfuehrung.UserId, verbindung.Id,
            [new SlotValuesInput("titel", JsonValue.Create(new string('x', 400)))], null);
        await walker.SaveChangesAsync();

        var html = Assert.Single(await SentHtml(prozessVersion.Prozess.Name));
        Assert.Contains(new string('x', 300) + "...", html);
        Assert.DoesNotContain(new string('x', 301), html);
        Assert.Single(System.Text.RegularExpressions.Regex.Matches(html, "Titel:"));
    }

    [Fact]
    public async Task Mail_has_no_angaben_block_when_the_process_has_no_public_fields() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var organisationseinheit = AddOrganisationseinheit(db);
        var gruppe = AddMitarbeiterGruppe(db, ["ohne-angaben@example.com"]);

        var prozessName = await StepFromBuergerStartIntoAndReturnProzessName(scope, db, new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = organisationseinheit.Id,
                MitarbeiterGruppeId = gruppe.Id,
            },
        });

        var html = Assert.Single(await SentHtml(prozessName));
        Assert.DoesNotContain("Angaben zum Antrag", html);
    }

    private async Task<string> StepFromBuergerStartIntoAndReturnProzessName(IServiceScope scope, DomainContext db,
        Schritt nextSchritt) {
        var startSchritt = BuergerFormularSchritt();
        var verbindung = new Verbindung { Von = startSchritt, Nach = nextSchritt };
        startSchritt.Verbindungen.Add(verbindung);
        var prozessVersion = await AddProzessVersion(db, [startSchritt, nextSchritt], startSchritt.Id);

        await using var walker = await StartAusfuehrung(scope, prozessVersion);
        walker.Step(walker.Ausfuehrung.UserId, verbindung.Id, [], null);
        await walker.SaveChangesAsync();

        return prozessVersion.Prozess.Name;
    }

    private async Task<List<string>> SentHtml(string prozessName) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        return await db.EmailOutboxItems
            .Where(item => item.KommuneId == KommuneId && item.Subject.Contains(prozessName))
            .Select(item => item.Html)
            .ToListAsync();
    }

    private async Task StepIntoDynamicSchritt(IServiceScope scope, DomainContext db,
        List<ZustaendigkeitArt> dynamischeArten, Zustaendigkeit istZustaendigkeit, params string[] expectedAddresses) {
        await StepFromBuergerStartInto(scope, db, new FormularSchritt {
            Id = Guid.NewGuid(),
            Felder = new List<FormularFeld>(),
            VersendeEMailAnMitarbeiterGruppe = true,
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Dynamisch,
                DynamischeArten = dynamischeArten,
            },
        }, istZustaendigkeit, true, expectedAddresses);
    }

    private async Task StepFromBuergerStartInto(IServiceScope scope, DomainContext db, Schritt nextSchritt,
        Zustaendigkeit? istZustaendigkeit, bool saveChanges, params string[] expectedAddresses) {
        var startSchritt = BuergerFormularSchritt();

        var verbindung = new Verbindung { Von = startSchritt, Nach = nextSchritt };
        startSchritt.Verbindungen.Add(verbindung);

        var prozessVersion = await AddProzessVersion(db, [startSchritt, nextSchritt], startSchritt.Id);

        await using var walker = await StartAusfuehrung(scope, prozessVersion);
        walker.Step(walker.Ausfuehrung.UserId, verbindung.Id, [], istZustaendigkeit);
        if (saveChanges) {
            await walker.SaveChangesAsync();
        }

        Assert.Equal(expectedAddresses, await SentAddresses(prozessVersion.Prozess.Name));
    }

    private static FormularSchritt BuergerFormularSchritt() => new() {
        Id = Guid.NewGuid(),
        Felder = new List<FormularFeld>(),
        SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
    };

    private static MitarbeiterGruppe AddMitarbeiterGruppe(DomainContext db, List<string> eMailAdressen) {
        var gruppe = new MitarbeiterGruppe {
            Id = Guid.NewGuid(),
            Name = $"Walker email notification test group {Guid.NewGuid()} (do not use in UI)",
            KommuneId = KommuneId,
            EMailAdressen = eMailAdressen,
        };
        db.MitarbeiterGruppen.Add(gruppe);
        return gruppe;
    }

    private static Dienstleister AddDienstleister(DomainContext db, List<string> eMailAdressen) {
        var dienstleister = new Dienstleister {
            Id = Guid.NewGuid(),
            Name = $"Walker email notification test service {Guid.NewGuid()} (do not use in UI)",
            MandantId = KommuneId,
            EMailAdressen = eMailAdressen,
        };
        db.Dienstleister.Add(dienstleister);
        return dienstleister;
    }

    private static Untereinheit AddOrganisationseinheit(DomainContext db) {
        var organisationseinheit = new Untereinheit {
            Id = Guid.NewGuid(),
            Name = $"Walker email notification test unit {Guid.NewGuid()} (do not use in UI)",
            KommuneId = KommuneId,
            IsGemeinde = false,
        };
        db.Untereinheit.Add(organisationseinheit);
        return organisationseinheit;
    }

    private static async Task<ProzessVersion> AddProzessVersion(DomainContext db, List<Schritt> schritte,
        Guid startId) {
        var prozessVersion = new ProzessVersion {
            Id = Guid.NewGuid(),
            CreatedAt = SystemClock.Instance.GetCurrentInstant(),
            Beschreibungstext = "Test",
            Schritte = schritte,
            Prozess = new Prozess {
                Id = Guid.NewGuid(),
                Name = $"Walker email notification test process {Guid.NewGuid()}",
                KommuneId = KommuneId,
            },
        };
        prozessVersion.ProzessId = prozessVersion.Prozess.Id;
        db.ProzessVersionen.Add(prozessVersion);

        // Save once first to avoid a circular FK dependency (StartId <-> Schritt.ProzessVersionId),
        // same as NeueProzessVersionErstellenMutation does.
        await db.SaveChangesAsync();
        prozessVersion.StartId = startId;
        await db.SaveChangesAsync();

        return prozessVersion;
    }

    private async Task<Walker> StartAusfuehrung(IServiceScope scope, ProzessVersion prozessVersion) {
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var userId = await db.Mitarbeiter.Where(u => u.EMail == SuperAdminEmail).Select(u => u.Id).FirstAsync();

        var walker = await scope.ServiceProvider.GetRequiredService<WalkerFactory>()
            .StartNewAusfuehrung(prozessVersion.Id, new Ausfuehrung {
                ProzessVersionId = prozessVersion.Id,
                UserId = userId,
                CreatedAt = SystemClock.Instance.GetCurrentInstant(),
                SharedKeyEncryptedForBuerger = "test",
                SharedKeyEncryptedForKommune = "test",
                Status = AusfuehrungStatus.BearbeitungDurchBuerger,
            });
        await walker.SaveChangesAsync();

        return walker;
    }

    private async Task<List<string>> SentAddresses(string prozessName) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        return await db.EmailOutboxItems
            .Where(item => item.KommuneId == KommuneId && item.Subject.Contains(prozessName))
            .Select(item => item.RecipientEmail)
            .OrderBy(email => email)
            .ToListAsync();
    }
}
