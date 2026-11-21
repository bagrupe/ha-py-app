using System.Text.Json;
using API.Features.Prozess;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Lage;

/// <summary>
/// "+1 · Sehe ich auch": someone confirms an open report instead of filing a duplicate. Kept out of the process
/// engine on purpose: a slot value would need a Bearbeitung, i.e. a process step, for every confirmation.
/// </summary>
[GraphQLDescription("Bestätigung (\"+1 · Sehe ich auch\") einer offenen Meldung durch eine weitere Person.")]
public class MeldungBestaetigung {
    public Guid Id { get; set; }
    [GraphQLIgnore] public Guid AusfuehrungId { get; set; }
    [GraphQLIgnore] public Ausfuehrung Ausfuehrung { get; set; } = null!;
    public Instant CreatedAt { get; set; }

    [GraphQLDescription("Fotos der bestätigenden Person, gleiches Format wie der Slot \"bilder\" der Meldung.")]
    public JsonElement? Fotos { get; set; }
}

public class MeldungBestaetigungConfig : IEntityTypeConfiguration<MeldungBestaetigung> {
    public void Configure(EntityTypeBuilder<MeldungBestaetigung> builder) {
        builder.HasOne(b => b.Ausfuehrung).WithMany()
            .HasForeignKey(b => b.AusfuehrungId).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(b => b.AusfuehrungId);
    }
}
