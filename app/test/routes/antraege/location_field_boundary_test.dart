import 'dart:async';

import 'package:app/common/expressions/expression.dart';
import 'package:app/common/geofencing/geo_json_boundary.dart';
import 'package:app/common/geofencing/hameln_pyrmont_boundary_provider.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import '../../helper/localization_helper.dart';

/// A named GPX boundary point and its expected form validity.
typedef BoundaryTestPoint = ({
  String name,
  LatLng position,
  bool expectedValid,
});

/// Boundary points imported from hameln_pyrmont_boundary_tests.gpx.
const boundaryTestPoints = <BoundaryTestPoint>[
  (
    name: 'boundary_1_inside_10m',
    position: LatLng(52.17485426, 9.49596784),
    expectedValid: true,
  ),
  (
    name: 'boundary_1_border',
    position: LatLng(52.17485456, 9.49611408),
    expectedValid: true,
  ),
  (
    name: 'boundary_1_outside_10m',
    position: LatLng(52.17485487, 9.49626031),
    expectedValid: false,
  ),
  (
    name: 'boundary_2_inside_10m',
    position: LatLng(51.99102543, 9.64123130),
    expectedValid: true,
  ),
  (
    name: 'boundary_2_border',
    position: LatLng(51.99103691, 9.64137574),
    expectedValid: true,
  ),
  (
    name: 'boundary_2_outside_10m',
    position: LatLng(51.99104839, 9.64152018),
    expectedValid: false,
  ),
  (
    name: 'boundary_3_inside_10m',
    position: LatLng(51.95570462, 9.35424675),
    expectedValid: true,
  ),
  (
    name: 'boundary_3_border',
    position: LatLng(51.95579365, 9.35426700),
    expectedValid: true,
  ),
  (
    name: 'boundary_3_outside_10m',
    position: LatLng(51.95588269, 9.35428726),
    expectedValid: false,
  ),
  (
    name: 'boundary_4_inside_10m',
    position: LatLng(52.03498251, 9.17639108),
    expectedValid: true,
  ),
  (
    name: 'boundary_4_border',
    position: LatLng(52.03495513, 9.17625222),
    expectedValid: true,
  ),
  (
    name: 'boundary_4_outside_10m',
    position: LatLng(52.03492775, 9.17611337),
    expectedValid: false,
  ),
  (
    name: 'boundary_5_inside_10m',
    position: LatLng(52.20965512, 9.25388796),
    expectedValid: true,
  ),
  (
    name: 'boundary_5_border',
    position: LatLng(52.20971263, 9.25377547),
    expectedValid: true,
  ),
  (
    name: 'boundary_5_outside_10m',
    position: LatLng(52.20977014, 9.25366297),
    expectedValid: false,
  ),
];

/// Parsed boundary loaded directly from the bundled application asset.
late GeoJsonBoundary hamelnPyrmontBoundary;

/// Renders a location field that loads the bundled app boundary.
Future<GlobalKey<FormBuilderState>> pumpLocationField(
  WidgetTester tester, {
  required LatLng position,
}) async {
  final formKey = GlobalKey<FormBuilderState>();
  final field = Fragment_FormularFeld__LocationFormularFeld(
    angezeigterName: 'Adresse',
    slotName: 'adresse',
    pflichtfeld: true,
    istRelevant: boolExpressionFromJson('true'),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hamelnPyrmontBoundaryProvider.overrideWith(
          (ref) async => hamelnPyrmontBoundary,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: FormBuilder(
            key: formKey,
            initialValue: {field.slotName: FormLocation(position: position)},
            child: FormularLocationField(feld: field),
          ),
        ),
      ),
    ),
  );
  for (var attempt = 0; attempt < 20; attempt += 1) {
    await tester.pump(const Duration(milliseconds: 50));
    final textField = tester.widget<TextField>(find.byType(TextField));
    if (textField.enabled ?? true) break;
  }
  expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
  return formKey;
}

void main() {
  setUpAll(() async {
    await TestLocalizationHelper.init();
    final source = await rootBundle.loadString(hamelnPyrmontBoundaryAsset);
    hamelnPyrmontBoundary = GeoJsonBoundary.fromJson(source);
  });

  for (final point in boundaryTestPoints) {
    testWidgets(point.name, (tester) async {
      final formKey = await pumpLocationField(tester, position: point.position);

      expect(
        formKey.currentState!.validate(),
        point.expectedValid,
        reason: point.name,
      );
      await tester.pump();
      expect(
        find.text(
          'Die ausgewählte Adresse liegt außerhalb des Landkreises '
          'Hameln-Pyrmont.',
        ),
        point.expectedValid ? findsNothing : findsOneWidget,
      );
    });
  }

  testWidgets('shows progress before reverse geocoding completes', (
    tester,
  ) async {
    final formKey = GlobalKey<FormBuilderState>();
    final address = Completer<String?>();
    const position = LatLng(52.103, 9.356);
    final field = Fragment_FormularFeld__LocationFormularFeld(
      angezeigterName: 'Adresse',
      slotName: 'adresse',
      pflichtfeld: true,
      istRelevant: boolExpressionFromJson('true'),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hamelnPyrmontBoundaryProvider.overrideWith(
            (ref) async => hamelnPyrmontBoundary,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: FormularLocationField(
                feld: field,
                positionSelector: (_, _) async => position,
                addressResolver: (_) => address.future,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField));
    await tester.pump();

    final pendingValue =
        formKey.currentState!.instantValue['adresse'] as FormLocation;
    expect(pendingValue.position, position);
    expect(pendingValue.addressString, isNull);
    expect(find.text('Adresse wird ermittelt …'), findsOneWidget);

    address.complete('Teststraße 1, Hameln');
    await tester.pumpAndSettle();

    final resolvedValue =
        formKey.currentState!.instantValue['adresse'] as FormLocation;
    expect(resolvedValue.addressString, 'Teststraße 1, Hameln');
    expect(find.text('Teststraße 1, Hameln'), findsOneWidget);
  });
}
