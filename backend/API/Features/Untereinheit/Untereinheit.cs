using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Features.Untereinheit;

/// <summary>Repräsentiert Berechtigungen eines Backoffice-Benutzers für eine Untereinheit.</summary>
[PrimaryKey(nameof(UntereinheitId), nameof(BackofficeUserId))]
public class UntereinheitPermissions {
    /// <summary>Die ID der Untereinheit.</summary>
    public Guid UntereinheitId { get; set; }
    /// <summary>Die zugehörige Untereinheit.</summary>
    public Untereinheit Untereinheit { get; set; } = null!;
    /// <summary>Die ID des Backoffice-Benutzers.</summary>
    public Guid BackofficeUserId { get; set; }
    /// <summary>Der zugehörige Backoffice-Benutzer.</summary>
    [GraphQLIgnore] public BackofficeUser BackofficeUser { get; set; } = null!;

    /// <summary>Liste der Funktionsberechtigungen in der Organisationseinheit.</summary>
    [GraphQLIgnore]
    public List<FunktionsberechtigungInOrganisationseinheit> Funktionsberechtigungen { get; set; } = new();
}

/// <summary>Konfiguriert die Entity Framework Core-Mapping für UntereinheitPermissions.</summary>
public class UntereinheitPermissionsTypeConfiguration : IEntityTypeConfiguration<UntereinheitPermissions> {
    /// <summary>Konfiguriert die Datenbankabbildung der Funktionsberechtigungen als primitive Sammlung mit String-Konvertierung.</summary>
    public void Configure(EntityTypeBuilder<UntereinheitPermissions> builder) {
        builder.PrimitiveCollection(p => p.Funktionsberechtigungen)
            .HasDefaultValueSql("'{}'")
            .ElementType()
            .HasConversion<string>();
    }
}

/// <summary>Repräsentiert eine Organisationseinheit oder Kommune.</summary>
public class Untereinheit {
    /// <summary>Die eindeutige ID der Untereinheit.</summary>
    public Guid Id { get; set; }
    /// <summary>ID der zugehörigen Kommune.</summary>
    [GraphQLIgnore] public Guid KommuneId { get; set; }
    /// <summary>Die zugehörige Kommune.</summary>
    [GraphQLIgnore] public Kommune.Kommune Kommune { get; set; } = null!;
    /// <summary>Name der Untereinheit.</summary>
    public required string Name { get; set; }
    /// <summary>E-Mail-Adressen der Untereinheit.</summary>
    public List<String> EMailAdressen { get; set; } = [];
    /// <summary>Gibt an, ob es sich um eine Gemeinde handelt.</summary>
    public required bool IsGemeinde { get; set; }
    /// <summary>Optionaler Regionalschlüssel der Untereinheit.</summary>
    public string? Regionalschluessel { get; set; }

    /// <summary>Gibt an, ob die Untereinheit mit Bereich B synchronisiert ist.</summary>
    [GraphQLIgnore] public bool IsSyncedToBereichB { get; set; }
    /// <summary>Markierung, ob die Untereinheit zum Löschen vorgesehen ist.</summary>
    [GraphQLIgnore] public bool MarkedForDelete { get; set; }

    /// <summary>
    /// Gruppen, die der Untereinheit zugeordnet sind (nur über GraphQL-Feld <c>mitarbeiterGruppen</c> auflösen; nicht automatisch befüllt).
    /// </summary>
    [GraphQLIgnore]
    public List<MitarbeiterGruppe> Gruppen { get; set; } = [];
}

/// <summary>Konfiguration der Entity Framework Core Entity für Untereinheit.</summary>
public class UntereinheitEntityTypeConfiguration : IEntityTypeConfiguration<Untereinheit> {
    public void Configure(EntityTypeBuilder<Untereinheit> builder) {
        builder.PrimitiveCollection(u => u.EMailAdressen).HasDefaultValueSql("'{}'");
    }
}

/// <summary>Erweitert UntereinheitPermissions um Abfrageoperationen.</summary>
[ExtendObjectType<UntereinheitPermissions>]
public class UntereinheitPermissionsQueryExtensions {

    /// <summary>Lädt die zugehörige Untereinheit anhand der Berechtigungen.</summary>
    /// <param name="untereinheitPermissions">Die Berechtigungen der Untereinheit.</param>
    /// <param name="dataLoader">DataLoader zum Laden der Untereinheit.</param>
    /// <returns>Die zugehörige Untereinheit.</returns>
    public async Task<Untereinheit> GetUntereinheit([Parent] UntereinheitPermissions untereinheitPermissions, IUntereinheitByUntereinheitIdDataLoader dataLoader) {
        return await dataLoader.LoadAsync(untereinheitPermissions.UntereinheitId);
    }

    /// <summary>Lädt mehrere Untereinheiten anhand ihrer IDs.</summary>
    /// <param name="ids">Liste der Untereinheit-IDs.</param>
    /// <param name="dbContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="cancellationToken">Token zum Abbruch der Operation.</param>
    /// <returns>Dictionary mit Untereinheit-ID als Schlüssel und Untereinheit als Wert.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Untereinheit>> GetUntereinheitByUntereinheitId(IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken cancellationToken) {
        await using var db = await dbContextFactory.CreateDbContextAsync(cancellationToken);
        return await db.Untereinheit
            .Where(untereinheit => ids.Contains(untereinheit.Id))
            .ToDictionaryAsync(untereinheit => untereinheit.Id, cancellationToken);
    }

}
