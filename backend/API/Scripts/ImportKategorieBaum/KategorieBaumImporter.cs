using System.Diagnostics;
using System.Globalization;
using System.Text.RegularExpressions;
using API.Features.Auth;
using API.Features.Expressions;
using API.Features.Prozess;
using CsvHelper;
using CsvHelper.Configuration;
using CsvHelper.Configuration.Attributes;
using Path = System.IO.Path;

namespace API.Scripts.ImportKategorieBaum;

/// <summary>Repräsentiert einen Eintrag aus der CSV-Datei des Kategoriebaums.</summary>
/// <param name="C1">Erste Kategorieebene.</param>
/// <param name="C2">Zweite Kategorieebene.</param>
/// <param name="C3">Dritte Kategorieebene.</param>
/// <param name="C4">Zuständigkeitsinformationen.</param>
public record KategorieBaumCsvEntry(
    [property: Index(0)] string C1,
    [property: Index(1)] string C2,
    [property: Index(2)] string C3,
    [property: Index(3)] string C4);

/// <summary>Basisklasse für Elemente des Kategoriebaums mit einem Namen.</summary>
[DebuggerDisplay("Name = {Name}")]
public abstract class KategorieBaumElement {
    public required string Name { get; init; }
}

/// <summary>Repräsentiert eine Zuständigkeit mit Gruppenname und optionaler Innerorts-Kennzeichnung.</summary>
/// <param name="Gruppe">Name der Mitarbeitergruppe.</param>
/// <param name="IsInnerorts">Gibt an, ob die Zuständigkeit innerorts gilt.</param>
public record Zustaendigkeit(string Gruppe, bool? IsInnerorts);

/// <summary>Blattknoten im Kategoriebaum mit zugehörigen Zuständigkeiten.</summary>
public class KategorieBaumBlatt : KategorieBaumElement {
    public required ICollection<Zustaendigkeit> Zustaendigkeiten { get; init; }
}

/// <summary>Knoten im Kategoriebaum, der weitere Elemente als Kinder enthält.</summary>
public class KategorieBaumKnoten : KategorieBaumElement {
    public List<KategorieBaumElement> Kinder { get; } = [];
}

/// <summary>Importiert und verarbeitet einen Kategoriebaum aus einer CSV-Datei.</summary>
public partial class KategorieBaumImporter {
    private readonly string _path;
    private readonly KategorieBaumKnoten _baum;
    private readonly Guid _kommuneId;
    private readonly Dictionary<string, MitarbeiterGruppe> _gruppen;

    /// <summary>Initialisiert den Importer mit Pfad, Kommune und vorhandenen Mitarbeitergruppen.</summary>
    /// <param name="path">Pfad zur CSV-Datei.</param>
    /// <param name="kommuneId">ID der Kommune.</param>
    /// <param name="mitarbeiterGruppen">Liste vorhandener Mitarbeitergruppen.</param>
    public KategorieBaumImporter(string path, Guid kommuneId, List<MitarbeiterGruppe> mitarbeiterGruppen) {
        _path = path;
        _baum = ImportKategorieBaum(path);
        _kommuneId = kommuneId;
        _gruppen = mitarbeiterGruppen.ToDictionary(mg => mg.Name);
        PregenerateMissingGruppen(_baum);
    }

    /// <summary>Lädt und erstellt den Kategoriebaum aus der CSV-Datei.</summary>
    /// <param name="path">Pfad zur CSV-Datei.</param>
    /// <returns>Wurzelknoten des importierten Kategoriebaums.</returns>
    private static KategorieBaumKnoten ImportKategorieBaum(string path) {
        using var reader = new StreamReader(path);

        var csvReaderConfig = new CsvConfiguration(CultureInfo.InvariantCulture) {
            HasHeaderRecord = false,
            MissingFieldFound = null,
            Delimiter = ";",
            TrimOptions = TrimOptions.Trim,
        };

        using var csv = new CsvReader(reader, csvReaderConfig);
        var records = csv.GetRecords<KategorieBaumCsvEntry>().ToList();

        var baum = new KategorieBaumKnoten { Name = "Wurzel" };

        foreach (var record in records) {
            if (record.C1 != "") {
                baum.Kinder.Add(new KategorieBaumKnoten { Name = record.C1 });
            }

            var zustaendigeGruppe = ParseZustaendigkeiten(record.C4);

            var currentAst = (KategorieBaumKnoten)baum.Kinder.Last();
            if (record.C2 == "") {
                var currentZweig = (KategorieBaumKnoten)currentAst.Kinder.Last();
                currentZweig.Kinder.Add(new KategorieBaumBlatt { Name = record.C3, Zustaendigkeiten = zustaendigeGruppe });
            } else {
                if (record.C3 == "") {
                    currentAst.Kinder.Add(new KategorieBaumBlatt { Name = record.C2, Zustaendigkeiten = zustaendigeGruppe });
                } else {
                    var newZweig = new KategorieBaumKnoten { Name = record.C2 };
                    currentAst.Kinder.Add(newZweig);
                    newZweig.Kinder.Add(new KategorieBaumBlatt { Name = record.C3, Zustaendigkeiten = zustaendigeGruppe });
                }
            }
        }

        return baum;
    }

    /// <summary>Erzeugt fehlende Mitarbeitergruppen basierend auf Zuständigkeiten im Baum.</summary>
    /// <param name="element">Aktuelles Element des Kategoriebaums.</param>
    private void PregenerateMissingGruppen(KategorieBaumElement element) {
        if (element is KategorieBaumBlatt blatt) {
            var gruppenNamen = blatt.Zustaendigkeiten.Select(z => z.Gruppe);

            foreach (var gruppenName in gruppenNamen) {
                if (_gruppen.ContainsKey(gruppenName)) continue;

                var gruppe = new MitarbeiterGruppe {
                    Name = gruppenName,
                    KommuneId = _kommuneId,
                };
                _gruppen[gruppenName] = gruppe;
            }
        } else if (element is KategorieBaumKnoten knoten) {
            foreach (var baumElement in knoten.Kinder) {
                PregenerateMissingGruppen(baumElement);
            }
        }
    }

    /// <summary>Ermittelt die Formularfelder für den Kategoriebaum mit einem Offset.</summary>
    /// <param name="feldOffset">Startwert für die Reihenfolge der Felder.</param>
    /// <returns>Liste der Formularfelder.</returns>
    public List<StringFormularFeld> GetFelder(int feldOffset) => GetFelderInternal(_baum, feldOffset);

    /// <summary>Rekursiv ermittelt Formularfelder aus dem Kategoriebaum.</summary>
    /// <param name="baum">Aktuelles Kategoriebaumelement.</param>
    /// <param name="orderOffset">Offset für die Reihenfolge der Felder.</param>
    /// <param name="path">Pfad zur aktuellen Position im Baum.</param>
    /// <param name="depth">Tiefe im Baum.</param>
    /// <returns>Liste der Formularfelder.</returns>
    private List<StringFormularFeld> GetFelderInternal(KategorieBaumElement baum, int orderOffset, string path = "", int depth = 0) {
        string[] Feldtitel = ["Hauptkategorie", "Unterkategorie", "Spezifizierung"];

        if (baum is KategorieBaumKnoten wurzel) {
            var result = new List<StringFormularFeld>();
            var slotName = path + "_" + NormalizeNameToKey(wurzel.Name);

            result.Add(new StringFormularFeld {
                Order = depth + orderOffset,
                SlotName = slotName,
                AngezeigterName = Feldtitel[depth],
                Encrypted = false,
                OeffentlichSichtbar = depth == 0,
                Options = wurzel.Kinder.Select(ElementZuOption).ToList(),
                IstRelevant = depth == 0 ? true : new BoolExpression($"slot('{path}') == '{wurzel.Name}'"),
            });

            result.AddRange(wurzel.Kinder.SelectMany(k => GetFelderInternal(k, orderOffset, slotName, depth + 1)));

            return result;
        }

        return [];
    }

    /// <summary>Erzeugt Schritte und Verbindungen für den Kategoriebaum.</summary>
    /// <param name="vonSchritt">Ausgangsschritt für Verbindungen.</param>
    /// <param name="endeSchritt">Endschritt für Verbindungen.</param>
    /// <returns>Tuple aus Liste der Schritte und Verbindungen.</returns>
    public (List<Schritt> Schritte, List<Verbindung> Verbindungen) GetSchritte(Schritt vonSchritt, EndeSchritt endeSchritt) => GetSchritteInternal(_baum, vonSchritt, endeSchritt);

    /// <summary>Rekursiv erzeugt Schritte und Verbindungen aus dem Kategoriebaum.</summary>
    /// <param name="baum">Aktuelles Kategoriebaumelement.</param>
    /// <param name="vonSchritt">Ausgangsschritt für Verbindungen.</param>
    /// <param name="endeSchritt">Endschritt für Verbindungen.</param>
    /// <param name="path">Pfad zur aktuellen Position im Baum.</param>
    /// <returns>Tuple aus Liste der Schritte und Verbindungen.</returns>
    private (List<Schritt> Schritte, List<Verbindung> Verbindungen) GetSchritteInternal(KategorieBaumElement baum, Schritt vonSchritt, EndeSchritt endeSchritt, string path = "") {
        if (baum is KategorieBaumKnoten knoten) {
            var result = knoten.Kinder.Select(
                k => GetSchritteInternal(k, vonSchritt, endeSchritt, path + "_" + NormalizeNameToKey(baum.Name))
            ).ToList();

            return (
                result.SelectMany(r => r.Schritte).ToList(),
                result.SelectMany(r => r.Verbindungen).ToList()
            );
        }

        if (baum is KategorieBaumBlatt blatt) {
            var backofficeSchritte = new List<Schritt>();
            var verbindungen = new List<Verbindung>();

            foreach (var zustaendigkeit in blatt.Zustaendigkeiten) {
                var backofficeSchritt = new FormularSchritt {
                    Id = Guid.NewGuid(),
                    Felder = [],
                    Titel = blatt.Name,
                    SollZustaendigkeit = new Features.Prozess.Zustaendigkeit { MitarbeiterGruppe = _gruppen[zustaendigkeit.Gruppe] }
                };

                backofficeSchritte.Add(backofficeSchritt);

                var istRelevantExpression = $"slot('{path}') == '{blatt.Name}'";
                if (zustaendigkeit.IsInnerorts is { } isInnerorts) {
                    istRelevantExpression += $" && (isInside('Ortslagen', slot('adresse')) == {isInnerorts.ToString().ToLower()})";
                }

                verbindungen.AddRange(new List<Verbindung> {
                    new() {
                        Id = Guid.NewGuid(),
                        VonId = vonSchritt.Id,
                        NachId = backofficeSchritt.Id,
                        IstRelevant = new BoolExpression(istRelevantExpression),
                    },
                    new () {
                        Id = Guid.NewGuid(),
                        VonId = backofficeSchritt.Id,
                        NachId = endeSchritt.Id,
                        Name = "Abschließen",
                    }
                });
            }

            return (backofficeSchritte, verbindungen);
        }

        return ([], []);
    }

    /// <summary>Erzeugt eine Formularfeldoption aus einem Kategoriebaumelement.</summary>
    /// <param name="element">Kategoriebaumelement.</param>
    /// <returns>Option mit dem Namen des Elements.</returns>
    private static StringFormularFeldOption ElementZuOption(KategorieBaumElement element) {
        return new StringFormularFeldOption(element.Name);
    }

    /// <summary>Normalisiert einen Namen zu einem Schlüssel, der nur alphanumerische Zeichen und Unterstriche enthält.</summary>
    /// <param name="name">Zu normalisierender Name.</param>
    /// <returns>Normalisierter Schlüsselstring.</returns>
    private static string NormalizeNameToKey(string name) {
        var nonAlphaNumericRegex = NonAlphaNumericRegex();

        var lowerWithUmlautsConvertedName = name.ToLower()
            .Replace("ß", "ss").Replace("ä", "ae").Replace("ö", "oe").Replace("ü", "ue");

        return nonAlphaNumericRegex.Replace(lowerWithUmlautsConvertedName, "_");
    }

    /// <summary>Parst eine Zuständigkeitsbeschreibung in eine Menge von Zuständigkeiten.</summary>
    /// <param name="input">Eingabestring mit Zuständigkeitsinformationen.</param>
    /// <returns>Menge von Zuständigkeiten.</returns>
    private static HashSet<Zustaendigkeit> ParseZustaendigkeiten(string input) {
        var split = input.Split(" / ");
        return split.Select(
            part => {
                var regex = SanitizeZustaendigeGruppeRegex();
                var match = regex.Match(part);
                var gruppe = match.Groups["Gruppe"].Value.Trim();
                var prefix = match.Groups["Prefix"].Success ? match.Groups["Prefix"].Value.Trim() : null;

                return new Zustaendigkeit(gruppe, prefix == null ? null : prefix == "Innerorts:");
            }
        ).ToHashSet();
    }

    [GeneratedRegex(@"^(?<Prefix>.*?:)?\s*(?<Gruppe>[^(]*)(?:\s*\(.*\))?")]
    private static partial Regex SanitizeZustaendigeGruppeRegex();
    [GeneratedRegex(@"\W")]
    private static partial Regex NonAlphaNumericRegex();
}
