namespace API.Features.Kommune;

/// <summary>Repräsentiert eine Kommune mit Id, Name und kryptographischen Schlüsseln.</summary>
public class Kommune {
    /// <summary>Die eindeutige Identifikationsnummer der Kommune.</summary>
    public Guid Id { get; set; }

    /// <summary>Der Name der Kommune.</summary>
    public required string Name { get; set; }

    /// <summary>Der öffentliche Schlüssel der Kommune.</summary>
    public string? PublicKey { get; set; }

    /// <summary>Der private Schlüssel der Kommune.</summary>
    [GraphQLIgnore] public EncryptedValue? PrivateKey { get; set; }
}
