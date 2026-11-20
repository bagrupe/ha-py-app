using API.Features;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Npgsql;
using Respawn;

namespace IntegrationTests;

/// <summary>
/// Isolated API host for <see cref="LageHelferSeederTest"/> with per-test database reset.
/// </summary>
public class LageHelferSeederApiFactory : BackendApiFactory {
    private Respawner? _respawner;

    protected override void ConfigureWebHost(IWebHostBuilder builder) {
        base.ConfigureWebHost(builder);
        builder.ConfigureTestServices(services => {
            // Scoped DomainContext is overridden for tests; re-point the pooled factory so seeders see the same DB.
            services.RemoveAll<IDbContextFactory<DomainContext>>();
            services.AddDbContextFactory<DomainContext>(options => {
                var connString = Environment.GetEnvironmentVariable("TEST_DB_CONNECTION")
                    ?? "Host=localhost;Port=5433;Database=local_test_db;Username=postgres;Password=postgres;";
                var dataSourceBuilder = new NpgsqlDataSourceBuilder(connString);
                dataSourceBuilder.EnableDynamicJson();
                dataSourceBuilder.UseNodaTime();
                options.UseNpgsql(dataSourceBuilder.Build());
            });
        });
    }

    public async Task ResetDatabaseAsync() {
        using var scope = Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var connection = db.Database.GetDbConnection();
        if (connection.State != System.Data.ConnectionState.Open) {
            await connection.OpenAsync();
        }

        _respawner ??= await Respawner.CreateAsync(connection, new RespawnerOptions {
            DbAdapter = DbAdapter.Postgres,
            TablesToIgnore =
            [
                "__EFMigrationsHistory",
                "__EFMigrationsHistory_Archive",
            ],
        });

        await _respawner.ResetAsync(connection);
    }
}

[CollectionDefinition("LageHelfer Seeder Tests", DisableParallelization = true)]
public class LageHelferSeederTestCollection : ICollectionFixture<LageHelferSeederApiFactory>;
