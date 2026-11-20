import 'package:app/common/expressions/evaluating_visitor_service.dart';
import 'package:app/common/expressions/expression.dart';
import 'package:app/common/geo_service.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/text_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_schritt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NoopGeoService implements GeoService {
  @override
  Future<bool> isPointInGeoflaeche(String name, LatLng position) async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FixedProgressNotifier extends AntragProgressNotifier {
  @override
  AntragProgress? build() => AntragProgress(
    prozess: Fragment_ProzessOwnData(id: 'p1', name: 'Testprozess', tags: []),
    prozessVersion: Fragment_ProzessVersionOwnData(id: 'pv1'),
    kommune: Fragment_KommuneCrypto(),
    schritte: const [],
  );
}

FormularTextFeldData _textField(String slotName) => FormularTextFeldData(
  multiline: false,
  stringOptions: const [],
  validationType: Enum_StringValidationType.DEFAULT,
  slotName: slotName,
  pflichtfeld: true,
  istRelevant: BoolExpression('true'),
  durchsuchbar: false,
);

void main() {
  testWidgets(
    'clears a required-field error once it is corrected, without affecting an untouched field',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final formularSchritt = FormularSchritt(
        FormularSchrittData(
          id: 's1',
          erledigungDurchBuerger: true,
          slots: const [],
          verbindungen: const [],
          felder: [_textField('vorname'), _textField('nachname')],
        ),
      );
      addTearDown(formularSchritt.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            antragProgressProvider.overrideWith(_FixedProgressNotifier.new),
            evaluatingVisitorProvider.overrideWithValue(
              EvaluatingVisitorService(_NoopGeoService()),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) =>
                    formularSchritt.build(context, ref),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(formularSchritt.isComplete(), isFalse);
      await tester.pumpAndSettle();
      const requiredError = 'Diese Angabe ist zwingend notwendig';
      expect(find.text(requiredError), findsNWidgets(2));

      await tester.enterText(find.byType(TextField).first, 'Max');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text(requiredError), findsOneWidget);
    },
  );
}
