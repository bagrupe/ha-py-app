using Microsoft.AspNetCore.Identity;
using NodaTime;

namespace API.Features.Auth.Mutations;

internal static class WeakBuergerRegistration {
    internal static Buerger Create(
        IPasswordHasher<User> passwordHasher,
        IClock clock,
        WeakLoginCredentials credentials) {
        var buerger = new Buerger {
            PublicKey = credentials.PublicKey,
            PersonalPrivateKey = credentials.EncryptedPrivateKey,
            PersonalPrivateKeySalt = credentials.Salt,
            PersonalDataKeyEncryptedForBuerger = credentials.PersonalDataKeyForBuerger,
            CreatedAt = clock.GetCurrentInstant(),
        };
        buerger.Password = passwordHasher.HashPassword(buerger, credentials.DerivedPassword);
        return buerger;
    }
}
