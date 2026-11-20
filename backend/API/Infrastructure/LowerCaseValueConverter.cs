using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace API.Infrastructure;

/// <summary>Konvertiert Zeichenketten in Kleinbuchstaben für die Datenbankspeicherung und -abfrage.</summary>
public class LowerCaseValueConverter() : ValueConverter<string, string>(
    v => v.ToLowerInvariant(),
    v => v.ToLowerInvariant()
);
