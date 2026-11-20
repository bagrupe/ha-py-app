using System.Linq.Expressions;
using API.Features.Auth;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Features.Lage;

public class GebietEinsatzleitung {
    public Guid GebietId { get; set; }
    public Gebiet Gebiet { get; set; } = null!;
    public Guid MitarbeiterGruppeId { get; set; }
    public MitarbeiterGruppe MitarbeiterGruppe { get; set; } = null!;

    public static readonly Expression<Func<GebietEinsatzleitung, bool>> IsEffective = ge =>
        !ge.MitarbeiterGruppe.IsDeleted
        && ge.MitarbeiterGruppe.Organisationseinheiten.Any(u => u.Id == ge.Gebiet.UntereinheitId);
}

public class GebietEinsatzleitungConfig : IEntityTypeConfiguration<GebietEinsatzleitung> {
    public void Configure(EntityTypeBuilder<GebietEinsatzleitung> builder) {
        builder.HasKey(ge => new { ge.GebietId, ge.MitarbeiterGruppeId });
        builder.HasOne(ge => ge.Gebiet).WithMany()
            .HasForeignKey(ge => ge.GebietId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(ge => ge.MitarbeiterGruppe).WithMany()
            .HasForeignKey(ge => ge.MitarbeiterGruppeId).OnDelete(DeleteBehavior.Restrict);
    }
}
