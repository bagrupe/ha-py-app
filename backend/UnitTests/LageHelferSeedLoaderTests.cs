using API.Seeders.LageHelfer;

namespace IntegrationTests;

public class LageHelferSeedLoaderTests {
    private static string ExamplePath =>
        Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "API",
            "Seeders", "LageHelfer", "Data", "example"));

    private static string WriteTempSeed(string json, string? geojson = null) {
        var dir = Path.Combine(Path.GetTempPath(), "lagehelfer-seed-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(dir);
        File.WriteAllText(Path.Combine(dir, "seed.json"), json);
        File.WriteAllText(Path.Combine(dir, "flaechen.geojson"), geojson ?? """{"type":"FeatureCollection","features":[]}""");
        return dir;
    }

    [Fact]
    public void Load_example_succeeds() {
        var doc = LageHelferSeedLoader.Load(ExamplePath);
        Assert.Equal(1, doc.Version);
        Assert.Equal(2, doc.Organisationseinheiten.Count);
        Assert.Equal(3, doc.Organisationseinheiten.Sum(o => o.Bereiche.Count));
        Assert.Equal(2, doc.BereichGeometrien.Count);
        Assert.NotNull(doc.Demo);
    }

    [Fact]
    public void Load_example_reads_einheiten_of_a_bereich() {
        var doc = LageHelferSeedLoader.Load(ExamplePath);
        var walddorf = doc.Organisationseinheiten.SelectMany(o => o.Bereiche).Single(b => b.Key == "Walddorf");
        Assert.Equal(["HLF 20 Walddorf", "MTW Walddorf"], walddorf.Einheiten);
    }

    [Fact]
    public void Rejects_einheiten_without_einsatzleitung() {
        var dir = WriteTempSeed("""
            {
              "version": 1,
              "idNamespace": "325be732-b4d0-4bbe-9ff6-4be737e4c909",
              "kommune": {"id": "84a06067-dc9e-46d0-b60a-8258cf7c1ce7", "name": "x"},
              "organisationseinheiten": [
                {"key": "A", "name": "A", "bereiche": [{"key": "X", "name": "X", "einheiten": ["HLF"]}], "abteilungen": []}
              ]
            }
            """);
        Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
    }

    [Fact]
    public void Rejects_unknown_version() {
        var dir = WriteTempSeed("""{"version":2,"idNamespace":"325be732-b4d0-4bbe-9ff6-4be737e4c909","kommune":{"id":"84a06067-dc9e-46d0-b60a-8258cf7c1ce7","name":"x"},"organisationseinheiten":[]}""");
        Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
    }

    [Fact]
    public void Rejects_duplicate_bereich_key() {
        var dir = WriteTempSeed("""
            {
              "version": 1,
              "idNamespace": "325be732-b4d0-4bbe-9ff6-4be737e4c909",
              "kommune": {"id": "84a06067-dc9e-46d0-b60a-8258cf7c1ce7", "name": "x"},
              "organisationseinheiten": [
                {"key": "A", "name": "A", "bereiche": [{"key": "dup", "name": "1", "einsatzleitung": "E1"}], "abteilungen": []},
                {"key": "B", "name": "B", "bereiche": [{"key": "dup", "name": "2", "einsatzleitung": "E2"}], "abteilungen": []}
              ]
            }
            """);
        Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
    }

    [Fact]
    public void Rejects_feature_for_unknown_bereich() {
        var dir = WriteTempSeed("""
            {
              "version": 1,
              "idNamespace": "325be732-b4d0-4bbe-9ff6-4be737e4c909",
              "kommune": {"id": "84a06067-dc9e-46d0-b60a-8258cf7c1ce7", "name": "x"},
              "organisationseinheiten": [
                {"key": "A", "name": "A", "bereiche": [{"key": "X", "name": "X", "einsatzleitung": "E"}], "abteilungen": []}
              ]
            }
            """, """
            {"type":"FeatureCollection","features":[{"type":"Feature","properties":{"bereich":"Y"},"geometry":{"type":"Polygon","coordinates":[[[0,0],[1,0],[1,1],[0,0]]]}}]}
            """);
        Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
    }

    [Fact]
    public void Rejects_invalid_geometry_type() {
        var dir = WriteTempSeed("""
            {
              "version": 1,
              "idNamespace": "325be732-b4d0-4bbe-9ff6-4be737e4c909",
              "kommune": {"id": "84a06067-dc9e-46d0-b60a-8258cf7c1ce7", "name": "x"},
              "organisationseinheiten": [
                {"key": "A", "name": "A", "bereiche": [{"key": "X", "name": "X", "einsatzleitung": "E"}], "abteilungen": []}
              ]
            }
            """, """
            {"type":"FeatureCollection","features":[{"type":"Feature","properties":{"bereich":"X"},"geometry":{"type":"Point","coordinates":[0,0]}}]}
            """);
        Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
    }

    [Fact]
    public void Rejects_einsatzleitungBereich_without_bereich_einsatzleitung() {
        var dir = WriteTempSeed("""
            {
              "version": 1,
              "idNamespace": "325be732-b4d0-4bbe-9ff6-4be737e4c909",
              "kommune": {"id": "84a06067-dc9e-46d0-b60a-8258cf7c1ce7", "name": "x"},
              "organisationseinheiten": [
                {
                  "key": "A",
                  "name": "A",
                  "bereiche": [{"key": "X", "name": "X"}],
                  "abteilungen": []
                }
              ],
              "demo": {
                "passwort": "123456",
                "nutzer": [
                  {
                    "key": "u",
                    "email": "u@example.com",
                    "vorname": "U",
                    "nachname": "U",
                    "art": "Nutzer",
                    "einsatzleitungBereich": "X"
                  }
                ]
              }
            }
            """);
        var ex = Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
        Assert.Contains("keine einsatzleitung", ex.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void Bereich_without_feature_is_allowed() {
        var doc = LageHelferSeedLoader.Load(ExamplePath);
        Assert.DoesNotContain("Walddorf", doc.BereichGeometrien.Keys);
        Assert.Contains(doc.Organisationseinheiten.SelectMany(o => o.Bereiche), b => b.Key == "Walddorf");
    }

    [Fact]
    public void Example_loads_globaleRechte() {
        var doc = LageHelferSeedLoader.Load(ExamplePath);
        var einsatzleitung = doc.Demo!.Nutzer.Single(n => n.Key == "einsatzleitung-nord");
        Assert.Equal(["LageHelfer"], einsatzleitung.GlobaleRechte);
    }

    [Fact]
    public void Example_derived_ids_are_stable() {
        var doc = LageHelferSeedLoader.Load(ExamplePath);
        var ns = doc.IdNamespace;
        Assert.Equal(new Guid("a1b2c3d4-e5f6-7890-abcd-ef1234567890"), ns);
        Assert.Equal(new Guid("11111111-2222-3333-4444-555555555551"), doc.Kommune.Id);

        Assert.Equal(new Guid("603b9690-93d4-5841-8e2e-9e9a1b3fa19c"),
            LageHelferSeedData.OrganisationseinheitId(ns, "Nordkreis"));
        Assert.Equal(new Guid("29153e46-9cfb-59e8-b606-d984ad87040c"), LageHelferSeedData.GebietId(ns, "Nordstadt"));
        Assert.Equal(new Guid("15ab510f-5759-530f-ac8c-41590ecb2795"),
            LageHelferSeedData.EinsatzleitungId(ns, "Walddorf"));
        Assert.Equal(new Guid("e74d059d-62b8-56df-ae4a-0d0af4033a5a"),
            LageHelferSeedData.NutzerId(ns, "superadmin"));
    }

    private const string ProzessSeedPrefix = """
        {
          "version": 1,
          "idNamespace": "325be732-b4d0-4bbe-9ff6-4be737e4c909",
          "kommune": {"id": "84a06067-dc9e-46d0-b60a-8258cf7c1ce7", "name": "x"},
          "organisationseinheiten": [],
          "prozesse":
        """;

    [Fact]
    public void Example_loads_prozesse() {
        var doc = LageHelferSeedLoader.Load(ExamplePath);
        var prozess = Assert.Single(doc.Prozesse);
        Assert.Equal("ereignis-melden", prozess.Key);
        Assert.Equal(LageHelferProzessVorlage.Ereignismeldung, prozess.Vorlage);
        Assert.Equal(["Anonym", "LageHelfer"], prozess.Tags);
        Assert.Equal(["Unwetter", "Großbrand", "Hagelsturm", "Blitzeis"], prozess.Kategorien);
    }

    [Fact]
    public void Prozesse_section_is_optional() {
        var dir = WriteTempSeed("""{"version":1,"idNamespace":"325be732-b4d0-4bbe-9ff6-4be737e4c909","kommune":{"id":"84a06067-dc9e-46d0-b60a-8258cf7c1ce7","name":"x"},"organisationseinheiten":[]}""");
        Assert.Empty(LageHelferSeedLoader.Load(dir).Prozesse);
    }

    [Fact]
    public void Rejects_unknown_vorlage() {
        var dir = WriteTempSeed(ProzessSeedPrefix + """
            [{"key": "p", "vorlage": "Gibtsnicht", "name": "P", "kategorien": ["A"]}]}
            """);
        var e = Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
        Assert.Contains("Gibtsnicht", e.Message);
    }

    [Fact]
    public void Rejects_ereignismeldung_without_kategorien() {
        var dir = WriteTempSeed(ProzessSeedPrefix + """
            [{"key": "p", "vorlage": "Ereignismeldung", "name": "P", "kategorien": []}]}
            """);
        Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
    }

    [Fact]
    public void Rejects_same_tag_on_two_prozesse() {
        var dir = WriteTempSeed(ProzessSeedPrefix + """
            [
              {"key": "a", "vorlage": "Ereignismeldung", "name": "A", "tags": ["Anonym"], "kategorien": ["X"]},
              {"key": "b", "vorlage": "Ereignismeldung", "name": "B", "tags": ["Anonym"], "kategorien": ["X"]}
            ]}
            """);
        var e = Assert.Throws<InvalidOperationException>(() => LageHelferSeedLoader.Load(dir));
        Assert.Contains("Anonym", e.Message);
    }
}
