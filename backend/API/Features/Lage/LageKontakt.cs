using System.ComponentModel.DataAnnotations;
using NodaTime;

namespace API.Features.Lage;

public class LageKontakt {
    public Guid Id { get; set; }
    public Guid LageId { get; set; }
    public Lage Lage { get; set; } = null!;
    public Guid? MeldungId { get; set; }
    [MaxLength(40)] public required string Telefonnummer { get; set; }
    public bool Rueckruf { get; set; }
    public Instant Erstellt { get; set; }
    public Instant? Erledigt { get; set; }
}
