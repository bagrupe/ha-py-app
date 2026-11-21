using API.Infrastructure;

namespace API.Features.Prozess;

public class ZuVieleDateienException(string feld, int maxAnzahl)
    : DomainException($"Für \"{feld}\" sind höchstens {maxAnzahl} Dateien erlaubt.");
