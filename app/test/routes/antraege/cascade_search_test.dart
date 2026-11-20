import 'package:app/common/expressions/evaluating_visitor_service.dart';
import 'package:app/common/expressions/expression.dart';
import 'package:app/common/geo_service.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/antraege/components/schritte/cascade_search_index.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/text_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

class _FakeGeoService implements GeoService {
  int calls = 0;

  @override
  Future<bool> isPointInGeoflaeche(String name, LatLng position) async {
    calls++;
    return name == 'Hameln' && position.latitude > 52;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TextFeldOption _option(String name, {String? istRelevant}) => TextFeldOption(
  key: name,
  value: name,
  istRelevant: istRelevant == null ? null : BoolExpression(istRelevant),
);

FormularTextFeldData _field(
  String slotName,
  List<TextFeldOption> options, {
  String istRelevant = 'true',
  bool durchsuchbar = false,
}) => FormularTextFeldData(
  multiline: false,
  stringOptions: options,
  durchsuchbar: durchsuchbar,
  validationType: Enum_StringValidationType.DEFAULT,
  slotName: slotName,
  pflichtfeld: false,
  istRelevant: BoolExpression(istRelevant),
);

const _onlyHameln = "isInside('Hameln', slot('adresse')) == true";
const _insideHameln = FormLocation(position: LatLng(52.1, 9.36));
const _outside = FormLocation(position: LatLng(51.9, 9.2));

void main() {
  late _FakeGeoService geo;
  late EvaluatingVisitorService visitor;

  final kategorie = _field('kategorie', [
    _option('Straßen'),
    _option('Grünflächen und Parks', istRelevant: _onlyHameln),
  ], durchsuchbar: true);
  final strassen = _field('kategorie_2__strassen', [
    _option('Schäden'),
    _option('Beleuchtung'),
  ], istRelevant: "slot('kategorie') == 'Straßen'");
  final gruen = _field(
    'kategorie_2__gruenflaechen',
    [_option('Kaputte Parkbank')],
    istRelevant: "slot('kategorie') == 'Grünflächen und Parks'",
  );
  final schaeden = _field(
    'kategorie_3__strassen__schaeden',
    [_option('Schlagloch'), _option('Riss im Gehweg')],
    istRelevant: "slot('kategorie_2__strassen') == 'Schäden'",
  );
  final unrelated = _field('anrede', [_option('Frau'), _option('Herr')]);
  final allFields = [kategorie, strassen, gruen, schaeden, unrelated];

  setUp(() {
    geo = _FakeGeoService();
    visitor = EvaluatingVisitorService(geo);
  });

  test('offers only complete cascade paths', () async {
    final index = await CascadeSearchIndex.build(kategorie, allFields, visitor);

    final paths = index.entries
        .map((e) => [...e.parentLabels, e.label].join(' > '))
        .toList();
    expect(paths, [
      'Straßen > Schäden > Schlagloch',
      'Straßen > Schäden > Riss im Gehweg',
      'Straßen > Beleuchtung',
      'Grünflächen und Parks > Kaputte Parkbank',
    ]);
    expect(
      index.entries.expand((e) => e.steps).map((s) => s.field.slotName),
      isNot(contains('anrede')),
    );
  });

  test(
    'detects child fields with escaped quotes and complex expressions',
    () async {
      final rootField = _field('kategorie', [
        _option("Müll 'wild'"),
        _option('Sonstiges'),
      ], durchsuchbar: true);
      final escaped = _field('kategorie_2__muell', [
        _option('Sperrmüll'),
      ], istRelevant: r"slot('kategorie') == 'Müll \'wild\''");
      final komplex = _field(
        'kategorie_2__sonstiges',
        [_option('Anderes')],
        istRelevant: "slot('kategorie') == 'Sonstiges' && true",
      );

      final index = await CascadeSearchIndex.build(rootField, [
        rootField,
        escaped,
        komplex,
      ], visitor);

      final paths = index.entries
          .map((e) => [...e.parentLabels, e.label].join(' > '))
          .toList();
      expect(paths, ["Müll 'wild' > Sperrmüll", 'Sonstiges > Anderes']);
    },
  );

  test('finds deep entries across umlauts and multiple words', () async {
    final index = await CascadeSearchIndex.build(kategorie, allFields, visitor);

    expect(
      CascadeSearchIndex.search(index.entries, 'schlagloch').single.label,
      'Schlagloch',
    );
    expect(
      CascadeSearchIndex.search(index.entries, 'strasse riss').single.label,
      'Riss im Gehweg',
    );
    expect(
      CascadeSearchIndex.search(index.entries, 'BANK').single.label,
      'Kaputte Parkbank',
    );
    expect(CascadeSearchIndex.search(index.entries, '   '), isEmpty);
  });

  test('finds complete descendants via a parent level', () async {
    final index = await CascadeSearchIndex.build(kategorie, allFields, visitor);

    final results = CascadeSearchIndex.search(index.entries, 'schäden');
    expect(results.map((e) => e.label), contains('Schlagloch'));
    expect(results.map((e) => e.label), contains('Riss im Gehweg'));
    expect(results.map((e) => e.label), isNot(contains('Schäden')));
  });

  test('supports child relevance with parent and address conditions', () async {
    final conditionalChild = _field(
      'kategorie_2__strassen',
      [_option('Schlagloch')],
      istRelevant:
          "slot('kategorie') == 'Straßen' && isInside('Hameln', slot('adresse')) == true",
    );
    final root = _field('kategorie', [_option('Straßen')], durchsuchbar: true);
    final index = await CascadeSearchIndex.build(root, [
      root,
      conditionalChild,
    ], visitor);

    expect(index.entries.single.pathLabel, 'Straßen › Schlagloch');
    expect(
      await index.visibleEntries(visitor, {'adresse': _insideHameln}),
      hasLength(1),
    );
    expect(await index.visibleEntries(visitor, {'adresse': _outside}), isEmpty);
  });

  test('only offers what the cascade offers for the address', () async {
    final index = await CascadeSearchIndex.build(kategorie, allFields, visitor);

    final outside = await index.visibleEntries(visitor, {'adresse': _outside});
    expect(outside.map((e) => e.label), isNot(contains('Kaputte Parkbank')));
    expect(
      outside.map((e) => e.label),
      isNot(contains('Grünflächen und Parks')),
    );

    final insideHameln = await index.visibleEntries(visitor, {
      'adresse': _insideHameln,
    });
    expect(insideHameln.map((e) => e.label), contains('Kaputte Parkbank'));
  });

  test('re-evaluates visibility only when the address changes', () async {
    final index = await CascadeSearchIndex.build(kategorie, allFields, visitor);

    await index.visibleEntries(visitor, {'adresse': _insideHameln});
    final callsAfterFirst = geo.calls;
    await index.visibleEntries(visitor, {
      'adresse': _insideHameln,
      'kategorie': 'Straßen',
    });
    expect(geo.calls, callsAfterFirst);

    await index.visibleEntries(visitor, {'adresse': _outside});
    expect(geo.calls, greaterThan(callsAfterFirst));
  });

  test('build and search stay fast at the real tree size', () async {
    final level2 = <FormularTextFeldData>[];
    final level3 = <FormularTextFeldData>[];
    final roots = <TextFeldOption>[];
    var level2Total = 0;
    var level3Total = 0;
    for (var h = 0; h < 54; h++) {
      roots.add(
        _option('Haupt $h', istRelevant: h.isEven ? _onlyHameln : null),
      );
      final count = h < 48 ? 4 : 3;
      final children = [
        for (var u = 0; u < count && level2Total < 210; u++)
          _option('Unter $h-$u'),
      ];
      level2Total += children.length;
      level2.add(
        _field(
          'kategorie_2__h$h',
          children,
          istRelevant: "slot('kategorie') == 'Haupt $h'",
        ),
      );
      if (level3Total < 55) {
        final specs = [for (var s = 0; s < 5; s++) _option('Spez $h-$s')];
        level3Total += specs.length;
        level3.add(
          _field(
            'kategorie_3__h${h}__u0',
            specs,
            istRelevant: "slot('kategorie_2__h$h') == 'Unter $h-0'",
          ),
        );
      }
    }
    final rootField = _field('kategorie', roots, durchsuchbar: true);

    final stopwatch = Stopwatch()..start();
    final index = await CascadeSearchIndex.build(rootField, [
      rootField,
      ...level2,
      ...level3,
    ], visitor);
    final buildMs = stopwatch.elapsedMilliseconds;
    await index.visibleEntries(visitor, {'adresse': _insideHameln});
    final visibilityMs = stopwatch.elapsedMilliseconds - buildMs;
    stopwatch.reset();
    for (var i = 0; i < 100; i++) {
      CascadeSearchIndex.search(index.entries, 'spez 3');
    }
    final searchMicros = stopwatch.elapsedMicroseconds / 100;

    expect(index.entries.length, level2Total - level3.length + level3Total);
    expect(buildMs, lessThan(100));
    expect(visibilityMs, lessThan(100));
    expect(searchMicros, lessThan(5000));
  });
}
