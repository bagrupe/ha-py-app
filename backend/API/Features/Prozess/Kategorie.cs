using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Features.Prozess;

/// <summary>
/// Ein Untereinheit-eigener Knoten darf nur unter einer geteilten Kategorie oder einer weiteren eigenen
/// Kategorie derselben Untereinheit hängen (siehe <see cref="Mutations.KategorieMutations"/>), nie unter der
/// eigenen Kategorie einer anderen Untereinheit.
/// </summary>
[ObjectType]
[GraphQLDescription(
    "Ein Knoten im Mängelmelder-Kategoriebaum. Fehlt eine eigene Zuständigkeit, gilt die des nächsten " +
    "Elternknotens, der eine eigene festlegt.")]
public class Kategorie {
    public Guid Id { get; init; }

    [GraphQLIgnore] public Guid KommuneId { get; set; }

    [GraphQLDescription(
        "Übergeordnete Kategorie. Fehlt bei einer geteilten Top-Level-Kategorie oder dem Wurzel-Knoten einer Untereinheit.")]
    public Guid? ParentId { get; set; }
    [GraphQLIgnore] public Kategorie? Parent { get; init; }
    [GraphQLIgnore] public ICollection<Kategorie> Kinder { get; init; } = new HashSet<Kategorie>();

    [GraphQLDescription(
        "Null = geteilte Kategorie, für alle Untereinheiten sichtbar. Gesetzt = eigene Kategorie dieser Untereinheit.")]
    public Guid? UntereinheitId { get; set; }
    [GraphQLIgnore] public Untereinheit.Untereinheit? Untereinheit { get; init; }

    [GraphQLDescription(
        "Markiert den einen, für Bürger unsichtbaren Wurzel-Knoten einer Untereinheit. Seine Zuständigkeit " +
        "dient als Standard-Zuständigkeit für alle Kategorien dieser Untereinheit, für die keine " +
        "spezifischere Zuständigkeit vererbt wird. Jede Untereinheit hat genau einen solchen Knoten.")]
    public bool IstWurzel { get; set; }

    public string Name { get; set; } = "";

    [GraphQLDescription(
        "Eigene Zuständigkeit dieses Knotens. Null = erbt die Zuständigkeit des nächsten Elternknotens, " +
        "der eine eigene festlegt.")]
    public Zustaendigkeit? Ziel { get; set; }
}

[ObjectType]
[GraphQLDescription("Blendet eine geteilte Kategorie für eine bestimmte Untereinheit aus.")]
public class KategorieAusblendung {
    public Guid Id { get; init; }

    public Guid KategorieId { get; set; }
    [GraphQLIgnore] public Kategorie Kategorie { get; init; } = null!;

    public Guid UntereinheitId { get; set; }
    [GraphQLIgnore] public Untereinheit.Untereinheit Untereinheit { get; init; } = null!;
}

/// <summary>Konfiguration der Entity Framework Core Entity für Kategorie.</summary>
public class KategorieEntityTypeConfiguration : IEntityTypeConfiguration<Kategorie> {
    public void Configure(EntityTypeBuilder<Kategorie> builder) {
        builder.HasOne(k => k.Parent).WithMany(k => k.Kinder).HasForeignKey(k => k.ParentId).OnDelete(DeleteBehavior.Cascade);
        builder.HasOne(k => k.Untereinheit).WithMany().HasForeignKey(k => k.UntereinheitId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(k => k.ParentId);
        builder.HasIndex(k => k.UntereinheitId);
        // Ein Wurzel-Knoten je Untereinheit: partieller Index nur als rohes SQL in der Migration (EF-Fluent-API kann das nicht).
    }
}

/// <summary>Konfiguration der Entity Framework Core Entity für KategorieAusblendung.</summary>
public class KategorieAusblendungEntityTypeConfiguration : IEntityTypeConfiguration<KategorieAusblendung> {
    public void Configure(EntityTypeBuilder<KategorieAusblendung> builder) {
        builder.HasOne(a => a.Kategorie).WithMany().HasForeignKey(a => a.KategorieId).OnDelete(DeleteBehavior.Cascade);
        builder.HasOne(a => a.Untereinheit).WithMany().HasForeignKey(a => a.UntereinheitId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(a => new { a.KategorieId, a.UntereinheitId }).IsUnique();
    }
}
