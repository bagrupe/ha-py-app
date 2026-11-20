using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Konfiguration zur Kompatibilität der mobilen App mit diesem Backend.</summary>
public class MobileAppOptions : IValidatable {

    /// <summary>
    /// Mindest-App-Version (SemVer Kern <c>major.minor.patch</c>), die dieser Server unterstützt.
    /// </summary>
    [Required]
    public string MinimumCompatibleAppVersion { get; init; } = null!;

    /// <inheritdoc />
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
        if (!Version.TryParse(MinimumCompatibleAppVersion.Trim(), out _)) {
            throw new ValidationException(
                "MinimumCompatibleAppVersion must be a valid version (e.g. 1.2.3).");
        }
    }
}
