using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen für Bereich B mit URLs und Validierung.</summary>
public class BereichBOptions : IValidatable {
    /// <summary>Die öffentliche API-URL von Bereich B.</summary>
    public string ApiUrl { get; init; } = null!;

    /// <summary>Die interne API-URL von Bereich B.</summary>
    public string InternalApiUrl { get; init; } = null!;

    /// <summary>Shared Secret für interne Bereich-B-Endpunkte (x-internal-api-secret Header).</summary>
    public string? InternalApiSecret { get; init; }

    /// <summary>Validiert die aktuellen Optionen anhand von DataAnnotations.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
