using API.Features.Auth;
using API.Features.Prozess.Mutations;
using API.Infrastructure;
using HotChocolate.Utilities;
using Microsoft.EntityFrameworkCore;
using Quartz;

namespace API.Features.Prozess;

/// <summary>Erweitert den Typ Type um eine Prüfung, ob er instanziierbar ist.</summary>
public static class IsConstructableTypeExtension {
    /// <summary>Prüft, ob der Typ mindestens einen Konstruktor besitzt und nicht abstrakt ist.</summary>
    public static bool IsConstructable(this Type type) => type.GetConstructors().Any() && !type.IsAbstract;
}

/// <summary>Löst ausführbare programmatische Schritte anhand ihres AssemblyQualifiedName auf und verwaltet Instanzen.</summary>
public class ProgrammatischerSchrittResolver {
    private readonly Dictionary<string, ProgrammatischerSchrittExecutable> _executables = new();
    private readonly IServiceProvider _serviceProvider;

    /// <summary>Initialisiert den Resolver mit dem Service-Provider.</summary>
    public ProgrammatischerSchrittResolver(IServiceProvider serviceProvider) {
        _serviceProvider = serviceProvider;
    }

    /// <summary>Liefert die ausführbare Instanz für den angegebenen AssemblyQualifiedName.</summary>
    /// <param name="assemblyQualifiedName">Der vollständige Typname mit Assembly.</param>
    /// <returns>Die ausführbare Implementierung des programmatischen Schritts.</returns>
    /// <exception cref="InvalidOperationException">Wenn keine Instanz gefunden wird.</exception>
    public ProgrammatischerSchrittExecutable GetForName(string assemblyQualifiedName) {
        if (_executables.TryGetValue(assemblyQualifiedName, out var executable)) return executable;

        var type = Type.GetType(assemblyQualifiedName);
        if (type is null || !_serviceProvider.TryGetService(type, out var service)) {
            throw new InvalidOperationException($"Cannot find executable instance for name {assemblyQualifiedName}");
        }

        var newExecutable = (service as ProgrammatischerSchrittExecutable)!;
        _executables[assemblyQualifiedName] = newExecutable;

        return newExecutable;
    }

    /// <summary>Prüft, ob eine Implementierung für den angegebenen AssemblyQualifiedName existiert.</summary>
    /// <param name="assemblyQualifiedName">Der vollständige Typname mit Assembly.</param>
    /// <returns>True, wenn eine Implementierung vorhanden ist, sonst false.</returns>
    public bool HasImplementation(string assemblyQualifiedName) {
        try {
            GetForName(assemblyQualifiedName);
            return true;
        } catch (InvalidOperationException) {
            return false;
        }
    }
}

/// <summary>Job zur Ausführung programmatischer Schritte, der parallele Ausführungen verhindert.</summary>
[DisallowConcurrentExecution]
public class ProgrammatischerSchrittRunner : IJob {
    private readonly WalkerFactory _walkerFactory;
    private readonly IServiceProvider _serviceProvider;
    private readonly ProgrammatischerSchrittResolver _schrittResolver;
    private readonly ILogger<ProgrammatischerSchrittRunner> _logger;

    /// <summary>Initialisiert den Runner mit den benötigten Diensten.</summary>
    public ProgrammatischerSchrittRunner(WalkerFactory walkerFactory,
        IServiceProvider serviceProvider, ProgrammatischerSchrittResolver schrittResolver, ILogger<ProgrammatischerSchrittRunner> logger) {
        _walkerFactory = walkerFactory;
        _serviceProvider = serviceProvider;
        _schrittResolver = schrittResolver;
        _logger = logger;
    }

    /// <summary>Führt den Job aus und verarbeitet alle aktuellen programmatischen Schritte.</summary>
    /// <param name="context">Der Ausführungskontext des Jobs.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await foreach (var walker in _walkerFactory.GetWalkerForCurrentStep<ProgrammatischerSchritt>()) {
            if (walker.CurrentSchritt is not ProgrammatischerSchritt schritt) {
                continue;
            }

            using var scope = _serviceProvider.CreateScope();
            var executable = _schrittResolver.GetForName(schritt.ImplementationAssemblyQualifiedName);
            try {
                _logger.LogDebug("Running programmatischer Schritt {Name}", executable.GetType().Name);
                var result = await executable.ExecuteAsync(walker);

                // Wir wollen den Step nicht validieren, um Fallbackverhalten wie bei der Weiche zu ermöglichen
                walker.Step(SystemUser.UserId, result.NextVerbindungGuid, Array.Empty<SlotValuesInput>(), result.NaechsteIstZustaendigkeit, false);
                await walker.SaveChangesAsync();
            } catch (Exception e) {
                failures.RecordFailure();
                _logger.LogError(e.Message);
            }
        }
    }
}

/// <summary>Erweitert IServiceCollection um die Registrierung des ProgrammatischerSchrittRunner und zugehöriger Dienste.</summary>
public static class ProgrammatischerSchrittRunnerServiceExtensions {
    /// <summary>Registriert alle ausführbaren programmatischen Schritte und den Runner im DI-Container.</summary>
    /// <param name="services">Die Service-Collection zur Registrierung.</param>
    /// <returns>Die erweiterte Service-Collection.</returns>
    public static IServiceCollection AddProgrammatischerSchrittRunner(this IServiceCollection services) {
        const string everyTenSeconds = "0/10 * * ? * * *";

        var implementations = typeof(ProgrammatischerSchrittResolver).Assembly.GetTypes()
            .Where(t => t.IsAssignableTo(typeof(ProgrammatischerSchrittExecutable)) && t.IsConstructable());

        foreach (var implementationType in implementations) {
            services.AddSingleton(implementationType);
        }

        services
            .AddSingleton<ProgrammatischerSchrittResolver>()
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<ProgrammatischerSchrittRunner>(everyTenSeconds, fireImmediate: true));

        return services;
    }

    /// <summary>Prüft, ob für alle in der Datenbank vorhandenen programmatischen Schritte Implementierungen existieren.</summary>
    /// <param name="serviceProvider">Der Service-Provider zur Auflösung der Dienste.</param>
    /// <exception cref="InvalidOperationException">Wenn Implementierungen fehlen.</exception>
    public static async Task EnsureProgrammatischeSchrittImplementations(this IServiceProvider serviceProvider) {
        var dbFactory = serviceProvider.GetRequiredService<IDbContextFactory<DomainContext>>();
        await using var db = await dbFactory.CreateDbContextAsync();

        var resolver = serviceProvider.GetRequiredService<ProgrammatischerSchrittResolver>();

        var names = await db.ProgrammatischeSchritte
            .Select(s => s.ImplementationAssemblyQualifiedName)
            .Distinct()
            .ToListAsync();

        var missingImplementations = names
            .Where(name => !resolver.HasImplementation(name))
            .Select(s => $"'{s}'")
            .ToList();
        if (missingImplementations.Any()) {
            var missingImplementationsString = string.Join(", ", missingImplementations);

            throw new InvalidOperationException($"Missing implementations for programmatische Schritte {missingImplementationsString}");
        }
    }
}
