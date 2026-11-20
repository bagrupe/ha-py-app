using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

public class BundIdOptions : IValidatable {
    public bool Enabled { get; init; }

    [Required]
    public string KeycloakAuthority { get; init; } = null!;

    [Required]
    public string Audience { get; init; } = null!;

    [Required]
    public string IdentityProviderAlias { get; init; } = null!;

    public bool RequireBundIdIdentityProviderClaim { get; init; } = true;

    /// <inheritdoc />
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
