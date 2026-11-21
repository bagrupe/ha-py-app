using System.Text.Json;
using API.Features;
using API.Features.Auth;
using API.Features.Lage;
using API.Features.Prozess;
using API.Features.Prozess.ProgrammatischeSchritte;
using API.Features.Untereinheit;
using API.Seeders.LageHelfer;
using HotChocolate;
using HotChocolate.Execution;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using static IntegrationTests.GebietEinsatzleitungSeeder;

namespace IntegrationTests;

/// <summary>Seeds Gebiete, Lagen and the LageHelfer report process, and files anonymous reports.</summary>
public abstract class LageMeldungTestBase(BackendApiFactory factory) : GraphQLTests(factory) {
    protected readonly GebietEinsatzleitungSeeder gebietSeeder = new(factory);
    protected readonly LageSeeder lageSeeder = new(factory);

    protected const string West = """{"type":"Polygon","coordinates":[[[9.0,52.0],[9.5,52.0],[9.5,52.5],[9.0,52.5],[9.0,52.0]]]}""";
    protected const string East = """{"type":"Polygon","coordinates":[[[9.5,52.0],[10.0,52.0],[10.0,52.5],[9.5,52.5],[9.5,52.0]]]}""";
    protected const string Live = "CalledOut,Ready,Live";
    protected const string FakeFoto = "/9j/4AAQSkZJRgABAQ==";

    private const string CreateAnonymMutation = """
        mutation CreateAnonym($input: AusfuehrungCreateAnonymInput!) {
          ausfuehrungCreateAnonym(input: $input) {
            anonymeAusfuehrungResult { correlationId meldungsnummer }
            errors { __typename }
          }
        }
        """;

    protected record Meldeprozess(Guid VersionId, Schritt Meldung, Verbindung ZurZuordnung);

    protected void ActAnonymously() =>
        Factory.Services.GetRequiredService<IHttpContextAccessor>().HttpContext = new DefaultHttpContext();

    protected async Task<(Guid KommuneId, Untereinheit Untereinheit)> SeedKommuneMitUntereinheit() {
        var kommune = await gebietSeeder.SeedKommune();
        return (kommune.Id, await gebietSeeder.SeedUntereinheit(kommune.Id));
    }

    protected async Task<(Gebiet Gebiet, MitarbeiterGruppe Einsatzleitung)> SeedGebietMitEinsatzleitung(
        Untereinheit untereinheit, string name, string geometry) {
        var einsatzleitung = NewMitarbeiterGruppe(untereinheit);
        await gebietSeeder.SeedMitarbeiterGruppen(untereinheit, einsatzleitung);
        var gebiet = NewGebiet(untereinheit.Id);
        gebiet.Name = name;
        gebiet.Geometry = geometry;
        await gebietSeeder.SeedGebiet(gebiet, einsatzleitung);
        return (gebiet, einsatzleitung);
    }

    protected async Task<(Meldeprozess Meldeprozess, LageSelectionInput Auswahl)> SeedLiveMeldeprozess() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        var (west, _) = await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        var lage = await lageSeeder.SeedLageForGebiet(west, Live);
        return (await SeedMeldeprozess(kommuneId, lageErforderlich: true), new LageSelectionInput(lage.Id, west.Id));
    }

    protected async Task<bool> NoAusfuehrungFor(Guid versionId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        return !await scope.ServiceProvider.GetRequiredService<DomainContext>().Ausfuehrungen
            .AnyAsync(a => a.ProzessVersionId == versionId);
    }

    protected async Task<Meldeprozess> SeedMeldeprozess(Guid kommuneId, bool lageErforderlich = false) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var tagNames = lageErforderlich
            ? new[] { AnonymeEinreichung.ProzessTagName, AnonymeEinreichung.LageHelferTagName }
            : [AnonymeEinreichung.ProzessTagName];
        var tags = new List<ProzessTag>();
        foreach (var name in tagNames) {
            var tag = await db.ProzessTags.AsTracking().FirstOrDefaultAsync(t => t.Tag == name);
            if (tag is null) {
                tag = new ProzessTag { Id = Guid.NewGuid(), Tag = name };
                db.ProzessTags.Add(tag);
            }
            tags.Add(tag);
        }

        var seed = new LageHelferProzessSeed("test", LageHelferProzessVorlage.Ereignismeldung, "Ereignis melden", [],
            ["Unwetter"]);
        var versionId = Guid.NewGuid();
        var (schritte, verbindungen, rollen) = EreignismeldungVorlage.Build(seed, versionId);
        foreach (var verbindung in verbindungen) {
            verbindung.Von.Verbindungen.Add(verbindung);
        }

        var now = scope.ServiceProvider.GetRequiredService<IClock>().GetCurrentInstant();
        var version = new ProzessVersion {
            Id = versionId,
            Prozess = new Prozess { Id = Guid.NewGuid(), Name = "Ereignis melden", KommuneId = kommuneId, Tags = tags },
            CreatedAt = now,
            PublishedAt = now,
            Schritte = schritte,
            Rollen = rollen,
            Beschreibungstext = EreignismeldungVorlage.Beschreibungstext,
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();
        version.StartId = schritte[0].Id;
        await db.SaveChangesAsync();

        return new Meldeprozess(versionId, schritte[0], verbindungen.Single(v => v.Von == schritte[0]));
    }

    protected async Task<IQueryResult> CreateAnonym(Meldeprozess prozess, LageSelectionInput? lage, double lng,
        double lat, string beschreibung = "Baum blockiert Straße", string[]? fotos = null) {
        ActAnonymously();
        return await ExecuteQuery(null, CreateAnonymMutation, new Dictionary<string, object?> {
            ["prozessVersionId"] = prozess.VersionId,
            ["sharedKeyEncryptedForKommune"] = "key",
            ["lage"] = lage is null
                ? null
                : new Dictionary<string, object?> { ["lageId"] = lage.LageId, ["gebietId"] = lage.GebietId },
            ["bearbeitungen"] = new List<Dictionary<string, object?>> {
                Bearbeitung(prozess.Meldung, prozess.ZurZuordnung, new (string, object)[] {
                    (EreignismeldungVorlage.StandortSlot,
                        new { addressString = "Zuhause", coordinates = new[] { lng, lat } }),
                    (EreignismeldungVorlage.KategorieSlot, "Unwetter"),
                    (EreignismeldungVorlage.BeschreibungSlot, beschreibung),
                }.Concat(fotos is null ? [] : [(EreignismeldungVorlage.BilderSlot, fotos)]).ToArray()),
            },
        });
    }

    protected static Guid CorrelationIdOf(IQueryResult create) =>
        JsonDocument.Parse(create.ToJson()).RootElement.GetProperty("data")
            .GetProperty("ausfuehrungCreateAnonym").GetProperty("anonymeAusfuehrungResult")
            .GetProperty("correlationId").GetGuid();

    protected async Task RunZustaendigkeitsschritt(Guid ausfuehrungId) {
        var schritt = Factory.Services.GetRequiredService<GebietEinsatzleitungZustaendigkeitSchritt>();
        await using var scope = Factory.Services.CreateAsyncScope();
        await using var walker = await scope.ServiceProvider.GetRequiredService<WalkerFactory>()
            .ContinueAusfuehrung(ausfuehrungId);
        var result = await schritt.ExecuteAsync(walker);
        walker.Step(SystemUser.UserId, result.NextVerbindungGuid, [], result.NaechsteIstZustaendigkeit, false);
        await walker.SaveChangesAsync();
    }

    private static Dictionary<string, object?> Bearbeitung(Schritt schritt, Verbindung verbindung,
        params (string Slot, object Value)[] slots) =>
        new() {
            ["schrittId"] = schritt.Id,
            ["nextVerbindungId"] = verbindung.Id,
            ["slotValues"] = slots.Select(s => new Dictionary<string, object?> {
                ["name"] = s.Slot,
                ["value"] = new Dictionary<string, object?> { ["plainValue"] = JsonSerializer.SerializeToElement(s.Value) },
            }).ToList(),
        };
}
