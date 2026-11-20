using System.Security.Claims;
using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Dienstleistungen;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Options;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class ProzessLoeschenTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string DeleteProzessVersionMutation = """
        mutation Loeschen($input: DeleteProzessVersionInput!) {
          deleteProzessVersion(deleteProzessVersionInput: $input) {
            prozessVersion { id }
            errors { __typename ... on Error { message } }
          }
        }
        """;

    private const string DeleteServicePortalLinkMutation = """
        mutation Loeschen($input: DeleteServicePortalLinkInput!) {
          deleteServicePortalLink(deleteServicePortalLinkInput: $input) {
            servicePortalLink { id }
            errors { __typename ... on Error { message } }
          }
        }
        """;

    private const string DeleteProzessMutation = """
        mutation Loeschen($input: DeleteProzessInput!) {
          deleteProzess(deleteProzessInput: $input) {
            prozess { id }
            errors { __typename ... on Error { message } }
          }
        }
        """;

    [Fact]
    public async Task DeleteProzessVersion_Ohne_Prozessverwaltung_Berechtigung_schlaegt_fehl() {
        var (_, versionIds, _) = await SeedProzessMitVersionen(2);
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[0] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.NotEmpty((IEnumerable<object>)payload!["errors"]!);
    }

    [Fact]
    public async Task DeleteProzessVersion_Mit_vorhandenen_Ausfuehrungen_schlaegt_fehl() {
        var (_, versionIds, schrittIds) = await SeedProzessMitVersionen(2);
        var buerger = await CreateBuergerAsync();
        await SeedAusfuehrung(versionIds[0], schrittIds[0], buerger.Id);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[0] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        var error = ((IEnumerable<object>)payload!["errors"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Single();
        Assert.Equal("ProzessVersionHasAusfuehrungen", error["__typename"]);
    }

    [Fact]
    public async Task HatAusfuehrungen_zeigt_pro_Version_ob_bereits_Ausfuehrungen_zugeordnet_sind() {
        var (prozessId, versionIds, schrittIds) = await SeedProzessMitVersionen(2);
        var buerger = await CreateBuergerAsync();
        await SeedAusfuehrung(versionIds[0], schrittIds[0], buerger.Id);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        const string query = """
            query Versionen($kommuneId: UUID!, $prozessId: UUID!) {
              kommune(kommuneId: $kommuneId) {
                prozessById(id: $prozessId) {
                  versionen { id hatAusfuehrungen }
                }
              }
            }
            """;

        var result = await ExecuteGraphqlAsync(mitarbeiter, query, new Dictionary<string, object?> {
            ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
            ["prozessId"] = prozessId,
        });

        Assert.Null(result.Errors);
        var kommune = result.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        var prozess = kommune!["prozessById"] as IReadOnlyDictionary<string, object>;
        var versionen = ((IEnumerable<object>)prozess!["versionen"]!)
            .Cast<IReadOnlyDictionary<string, object>>()
            .ToDictionary(v => (string)v["id"]!, v => (bool)v["hatAusfuehrungen"]!);

        Assert.True(versionen[versionIds[0].ToString()]);
        Assert.False(versionen[versionIds[1].ToString()]);
    }

    [Fact]
    public async Task DeleteProzessVersion_Letzte_verbleibende_Version_ohne_Ausfuehrungen_loescht_auch_den_Prozess() {
        var (prozessId, versionIds, _) = await SeedProzessMitVersionen(1);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[0] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.ProzessVersionen.AnyAsync(pv => pv.Id == versionIds[0]));
        Assert.False(await db.Prozesse.AnyAsync(p => p.Id == prozessId));
    }

    [Fact]
    public async Task DeleteProzessVersion_Letzte_verbleibende_Version_mit_Ausfuehrungen_schlaegt_weiterhin_fehl() {
        var (prozessId, versionIds, schrittIds) = await SeedProzessMitVersionen(1);
        var buerger = await CreateBuergerAsync();
        await SeedAusfuehrung(versionIds[0], schrittIds[0], buerger.Id);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[0] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        var error = ((IEnumerable<object>)payload!["errors"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Single();
        Assert.Equal("ProzessVersionHasAusfuehrungen", error["__typename"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.True(await db.Prozesse.AnyAsync(p => p.Id == prozessId));
    }

    [Fact]
    public async Task DeleteProzessVersion_Gleichzeitig_entstandene_Ausfuehrung_verhindert_das_Loeschen() {
        var (_, versionIds, schrittIds) = await SeedProzessMitVersionen(2);
        var buerger = await CreateBuergerAsync();

        await using var raceScope = Factory.Services.CreateAsyncScope();
        var raceDb = raceScope.ServiceProvider.GetRequiredService<DomainContext>();
        var version = await raceDb.ProzessVersionen.AsTracking().FirstAsync(pv => pv.Id == versionIds[0]);
        raceDb.Remove(version);

        await SeedAusfuehrung(versionIds[0], schrittIds[0], buerger.Id);

        await Assert.ThrowsAsync<DbUpdateException>(() => raceDb.SaveChangesAsync());
    }

    [Fact]
    public async Task DeleteProzessVersion_Letzte_veroeffentlichte_Version_schlaegt_fehl_trotz_verbleibendem_Entwurf() {
        var (_, versionIds, _) = await SeedProzessMitVersionen([true, false]);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[0] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        var error = ((IEnumerable<object>)payload!["errors"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Single();
        Assert.Equal("ProzessVersionIsLastPublished", error["__typename"]);
    }

    [Fact]
    public async Task DeleteProzessVersion_Entwurfsversion_neben_veroeffentlichter_Version_wird_geloescht() {
        var (prozessId, versionIds, _) = await SeedProzessMitVersionen([true, false]);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[1] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var verbleibendeVersionen =
            await db.ProzessVersionen.Where(pv => pv.ProzessId == prozessId).Select(pv => pv.Id).ToListAsync();
        Assert.Equal([versionIds[0]], verbleibendeVersionen);
    }

    [Fact]
    public async Task DeleteProzessVersion_Aktuell_aktive_Version_schlaegt_fehl_trotz_aelterer_veroeffentlichter_Version() {
        var (_, versionIds, _) = await SeedProzessMitVersionen([true, true]);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[1] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        var error = ((IEnumerable<object>)payload!["errors"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Single();
        Assert.Equal("ProzessVersionIsCurrentVersion", error["__typename"]);
    }

    [Fact]
    public async Task DeleteProzessVersion_Aeltere_veroeffentlichte_Version_neben_aktueller_wird_geloescht() {
        var (prozessId, versionIds, _) = await SeedProzessMitVersionen([true, true]);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[0] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var verbleibendeVersionen =
            await db.ProzessVersionen.Where(pv => pv.ProzessId == prozessId).Select(pv => pv.Id).ToListAsync();
        Assert.Equal([versionIds[1]], verbleibendeVersionen);
    }

    [Fact]
    public async Task DeleteProzessVersion_Unbenutzte_und_nicht_letzte_Version_wird_geloescht() {
        var (prozessId, versionIds, _) = await SeedProzessMitVersionen(2);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionIds[0] } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);
        var geloeschteVersion = payload!["prozessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.Equal(versionIds[0].ToString(), geloeschteVersion!["id"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var verbleibendeVersionen =
            await db.ProzessVersionen.Where(pv => pv.ProzessId == prozessId).Select(pv => pv.Id).ToListAsync();
        Assert.Equal([versionIds[1]], verbleibendeVersionen);
    }

    [Fact]
    public async Task DeleteProzessVersion_Raeumt_Schritte_Verbindungen_Formularfelder_und_Rollen_aus_laesst_aber_zustaendige_Stellen_unangetastet() {
        await using var seedScope = Factory.Services.CreateAsyncScope();
        var seedDb = seedScope.ServiceProvider.GetRequiredService<DomainContext>();

        var untereinheit = new Untereinheit {
            Id = Guid.NewGuid(),
            Name = $"CascadeCheck OE {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = true,
            Regionalschluessel = "03252099",
        };
        var mitarbeiterGruppe = new MitarbeiterGruppe {
            Id = Guid.NewGuid(),
            Name = $"CascadeCheck Abteilung {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Mitarbeiter = new List<Mitarbeiter>(),
        };
        var dienstleister = new Dienstleister {
            Id = Guid.NewGuid(),
            Name = $"CascadeCheck DL {Guid.NewGuid():N}",
            MandantId = KommuneSeeder.LandkreisHaPy.Id,
            EMailAdressen = ["cascade-check@test.local"],
        };
        seedDb.Untereinheit.Add(untereinheit);
        seedDb.MitarbeiterGruppen.Add(mitarbeiterGruppe);
        seedDb.Dienstleister.Add(dienstleister);
        await seedDb.SaveChangesAsync();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = $"ProzessLoeschenTest CascadeCheck {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        var formularSchritt = new FormularSchritt {
            Id = Guid.NewGuid(),
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = untereinheit.Id,
                MitarbeiterGruppeId = mitarbeiterGruppe.Id,
            },
            Felder = new List<FormularFeld> {
                new StringFormularFeld { SlotName = "foo", Order = 0 },
            },
        };
        var endeSchritt = new EndeSchritt {
            Id = Guid.NewGuid(),
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Dienstleister,
                DienstleisterId = dienstleister.Id,
            },
        };
        var verbindung = new Verbindung { Von = formularSchritt, Nach = endeSchritt };
        formularSchritt.Verbindungen.Add(verbindung);

        var rolle = new ZustaendigkeitRolle { Id = Guid.NewGuid(), Name = "CascadeCheck Rolle" };
        var reicheVersion = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 1, 1, 0, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 1, 1, 0, 0, 0),
            Beschreibungstext = "test",
            Schritte = [formularSchritt, endeSchritt],
            Rollen = [rolle],
        };
        seedDb.ProzessVersionen.Add(reicheVersion);
        await seedDb.SaveChangesAsync();
        reicheVersion.StartId = formularSchritt.Id;
        await seedDb.SaveChangesAsync();

        var zweiteVersion = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 1, 1, 0, 1, 0),
            PublishedAt = Instant.FromUtc(2026, 1, 1, 0, 1, 0),
            Beschreibungstext = "test",
        };
        seedDb.ProzessVersionen.Add(zweiteVersion);
        await seedDb.SaveChangesAsync();

        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> {
                ["input"] = new Dictionary<string, object?> { ["id"] = reicheVersion.Id },
            });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.Schritte.AnyAsync(s => s.Id == formularSchritt.Id || s.Id == endeSchritt.Id));
        Assert.False(await db.Set<Verbindung>().AnyAsync(v => v.Id == verbindung.Id));
        Assert.False(await db.Set<FormularFeld>().AnyAsync(f => f.SchrittId == formularSchritt.Id));
        Assert.False(await db.Set<ZustaendigkeitRolle>().AnyAsync(r => r.Id == rolle.Id));

        Assert.True(await db.Untereinheit.AnyAsync(u => u.Id == untereinheit.Id));
        Assert.True(await db.MitarbeiterGruppen.AnyAsync(g => g.Id == mitarbeiterGruppe.Id));
        Assert.True(await db.Dienstleister.AnyAsync(d => d.Id == dienstleister.Id));
    }

    [Theory]
    [InlineData(true, false)]
    [InlineData(false, true)]
    [InlineData(true, true)]
    public async Task DeleteProzessVersion_Mit_Rollen_in_Schritten_wird_geloescht_und_andere_Version_behaelt_ihre_Rolle(
        bool schreibtRolle, bool liestRolle) {
        var (prozessId, zuLoeschen, andere, rolle, andereRolle) = await SeedProzessMitRollenVersionen(schreibtRolle, liestRolle);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = zuLoeschen } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.ProzessVersionen.AnyAsync(pv => pv.Id == zuLoeschen));
        Assert.False(await db.Schritte.AnyAsync(s => s.ProzessVersionId == zuLoeschen));
        Assert.False(await db.Set<ZustaendigkeitRolle>().AnyAsync(r => r.Id == rolle));
        Assert.True(await db.ProzessVersionen.AnyAsync(pv => pv.Id == andere));
        Assert.True(await db.Set<ZustaendigkeitRolle>().AnyAsync(r => r.Id == andereRolle));
        Assert.True(await db.Prozesse.AnyAsync(p => p.Id == prozessId));
    }

    [Fact]
    public async Task DeleteProzessVersion_Letzte_Version_mit_Rollen_in_Schritten_loescht_Prozess_und_Rollen() {
        var (prozessId, versionId, rolleId) = await SeedLetzteVersionMitRolle();
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = versionId } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.Prozesse.AnyAsync(p => p.Id == prozessId));
        Assert.False(await db.Set<ZustaendigkeitRolle>().AnyAsync(r => r.Id == rolleId));
    }

    [Fact]
    public async Task DeleteProzessVersion_Mit_Ausfuehrungen_laesst_Rollen_unangetastet() {
        var (_, zuLoeschen, _, rolle, _) = await SeedProzessMitRollenVersionen(true, false);
        await using (var seedScope = Factory.Services.CreateAsyncScope()) {
            var seedDb = seedScope.ServiceProvider.GetRequiredService<DomainContext>();
            var schrittId = await seedDb.Schritte.Where(s => s.ProzessVersionId == zuLoeschen).Select(s => s.Id).FirstAsync();
            var buerger = await CreateBuergerAsync();
            await SeedAusfuehrung(zuLoeschen, schrittId, buerger.Id);
        }
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessVersionMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = zuLoeschen } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzessVersion"] as IReadOnlyDictionary<string, object>;
        var error = ((IEnumerable<object>)payload!["errors"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Single();
        Assert.Equal("ProzessVersionHasAusfuehrungen", error["__typename"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.True(await db.Set<ZustaendigkeitRolle>().AnyAsync(r => r.Id == rolle));
        Assert.True(await db.ProzessVersionen.AnyAsync(pv => pv.Id == zuLoeschen));
    }

    [Fact]
    public async Task DeleteServicePortalLink_Ohne_Prozessverwaltung_Berechtigung_schlaegt_fehl() {
        var linkId = await SeedServicePortalLink();
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteServicePortalLinkMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = linkId } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteServicePortalLink"] as IReadOnlyDictionary<string, object>;
        Assert.NotEmpty((IEnumerable<object>)payload!["errors"]!);
    }

    [Fact]
    public async Task DeleteServicePortalLink_Wird_geloescht() {
        var linkId = await SeedServicePortalLink();
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteServicePortalLinkMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = linkId } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteServicePortalLink"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.ServicePortalLink.AnyAsync(l => l.Id == linkId));
    }

    [Fact]
    public async Task DeleteProzess_Ohne_Prozessverwaltung_Berechtigung_schlaegt_fehl() {
        var prozessId = await SeedProzessOhneVersion();
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzess"] as IReadOnlyDictionary<string, object>;
        Assert.NotEmpty((IEnumerable<object>)payload!["errors"]!);
    }

    [Fact]
    public async Task DeleteProzess_Mit_vorhandenen_Versionen_schlaegt_fehl() {
        var (prozessId, _, _) = await SeedProzessMitVersionen(1);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzess"] as IReadOnlyDictionary<string, object>;
        var error = ((IEnumerable<object>)payload!["errors"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Single();
        Assert.Equal("ProzessHasVersionen", error["__typename"]);
    }

    [Fact]
    public async Task DeleteProzess_Ohne_Versionen_wird_geloescht() {
        var prozessId = await SeedProzessOhneVersion();
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DeleteProzessMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        Assert.Null(result.Errors);
        var payload = result.Data!["deleteProzess"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.Prozesse.AnyAsync(p => p.Id == prozessId));
    }

    private async Task<Guid> SeedProzessOhneVersion() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = $"ProzessLoeschenTest ohne Version {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        db.Prozesse.Add(prozess);
        await db.SaveChangesAsync();
        return prozess.Id;
    }

    /// <summary>Legt einen Prozess mit der angegebenen Anzahl Versionen an, je mit eigenem EndeSchritt als Start.</summary>
    private Task<(Guid ProzessId, List<Guid> VersionIds, List<Guid> SchrittIds)> SeedProzessMitVersionen(
        int anzahlVersionen) =>
        SeedProzessMitVersionen(Enumerable.Repeat(true, anzahlVersionen).ToList());

    /// <summary>Legt einen Prozess mit einer Version je Eintrag in <paramref name="veroeffentlicht"/> an
    /// (true = veröffentlicht, false = Entwurf), je mit eigenem EndeSchritt als Start.</summary>
    private async Task<(Guid ProzessId, List<Guid> VersionIds, List<Guid> SchrittIds)> SeedProzessMitVersionen(
        List<bool> veroeffentlicht) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = $"ProzessLoeschenTest {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        var versionIds = new List<Guid>();
        var schrittIds = new List<Guid>();
        var basisZeitpunkt = Instant.FromUtc(2026, 1, 1, 0, 0, 0);

        for (var i = 0; i < veroeffentlicht.Count; i++) {
            var endeSchritt = new EndeSchritt {
                Id = Guid.NewGuid(),
                SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            };
            var version = new ProzessVersion {
                Id = Guid.NewGuid(),
                Prozess = prozess,
                CreatedAt = basisZeitpunkt.Plus(Duration.FromMinutes(i)),
                PublishedAt = veroeffentlicht[i] ? basisZeitpunkt.Plus(Duration.FromMinutes(i)) : null,
                Beschreibungstext = "test",
                Schritte = [endeSchritt],
            };
            db.ProzessVersionen.Add(version);
            await db.SaveChangesAsync();

            version.StartId = endeSchritt.Id;
            await db.SaveChangesAsync();

            versionIds.Add(version.Id);
            schrittIds.Add(endeSchritt.Id);
        }

        return (prozess.Id, versionIds, schrittIds);
    }

    private static Schritt RollenSchritt(Guid? schreibtRolleId, Guid? liestRolleId) => new EndeSchritt {
        Id = Guid.NewGuid(),
        SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger, LiestRolleId = liestRolleId },
        SchreibtRolleId = schreibtRolleId,
    };

    private async Task<(Guid ProzessId, Guid ZuLoeschen, Guid Andere, Guid Rolle, Guid AndereRolle)>
        SeedProzessMitRollenVersionen(bool schreibtRolle, bool liestRolle) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = $"ProzessLoeschenTest Rollen {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        var rolle = new ZustaendigkeitRolle { Id = Guid.NewGuid(), Name = "Rolle alt" };
        var andereRolle = new ZustaendigkeitRolle { Id = Guid.NewGuid(), Name = "Rolle neu" };
        var basis = Instant.FromUtc(2026, 1, 1, 0, 0, 0);

        var schritt = RollenSchritt(schreibtRolle ? rolle.Id : null, liestRolle ? rolle.Id : null);
        var zuLoeschen = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = basis,
            PublishedAt = basis,
            Beschreibungstext = "test",
            Schritte = [schritt],
            Rollen = [rolle],
        };
        var andereSchritt = RollenSchritt(andereRolle.Id, andereRolle.Id);
        var andere = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = basis.Plus(Duration.FromMinutes(1)),
            PublishedAt = basis.Plus(Duration.FromMinutes(1)),
            Beschreibungstext = "test",
            Schritte = [andereSchritt],
            Rollen = [andereRolle],
        };
        db.ProzessVersionen.AddRange(zuLoeschen, andere);
        await db.SaveChangesAsync();
        zuLoeschen.StartId = schritt.Id;
        andere.StartId = andereSchritt.Id;
        await db.SaveChangesAsync();

        return (prozess.Id, zuLoeschen.Id, andere.Id, rolle.Id, andereRolle.Id);
    }

    private async Task<(Guid ProzessId, Guid VersionId, Guid RolleId)> SeedLetzteVersionMitRolle() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = $"ProzessLoeschenTest LetzteRolle {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        var rolle = new ZustaendigkeitRolle { Id = Guid.NewGuid(), Name = "Rolle" };
        var schritt = RollenSchritt(rolle.Id, rolle.Id);
        var version = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 1, 1, 0, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 1, 1, 0, 0, 0),
            Beschreibungstext = "test",
            Schritte = [schritt],
            Rollen = [rolle],
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();
        version.StartId = schritt.Id;
        await db.SaveChangesAsync();

        return (prozess.Id, version.Id, rolle.Id);
    }

    private async Task<Guid> SeedAusfuehrung(Guid prozessVersionId, Guid schrittId, Guid buergerUserId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var id = Guid.NewGuid();
        var sharedKey = RandomNumberGenerator.GetBytes(32);
        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = id,
            ProzessVersionId = prozessVersionId,
            UserId = buergerUserId,
            CreatedAt = SystemClock.Instance.GetCurrentInstant(),
            Status = AusfuehrungStatus.BearbeitungDurchBuerger,
            SchrittId = schrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Followers = [],
            Bearbeitungen = [],
        });
        await db.SaveChangesAsync();
        return id;
    }

    private async Task<Guid> SeedServicePortalLink() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var link = new ServicePortalLink {
            Id = Guid.NewGuid(),
            Name = $"ProzessLoeschenTest Link {Guid.NewGuid():N}",
            Url = "https://example.org",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        db.ServicePortalLink.Add(link);
        await db.SaveChangesAsync();
        return link.Id;
    }

    private async Task<Buerger> CreateBuergerAsync() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        await db.SaveChangesAsync();
        return buerger;
    }

    private async Task<ClaimsPrincipal> CreateBackofficeUserWithPrincipalAsync(
        List<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"prozess-loeschen-test-{Guid.NewGuid():N}@test.local",
            Vorname = "Prozess",
            Nachname = "LoeschenTest",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Admin,
            Funktionsberechtigungen = globaleFunktionsberechtigungen,
            Gruppen = [],
            UntereinheitPermissions = [],
        };

        // CurrentUserAccessor.User() lehnt Mitarbeiter ohne OrganisationPrivateKey als
        // unauthentifiziert ab - Crypto-Bootstrap wie beim echten Login nötig, obwohl dieser Test
        // das JWT direkt baut statt die Login-Mutation zu durchlaufen.
        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        TestUserCrypto.InitializeMitarbeiterCrypto(user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey,
            hasher);

        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        var identity = new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt");
        return new ClaimsPrincipal(identity);
    }
}
