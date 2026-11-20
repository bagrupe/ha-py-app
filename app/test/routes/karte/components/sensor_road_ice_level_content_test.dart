import 'package:app/graphql/__generated__/sensoren.graphql.dart';
import 'package:app/routes/karte/components/sensor_road_ice_level_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper/localization_helper.dart';

Future<void> pumpRoadIceLevelContent(
  WidgetTester tester, {
  required Fragment_SensorDangerLevels sensor,
  required Fragment_SensorFieldReading field,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SensorRoadIceLevelContent(sensor: sensor, field: field),
      ),
    ),
  );
}

void main() {
  setUpAll(TestLocalizationHelper.init);

  testWidgets('shows the unknown-status fallback when the alarm level '
      'itself cannot be parsed', (tester) async {
    await pumpRoadIceLevelContent(
      tester,
      sensor: Fragment_SensorDangerLevels(glaetteAlarmLevel: 'UNKNOWN'),
      field: Fragment_SensorFieldReading(trendHistorie: []),
    );

    expect(find.text('Status unbekannt'), findsOneWidget);
  });

  testWidgets(
    'does not show the unknown-status fallback for a valid alarm level '
    'that just has no CMS-configured warning text',
    (tester) async {
      await pumpRoadIceLevelContent(
        tester,
        sensor: Fragment_SensorDangerLevels(glaetteAlarmLevel: 'CRITICAL'),
        field: Fragment_SensorFieldReading(
          trendHistorie: [],
          werteart: Fragment_SensorFieldReading_werteart(
            id: 'sensor-art-1',
            name: 'Glätte',
          ),
        ),
      );

      expect(find.text('Status unbekannt'), findsNothing);
    },
  );

  testWidgets('shows the configured pill and hint for a valid alarm level', (
    tester,
  ) async {
    await pumpRoadIceLevelContent(
      tester,
      sensor: Fragment_SensorDangerLevels(glaetteAlarmLevel: 'WARNING'),
      field: Fragment_SensorFieldReading(
        trendHistorie: [],
        werteart: Fragment_SensorFieldReading_werteart(
          id: 'sensor-art-1',
          name: 'Glätte',
          warnstufeText3: Fragment_SensorFieldReading_werteart_warnstufeText3(
            kurzlabel: 'Warnung',
            titel: 'Glättegefahr',
            beschreibung: 'Es besteht Glättegefahr.',
          ),
        ),
      ),
    );

    expect(find.text('Warnung'), findsOneWidget);
    expect(find.text('Glättegefahr'), findsOneWidget);
    expect(find.text('Es besteht Glättegefahr.'), findsOneWidget);
    expect(find.text('Status unbekannt'), findsNothing);
  });
}
