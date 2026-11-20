using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

public class KeyEscrowOptions : IValidatable {
    private const int KeyLengthInBytes = 32;

    public int CurrentVersion { get; init; }

    [Required]
    public Dictionary<int, string> Keys { get; init; } = null!;

    [Range(1, 1000)]
    public int MaxRetrievalsPerHour { get; init; } = 10;

    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);

        if (!Keys.ContainsKey(CurrentVersion)) {
            throw new ValidationException($"KeyEscrow:CurrentVersion {CurrentVersion} has no entry in KeyEscrow:Keys.");
        }

        foreach (var (version, value) in Keys) {
            byte[] bytes;
            try {
                bytes = Convert.FromBase64String(value);
            } catch (FormatException) {
                throw new ValidationException($"KeyEscrow:Keys:{version} is not valid Base64.");
            }

            if (bytes.Length != KeyLengthInBytes) {
                throw new ValidationException($"KeyEscrow:Keys:{version} must be {KeyLengthInBytes} bytes.");
            }
        }
    }

    public byte[] GetKey(int version) => Convert.FromBase64String(Keys[version]);
}
