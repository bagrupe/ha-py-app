using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;
using IOPath = System.IO.Path;

namespace API.Seeders.LageHelfer;

/// <summary>
/// Liest und validiert <c>seed.json</c> und <c>flaechen.geojson</c> aus einem Verzeichnis.
/// </summary>
public static class LageHelferSeedLoader {
    private static readonly JsonSerializerOptions JsonOptions = new() {
        PropertyNameCaseInsensitive = true,
        ReadCommentHandling = JsonCommentHandling.Skip,
        AllowTrailingCommas = true,
    };

    /// <summary>Lädt beide Dateien aus <paramref name="directory"/>.</summary>
    /// <exception cref="InvalidOperationException">bei Verstößen gegen die Importregeln</exception>
    public static LageHelferSeedDocument Load(string directory) {
        if (string.IsNullOrWhiteSpace(directory)) {
            throw new InvalidOperationException("LageHelfer-Seed-Pfad ist nicht gesetzt.");
        }

        if (!Directory.Exists(directory)) {
            throw new InvalidOperationException($"LageHelfer-Seed-Verzeichnis existiert nicht: {directory}");
        }

        var seedPath = IOPath.Combine(directory, "seed.json");
        var flaechenPath = IOPath.Combine(directory, "flaechen.geojson");

        if (!File.Exists(seedPath)) {
            throw new InvalidOperationException($"Datei fehlt: {seedPath}");
        }

        if (!File.Exists(flaechenPath)) {
            throw new InvalidOperationException($"Datei fehlt: {flaechenPath}");
        }

        var raw = JsonSerializer.Deserialize<SeedJsonRoot>(File.ReadAllText(seedPath), JsonOptions)
            ?? throw new InvalidOperationException("seed.json konnte nicht gelesen werden.");

        if (raw.Version != 1) {
            throw new InvalidOperationException($"Unbekannte seed.json-Version {raw.Version} (erwartet: 1).");
        }

        if (!Guid.TryParse(raw.IdNamespace, out var idNamespace)) {
            throw new InvalidOperationException("idNamespace ist keine gültige GUID.");
        }

        if (!Guid.TryParse(raw.Kommune?.Id, out var kommuneId) || string.IsNullOrWhiteSpace(raw.Kommune?.Label)) {
            throw new InvalidOperationException("kommune.id oder kommune.name fehlt oder ist ungültig.");
        }

        var organisationseinheiten = raw.Organisationseinheiten ?? [];
        EnsureUniqueKeys(organisationseinheiten.Select(o => o.Key), "Organisationseinheit");

        var bereichKeys = new HashSet<string>(StringComparer.Ordinal);
        var bereichMitEinsatzleitung = new HashSet<string>(StringComparer.Ordinal);
        foreach (var oe in organisationseinheiten) {
            var bereiche = oe.Bereiche ?? [];
            EnsureUniqueKeys(bereiche.Select(b => b.Key), "Bereich");
            foreach (var bereich in bereiche) {
                if (!bereichKeys.Add(bereich.Key)) {
                    throw new InvalidOperationException($"Bereich-Schlüssel '{bereich.Key}' kommt mehrfach vor.");
                }

                if (!string.IsNullOrWhiteSpace(bereich.EinsatzleitungName)) {
                    bereichMitEinsatzleitung.Add(bereich.Key);
                }
            }

            var abteilungen = oe.Abteilungen ?? [];
            EnsureUniqueKeys(abteilungen.Select(a => a.Key), "Abteilung");
        }

        var oeByKey = organisationseinheiten.ToDictionary(o => o.Key, o => o, StringComparer.Ordinal);

        LageHelferDemoSeed? demo = null;
        if (raw.Demo is not null) {
            var nutzer = raw.Demo.Nutzer ?? [];
            EnsureUniqueKeys(nutzer.Select(n => n.Key), "Nutzer");
            foreach (var n in nutzer) {
                if (n.Organisationseinheit is not null && !oeByKey.ContainsKey(n.Organisationseinheit)) {
                    throw new InvalidOperationException(
                        $"Nutzer '{n.Key}' verweist auf unbekannte Organisationseinheit '{n.Organisationseinheit}'.");
                }

                if (n.EinsatzleitungBereich is not null) {
                    if (!bereichKeys.Contains(n.EinsatzleitungBereich)) {
                        throw new InvalidOperationException(
                            $"Nutzer '{n.Key}' verweist auf unbekannten Bereich '{n.EinsatzleitungBereich}'.");
                    }

                    if (!bereichMitEinsatzleitung.Contains(n.EinsatzleitungBereich)) {
                        throw new InvalidOperationException(
                            $"Nutzer '{n.Key}' verweist mit einsatzleitungBereich auf '{n.EinsatzleitungBereich}', " +
                            "dem in seed.json keine einsatzleitung zugeordnet ist.");
                    }
                }
            }

            demo = new LageHelferDemoSeed(
                raw.Demo.Passwort ?? throw new InvalidOperationException("demo.passwort fehlt."),
                nutzer.Select(n => new LageHelferDemoNutzerSeed(
                    n.Key,
                    n.Email,
                    n.Vorname,
                    n.Nachname,
                    n.Art,
                    n.Organisationseinheit,
                    n.EinsatzleitungBereich,
                    n.Rechte,
                    n.GlobaleRechte)).ToList());
        }

        var geometrien = LoadFlaechen(flaechenPath, bereichKeys);

        return new LageHelferSeedDocument(
            raw.Version,
            idNamespace,
            new LageHelferKommuneSeed(kommuneId, raw.Kommune.Label),
            organisationseinheiten.Select(oe => new LageHelferOrganisationseinheitSeed(
                oe.Key,
                oe.Label,
                (oe.Bereiche ?? []).Select(b => new LageHelferBereichSeed(b.Key, b.Label, b.EinsatzleitungName)).ToList(),
                (oe.Abteilungen ?? []).Select(a => new LageHelferAbteilungSeed(a.Key, a.Label)).ToList())).ToList(),
            demo,
            geometrien);
    }

    private static void EnsureUniqueKeys(IEnumerable<string> keys, string kind) {
        var seen = new HashSet<string>(StringComparer.Ordinal);
        foreach (var key in keys) {
            if (string.IsNullOrWhiteSpace(key)) {
                throw new InvalidOperationException($"{kind}-Schlüssel fehlt.");
            }

            if (!seen.Add(key)) {
                throw new InvalidOperationException($"{kind}-Schlüssel '{key}' kommt doppelt vor.");
            }
        }
    }

    private static Dictionary<string, string> LoadFlaechen(string path, IReadOnlySet<string> bereichKeys) {
        var root = JsonNode.Parse(File.ReadAllText(path))?.AsObject()
            ?? throw new InvalidOperationException("flaechen.geojson ist kein JSON-Objekt.");

        if (root["type"]?.GetValue<string>() != "FeatureCollection") {
            throw new InvalidOperationException("flaechen.geojson muss eine FeatureCollection sein.");
        }

        var features = root["features"]?.AsArray()
            ?? throw new InvalidOperationException("flaechen.geojson enthält kein features-Array.");

        var result = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (var featureNode in features) {
            var feature = featureNode?.AsObject()
                ?? throw new InvalidOperationException("Feature-Eintrag ist kein Objekt.");

            var bereich = feature["properties"]?["bereich"]?.GetValue<string>();
            if (string.IsNullOrWhiteSpace(bereich)) {
                throw new InvalidOperationException("Feature ohne properties.bereich.");
            }

            if (!bereichKeys.Contains(bereich)) {
                throw new InvalidOperationException($"Feature verweist auf unbekannten Bereich '{bereich}'.");
            }

            if (result.ContainsKey(bereich)) {
                throw new InvalidOperationException($"Mehrere Features für Bereich '{bereich}'.");
            }

            var geometry = feature["geometry"]?.AsObject()
                ?? throw new InvalidOperationException($"Feature für '{bereich}' hat keine Geometrie.");

            var type = geometry["type"]?.GetValue<string>();
            if (type is not ("Polygon" or "MultiPolygon")) {
                throw new InvalidOperationException(
                    $"Geometrie für Bereich '{bereich}' ist weder Polygon noch MultiPolygon (Typ: {type}).");
            }

            result[bereich] = geometry.ToJsonString();
        }

        return result;
    }

    private sealed class SeedJsonRoot {
        public int Version { get; set; }
        public string? IdNamespace { get; set; }
        public SeedJsonKommune? Kommune { get; set; }
        public List<SeedJsonOrganisationseinheit>? Organisationseinheiten { get; set; }
        public SeedJsonDemo? Demo { get; set; }
    }

    private sealed class SeedJsonKommune {
        public string? Id { get; set; }

        [JsonPropertyName("name")]
        public string? Label { get; set; }
    }

    private sealed class SeedJsonOrganisationseinheit {
        public required string Key { get; set; }

        [JsonPropertyName("name")]
        public required string Label { get; set; }

        public List<SeedJsonBereich>? Bereiche { get; set; }
        public List<SeedJsonAbteilung>? Abteilungen { get; set; }
    }

    private sealed class SeedJsonBereich {
        public required string Key { get; set; }

        [JsonPropertyName("name")]
        public required string Label { get; set; }

        [JsonPropertyName("einsatzleitung")]
        public string? EinsatzleitungName { get; set; }
    }

    private sealed class SeedJsonAbteilung {
        public required string Key { get; set; }

        [JsonPropertyName("name")]
        public required string Label { get; set; }
    }

    private sealed class SeedJsonDemo {
        public string? Passwort { get; set; }
        public List<SeedJsonNutzer>? Nutzer { get; set; }
    }

    private sealed class SeedJsonNutzer {
        public required string Key { get; set; }
        public required string Email { get; set; }
        public required string Vorname { get; set; }
        public required string Nachname { get; set; }
        public required string Art { get; set; }
        public string? Organisationseinheit { get; set; }

        [JsonPropertyName("einsatzleitungBereich")]
        public string? EinsatzleitungBereich { get; set; }

        public List<string>? Rechte { get; set; }
        public List<string>? GlobaleRechte { get; set; }
    }
}
