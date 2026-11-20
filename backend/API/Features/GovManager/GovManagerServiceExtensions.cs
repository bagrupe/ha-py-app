namespace API.Features.GovManager;

/// <summary>Erweitert IServiceCollection um die Registrierung der GovManager-Dienste.</summary>
public static class GovManagerServiceExtensions {
    /// <summary>Registriert die GovManager-spezifischen Runner im DI-Container.</summary>
    /// <param name="services">Die Service-Sammlung zur Erweiterung.</param>
    /// <returns>Die erweiterte Service-Sammlung.</returns>
    public static IServiceCollection AddGovManager(this IServiceCollection services) {
        return services
            .AddGovManagerRestExportRunner()
            .AddGovManagerRequestRunner();
    }
}
