namespace API.Seeders.Helpers;

/// <summary>Reads externally supplied secrets for persistent development seed data.</summary>
public static class SeedSecrets {
    /// <summary>Returns a configured secret or fails before seed data is created.</summary>
    public static string GetRequiredValue(string name) =>
        Environment.GetEnvironmentVariable(name) is { Length: > 0 } value
            ? value
            : throw new InvalidOperationException($"Set {name} before using development seed data.");
}
