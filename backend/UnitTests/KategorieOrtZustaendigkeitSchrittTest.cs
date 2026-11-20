using System.Text.Json;
using API.Features;
using API.Features.Prozess;
using API.Features.Prozess.ProgrammatischeSchritte;

namespace IntegrationTests;

/// <summary>Pure logic tests for <see cref="KategorieOrtZustaendigkeitSchritt"/>: no database, no HTTP, no GraphQL.</summary>
public class KategorieOrtZustaendigkeitSchrittTest {
    public static readonly TheoryData<string[]> ArbitraryDepthPaths = new() {
        new[] { "Straßen" },
        new[] { "Straßen", "Beleuchtung" },
        new[] { "Straßen", "Beleuchtung", "Ausgefallen" },
    };

    [Theory]
    [MemberData(nameof(ArbitraryDepthPaths))]
    public void BuildKategoriePfad_reads_arbitrarily_many_levels(string[] erwartetePfad) {
        var slotValues = ToSlotValues(erwartetePfad);

        var pfad = KategorieOrtZustaendigkeitSchritt.BuildKategoriePfad(slotValues);

        Assert.Equal(erwartetePfad, pfad);
    }

    [Fact]
    public void BuildKategoriePfad_stops_at_first_missing_level_even_if_a_deeper_one_exists() {
        var slotValues = ToSlotValues(["Straßen"]);
        const string lueckenSlotName = "kategorie_3__strassen__beleuchtung";
        var luecke = new PlainSlotValue { SlotName = lueckenSlotName, Value = JsonSerializer.SerializeToElement("Ausgefallen"), Bearbeitung = null! };
        var mitLuecke = new Dictionary<string, SlotValue>(slotValues) { [lueckenSlotName] = luecke };

        var pfad = KategorieOrtZustaendigkeitSchritt.BuildKategoriePfad(mitLuecke);

        Assert.Equal(["Straßen"], pfad);
    }

    [Fact]
    public void BuildKategoriePfad_ignores_an_optional_level_the_app_sent_encrypted_without_a_choice() {
        var slotValues = ToSlotValues(["Spielplatz"]);
        const string leereEbene = "kategorie_2__spielplatz";
        slotValues[leereEbene] = new EncryptedSlotValue { SlotName = leereEbene, Value = new EncryptedValue("n", "t", "c"), Bearbeitung = null! };

        var pfad = KategorieOrtZustaendigkeitSchritt.BuildKategoriePfad(slotValues);

        Assert.Equal(["Spielplatz"], pfad);
    }

    [Fact]
    public void BuildKategoriePfad_ignores_an_optional_level_with_a_json_null_value() {
        var slotValues = ToSlotValues(["Spielplatz"]);
        const string leereEbene = "kategorie_2__spielplatz";
        slotValues[leereEbene] = new PlainSlotValue { SlotName = leereEbene, Value = JsonSerializer.SerializeToElement<string?>(null), Bearbeitung = null! };

        var pfad = KategorieOrtZustaendigkeitSchritt.BuildKategoriePfad(slotValues);

        Assert.Equal(["Spielplatz"], pfad);
    }

    [Fact]
    public void BuildKategoriePfad_still_rejects_an_encrypted_first_level() {
        var slotValues = new Dictionary<string, SlotValue> {
            ["kategorie"] = new EncryptedSlotValue { SlotName = "kategorie", Value = new EncryptedValue("n", "t", "c"), Bearbeitung = null! },
        };

        Assert.Throws<InvalidOperationException>(() => KategorieOrtZustaendigkeitSchritt.BuildKategoriePfad(slotValues));
    }

    [Fact]
    public void Slug_matches_the_category_tree_importers_convention() {
        Assert.Equal("strassen", KategorieOrtZustaendigkeitSchritt.Slug("Straßen"));
        Assert.Equal("oeffentliche_anlagen", KategorieOrtZustaendigkeitSchritt.Slug("Öffentliche Anlagen"));
    }

    [Fact]
    public void ResolveTiefstenKnoten_finds_the_exact_leaf_when_the_full_path_matches() {
        var wurzel = NeuerKnoten("Standard-Zuständigkeit", parent: null, untereinheitId: UntereinheitId, istWurzel: true);
        var strassen = NeuerKnoten("Straßen", parent: null, untereinheitId: null);
        var beleuchtung = NeuerKnoten("Beleuchtung", parent: strassen, untereinheitId: null);
        var alle = new List<Kategorie> { wurzel, strassen, beleuchtung };

        var treffer = KategorieOrtZustaendigkeitSchritt.ResolveTiefstenKnoten(alle, ["Straßen", "Beleuchtung"]);

        Assert.Equal(beleuchtung.Id, treffer?.Id);
    }

    [Fact]
    public void ResolveTiefstenKnoten_stops_at_the_deepest_ancestor_when_a_lower_level_is_unknown() {
        var strassen = NeuerKnoten("Straßen", parent: null, untereinheitId: null);
        var alle = new List<Kategorie> { strassen };

        var treffer = KategorieOrtZustaendigkeitSchritt.ResolveTiefstenKnoten(alle, ["Straßen", "Unbekannt"]);

        Assert.Equal(strassen.Id, treffer?.Id);
    }

    [Fact]
    public void ResolveTiefstenKnoten_returns_null_when_even_the_top_level_is_unknown() {
        var strassen = NeuerKnoten("Straßen", parent: null, untereinheitId: null);
        var alle = new List<Kategorie> { strassen };

        var treffer = KategorieOrtZustaendigkeitSchritt.ResolveTiefstenKnoten(alle, ["Grünflächen"]);

        Assert.Null(treffer);
    }

    [Fact]
    public void ResolveTiefstenKnoten_never_matches_the_invisible_wurzel_knoten_as_a_category() {
        var wurzel = NeuerKnoten("Standard-Zuständigkeit", parent: null, untereinheitId: UntereinheitId, istWurzel: true);
        var alle = new List<Kategorie> { wurzel };

        var treffer = KategorieOrtZustaendigkeitSchritt.ResolveTiefstenKnoten(alle, ["Standard-Zuständigkeit"]);

        Assert.Null(treffer);
    }

    [Fact]
    public void FindeVererbteZustaendigkeit_returns_the_nodes_own_ziel_when_set() {
        var eigenesZiel = new Zustaendigkeit { Art = ZustaendigkeitArt.Dienstleister, DienstleisterId = Guid.NewGuid() };
        var knoten = NeuerKnoten("Beleuchtung", parent: null, untereinheitId: null, ziel: eigenesZiel);

        var ziel = KategorieOrtZustaendigkeitSchritt.FindeVererbteZustaendigkeit([knoten], knoten, UntereinheitId);

        Assert.Same(eigenesZiel, ziel);
    }

    [Fact]
    public void FindeVererbteZustaendigkeit_walks_up_to_the_nearest_ancestor_with_an_own_ziel() {
        var elternZiel = new Zustaendigkeit { Art = ZustaendigkeitArt.Dienstleister, DienstleisterId = Guid.NewGuid() };
        var eltern = NeuerKnoten("Straßen", parent: null, untereinheitId: null, ziel: elternZiel);
        var kind = NeuerKnoten("Beleuchtung", parent: eltern, untereinheitId: null);
        var enkel = NeuerKnoten("Ausgefallen", parent: kind, untereinheitId: null);
        var alle = new List<Kategorie> { eltern, kind, enkel };

        var ziel = KategorieOrtZustaendigkeitSchritt.FindeVererbteZustaendigkeit(alle, enkel, UntereinheitId);

        Assert.Same(elternZiel, ziel);
    }

    [Fact]
    public void FindeVererbteZustaendigkeit_returns_null_when_no_ancestor_up_to_the_top_has_a_ziel() {
        var eltern = NeuerKnoten("Straßen", parent: null, untereinheitId: null);
        var kind = NeuerKnoten("Beleuchtung", parent: eltern, untereinheitId: null);
        var alle = new List<Kategorie> { eltern, kind };

        var ziel = KategorieOrtZustaendigkeitSchritt.FindeVererbteZustaendigkeit(alle, kind, UntereinheitId);

        Assert.Null(ziel);
    }

    [Fact]
    public void FindeVererbteZustaendigkeit_returns_null_for_a_null_node_so_the_caller_falls_back_to_the_wurzel() {
        var ziel = KategorieOrtZustaendigkeitSchritt.FindeVererbteZustaendigkeit([], null, UntereinheitId);

        Assert.Null(ziel);
    }

    [Fact]
    public void FindeVererbteZustaendigkeit_prefers_the_untereinheit_owned_twins_ziel_over_the_shared_ancestor() {
        var eigenesZiel = new Zustaendigkeit { Art = ZustaendigkeitArt.Dienstleister, DienstleisterId = Guid.NewGuid() };
        var geteilterEltern = NeuerKnoten("Gewässer", parent: null, untereinheitId: null);
        var zwilling = NeuerKnoten("Gewässer", parent: null, untereinheitId: UntereinheitId, ziel: eigenesZiel);
        var geteiltesKind = NeuerKnoten("Gewässer verschmutzt", parent: geteilterEltern, untereinheitId: null);
        var alle = new List<Kategorie> { geteilterEltern, zwilling, geteiltesKind };

        var ziel = KategorieOrtZustaendigkeitSchritt.FindeVererbteZustaendigkeit(alle, geteiltesKind, UntereinheitId);

        Assert.Same(eigenesZiel, ziel);
    }

    [Fact]
    public void FindeVererbteZustaendigkeit_does_not_confuse_twins_of_same_named_leaves_under_different_parents() {
        var gewaesser = NeuerKnoten("Gewässer", parent: null, untereinheitId: null);
        var wasserUndAbwasser = NeuerKnoten("Wasser- und Abwasserversorgung", parent: null, untereinheitId: null);
        var verschmutztUnterGewaesser = NeuerKnoten("Gewässer verschmutzt", parent: gewaesser, untereinheitId: null);
        var verschmutztUnterWasser = NeuerKnoten("Gewässer verschmutzt", parent: wasserUndAbwasser, untereinheitId: null);

        var falscherZwillingZiel = new Zustaendigkeit { Art = ZustaendigkeitArt.Dienstleister, DienstleisterId = Guid.NewGuid() };
        var falscherZwilling = NeuerKnoten("Gewässer verschmutzt", parent: wasserUndAbwasser, untereinheitId: UntereinheitId, ziel: falscherZwillingZiel);

        var alle = new List<Kategorie> {
            gewaesser, wasserUndAbwasser, verschmutztUnterGewaesser, verschmutztUnterWasser, falscherZwilling,
        };

        var ziel = KategorieOrtZustaendigkeitSchritt.FindeVererbteZustaendigkeit(alle, verschmutztUnterGewaesser, UntereinheitId);

        Assert.Null(ziel);
    }

    private static readonly Guid UntereinheitId = Guid.NewGuid();

    private static Kategorie NeuerKnoten(string name, Kategorie? parent, Guid? untereinheitId, bool istWurzel = false, Zustaendigkeit? ziel = null) => new() {
        Id = Guid.NewGuid(),
        KommuneId = Guid.NewGuid(),
        ParentId = parent?.Id,
        UntereinheitId = untereinheitId,
        IstWurzel = istWurzel,
        Name = name,
        Ziel = ziel,
    };

    private static Dictionary<string, SlotValue> ToSlotValues(string[] pfad) {
        var slotValues = new Dictionary<string, SlotValue> {
            ["kategorie"] = new PlainSlotValue { SlotName = "kategorie", Value = JsonSerializer.SerializeToElement(pfad[0]), Bearbeitung = null! },
        };
        var slugPfad = new List<string> { KategorieOrtZustaendigkeitSchritt.Slug(pfad[0]) };
        for (var ebene = 2; ebene <= pfad.Length; ebene++) {
            var slotName = $"kategorie_{ebene}__{string.Join("__", slugPfad)}";
            slotValues[slotName] = new PlainSlotValue { SlotName = slotName, Value = JsonSerializer.SerializeToElement(pfad[ebene - 1]), Bearbeitung = null! };
            slugPfad.Add(KategorieOrtZustaendigkeitSchritt.Slug(pfad[ebene - 1]));
        }
        return slotValues;
    }
}
