using System.Runtime.CompilerServices;
using System.Security.Cryptography;

/// <summary>Provides fresh seed secrets for the isolated test process.</summary>
public static class SeedSecretInitializer {
    /// <summary>Creates test-only keys without storing private material in the repository.</summary>
    [ModuleInitializer]
    public static void Initialize() {
        using var rsa = RSA.Create(4096);
        Environment.SetEnvironmentVariable("SEED_KOMMUNE_RSA_XML", rsa.ToXmlString(true));
        Environment.SetEnvironmentVariable("SEED_BUERGER_RSA_XML", rsa.ToXmlString(true));
        Environment.SetEnvironmentVariable("SEED_KOMMUNE_ENCRYPTION_KEY",
            Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)));
    }
}
