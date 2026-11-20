using API.Features;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Features.Prozess.Mutations;
using API.Features.Prozess.ProgrammatischeSchritte;
using API.Features.Untereinheit;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

/// <summary>End-to-end proof that <see cref="KategorieSyncExport"/> replaces only the category field cascade and leaves every other field/step untouched.</summary>
[Collection("Api Tests")]
public class KategorieSyncExportTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string MutationKategorieCreate = """
        mutation KategorieCreate($input: KategorieCreateInput!) {
          kategorieCreate(input: $input) {
            kategorie { id }
            errors { __typename ... on Error { message } }
          }
        }
        """;

    private const string MutationKategorieAusblendungSetzen = """
        mutation KategorieAusblendungSetzen($input: KategorieAusblendungSetzenInput!) {
          kategorieAusblendungSetzen(input: $input) {
            success
            errors { __typename }
          }
        }
        """;

    private const string MutationKategorieAusblendungAufheben = """
        mutation KategorieAusblendungAufheben($input: KategorieAusblendungAufhebenInput!) {
          kategorieAusblendungAufheben(input: $input) {
            success
            errors { __typename }
          }
        }
        """;

    [Fact]
    public async Task Kategorie_create_triggers_a_sync_export_that_preserves_everything_else_in_the_process() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var untereinheitId = KommuneSeeder.AerzenOrganisationseinheitId;
        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;

        var prozessId = Guid.NewGuid();
        var meldungSchrittId = Guid.NewGuid();
        var routingSchrittId = Guid.NewGuid();
        var endeSchrittId = Guid.NewGuid();
        var fotoFeldId = Guid.NewGuid();

        await SeedeAusgangsProzess(kommuneId, prozessId, meldungSchrittId, routingSchrittId, endeSchrittId, fotoFeldId);

        var suffix = Guid.NewGuid().ToString("N")[..8];
        var strassenName = $"Straßen-{suffix}";
        var beleuchtungName = $"Beleuchtung-{suffix}";
        var strassenSlug = KategorieOrtZustaendigkeitSchritt.Slug(strassenName);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var strassenId = await KategorieAnlegen(superAdmin, parentId: null, untereinheitId: null, strassenName);
        await KategorieAnlegen(superAdmin, parentId: strassenId, untereinheitId: null, beleuchtungName);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var versionen = await db.ProzessVersionen.Where(v => v.ProzessId == prozessId).CountAsync();
        Assert.Equal(3, versionen); // Ausgangsversion + 2 Sync-Exports (einer je Kategorie-Anlage.

        var neuesteVersion = await db.ProzessVersionen
            .Include(v => v.Schritte).ThenInclude(s => s.Verbindungen).AsSplitQuery()
            .Where(v => v.ProzessId == prozessId)
            .OrderByDescending(v => v.PublishedAt)
            .FirstAsync();

        var meldungSchritt = neuesteVersion.Schritte.OfType<FormularSchritt>().Single(f => f.Felder.Any(x => x.SlotName == "adresse"));

        var adresse = meldungSchritt.Felder.Single(f => f.SlotName == "adresse");
        Assert.Equal(0, adresse.Order);

        var anliegen = (StringFormularFeld)meldungSchritt.Felder.Single(f => f.SlotName == "anliegen");
        Assert.True(anliegen.Durchsuchbar);
        Assert.Equal("isInside('Aerzen', slot('adresse')) == true", anliegen.Options.Single().IstRelevant!.ExpressionString);

        var foto = meldungSchritt.Felder.Single(f => f.SlotName == "foto");
        Assert.Equal("foto", foto.SlotName); // unverändert erhalten, kein Kategorie-Feld

        var kategorieFeld = (StringFormularFeld)meldungSchritt.Felder.Single(f => f.SlotName == "kategorie");
        Assert.True(kategorieFeld.IstRelevant.AlwaysTrue);
        Assert.False(kategorieFeld.Durchsuchbar); // neu angelegtes Kategorie-Feld: standardmäßig deaktiviert (#439)
        var strassenOption = kategorieFeld.Options.Single(o => o.Key == strassenName);
        Assert.Null(strassenOption.IstRelevant); // geteilt, keine Ausblendung -> immer sichtbar

        var unterkategorieFeld = (StringFormularFeld)meldungSchritt.Felder.Single(f => f.SlotName == $"kategorie_2__{strassenSlug}");
        Assert.Equal($"slot('kategorie') == '{strassenName}'", unterkategorieFeld.IstRelevant.ExpressionString);
        Assert.Contains(unterkategorieFeld.Options, o => o.Key == beleuchtungName);
        Assert.True(kategorieFeld.OeffentlichSichtbar);
        Assert.False(unterkategorieFeld.OeffentlichSichtbar);
        Assert.False(unterkategorieFeld.Durchsuchbar);

        // Andere Schritte/Verbindungen unverändert in Struktur (neue IDs durch das Rescrambling beim Republish, aber gleiche Typen/Anzahl).
        Assert.Equal(3, neuesteVersion.Schritte.Count);
        Assert.Single(neuesteVersion.Schritte.OfType<ProgrammatischerSchritt>());
        Assert.Single(neuesteVersion.Schritte.OfType<EndeSchritt>());
        Assert.Equal(2, neuesteVersion.Schritte.SelectMany(s => s.Verbindungen).Count());
    }

    [Fact]
    public async Task Durchsuchbar_Einstellung_bleibt_beim_naechsten_Kategorie_Sync_erhalten() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;

        var prozessId = Guid.NewGuid();
        var meldungSchrittId = Guid.NewGuid();
        var routingSchrittId = Guid.NewGuid();
        var endeSchrittId = Guid.NewGuid();
        var fotoFeldId = Guid.NewGuid();
        await SeedeAusgangsProzess(kommuneId, prozessId, meldungSchrittId, routingSchrittId, endeSchrittId, fotoFeldId);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        await KategorieAnlegen(superAdmin, parentId: null, untereinheitId: null, $"Kategorie-{Guid.NewGuid()}");

        // Simuliert das Umschalten von "Suche in der App anbieten" im Prozesseditor und das Veröffentlichen dort.
        await SetzeDurchsuchbarAufLetzterVersion(prozessId, kommuneId, "kategorie", durchsuchbar: true);

        // Eine weitere Kategorie-Änderung darf diese Einstellung nicht wieder verwerfen (#439).
        await KategorieAnlegen(superAdmin, parentId: null, untereinheitId: null, $"Kategorie-{Guid.NewGuid()}");

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var neuesteVersion = await db.ProzessVersionen
            .Include(v => v.Schritte).AsSplitQuery()
            .Where(v => v.ProzessId == prozessId)
            .OrderByDescending(v => v.PublishedAt)
            .FirstAsync();
        var meldungSchritt = neuesteVersion.Schritte.OfType<FormularSchritt>().Single(f => f.Felder.Any(x => x.SlotName == "adresse"));
        var kategorieFeld = (StringFormularFeld)meldungSchritt.Felder.Single(f => f.SlotName == "kategorie");
        Assert.True(kategorieFeld.Durchsuchbar);
    }

    [Fact]
    public async Task Kategorie_Aenderung_schlaegt_nicht_fehl_wenn_derselbe_Kategorie_Slotname_in_mehreren_FormularSchritten_vorkommt() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;

        var prozessId = Guid.NewGuid();
        await SeedeProzessMitZweiKategorieSchritten(kommuneId, prozessId);

        // Löste vor dem Fix eine ArgumentException aus, weil derselbe Kategorie-Slotname in mehreren
        // FormularSchritten vorkommt.
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        await KategorieAnlegen(superAdmin, parentId: null, untereinheitId: null, $"Kategorie-{Guid.NewGuid()}");

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var neuesteVersion = await db.ProzessVersionen
            .Include(v => v.Schritte).AsSplitQuery()
            .Where(v => v.ProzessId == prozessId)
            .OrderByDescending(v => v.PublishedAt)
            .FirstAsync();

        var formularSchritte = neuesteVersion.Schritte.OfType<FormularSchritt>()
            .Where(s => s.Felder.Any(f => f.SlotName == "adresse"))
            .ToList();
        Assert.Equal(2, formularSchritte.Count);
        Assert.All(formularSchritte, s => Assert.Contains(s.Felder, f => f.SlotName == "kategorie"));
    }

    [Fact]
    public async Task Ausblendung_adds_a_negated_isInside_condition_to_exactly_that_option() {
        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;

        // Eigener Name "Aerzen" statt der geteilten Fixture (die heißt "Aerzen (Test)", passt nicht zur Geo-Zuordnung).
        var untereinheitId = Guid.NewGuid();
        await using (var seedScope = Factory.Services.CreateAsyncScope()) {
            var seedDb = seedScope.ServiceProvider.GetRequiredService<DomainContext>();
            seedDb.Untereinheit.Add(new Untereinheit { Id = untereinheitId, Name = "Aerzen", KommuneId = kommuneId, IsGemeinde = true });
            await seedDb.SaveChangesAsync();
        }

        var prozessId = Guid.NewGuid();
        var meldungSchrittId = Guid.NewGuid();
        var routingSchrittId = Guid.NewGuid();
        var endeSchrittId = Guid.NewGuid();
        var fotoFeldId = Guid.NewGuid();
        await SeedeAusgangsProzess(kommuneId, prozessId, meldungSchrittId, routingSchrittId, endeSchrittId, fotoFeldId);

        var gruenflaechenName = $"Grünflächen-{Guid.NewGuid()}";
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var gruenflaechenId = await KategorieAnlegen(superAdmin, parentId: null, untereinheitId: null, gruenflaechenName);

        var ausblendenResult = await ExecuteQuery(superAdmin, MutationKategorieAusblendungSetzen, new Dictionary<string, object?> {
            ["kategorieId"] = gruenflaechenId,
            ["untereinheitId"] = untereinheitId,
        });
        DenyMutationError(ausblendenResult, "kategorieAusblendungSetzen");

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var neuesteVersion = await db.ProzessVersionen
            .Include(v => v.Schritte).AsSplitQuery()
            .Where(v => v.ProzessId == prozessId)
            .OrderByDescending(v => v.PublishedAt)
            .FirstAsync();

        var meldungSchritt = neuesteVersion.Schritte.OfType<FormularSchritt>().Single(f => f.Felder.Any(x => x.SlotName == "adresse"));
        var kategorieFeld = (StringFormularFeld)meldungSchritt.Felder.Single(f => f.SlotName == "kategorie");
        var option = kategorieFeld.Options.Single(o => o.Key == gruenflaechenName);

        Assert.NotNull(option.IstRelevant);
        Assert.Contains("isInside('Aerzen', slot('adresse')) == false", option.IstRelevant!.ExpressionString);
    }

    [Fact]
    public async Task Ausblendung_aufheben_succeeds_for_a_process_that_also_contains_a_NachrichtSchritt() {
        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;
        var untereinheitId = Guid.NewGuid();
        await using (var seedScope = Factory.Services.CreateAsyncScope()) {
            var seedDb = seedScope.ServiceProvider.GetRequiredService<DomainContext>();
            seedDb.Untereinheit.Add(new Untereinheit { Id = untereinheitId, Name = "Hameln", KommuneId = kommuneId, IsGemeinde = true });
            await seedDb.SaveChangesAsync();
        }

        var prozessId = Guid.NewGuid();
        var meldungSchrittId = Guid.NewGuid();
        var routingSchrittId = Guid.NewGuid();
        var endeSchrittId = Guid.NewGuid();
        var fotoFeldId = Guid.NewGuid();
        var nachrichtSchrittId = Guid.NewGuid();
        await SeedeAusgangsProzess(kommuneId, prozessId, meldungSchrittId, routingSchrittId, endeSchrittId, fotoFeldId, nachrichtSchrittId);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var kategorieName = $"Kategorie-{Guid.NewGuid()}";
        var kategorieId = await KategorieAnlegen(superAdmin, parentId: null, untereinheitId: null, kategorieName);

        var ausblendenResult = await ExecuteQuery(superAdmin, MutationKategorieAusblendungSetzen, new Dictionary<string, object?> {
            ["kategorieId"] = kategorieId,
            ["untereinheitId"] = untereinheitId,
        });
        DenyMutationError(ausblendenResult, "kategorieAusblendungSetzen");

        var einblendenResult = await ExecuteQuery(superAdmin, MutationKategorieAusblendungAufheben, new Dictionary<string, object?> {
            ["kategorieId"] = kategorieId,
            ["untereinheitId"] = untereinheitId,
        });
        DenyMutationError(einblendenResult, "kategorieAusblendungAufheben");

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var nochAusgeblendet = await db.KategorieAusblendungen
            .AnyAsync(a => a.KategorieId == kategorieId && a.UntereinheitId == untereinheitId);
        Assert.False(nochAusgeblendet);

        var neuesteVersion = await db.ProzessVersionen
            .Include(v => v.Schritte).AsSplitQuery()
            .Where(v => v.ProzessId == prozessId)
            .OrderByDescending(v => v.PublishedAt)
            .FirstAsync();
        Assert.Single(neuesteVersion.Schritte.OfType<NachrichtSchritt>());
    }

    [Fact]
    public async Task Kategorie_create_succeeds_for_a_process_whose_Meldung_schritt_also_contains_an_AnzeigeTextBlockFeld() {
        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;

        var prozessId = Guid.NewGuid();
        var meldungSchrittId = Guid.NewGuid();
        var routingSchrittId = Guid.NewGuid();
        var endeSchrittId = Guid.NewGuid();
        var fotoFeldId = Guid.NewGuid();
        var textBlockFeldId = Guid.NewGuid();
        await SeedeAusgangsProzess(kommuneId, prozessId, meldungSchrittId, routingSchrittId, endeSchrittId, fotoFeldId, textBlockFeldId: textBlockFeldId);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        await KategorieAnlegen(superAdmin, parentId: null, untereinheitId: null, $"Kategorie-{Guid.NewGuid()}");

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var neuesteVersion = await db.ProzessVersionen
            .Include(v => v.Schritte).AsSplitQuery()
            .Where(v => v.ProzessId == prozessId)
            .OrderByDescending(v => v.PublishedAt)
            .FirstAsync();
        var meldungSchritt = neuesteVersion.Schritte.OfType<FormularSchritt>().Single(f => f.Felder.Any(x => x.SlotName == "adresse"));
        Assert.Contains(meldungSchritt.Felder, f => f is AnzeigeTextBlockFeld);
    }

    [Fact]
    public async Task Kategorie_create_for_an_Untereinheit_without_a_Geoflaeche_fails_with_a_domain_error_instead_of_crashing() {
        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;
        var untereinheitId = Guid.NewGuid();
        await using (var seedScope = Factory.Services.CreateAsyncScope()) {
            var seedDb = seedScope.ServiceProvider.GetRequiredService<DomainContext>();
            seedDb.Untereinheit.Add(new Untereinheit { Id = untereinheitId, Name = "Landkreis Hameln-Pyrmont", KommuneId = kommuneId, IsGemeinde = false });
            await seedDb.SaveChangesAsync();
        }

        var prozessId = Guid.NewGuid();
        var meldungSchrittId = Guid.NewGuid();
        var routingSchrittId = Guid.NewGuid();
        var endeSchrittId = Guid.NewGuid();
        var fotoFeldId = Guid.NewGuid();
        await SeedeAusgangsProzess(kommuneId, prozessId, meldungSchrittId, routingSchrittId, endeSchrittId, fotoFeldId);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var result = await ExecuteQuery(superAdmin, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = null,
            ["untereinheitId"] = untereinheitId,
            ["name"] = $"Kategorie-{Guid.NewGuid()}",
        });

        Assert.Null(result.Errors);
        var payload = (IReadOnlyDictionary<string, object?>)result.Data!["kategorieCreate"]!;
        var errors = (IReadOnlyList<object?>)payload["errors"]!;
        Assert.Single(errors);
    }

    private async Task<Guid> KategorieAnlegen(System.Security.Claims.ClaimsPrincipal user, Guid? parentId, Guid? untereinheitId, string name) {
        var result = await ExecuteQuery(user, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = parentId,
            ["untereinheitId"] = untereinheitId,
            ["name"] = name,
        });
        DenyMutationError(result, "kategorieCreate");
        var payload = (IReadOnlyDictionary<string, object?>)result.Data!["kategorieCreate"]!;
        var kategorie = (IReadOnlyDictionary<string, object?>)payload["kategorie"]!;
        return Guid.Parse((string)kategorie["id"]!);
    }

    /// <summary>Publiziert die aktuelle Version mit geänderter Durchsuchbar-Einstellung auf dem genannten Slot erneut - wie ein Speichern im Prozesseditor, ohne den Kategoriebaum zu berühren.</summary>
    private async Task SetzeDurchsuchbarAufLetzterVersion(Guid prozessId, Guid kommuneId, string slotName, bool durchsuchbar) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var clock = scope.ServiceProvider.GetRequiredService<IClock>();

        var version = await db.ProzessVersionen
            .Include(v => v.Schritte).ThenInclude(s => s.Verbindungen)
            .Where(v => v.ProzessId == prozessId && v.PublishedAt != null)
            .OrderByDescending(v => v.PublishedAt)
            .AsSplitQuery()
            .FirstAsync();

        var (schritte, verbindungen, rollen) = ProzessGraphReader.ReadCurrentGraph(version);
        var gepatchteSchritte = schritte.Select(s => {
            if (s.FormularSchrittInput is not { } formularSchritt) return s;
            var gepatchteFelder = formularSchritt.Felder.Select(f =>
                f.StringFormularFeldInput is { } str && str.SlotName == slotName
                    ? f with { StringFormularFeldInput = str with { Durchsuchbar = durchsuchbar } }
                    : f
            ).ToList();
            return s with { FormularSchrittInput = formularSchritt with { Felder = gepatchteFelder } };
        }).ToList();

        var mutation = new NeueProzessVersionErstellenMutation();
        await mutation.PublishNewVersionAsync(db, prozessId, kommuneId, gepatchteSchritte, verbindungen, rollen, veroeffentlichen: true, clock, CancellationToken.None);
    }

    private async Task SeedeAusgangsProzess(
        Guid kommuneId, Guid prozessId, Guid meldungSchrittId, Guid routingSchrittId, Guid endeSchrittId, Guid fotoFeldId,
        Guid? nachrichtSchrittId = null, Guid? textBlockFeldId = null
    ) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var clock = scope.ServiceProvider.GetRequiredService<IClock>();

        // Sync-Export verarbeitet immer den gesamten Kategoriebaum der Kommune - Reste anderer Testfälle entfernen.
        db.KategorieAusblendungen.RemoveRange(await db.KategorieAusblendungen.AsTracking().ToListAsync());
        db.Kategorien.RemoveRange(await db.Kategorien.AsTracking().ToListAsync());
        await db.SaveChangesAsync();

        // Tag-Zuordnung aller Alt-Prozesse entfernen, sonst könnte ein anderer Testfall mit demselben Tag den Sync-Export umleiten.
        var tag = await db.ProzessTags.AsTracking()
            .Include(t => t.Prozesse)
            .FirstOrDefaultAsync(t => t.Tag == KategorieSyncExport.ProzessTagName);
        if (tag is null) {
            tag = new ProzessTag { Id = Guid.NewGuid(), Tag = KategorieSyncExport.ProzessTagName };
            db.ProzessTags.Add(tag);
        }

        var kollidierendeProzesse = tag.Prozesse.Where(p => p.KommuneId == kommuneId).ToList();
        foreach (var alt in kollidierendeProzesse) tag.Prozesse.Remove(alt);

        var prozess = new Prozess { Id = prozessId, Name = "Mängelmelder-Version-2", KommuneId = kommuneId };
        tag.Prozesse.Add(prozess);
        db.Prozesse.Add(prozess);
        await db.SaveChangesAsync();

        var buergerSollZustaendigkeit = new SchrittSollZustaendigkeitInput(ZustaendigkeitArt.Buerger, null, null, null, null, null);

        var meldungFelder = new List<FormularFeldInput> {
                new(
                    CheckboxListFormularFeldInput: null, StringFormularFeldInput: null, UploadFormularFeldInput: null,
                    LocationFormularFeldInput: new LocationFormularFeldInput(Guid.NewGuid(), "adresse", "Adresse", null, 0, false, null, true, true, false),
                    DateFormularFeldInput: null, SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
                new(
                    CheckboxListFormularFeldInput: null, StringFormularFeldInput: null,
                    UploadFormularFeldInput: new UploadFormularFeldInput(fotoFeldId, "foto", "Foto", null, 1, false, null, true, false, false, false, false, false),
                    LocationFormularFeldInput: null, DateFormularFeldInput: null, SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
                new(
                    CheckboxListFormularFeldInput: null,
                    StringFormularFeldInput: new StringFormularFeldInput(
                        Guid.NewGuid(), "kategorie", "Kategorie", null, 2, false, null, true, true, false, [new StringFormularFeldOption("Alt")], false),
                    UploadFormularFeldInput: null, LocationFormularFeldInput: null, DateFormularFeldInput: null,
                    SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
                new(
                    CheckboxListFormularFeldInput: null,
                    StringFormularFeldInput: new StringFormularFeldInput(
                        Guid.NewGuid(), "anliegen", "Anliegen", null, 3, false, null, true, false, false,
                        [new StringFormularFeldOption("Lob", "Lob", new BoolExpression("isInside('Aerzen', slot('adresse')) == true"))],
                        OeffentlichSichtbar: false, Durchsuchbar: true),
                    UploadFormularFeldInput: null, LocationFormularFeldInput: null, DateFormularFeldInput: null,
                    SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
        };

        if (textBlockFeldId is { } textBlockId) {
            meldungFelder.Add(new FormularFeldInput(
                CheckboxListFormularFeldInput: null, StringFormularFeldInput: null, UploadFormularFeldInput: null,
                LocationFormularFeldInput: null, DateFormularFeldInput: null, SignatureFormularFeldInput: null, TimeFormularFeldInput: null,
                AnzeigeTextBlockFormularFeldInput: new AnzeigeTextBlockFormularFeldInput(
                    textBlockId, "textblock", "Hinweis", null, meldungFelder.Count, false, null, "Hinweistext", true, false, false)));
        }

        var meldungSchritt = new FormularSchrittInput(
            meldungSchrittId, "Meldung erfassen", null, buergerSollZustaendigkeit, null,
            Felder: meldungFelder,
            NodePosition: null, SchreibtRolleId: null);

        var routingSchritt = new ProgrammatischerSchrittInput(
            routingSchrittId, "Zuständigkeit ermitteln", null, buergerSollZustaendigkeit, null,
            typeof(KategorieOrtZustaendigkeitSchritt).AssemblyQualifiedName!, null, null);

        var endeSchritt = new EndeSchrittInput(endeSchrittId, "Ende", null, buergerSollZustaendigkeit, null, null, null);

        var schritte = new List<SchrittInput> {
            new(FormularSchrittInput: meldungSchritt, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
                ProgrammatischerSchrittInput: null, EndeSchrittInput: null, NachrichtSchrittInput: null,
                EmailForwardSchrittInput: null, GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
            new(FormularSchrittInput: null, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
                ProgrammatischerSchrittInput: routingSchritt, EndeSchrittInput: null, NachrichtSchrittInput: null,
                EmailForwardSchrittInput: null, GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
            new(FormularSchrittInput: null, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
                ProgrammatischerSchrittInput: null, EndeSchrittInput: endeSchritt, NachrichtSchrittInput: null,
                EmailForwardSchrittInput: null, GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
        };

        var verbindungen = new List<VerbindungInput> {
            new(Guid.NewGuid(), meldungSchrittId, routingSchrittId, null, null, null, true),
            new(Guid.NewGuid(), routingSchrittId, endeSchrittId, null, null, null, true),
        };

        if (nachrichtSchrittId is { } nachrichtId) {
            var nachrichtSchritt = new NachrichtSchrittInput(nachrichtId, "Nachricht", null, buergerSollZustaendigkeit, null, null, null);
            schritte.Add(new SchrittInput(
                FormularSchrittInput: null, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
                ProgrammatischerSchrittInput: null, EndeSchrittInput: null, NachrichtSchrittInput: nachrichtSchritt,
                EmailForwardSchrittInput: null, GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null));
            verbindungen.Add(new VerbindungInput(Guid.NewGuid(), routingSchrittId, nachrichtId, null, null, null, true));
            verbindungen.Add(new VerbindungInput(Guid.NewGuid(), nachrichtId, endeSchrittId, null, null, null, true));
        }

        var mutation = new NeueProzessVersionErstellenMutation();
        await mutation.PublishNewVersionAsync(db, prozessId, kommuneId, schritte, verbindungen, [], veroeffentlichen: true, clock, CancellationToken.None);
    }

    /// <summary>Zwei FormularSchritte mit je einem "adresse"- und "kategorie"-Feld, direkt ins Ende mündend - Repro für den Crash bei doppeltem Kategorie-Slotnamen über mehrere Schritte.</summary>
    private async Task SeedeProzessMitZweiKategorieSchritten(Guid kommuneId, Guid prozessId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var clock = scope.ServiceProvider.GetRequiredService<IClock>();

        db.KategorieAusblendungen.RemoveRange(await db.KategorieAusblendungen.AsTracking().ToListAsync());
        db.Kategorien.RemoveRange(await db.Kategorien.AsTracking().ToListAsync());
        await db.SaveChangesAsync();

        var tag = await db.ProzessTags.AsTracking()
            .Include(t => t.Prozesse)
            .FirstOrDefaultAsync(t => t.Tag == KategorieSyncExport.ProzessTagName);
        if (tag is null) {
            tag = new ProzessTag { Id = Guid.NewGuid(), Tag = KategorieSyncExport.ProzessTagName };
            db.ProzessTags.Add(tag);
        }
        var kollidierendeProzesse = tag.Prozesse.Where(p => p.KommuneId == kommuneId).ToList();
        foreach (var alt in kollidierendeProzesse) tag.Prozesse.Remove(alt);

        var prozess = new Prozess { Id = prozessId, Name = "Mängelmelder-Zwei-Kategorie-Schritte", KommuneId = kommuneId };
        tag.Prozesse.Add(prozess);
        db.Prozesse.Add(prozess);
        await db.SaveChangesAsync();

        var buergerSollZustaendigkeit = new SchrittSollZustaendigkeitInput(ZustaendigkeitArt.Buerger, null, null, null, null, null);

        List<FormularFeldInput> AdresseUndKategorieFelder() => [
            new(CheckboxListFormularFeldInput: null, StringFormularFeldInput: null, UploadFormularFeldInput: null,
                LocationFormularFeldInput: new LocationFormularFeldInput(Guid.NewGuid(), "adresse", "Adresse", null, 0, false, null, true, true, false),
                DateFormularFeldInput: null, SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
            new(CheckboxListFormularFeldInput: null,
                StringFormularFeldInput: new StringFormularFeldInput(
                    Guid.NewGuid(), "kategorie", "Kategorie", null, 1, false, null, true, true, false, [new StringFormularFeldOption("Alt")], false),
                UploadFormularFeldInput: null, LocationFormularFeldInput: null, DateFormularFeldInput: null,
                SignatureFormularFeldInput: null, TimeFormularFeldInput: null, AnzeigeTextBlockFormularFeldInput: null),
        ];

        var ersterSchrittId = Guid.NewGuid();
        var zweiterSchrittId = Guid.NewGuid();
        var endeSchrittId = Guid.NewGuid();

        var ersterSchritt = new FormularSchrittInput(
            ersterSchrittId, "Formular Bürger 1", null, buergerSollZustaendigkeit, null,
            Felder: AdresseUndKategorieFelder(), NodePosition: null, SchreibtRolleId: null);
        var zweiterSchritt = new FormularSchrittInput(
            zweiterSchrittId, "Formular Bürger 2", null, buergerSollZustaendigkeit, null,
            Felder: AdresseUndKategorieFelder(), NodePosition: null, SchreibtRolleId: null);
        var endeSchritt = new EndeSchrittInput(endeSchrittId, "Ende", null, buergerSollZustaendigkeit, null, null, null);

        var schritte = new List<SchrittInput> {
            new(FormularSchrittInput: ersterSchritt, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
                ProgrammatischerSchrittInput: null, EndeSchrittInput: null, NachrichtSchrittInput: null,
                EmailForwardSchrittInput: null, GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
            new(FormularSchrittInput: zweiterSchritt, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
                ProgrammatischerSchrittInput: null, EndeSchrittInput: null, NachrichtSchrittInput: null,
                EmailForwardSchrittInput: null, GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
            new(FormularSchrittInput: null, BezahlenSchrittInput: null, WarteAufBezahlungAbgeschlossenSchrittInput: null,
                ProgrammatischerSchrittInput: null, EndeSchrittInput: endeSchritt, NachrichtSchrittInput: null,
                EmailForwardSchrittInput: null, GovManagerRestExportSchrittInput: null, WarteAufGovManagerSchrittInput: null),
        };

        var verbindungen = new List<VerbindungInput> {
            new(Guid.NewGuid(), ersterSchrittId, zweiterSchrittId, null, null, null, true),
            new(Guid.NewGuid(), zweiterSchrittId, endeSchrittId, null, null, null, true),
        };

        var mutation = new NeueProzessVersionErstellenMutation();
        await mutation.PublishNewVersionAsync(db, prozessId, kommuneId, schritte, verbindungen, [], veroeffentlichen: true, clock, CancellationToken.None);
    }
}
