using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using API.Features;
using API.Features.Aufbewahrung.Archive;
using API.Features.Auth;
using API.Features.Auth.BundId;
using API.Features.ObjectStorage;
using API.Features.PdfGenerator;
using API.Features.PushNotifications;
using HotChocolate.Execution;
using IntegrationTests.TestDoubles;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using NodaTime;
using NodaTime.Testing;
using Npgsql;
using Respawn;
using UnitTests;

namespace IntegrationTests;

public class BackendApiFactory : WebApplicationFactory<API.Program>, IAsyncLifetime {
    private Respawner _respawner;

    protected virtual IReadOnlyDictionary<string, string?> ConfigurationOverrides =>
        new Dictionary<string, string?>();

    protected virtual bool ResetsTestDatabase => true;

    protected virtual bool ConfiguresObjectStorage => true;

    protected override void ConfigureWebHost(IWebHostBuilder builder) {
        builder.UseEnvironment("Testing");
        builder.ConfigureAppConfiguration(config => config.AddInMemoryCollection(ConfigurationOverrides));

        if (ConfiguresObjectStorage) {
            builder.UseSetting("ObjectStorage:ServiceUrl", TestSetting("TEST_OBJECT_STORAGE_URL", "http://localhost:9010"));
            builder.UseSetting("ObjectStorage:Bucket", TestSetting("TEST_OBJECT_STORAGE_BUCKET", "hameln-test"));
            builder.UseSetting("ObjectStorage:AccessKeyId", TestSetting("TEST_OBJECT_STORAGE_ACCESS_KEY", "hameln-test"));
            builder.UseSetting("ObjectStorage:SecretAccessKey",
                TestSetting("TEST_OBJECT_STORAGE_SECRET_KEY", "hameln-test-secret"));
        }

        builder.ConfigureTestServices(services => {
            // 1. Remove existing DB registration
            services.RemoveAll(typeof(DbContextOptions<DomainContext>));
            services.RemoveAll(typeof(DomainContext));

            var connString = Environment.GetEnvironmentVariable("TEST_DB_CONNECTION")
                ?? "Host=localhost;Port=5433;Database=local_test_db;Username=postgres;Password=postgres;";

            // 2. Build the data source and explicitly enable dynamic JSON
            var dataSourceBuilder = new NpgsqlDataSourceBuilder(connString);
            dataSourceBuilder.EnableDynamicJson();
            dataSourceBuilder.UseNodaTime();
            var dataSource = dataSourceBuilder.Build();

            // 3. Register the DbContext using the configured data source
            services.AddDbContext<DomainContext>(options =>
                options.UseNpgsql(dataSource));

            // ArchiveContext points at Program.cs's own NpgsqlDataSource by default (built once at
            // startup from ConnectionStrings:Archive, unaffected by the override above) - re-point it
            // at the same test Postgres/database as DomainContext (its two tables don't collide with
            // DomainContext's), so tests can exercise archiving without a separate Archiv-Postgres.
            services.RemoveAll(typeof(DbContextOptions<ArchiveContext>));
            services.AddDbContext<ArchiveContext>(options =>
                options.UseNpgsql(dataSource, o => o.MigrationsHistoryTable("__EFMigrationsHistory_Archive")));

            // we mock the http-client used for the communication with the payload-cms.
            services.AddHttpClient("BereichBInternal")
                .ConfigurePrimaryHttpMessageHandler(() => new FakeSsoHttpMessageHandler());

            // Strawberry Shake registers named client "BereichBClient" (see generated Client.cs).
            // Stub GraphQL so integration tests do not need the real CMS on localhost:3001.
            // Schema stitching uses the separate named client "BereichB"; avoid querying stitched-only fields
            // (e.g. Kommune.name) in tests unless that client is stubbed too.
            services.AddHttpClient("BereichBClient")
                .ConfigurePrimaryHttpMessageHandler(() => new FakeBereichBGraphQLHttpMessageHandler());

            // Find and remove the Quartz hosted service so it doesn't start during tests
            var quartzHostedService = services.FirstOrDefault(d =>
                d.ServiceType == typeof(Microsoft.Extensions.Hosting.IHostedService) &&
                d.ImplementationType?.Name == "QuartzHostedService");

            if (quartzHostedService != null) {
                services.Remove(quartzHostedService);
            }

            // or rename if needed later on:
            // services.Configure<QuartzOptions>(opt => opt.SchedulerName = Guid.NewGuid().ToString());

            // for testing push notifications:
            services.RemoveAll(typeof(IFirebasePushMessagingService));
            services.AddSingleton<IFirebasePushMessagingService, RecordingFirebasePushMessagingService>();


            // GotenbergService renders PDFs via the default (unnamed) HttpClient.
            services.AddHttpClient(string.Empty)
                .ConfigurePrimaryHttpMessageHandler(() => new FakeGotenbergHttpMessageHandler());

            // Keeps tests off the real tile server while the "StaticMapTiles" client registration stays under test.
            services.RemoveAll(typeof(StaticMapService));
            services.AddSingleton(new FakeTileHandler().CreateService());

            // or rename if needed later on:
            // services.Configure<QuartzOptions>(opt => opt.SchedulerName = Guid.NewGuid().ToString());

            // use FakeClock:
            services.RemoveAll(typeof(IClock));
            Instant testBaselineTime = Instant.FromUtc(2026, 6, 30, 12, 0, 0);
            services.AddSingleton<FakeClock>(provider => new FakeClock(testBaselineTime, Duration.FromSeconds(1)));
            services.AddSingleton<IClock>(provider => provider.GetRequiredService<FakeClock>());

            // for sms-sending:
            services.RemoveAll(typeof(ISmsService));
            services.AddSingleton<RecordingSmsService>(provider => new RecordingSmsService());
            services.AddSingleton<ISmsService>(provider => provider.GetRequiredService<RecordingSmsService>());

            // for BundID login: replace real Keycloak-token validation (network call) with a fake
            // that returns whatever ClaimsPrincipal a test registers for a given opaque token string.
            services.RemoveAll(typeof(IKeycloakTokenValidator));
            services.AddSingleton<FakeKeycloakTokenValidator>(provider => new FakeKeycloakTokenValidator());
            services.AddSingleton<IKeycloakTokenValidator>(provider => provider.GetRequiredService<FakeKeycloakTokenValidator>());

            // No production consumer exists yet, so the upload/download routes are exercised through test consumers.
            services.AddSingleton<TestObjectStorageConsumers>();
            services.AddObjectStorageConsumer<TestObjectStorageConsumer>();
            services.AddObjectStorageConsumer<OtherTestObjectStorageConsumer>();
        });
    }

    private static string TestSetting(string environmentVariable, string localDefault) =>
        Environment.GetEnvironmentVariable(environmentVariable) ?? localDefault;

    public new async Task DisposeAsync() => await Task.CompletedTask;

    public async Task InitializeAsync() {
        if (ResetsTestDatabase) {
            DockerTestUtility.ResetTestDBForLocalTests();
        }

        using var scope = Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await db.Database.MigrateAsync();

        var archiveDb = scope.ServiceProvider.GetRequiredService<ArchiveContext>();
        await archiveDb.Database.MigrateAsync();
        // _respawner = await Respawner.CreateAsync(db.Database.GetDbConnection(), new RespawnerOptions {
        //     DbAdapter = DbAdapter.Postgres,
        //     TablesToIgnore = new Table[] { "__EFMigrationsHistory" }
        // });

    }

    public async Task ResetDB() {
        // using var scope = Services.CreateScope();
        // var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        // db.Database.OpenConnection();
        // await _respawner.ResetAsync(db.Database.GetDbConnection());
    }
}


// 2. Define the Collection Fixture
[CollectionDefinition("Api Tests", DisableParallelization = true)]
public class ApiTestCollection : ICollectionFixture<BackendApiFactory> {
    // This class has no code. It just tells xUnit to group tests together
    // and share the BackendApiFactory instance among them.
}

[Collection("Api Tests")]
public class GraphQLTests(BackendApiFactory factory) : IAsyncLifetime {
    protected BackendApiFactory Factory { get; } = factory;

    protected CryptoService crypto = new();

    protected const string SuperAdminEmail = "superadmin-hapy@example.com";
    protected const string SuperAdminPassword = "123456";

    protected TestSeeder testSeeder = new TestSeeder(factory);




    protected async Task<ClaimsPrincipal> GetUserToken(string email, string password) {
        var passwordPayload = crypto.GetServerLoginPassword(password, email);
        var loginInput = new Dictionary<string, object?> {
            { "email", email },
            { "password", passwordPayload }
        };

        var result = await ExecuteQuery(null, """
            mutation Login($input: LoginInput!) {
                login(input: $input) {
                    result
                    token
                }
            }
        """, loginInput);
        var queryResult = result.ExpectQueryResult();

        Assert.Null(queryResult.Errors);
        var loginResponse = queryResult.Data!["login"] as IReadOnlyDictionary<string, object>;
        var token = loginResponse!["token"] as string;

        var handler = new JwtSecurityTokenHandler();
        var jwtToken = handler.ReadJwtToken(token);

        var identity = new ClaimsIdentity(jwtToken.Claims, "jwt");

        return new ClaimsPrincipal(identity);
    }

    // protected async Task<ClaimsPrincipal> GetBuergerToken(Guid buergerId, string password) {

    // }

    protected async Task<IQueryResult> ExecuteQuery(ClaimsPrincipal? user, string query, Dictionary<string, object?>? parameters) {
        var executorResolver = Factory.Services.GetRequiredService<IRequestExecutorResolver>();
        var executor = await executorResolver.GetRequestExecutorAsync();

        var request = QueryRequestBuilder.New()
            .SetQuery(query);

        if (parameters is not null) {
            request.SetVariableValue("input", parameters);
        }

        if (user != null) {
            SetHttpContextUser(user);
            request.SetUser(user);
        }

        var result = await executor.ExecuteAsync(request.Create());
        var queryResult = result.ExpectQueryResult();
        return queryResult;
    }

    /// <summary>Runs a GraphQL operation with arbitrary named variables (not only <c>input</c>).</summary>
    protected async Task<IQueryResult> ExecuteGraphqlAsync(ClaimsPrincipal? user, string query,
        IReadOnlyDictionary<string, object?>? variables = null) {
        var executorResolver = Factory.Services.GetRequiredService<IRequestExecutorResolver>();
        var executor = await executorResolver.GetRequestExecutorAsync();

        var request = QueryRequestBuilder.New()
            .SetQuery(query);

        if (variables is not null) {
            foreach (var (name, value) in variables) {
                request.SetVariableValue(name, value);
            }
        }

        if (user != null) {
            SetHttpContextUser(user);
            request.SetUser(user);
        }

        var result = await executor.ExecuteAsync(request.Create());
        return result.ExpectQueryResult();
    }

    private void SetHttpContextUser(ClaimsPrincipal principal) {
        var httpContextAccessor = Factory.Services.GetRequiredService<IHttpContextAccessor>();
        httpContextAccessor.HttpContext = new DefaultHttpContext {
            User = principal
        };
    }

    public async Task InitializeAsync() {
        // await factory.ResetDB();
    }

    public Task DisposeAsync() => Task.CompletedTask;

    protected static ClaimsPrincipal Principal(Guid userId) =>
    new(new ClaimsIdentity([new Claim(ClaimTypes.NameIdentifier, userId.ToString())], "TestAuthType"));

    /// <summary>Authentifizierungsloser Aufrufer. Ein leerer Principal (statt null) stellt sicher,
    /// dass der geteilte HttpContext nicht den Nutzer des vorherigen Tests behält.</summary>
    protected static ClaimsPrincipal Anonymous() => new(new ClaimsIdentity());

    // helpers for graphql-responses
    protected static IReadOnlyDictionary<string, object?> Payload(IQueryResult result, string field) {
        Assert.Null(result.Errors);
        var data = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(result.Data);
        return Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(data[field]);
    }

    protected static void DenyMutationError(IQueryResult result, string field) {
        var payload = Payload(result, field);
        Assert.Null(payload["errors"]);
    }

    protected static void AssertMutationError(IQueryResult result, string field, string expectedErrorTypename) {
        var payload = Payload(result, field);
        var errors = Assert.IsAssignableFrom<IReadOnlyList<object?>>(payload["errors"]);
        var first = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(Assert.Single(errors));
        Assert.Equal(expectedErrorTypename, first["__typename"]);
    }
}

/// <summary>
/// Stubs GraphQL-over-HTTP for the Strawberry Shake named client <c>BereichBClient</c>.
/// Add cases in <see cref="ResolveOperationName"/> / the switch when integration tests hit new CMS operations.
/// </summary>
public sealed class FakeBereichBGraphQLHttpMessageHandler : HttpMessageHandler {
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken) {
        var body = request.Content is null
            ? ""
            : await request.Content.ReadAsStringAsync(cancellationToken).ConfigureAwait(false);

        var op = ResolveOperationName(body);
        var json = op switch {
            // EmailService → KommuneDesignService: no primary color → no follow-up logo HTTP fetch.
            "KommuneDesign" => """{"data":{"KommuneByBereichAId":null}}""",
            "KommuneMaengelConfig" => """{"data":{"KommuneByBereichAId":{"maengelmelder":{"maengelZeitfensterStunden":72},"ideenmelder":{"ideenZeitfensterStunden":72}}}}""",
            _ => """{"data":{}}"""
        };

        return new HttpResponseMessage(HttpStatusCode.OK) {
            Content = new StringContent(json, Encoding.UTF8, "application/json")
        };
    }

    private static string? ResolveOperationName(string body) {
        if (string.IsNullOrWhiteSpace(body)) {
            return null;
        }

        try {
            using var doc = JsonDocument.Parse(body);
            var root = doc.RootElement;
            if (root.TryGetProperty("operationName", out var on) && on.ValueKind == JsonValueKind.String) {
                var name = on.GetString();
                if (!string.IsNullOrEmpty(name)) {
                    return name;
                }
            }

            if (root.TryGetProperty("query", out var q) && q.ValueKind == JsonValueKind.String) {
                var qs = q.GetString() ?? "";
                if (qs.Contains("KommuneMaengelConfig", StringComparison.Ordinal)) {
                    return "KommuneMaengelConfig";
                }

                if (qs.Contains("KommuneDesign", StringComparison.Ordinal)) {
                    return "KommuneDesign";
                }
            }
        } catch (JsonException) {
            // ignore
        }

        return null;
    }
}

public sealed class FakeGotenbergHttpMessageHandler : HttpMessageHandler {
    protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,
        CancellationToken cancellationToken) {
        var response = new HttpResponseMessage(HttpStatusCode.OK) {
            Content = new ByteArrayContent("%PDF-fake"u8.ToArray())
        };
        response.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/pdf");
        return Task.FromResult(response);
    }
}

public class FakeSsoHttpMessageHandler : HttpMessageHandler {
    protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken) {
        // Return a fake 200 OK with a fake token whenever this client is used
        var response = new HttpResponseMessage(System.Net.HttpStatusCode.OK) {
            Content = new StringContent("fake-test-bereich-b-token")
        };

        return Task.FromResult(response);
    }
}
