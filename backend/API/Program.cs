using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Text;
using API.Features;
using API.Features.Abfallkalender;
using API.Features.Aufbewahrung.Jobs;
using API.Features.Auth;
using API.Features.Auth.BundId;
using API.Features.Auth.Jobs;
using API.Features.Auth.Mutations;
using API.Features.Auth.RefreshTokens;
using API.Features.BereichB;
using API.Features.BereichB.Jobs;
using API.Features.Ehrenamtsbank;
using API.Features.Email;
using API.Features.EmailForwarder;
using API.Features.Expressions;
using API.Features.Funktionsberechtigungen;
using API.Features.Geo;
using API.Features.GovManager;
using API.Features.Ideenmelder;
using API.Features.Kommune;
using API.Features.MaengelMelder;
using API.Features.ObjectStorage;
using API.Features.PdfGenerator;
using API.Features.PmPayment;
using API.Features.Prozess;
using API.Features.Prozess.Mutations;
using API.Features.Prozess.Validators;
using API.Features.PushNotifications;
// TODO: Uncomment this import when enabling the Firebase Push notification jobs.
// using API.Features.PushNotifications.Jobs;
using API.Features.Untereinheit;
using API.Infrastructure;
using API.Options;
using API.Scripts.ImportKategorieBaum;
using API.Seeders;
using API.Seeders.Extensions;
using API.Seeders.LageHelfer;
using FluentValidation;
using HotChocolate.AspNetCore;
using HotChocolate.Data.Filters;
using HotChocolate.Data.Filters.Expressions;
using HotChocolate.Types.NodaTime;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.IdentityModel.Tokens;
using NodaTime;
using Npgsql;
using Quartz;
using Sentry;
using User = API.Features.Auth.User;

var builder = WebApplication.CreateBuilder(args);

// This ensures that even if appsettings.json or appsettings.Development.json exist,
// the environment variables from .env files have the highest priority.
// Only needed for deployment via docker images and keeps the local development as it is.
builder.Configuration.AddEnvironmentVariables();

builder.WebHost.UseSentry(o => {
    o.Dsn = builder.Configuration["Sentry:Dsn"];
    o.Release = GetRelease(typeof(Program).Assembly);
    o.Environment = GetEnvironment(typeof(Program).Assembly);

    o.AddEntityFramework();
    o.EnableTracing = true;

    var sampleRate = 1.0f;
    o.SampleRate = sampleRate;
    o.TracesSampleRate = sampleRate;

    var isE2E = Environment.GetEnvironmentVariable("IS_E2E");
    if (isE2E is not null) {
        o.ConfigureScope(scope => {
            scope.SetTag("IsE2E", "yes");
        });
    }
});

var dataSourceBuilder = new NpgsqlDataSourceBuilder(builder.Configuration.GetConnectionString("Domain"));
dataSourceBuilder.UseNodaTime().EnableDynamicJson();
var dataSource = dataSourceBuilder.Build();

// Ohne Archiv-Connection-String bricht Build() beim Start ab, der Platzhalter verbindet erst bei Benutzung.
var archiveConnectionString = builder.Configuration.GetConnectionString("Archive");
var archiveDataSourceBuilder = new NpgsqlDataSourceBuilder(
    string.IsNullOrWhiteSpace(archiveConnectionString) ? "Host=localhost" : archiveConnectionString);
archiveDataSourceBuilder.UseNodaTime().EnableDynamicJson();
var archiveDataSource = archiveDataSourceBuilder.Build();

var objectStorageSection = builder.Configuration.GetSection(ObjectStorageOptions.SectionName);

var gotenbergUrl = builder.Configuration.GetRequiredSection("Gotenberg").GetValue<string>("Url")!.TrimEnd('/');

var healthChecksBuilder = builder.Services.AddHealthChecks()
    .AddNpgSql(
        builder.Configuration.GetConnectionString("Domain")!,
        name: "postgres")
    .AddUrlGroup(new Uri($"{gotenbergUrl}/health"), name: "gotenberg");

if (!string.IsNullOrWhiteSpace(archiveConnectionString)) {
    healthChecksBuilder.AddNpgSql(archiveConnectionString, name: "postgres-archive");
}

builder.Services.AddHttpClient("BereichBInternal",
    c => {
        c.BaseAddress =
            new Uri(builder.Configuration.GetRequiredSection("BereichB").GetValue<string>("InternalApiUrl")!);
        var internalApiSecret = builder.Configuration.GetRequiredSection("BereichB").GetValue<string>("InternalApiSecret");
        if (!string.IsNullOrEmpty(internalApiSecret)) {
            c.DefaultRequestHeaders.Add("x-internal-api-secret", internalApiSecret);
        }
    });
builder.Services.AddHttpClient("BereichB",
    c => c.BaseAddress =
        new Uri(builder.Configuration.GetRequiredSection("BereichB").GetValue<string>("ApiUrl")! + "/graphql"));

builder.Services.AddBereichBClient()
    .ConfigureHttpClient(client => {
        var apiKey = builder.Configuration.GetRequiredSection("BereichB").GetValue<string>("SuperAdminApiKey")!;
        client.DefaultRequestHeaders.Add("Authorization", new[] { $"benutzer API-Key {apiKey}" });

        client.BaseAddress =
            new Uri(builder.Configuration.GetRequiredSection("BereichB").GetValue<string>("ApiUrl")! + "/graphql");
    });
builder.Services.AddHttpClient(CronJobMetricsService.HttpClientName)
    .ConfigureHttpClient(client => client.Timeout = TimeSpan.FromSeconds(20));
builder.Services.AddHttpClient(StaticMapService.HttpClientName)
    .ConfigureHttpClient((services, client) => {
        var mapOptions = services.GetRequiredService<StaticMapOptions>();
        var userAgent = mapOptions.UserAgent ??
                        $"HaPy-App Backend ({services.GetRequiredService<EMailOptions>().From})";
        client.DefaultRequestHeaders.UserAgent.ParseAdd(userAgent);
        client.Timeout = TimeSpan.FromSeconds(mapOptions.TimeoutSeconds);
    })
    .ConfigurePrimaryHttpMessageHandler(services => new SocketsHttpHandler {
        MaxConnectionsPerServer = services.GetRequiredService<StaticMapOptions>().MaxConnections,
    });


var dataSeederEnabled = builder.Configuration.GetSection("DataSeeder").GetValue<bool>("Enabled");
if (builder.Environment.IsEnvironment("Testing") || (builder.Environment.IsDevelopment() && dataSeederEnabled)) {
    builder.Services
        .AddDataSeeder<KommuneSeeder>()
        .AddDataSeeder<MitarbeiterSeeder>();
}

builder.Services
    .AddDataSeeder<EhrenamtsbankSeeder>()
    // .AddDataSeeder<BuergerSeeder>()
    // .AddDataSeeder<ProzesseSeeder>()
    // .AddDataSeeder<ServicePortalLinkSeeder>()
    .AddTransient<LageHelferSeeder>()
    .AddSingleton<IPasswordHasher<User>, PasswordHasher<User>>()
    .AddSingleton<IValidator, ExpressionsTypeCheckerValidator>()
    .AddSingleton<PmPaymentClient>()
    .AddEmailRendering()
    .AddSingleton<PdfImageService>()
    .AddSingleton<StaticMapService>()
    .AddScoped<WalkerFactory>()
    .AddSingleton<AbfallkalenderService>()
    .AddSingleton<GeoService>()
    .AddSingleton<KategorieSyncExport>()
    .AddSingleton<BackoffService>()
    .AddSingleton<EvaluatingVisitorService>()
    .AddSingleton<UntereinheitenSynchronizer>()
    .AddScoped<BackofficeUserSynchronizer>()
    .AddSingleton<GemeindeInformationenImporter>()
    .AddSingleton<PdfGenerator>()
    .AddSingleton<GotenbergService>()
    .AddSingleton<RateLimitService>()
    .AddScoped<RateLimit>()
    .AddScoped<EmailService>()
    .AddScoped<KommuneDesignService>()
    .AddScoped<MaengelSichtbarkeitService>()
    .AddScoped<IdeenSichtbarkeitService>()
    .AddScoped<FunktionsberechtigungenService>()
    .AddScoped<AusfuehrungZustaendigkeitService>()
    .AddScoped<AusfuehrungWeiterleitenService>()
    .AddScoped<VorgangsverlaufService>()
    .AddScoped<EhrenamtsbankAuthService>()
    .AddScoped<BuergerAccountDeletionService>()
    .AddSingleton<IKeycloakTokenValidator, KeycloakTokenValidator>()
    .AddSingleton<IBundIdSubjectHasher, BundIdSubjectHasher>()
    .AddScoped<BundIdAuthService>()
    .AddScoped<RefreshTokenService>()
    .AddScoped<API.Features.Auth.KeyEscrow.KeyEscrowService>()
    .AddControllers().Services
    .AddRazorPages().Services
    .UseConfigurationValidation()
    .ConfigureValidatableSetting<EnvironmentOptions>(builder.Configuration.GetSection("Environment"))
    .ConfigureValidatableSetting<JWTOptions>(builder.Configuration.GetSection("JWT"))
    .ConfigureValidatableSetting<PmPaymentOptions>(builder.Configuration.GetSection("PmPayment"))
    .ConfigureValidatableSetting<GovManagerOptions>(builder.Configuration.GetSection("GovManager"))
    .ConfigureValidatableSetting<DataSeederOptions>(builder.Configuration.GetSection("DataSeeder"))
    .ConfigureValidatableSetting<BereichBOptions>(builder.Configuration.GetSection("BereichB"))
    .ConfigureValidatableSetting<EMailOptions>(builder.Configuration.GetSection("EMail"))
    .ConfigureValidatableSetting<GotenbergOptions>(builder.Configuration.GetSection("Gotenberg"))
    .ConfigureValidatableSetting<StaticMapOptions>(builder.Configuration.GetSection("Pdf:Map"))
    .ConfigureValidatableSetting<KawHamelnOptions>(builder.Configuration.GetSection("KawHameln"))
    .ConfigureValidatableSetting<RateLimitOptions>(builder.Configuration.GetSection("RateLimit"))
    .ConfigureValidatableSetting<WebOptions>(builder.Configuration.GetSection("Web"))
    .ConfigureValidatableSetting<ProzessOptions>(builder.Configuration.GetSection("Prozess"))
    .ConfigureValidatableSetting<MobileAppOptions>(builder.Configuration.GetSection("MobileApp"))
    .ConfigureValidatableSetting<BundIdOptions>(builder.Configuration.GetSection("BundId"))
    .AddAuthSessionOptions(builder.Configuration)
    .ConfigureValidatableSetting<KeyEscrowOptions>(builder.Configuration.GetSection("KeyEscrow"))
    .ConfigureValidatableSetting<BrevoOptions>(builder.Configuration.GetSection("Brevo"))
    // TODO: Configure the Firebase service account and uncomment this registration for Firebase Push notifications.
    // .Configure<FirebaseOptions>(builder.Configuration.GetSection(FirebaseOptions.SectionName))
    // .AddSingleton<IFirebaseMessagingClient, FirebaseMessagingClient>()
    .Configure<EhrenamtsbankOptions>(builder.Configuration.GetSection("Ehrenamtsbank"))
    .Configure<EhrenamtsbankZeitkontoOptions>(builder.Configuration.GetSection("EhrenamtsbankZeitkonto"))
    // TODO: Replace the no-op service with these registrations for Firebase Push notifications.
    // .AddSingleton<IFirebasePushMessagingService, FirebasePushMessagingService>()
    // .AddHostedService<FirebasePushMessagingStartupValidator>()
    .AddSingleton<IFirebasePushMessagingService, NoOpFirebasePushMessagingService>()
    .AddSingleton<SmtpClient>(sp => {
        var options = sp.GetRequiredService<EMailOptions>();
        return new SmtpClient(options.Host, options.Port) {
            EnableSsl = options.EnableSsl,
            Credentials = new NetworkCredential(options.User, options.Password)
        };
    })
    .AddObjectStorage(objectStorageSection)
    .AddObjectStorageConsumer<EhrenamtsbankEintragImageStorageConsumer>()
    .AddSingleton<IClock>(SystemClock.Instance)
    .AddSingleton<ISmsService, SmsService>()
    .AddScoped<ICurrentUserAccessor, CurrentUserAccessor>()
    .AddScoped<CurrentUserAccessor>()
    .AddAuthorization()
    .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options => {
        options.SaveToken = true;
        options.TokenValidationParameters = new TokenValidationParameters {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["JWT:Key"]!)),
            ValidIssuer = builder.Configuration["JWT:Issuer"]
        };

        options.Audience = builder.Configuration["JWT:Issuer"];
        options.Events = new JwtBearerEvents { OnTokenValidated = AccessTokenRevocation.RejectRevokedAsync };
    }).Services
    .AddHttpContextAccessor()
    .AddPooledDbContextFactory<DomainContext>(
        options => {
#if DEBUG
            options.EnableDetailedErrors();
            options.EnableSensitiveDataLogging();
            options.ConfigureWarnings(w => w.Throw(RelationalEventId.MultipleCollectionIncludeWarning));
#endif
            options.UseNpgsql(dataSource, o => {
                o.UseNodaTime();
            })
                .UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
        })
    .AddPooledDbContextFactory<API.Features.Aufbewahrung.Archive.ArchiveContext>(
        options => {
            options.UseNpgsql(archiveDataSource, o => {
                o.UseNodaTime();
                o.MigrationsHistoryTable("__EFMigrationsHistory_Archive");
            })
                .UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
        })
    // PersistKeysToDbContext resolves DomainContext directly. GraphQL uses the pooled factory,
    // so expose a scoped context backed by that same factory for Data Protection.
    .AddScoped<DomainContext>(sp =>
        sp.GetRequiredService<IDbContextFactory<DomainContext>>().CreateDbContext())
    .AddSingleton<CronJobMetricsService>()
    .AddQuartz(q => {
        q.AddJobListener<QuartzRestartServiceOnMissingTableJobListener>();
        q.AddJobListener<CronJobMetricsJobListener>();
    })
    .AddQuartzHostedService(o => {
        o.WaitForJobsToComplete = false;
    })
    .AddProgrammatischerSchrittRunner()
    .AddPaymentRunner()
    .AddGovManager()
    .AddEmailForwarderExportRunner()
    .AddBereichBSynchronizerRunner()
    .AddResetEmailJob()
    // TODO: Uncomment these jobs after enabling Firebase Push notifications.
    // .AddNewsArtikelPushNotificationJob()
    // .AddSensorGrenzwertPushNotificationJob()
    .AddInvitationEmailJob()
    .AddEmailOutboxSendJob()
    .AddAntragHardDeleteJob()
    .AddAntragArchivierungJob()
    .AddRefreshTokenCleanupJob()
    .AddGraphQLServer(
        maxAllowedRequestSize:
        40 * 1000 * 1024) // Request size had to be increased due to failing Prozesses. Default value ist 20 * 1000 * 24
    .ModifyOptions(o => {
        o.EnableOneOf = true;
    })
    .UseRequest<SentryHotChocolateContextMiddleware>()
    .UseField<StitchingFieldResolverHelperMiddleware>()
    .AddAuthorization()
    .AddAPITypes()
    .AddMutationConventions()
    .AddProjections()
    .AddFiltering(x =>
        x.AddDefaults()
            .AddInvariantComparison()
            .AddProviderExtension(new QueryableFilterProviderExtension(y =>
                y.AddFieldHandler<QueryableStringInvariantContainsHandler>())))
    .AddSorting()
    .AllowIntrospection(builder.Environment.IsDevelopment() || builder.Environment.IsStaging())
    // Floor is ~28: JsonValueWithSlotsRecursive (Prozess-Editor) is 22 levels before it is spread.
    .AddMaxExecutionDepthRule(
        builder.Configuration.GetValue<int?>("GraphQL:MaxExecutionDepth") ?? 50,
        skipIntrospectionFields: true)
    .AddErrorFilter<GraphQLErrorFilter>()
    .TryAddTypeInterceptor<FixStitchedJsonTypeInterceptor>()
    .AddRemoteSchemaFromFile("BereichB", "BereichB.graphql", ignoreRootTypes: true)
    .RenameType("Untereinheit", "BereichBUntereinheit", "BereichB")
    .AddPayloadCmsTypes()
    .AddTypeExtensionsFromFile("./Stitching.graphql")
    .AddType<ErrorCodeType>()
    .AddType<InstantType>()
    .AddType<LocalDateType>()
    .BindRuntimeType<StringExpression, StringExpressionType>()
    .BindRuntimeType<BoolExpression, BoolExpressionType>()
    .BindRuntimeType<IntExpression, IntExpressionType>()
    .AddDirectiveType<ExportDirective>()
    .ModifyOptions(options => options.RemoveUnreachableTypes = true)
    .RegisterService<CurrentUserAccessor>()
    .RegisterService<IClock>()
    .RegisterService<WalkerFactory>()
    .RegisterDbContext<DomainContext>(DbContextKind.Pooled)
    .RegisterDbContext<API.Features.Aufbewahrung.Archive.ArchiveContext>(DbContextKind.Pooled)
    .InitializeOnStartup()
    .UseDefaultPipeline()
    .AddLocalSchema("Internal", ignoreRootTypes: true).AddGraphQL("Internal").AddQueryType<SensorenExtensions>()
    .AddEnumType<HistoryMode>()
    .Services
    .AddSingleton<WriteSchemaToFrontends>()
    .AddHostedService(sp => sp.GetRequiredService<WriteSchemaToFrontends>());

builder.Services.AddGraphQL("BereichB").AddPayloadCmsTypes();

// hash for Phone Number:
var salt = builder.Configuration["Ehrenamtsbank:PhoneNumberSalt"];
PhoneHashingService.Initialize(salt ?? throw new Exception("Salt fehlt!"));

// encryption of Phone Number, store keys in the DB
builder.Services.AddDataProtection()
    .SetApplicationName("KommunalApp")
    .PersistKeysToDbContext<DomainContext>();
#if DEBUG
builder.Services.AddSwaggerGen();
#endif

builder.Services.AddCors(options => options.AddDefaultPolicy(policy =>
    policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));

var app = builder.Build();
app.Logger.LogInformation("Environment IsDevelopment :" + builder.Environment.IsDevelopment());
app.Logger.LogInformation("Environment IsStaging :" + builder.Environment.IsStaging());
if (!app.Environment.IsDevelopment()) {
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}
app.UseSentryTracing();
app.UseCors();
app.UseAuthentication();
app.UseAuthorization();

app.MapHealthChecks("/health/ready", new HealthCheckOptions {
    ResponseWriter = HealthCheckResponseWriter.WriteResponse,
});

app.MapGraphQL().WithOptions(new GraphQLServerOptions {
    // The IDE loads its schema via introspection, not via ?sdl.
    EnableSchemaRequests = app.Environment.IsDevelopment(),
    Tool = { Enable = app.Environment.IsDevelopment() || app.Environment.IsStaging() },
});
app.MapControllers();
app.MapRazorPages();

#if DEBUG
app.UseSwagger();
app.UseSwaggerUI();
#endif

if (args is ["export-schema-only"]) {
    await app.Services.GetRequiredService<WriteSchemaToFrontends>().StartAsync(default);
    return;
}

if (args is ["import-kategorie-baum", ..]) {
    // Using ActivatorUtilities here avoids having to add ImportKategorieBaum into our ServiceCollection,
    // thus avoiding a bunch of questionable code potentially being instantiated in a production environment.
    await ActivatorUtilities.CreateInstance<ImportKategorieBaum>(app.Services).Run(args);

    return;
}

if (args is ["rotate-key-escrow"]) {
    using var rotationScope = app.Services.CreateScope();
    var (reencrypted, failed) = await rotationScope.ServiceProvider
        .GetRequiredService<API.Features.Auth.KeyEscrow.KeyEscrowService>()
        .ReencryptToCurrentVersionAsync(default);
    app.Logger.LogInformation("Key escrow rotation finished: {Reencrypted} re-encrypted, {Failed} failed",
        reencrypted, failed);
    Environment.ExitCode = failed == 0 ? 0 : 1;

    return;
}

// Only handling the database if we are not exporting the schema
using var scope = app.Services.CreateScope();
var dbContext = scope.ServiceProvider
    .GetRequiredService<IDbContextFactory<DomainContext>>();

var seederOptions = scope.ServiceProvider.GetRequiredService<DataSeederOptions>();
// `using` / `await using` here causes an `ObjectDisposedException` when encountering errors in the database schema
// (EntityFrameworkCore.Infrastructure.ModelValidator.Validate). This prevents the actual error from surfacing.
// The workaround is to dispose manually.
var context = await dbContext.CreateDbContextAsync();
if (seederOptions.Recreate) {
    await context.Database.EnsureDeletedAsync();
}

await context.Database.MigrateAsync();

var missingEscrowKeyVersions = await scope.ServiceProvider
    .GetRequiredService<API.Features.Auth.KeyEscrow.KeyEscrowService>()
    .GetMissingKeyVersionsAsync(default);
if (missingEscrowKeyVersions.Count > 0) {
    app.Logger.LogError(
        "Stored key escrow entries use key versions without a configured key: {KeyVersions}. "
        + "Restoring the private key fails for these accounts. Restore the missing KeyEscrow:Keys entries "
        + "or run rotate-key-escrow before removing a key.",
        string.Join(", ", missingEscrowKeyVersions));
}

await SystemUser.EnsureSystemUserExists(context);
await API.Features.Aufbewahrung.AufbewahrungsEinstellungen.EnsureExists(context);

// Ohne erreichbare Archiv-DB startet das Backend trotzdem, nur die Archivierung bleibt aus.
try {
    var archiveFactory = scope.ServiceProvider
        .GetRequiredService<IDbContextFactory<API.Features.Aufbewahrung.Archive.ArchiveContext>>();
    await using var archiveContext = await archiveFactory.CreateDbContextAsync();
    await archiveContext.Database.MigrateAsync();
    app.Logger.LogInformation("Archiv-Datenbank migriert.");
} catch (Exception ex) {
    app.Logger.LogWarning(ex,
        "Archiv-Datenbank nicht erreichbar/migrierbar – Archivierung bleibt deaktiviert, Backend startet trotzdem.");
}

if (seederOptions.Enabled) {
    await scope.ServiceProvider.RunDataSeeders(SeederExtensions.SeederExecutionPosition.BeforeImports);
}

try {
    await scope.ServiceProvider.GetRequiredService<GemeindeInformationenImporter>()
        .ImportGemeindeInformationen();
} catch (Exception e) {
    Console.WriteLine($"Could not import gemeinden: {e}");
}

if (seederOptions.Enabled) {
    await scope.ServiceProvider.RunDataSeeders(SeederExtensions.SeederExecutionPosition.AfterImports);
}

if (seederOptions.LageHelferEnabled) {
    await scope.ServiceProvider.GetRequiredService<LageHelferSeeder>().Execute();
}

await scope.ServiceProvider.EnsureProgrammatischeSchrittImplementations();
context.Dispose();

app.Run();

static string GetEnvironment(Assembly assembly) {
    return assembly.GetCustomAttributes<AssemblyDescriptionAttribute>()
        .Select(a => a.Description)
        .FirstOrDefault() ?? "local";
}

static string GetRelease(Assembly assembly) {
    var version = assembly.GetCustomAttributes<AssemblyInformationalVersionAttribute>()
        .Select(a => a.InformationalVersion)
        .FirstOrDefault() ?? "none";

    // Entfernt unerwünschte Präfixe vor der Versionsnummer.
    version = version.Split("@").LastOrDefault() ?? "none";

    if (version.StartsWith("1.0.0")) {
        version = "none";
    }

    return version;
}

/// <summary>Definiert eine GraphQL-Direktive zum Exportieren von Feldern.</summary>
public class ExportDirective : DirectiveType {
    /// <summary>Konfiguriert die Direktive mit Namen, Argumenten und Anwendungsort.</summary>
    /// <param name="descriptor">Der Descriptor zur Konfiguration der Direktive.</param>
    protected override void Configure(IDirectiveTypeDescriptor descriptor) {
        descriptor.Name("export");
        descriptor.Argument("exportName").Type<NonNullType<StringType>>();
        descriptor.Location(DirectiveLocation.Field);
    }
}


// For Integration-Tests. See AppIntegration-Tests
namespace API {
    public partial class Program { }
}
