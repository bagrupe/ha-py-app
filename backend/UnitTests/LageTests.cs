using System.Text.Json.Nodes;
using API.Features;
using API.Features.Lage;
using API.Features.Untereinheit;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class LageTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string Polygon = """{"type":"Polygon","coordinates":[[[9.35,52.1],[9.4,52.1],[9.4,52.15],[9.35,52.1]]]}""";

    private DomainContext NewDb() =>
        Factory.Services.CreateScope().ServiceProvider.GetRequiredService<DomainContext>();

    private async Task<Guid> NewUntereinheit() {
        var untereinheit = new Untereinheit {
            Id = Guid.NewGuid(),
            Name = $"Landkreis {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = false,
        };
        var db = NewDb();
        db.Untereinheit.Add(untereinheit);
        await db.SaveChangesAsync();
        return untereinheit.Id;
    }

    private static Gebiet NewGebiet(Guid untereinheitId, string? name = null) => new() {
        Id = Guid.NewGuid(),
        UntereinheitId = untereinheitId,
        Name = name ?? $"Gebiet {Guid.NewGuid():N}",
        Geometry = Polygon,
    };

    private static Lage NewLage(Guid untereinheitId, params Gebiet[] gebiete) =>
        Lage.Create(untereinheitId, "Hochwasser", gebiete, Guid.NewGuid(), SystemClock.Instance.GetCurrentInstant());

    [Fact]
    public async Task Lage_with_Gebiete_round_trips_including_geometry() {
        var untereinheitId = await NewUntereinheit();
        var gebiet = NewGebiet(untereinheitId);
        var lage = NewLage(untereinheitId, gebiet);
        lage.Note = "intern";
        lage.WarningText = "Keller meiden";

        var db = NewDb();
        db.Gebiete.Add(gebiet);
        db.Lagen.Add(lage);
        await db.SaveChangesAsync();

        var loaded = await NewDb().Lagen
            .Include(l => l.LageGebiete).ThenInclude(lg => lg.Gebiet)
            .SingleAsync(l => l.Id == lage.Id);

        Assert.Equal(LageStatus.Created, loaded.Status);
        Assert.Equal(untereinheitId, loaded.UntereinheitId);
        Assert.Equal(lage.CreatedById, loaded.CreatedById);
        Assert.Equal("intern", loaded.Note);
        Assert.Equal("Keller meiden", loaded.WarningText);
        Assert.Null(loaded.ClosedAt);
        var loadedLageGebiet = Assert.Single(loaded.LageGebiete);
        Assert.Equal(LageGebietStatus.Inactive, loadedLageGebiet.Status);
        Assert.Null(loadedLageGebiet.CalledOutAt);
        var loadedGebiet = loadedLageGebiet.Gebiet;
        Assert.Equal(gebiet.Name, loadedGebiet.Name);
        Assert.True(JsonNode.DeepEquals(JsonNode.Parse(Polygon), JsonNode.Parse(loadedGebiet.Geometry)));
    }

    [Fact]
    public async Task TransitionTo_is_persisted() {
        var untereinheitId = await NewUntereinheit();
        var gebiet = NewGebiet(untereinheitId);
        var lage = NewLage(untereinheitId, gebiet);
        var db = NewDb();
        db.Gebiete.Add(gebiet);
        db.Lagen.Add(lage);
        await db.SaveChangesAsync();

        var userId = Guid.NewGuid();
        var at = Instant.FromUnixTimeSeconds(1_700_000_000);
        var tracked = NewDb();
        var lageGebiet = await tracked.LageGebiete.AsTracking()
            .SingleAsync(lg => lg.LageId == lage.Id && lg.GebietId == gebiet.Id);
        lageGebiet.TransitionTo(LageGebietStatus.CalledOut, userId, at);
        await tracked.SaveChangesAsync();

        var loaded = await NewDb().LageGebiete
            .SingleAsync(lg => lg.LageId == lage.Id && lg.GebietId == gebiet.Id);
        Assert.Equal(LageGebietStatus.CalledOut, loaded.Status);
        Assert.Equal(at, loaded.CalledOutAt);
        Assert.Equal(userId, loaded.CalledOutById);
    }

    [Fact]
    public async Task Same_Gebiet_name_in_two_Untereinheiten_is_allowed() {
        var firstUntereinheitId = await NewUntereinheit();
        var secondUntereinheitId = await NewUntereinheit();
        var name = $"Nord {Guid.NewGuid():N}";
        var db = NewDb();
        db.Gebiete.AddRange(NewGebiet(firstUntereinheitId, name), NewGebiet(secondUntereinheitId, name));
        await db.SaveChangesAsync();
    }

    [Fact]
    public async Task Same_Gebiet_name_twice_in_one_Untereinheit_fails() {
        var untereinheitId = await NewUntereinheit();
        var name = $"Nord {Guid.NewGuid():N}";
        var db = NewDb();
        db.Gebiete.Add(NewGebiet(untereinheitId, name));
        await db.SaveChangesAsync();

        var second = NewDb();
        second.Gebiete.Add(NewGebiet(untereinheitId, name));
        await Assert.ThrowsAsync<DbUpdateException>(() => second.SaveChangesAsync());
    }

    [Fact]
    public async Task Gebiet_without_Untereinheit_fails() {
        var db = NewDb();
        db.Gebiete.Add(NewGebiet(Guid.NewGuid()));
        var error = await Assert.ThrowsAsync<DbUpdateException>(() => db.SaveChangesAsync());
        Assert.Equal(Npgsql.PostgresErrorCodes.ForeignKeyViolation, Assert.IsType<Npgsql.PostgresException>(error.InnerException).SqlState);
    }

    [Fact]
    public async Task One_Gebiet_can_belong_to_two_Lagen() {
        var untereinheitId = await NewUntereinheit();
        var gebiet = NewGebiet(untereinheitId);

        var db = NewDb();
        db.Gebiete.Add(gebiet);
        db.Lagen.AddRange(NewLage(untereinheitId, gebiet), NewLage(untereinheitId, gebiet));
        await db.SaveChangesAsync();

        Assert.Equal(2, await NewDb().LageGebiete.CountAsync(lg => lg.GebietId == gebiet.Id));
    }

    [Fact]
    public async Task Deleting_a_Gebiet_linked_to_a_Lage_fails() {
        var untereinheitId = await NewUntereinheit();
        var gebiet = NewGebiet(untereinheitId);

        var db = NewDb();
        db.Gebiete.Add(gebiet);
        db.Lagen.Add(NewLage(untereinheitId, gebiet));
        await db.SaveChangesAsync();

        var error = await Assert.ThrowsAsync<Npgsql.PostgresException>(() =>
            NewDb().Gebiete.Where(g => g.Id == gebiet.Id).ExecuteDeleteAsync());
        Assert.Equal(Npgsql.PostgresErrorCodes.ForeignKeyViolation, error.SqlState);
    }

    [Fact]
    public async Task Lage_without_Untereinheit_fails() {
        var lage = NewLage(Guid.NewGuid());

        var db = NewDb();
        db.Lagen.Add(lage);
        var error = await Assert.ThrowsAsync<DbUpdateException>(() => db.SaveChangesAsync());
        Assert.Equal(Npgsql.PostgresErrorCodes.ForeignKeyViolation, Assert.IsType<Npgsql.PostgresException>(error.InnerException).SqlState);
    }
}
