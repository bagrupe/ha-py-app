using API.Features;

namespace API.Features.Auth.Mutations;

public record WeakLoginCredentials(
    string DerivedPassword,
    string PublicKey,
    EncryptedValue EncryptedPrivateKey,
    string PersonalDataKeyForBuerger,
    string Salt);
