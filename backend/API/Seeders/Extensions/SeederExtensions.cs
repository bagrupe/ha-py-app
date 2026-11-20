using API.Seeders.Base;

namespace API.Seeders.Extensions;

/// <summary>Erweitert IServiceCollection und IServiceProvider um Methoden für DataSeeder.</summary>
public static class SeederExtensions {
    /// <summary>Registriert einen DataSeeder als Singleton im DI-Container.</summary>
    /// <typeparam name="TSeeder">Typ des DataSeeders.</typeparam>
    /// <param name="services">Die Service-Sammlung zur Registrierung.</param>
    /// <returns>Die erweiterte Service-Sammlung.</returns>
    public static IServiceCollection AddDataSeeder<TSeeder>(this IServiceCollection services)
        where TSeeder : class, IDataSeeder {
        return services.AddSingleton<IDataSeeder, TSeeder>();
    }

    /// <summary>Definiert den Ausführungszeitpunkt von DataSeedern.</summary>
    public enum SeederExecutionPosition {
        BeforeImports,
        AfterImports
    }

    /// <summary>Führt alle registrierten DataSeeder entsprechend ihres Ausführungszeitpunkts aus.</summary>
    /// <param name="serviceProvider">Der Service-Provider zur Auflösung der Seeder.</param>
    /// <param name="seederExecutionPosition">Der Zeitpunkt der Ausführung.</param>
    /// <param name="cancellationToken">Token zum Abbrechen der Ausführung.</param>
    public static async Task RunDataSeeders(this IServiceProvider serviceProvider,
        SeederExecutionPosition seederExecutionPosition, CancellationToken cancellationToken = default) {
        foreach (var dataSeeder in serviceProvider.GetServices<IDataSeeder>()) {
            switch (seederExecutionPosition) {
                case SeederExecutionPosition.BeforeImports when dataSeeder.MustRunBeforeImports:
                case SeederExecutionPosition.AfterImports when !dataSeeder.MustRunBeforeImports:
                    await dataSeeder.Execute(cancellationToken);
                    break;
            }
        }
    }
}
