using API.Features.Auth;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Features.Lage;

[GraphQLDescription("Einsatzeinheit (z. B. \"HLF 20 Hameln\"), die eine Einsatzleitung mit Meldungen beauftragt.")]
public class Einheit {
    public Guid Id { get; set; }
    public required string Name { get; set; }

    [GraphQLDescription("Ausrüstung an Bord (z. B. \"Motorkettensäge\", \"Drehleiter\").")]
    public List<string> Ausruestung { get; set; } = [];

    [GraphQLDescription("Einsatzleitung (Mitarbeitergruppe), zu der die Einheit gehört.")]
    public Guid MitarbeiterGruppeId { get; set; }

    [GraphQLIgnore]
    public MitarbeiterGruppe MitarbeiterGruppe { get; set; } = null!;
}

public class EinheitConfig : IEntityTypeConfiguration<Einheit> {
    public void Configure(EntityTypeBuilder<Einheit> builder) {
        builder.HasOne(e => e.MitarbeiterGruppe).WithMany()
            .HasForeignKey(e => e.MitarbeiterGruppeId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(e => new { e.MitarbeiterGruppeId, e.Name }).IsUnique();
    }
}
