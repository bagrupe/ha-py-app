using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

public class AuthSessionOptions : IValidatable {
    public const string SectionName = "AuthSession";

    [Range(1, 1440)]
    public int StrongTokenLifetimeMinutes { get; init; } = 15;

    /// <summary>Verlängert sich mit jeder Nutzung.</summary>
    [Range(1, 365)]
    public int RefreshTokenLifetimeDays { get; init; } = 30;

    /// <inheritdoc />
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}

public static class AuthSessionOptionsExtension {
    public static IServiceCollection AddAuthSessionOptions(this IServiceCollection services, IConfiguration configuration) =>
        services
            // Früher unter "BundId" konfigurierte Laufzeiten gelten weiter, "AuthSession" hat Vorrang.
            .Configure<AuthSessionOptions>(configuration.GetSection("BundId"))
            .ConfigureValidatableSetting<AuthSessionOptions>(configuration.GetSection(AuthSessionOptions.SectionName));
}
