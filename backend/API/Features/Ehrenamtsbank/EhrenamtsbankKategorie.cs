using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Features.Ehrenamtsbank;

[GraphQLDescription(
    "Kategorie der Ehrenamtsbank. Bildet über die optionale Eltern-Referenz einen Baum beliebiger Tiefe.")]
public class EhrenamtsbankKategorie {
    public Guid Id { get; set; }

    public required string Name { get; set; }

    [GraphQLDescription(
        "Wenn false, werden diese Kategorie und logisch ihr gesamter Unterbaum nicht ausgespielt.")]
    public bool Active { get; set; } = true;

    [GraphQLIgnore] public bool RequiresClearance { get; set; }

    [NotMapped]
    [GraphQLName("requiresClearance")]
    [GraphQLDescription(
        "Gibt an, dass für diese Kategorie der Führungszeugnisprozess durchlaufen werden muss. " +
        "Ist true, sobald die Kategorie selbst oder eine ihrer Eltern bis zur Wurzel das Flag " +
        "gesetzt hat. Wird ausgeliefert, hat in diesem Stand aber noch keine funktionale Auswirkung.")]
    public bool RequiresEffectiveClearance { get; set; }

    [GraphQLDescription("Referenz auf die übergeordnete Kategorie. Null bei Wurzel-Kategorien.")]
    public Guid? ParentId { get; set; }

    [GraphQLIgnore] public EhrenamtsbankKategorie? Parent { get; set; }

    [GraphQLDescription("Reihenfolge innerhalb derselben Ebene. Die Sortierung obliegt dem Client.")]
    public int Sort { get; set; }
}

public class EhrenamtsbankKategorieConfig : IEntityTypeConfiguration<EhrenamtsbankKategorie> {
    public void Configure(EntityTypeBuilder<EhrenamtsbankKategorie> builder) {
        builder.HasOne(e => e.Parent)
            .WithMany()
            .HasForeignKey(e => e.ParentId)
            .OnDelete(DeleteBehavior.Restrict);
        builder.Property(e => e.Active).HasDefaultValue(true);
    }
}
