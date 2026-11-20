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
import 'package:flutter_form_builder/flutter_form_builder.dart';
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

FormularTextFeldData _kategorieFeld() => FormularTextFeldData(
  multiline: false,
  stringOptions: [TextFeldOption(key: 'A', value: 'A')],
  validationType: Enum_StringValidationType.DEFAULT,
  slotName: 'kategorie',
  pflichtfeld: false,
  istRelevant: BoolExpression('true'),
  durchsuchbar: true,
);

FormularTextFeldData _kategorieKindFeld() => FormularTextFeldData(
  multiline: false,
  stringOptions: [
    TextFeldOption(
      key: 'X',
      value: 'X',
      istRelevant: BoolExpression("slot('ort') == 'Hameln'"),
    ),
  ],
  validationType: Enum_StringValidationType.DEFAULT,
  slotName: 'kategorie_2__a',
  pflichtfeld: false,
  istRelevant: BoolExpression("slot('kategorie') == 'A'"),
  durchsuchbar: false,
);

void main() {
  testWidgets(
    'shows a blocking dialog once an actively selected category option is '
    'discarded by an unrelated field change',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final formularSchritt = FormularSchritt(
        FormularSchrittData(
          id: 's1',
          erledigungDurchBuerger: true,
          slots: const [],
          verbindungen: const [],
          felder: [_kategorieFeld(), _kategorieKindFeld()],
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

      final formBuilderState =
          tester.state(find.byType(FormBuilder)) as FormBuilderState
            ..setInternalFieldValue('kategorie', 'A')
            ..setInternalFieldValue('kategorie_2__a', 'X')
            ..setInternalFieldValue('ort', 'Hameln');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(formBuilderState.instantValue['kategorie_2__a'], 'X');

      formBuilderState.setInternalFieldValue('ort', 'Hannover');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(formBuilderState.instantValue['kategorie_2__a'], isNull);
      expect(
        find.text(
          'application.antraege.formular_schritt.category_adjusted_title',
        ),
        findsOneWidget,
      );

      await tester.tap(
        find.text(
          'application.antraege.formular_schritt.category_adjusted_confirm',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
