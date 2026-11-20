import 'dart:async';

import 'package:app/common/auth/mitteilungen_provider.dart';
import 'package:app/common/expressions/evaluating_visitor_service.dart';
import 'package:app/common/expressions/expression.dart';
import 'package:app/common/geo_service.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/common/volunteer_database/volunteer_database_enabled_notifier.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/antrag_layout.dart';
import 'package:app/routes/antraege/components/schritte/cascade_entry.dart';
import 'package:app/routes/antraege/components/schritte/cascade_step.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/formular_field_style.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/cascade_search_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/cascade_search_selection.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/text_field.dart';
import 'package:app/routes/antraege/components/schritte/formular_schritt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeGeoService implements GeoService {
  int calls = 0;

  @override
  Future<bool> isPointInGeoflaeche(String name, LatLng position) async {
    calls++;
    return (name == 'Salzhemmendorf' && position.latitude < 52) ||
        (name == 'Hameln' && position.latitude >= 52);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FixedProgressNotifier extends AntragProgressNotifier {
  @override
  AntragProgress? build() => AntragProgress(
    prozess: Fragment_ProzessOwnData(id: 'p1', name: 'Mängelmelder', tags: []),
    prozessVersion: Fragment_ProzessVersionOwnData(id: 'pv1'),
    kommune: Fragment_KommuneCrypto(),
    schritte: const [],
  );

  void replaceSlots(Map<String, dynamic> slots) {
    state = state!.copyWith(slots: slots);
  }
}

class _FixedMitteilungenCountNotifier extends MitteilungenCountNotifier {
  @override
  int build() => 0;
}

class _FixedVolunteerDatabaseNotifier extends VolunteerDatabaseEnabledNotifier {
  @override
  bool build() => false;
}

const _inSalzhemmendorf = FormLocation(position: LatLng(51.9, 9.6));
const _inHameln = FormLocation(position: LatLng(52.1, 9.36));

FormularTextFeldData _field(
  String slotName,
  List<TextFeldOption> options, {
  String istRelevant = 'true',
  bool durchsuchbar = false,
  bool pflichtfeld = false,
}) => FormularTextFeldData(
  multiline: false,
  stringOptions: options,
  durchsuchbar: durchsuchbar,
  validationType: Enum_StringValidationType.DEFAULT,
  slotName: slotName,
  pflichtfeld: pflichtfeld,
  istRelevant: BoolExpression(istRelevant),
);

void main() {
  late FormularSchritt formularSchritt;

  testWidgets('reveals the form title and content together when ready', (
    tester,
  ) async {
    final contentReady = ValueNotifier(false);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    addTearDown(contentReady.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          antragProgressProvider.overrideWith(_FixedProgressNotifier.new),
          mitteilungenCountNotifierProvider.overrideWith(
            _FixedMitteilungenCountNotifier.new,
          ),
          volunteerDatabaseEnabledProvider.overrideWith(
            _FixedVolunteerDatabaseNotifier.new,
          ),
        ],
        child: MaterialApp(
          home: AntragLayout(
            canPop: true,
            contentReadyListenable: contentReady,
            children: const [Text('Formularfeld')],
          ),
        ),
      ),
    );

    expect(
      find.byKey(const Key('antrag_content_loading_placeholder')),
      findsOneWidget,
    );
    expect(find.text('Mängelmelder'), findsNothing);
    expect(find.text('Formularfeld'), findsNothing);

    contentReady.value = true;
    await tester.pump();

    expect(
      find.byKey(const Key('antrag_content_loading_placeholder')),
      findsNothing,
    );
    expect(find.text('Mängelmelder'), findsOneWidget);
    expect(find.text('Formularfeld'), findsOneWidget);
  });

  FormularSchritt buildSchritt({
    bool childDurchsuchbar = false,
    bool withThirdLevel = false,
    bool rootDurchsuchbar = true,
    bool rootRequired = false,
    bool rootOptionAddressScoped = false,
    int additionalAddressScopedRootOptions = 0,
  }) => FormularSchritt(
    FormularSchrittData(
      id: 's1',
      erledigungDurchBuerger: true,
      slots: const [],
      verbindungen: const [],
      felder: [
        _field(
          'kategorie',
          [
            TextFeldOption(
              key: 'Bürgeranliegen',
              value: 'Bürgeranliegen',
              istRelevant: rootOptionAddressScoped
                  ? BoolExpression(
                      "isInside('Salzhemmendorf', slot('adresse')) == true",
                    )
                  : null,
            ),
            TextFeldOption(key: 'Andere Kategorie', value: 'Andere Kategorie'),
            for (
              var index = 0;
              index < additionalAddressScopedRootOptions;
              index++
            )
              TextFeldOption(
                key: 'Gemeinde-Kategorie $index',
                value: 'Gemeinde-Kategorie $index',
                istRelevant: BoolExpression(
                  "isInside('Salzhemmendorf', slot('adresse')) == true",
                ),
              ),
          ],
          durchsuchbar: rootDurchsuchbar,
          pflichtfeld: rootRequired,
        ),
        _field(
          'kategorie_2__buergeranliegen',
          [
            TextFeldOption(
              key: 'Eigene Salzhemmendorf',
              value: 'Eigene Salzhemmendorf',
              istRelevant: BoolExpression(
                "isInside('Salzhemmendorf', slot('adresse')) == true",
              ),
            ),
            TextFeldOption(key: 'Geteilt', value: 'Geteilt'),
          ],
          istRelevant: "slot('kategorie') == 'Bürgeranliegen'",
          durchsuchbar: childDurchsuchbar,
        ),
        _field(
          'kategorie_2__andere',
          [
            TextFeldOption(
              key: 'Veralteter Gemeinde-Slot',
              value: 'Veralteter Gemeinde-Slot',
              istRelevant: BoolExpression(
                "isInside('Salzhemmendorf', slot('adresse')) == true",
              ),
            ),
          ],
          istRelevant: "slot('kategorie') == 'Andere Kategorie'",
        ),
        if (withThirdLevel)
          _field(
            'kategorie_3__geteilt',
            [TextFeldOption(key: 'Details', value: 'Details')],
            istRelevant: "slot('kategorie_2__buergeranliegen') == 'Geteilt'",
          ),
      ],
    ),
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    formularSchritt = buildSchritt();
  });

  Future<FormBuilderState> pumpForm(
    WidgetTester tester, {
    _FakeGeoService? geoService,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          antragProgressProvider.overrideWith(_FixedProgressNotifier.new),
          evaluatingVisitorProvider.overrideWithValue(
            EvaluatingVisitorService(geoService ?? _FakeGeoService()),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Consumer(
                builder: (context, ref, _) =>
                    formularSchritt.build(context, ref),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.state<FormBuilderState>(find.byType(FormBuilder));
  }

  Future<void> search(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField).first, query);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
  }

  Future<void> setAddress(
    WidgetTester tester,
    FormBuilderState form,
    FormLocation address,
  ) async {
    form.setInternalFieldValue('adresse', address);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }

  testWidgets('shows a single search field per cascade', (tester) async {
    formularSchritt = buildSchritt(childDurchsuchbar: true);
    final form = await pumpForm(tester);
    await setAddress(tester, form, _inSalzhemmendorf);
    form.fields['kategorie']!.didChange('Bürgeranliegen');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButton<String>), findsNWidgets(2));
    expect(find.byType(CascadeSearchField), findsOneWidget);
  });

  testWidgets('highlights the category search in green', (tester) async {
    await pumpForm(tester);

    final searchField = tester.widget<TextField>(find.byType(TextField).first);
    final theme = Theme.of(tester.element(find.byType(TextField).first));
    expect(
      searchField.decoration?.fillColor,
      highlightedFieldBackground(theme),
    );
    expect(
      (searchField.decoration!.enabledBorder! as OutlineInputBorder).borderSide,
      BorderSide(color: theme.primaryColor),
    );
  });

  testWidgets(
    'evaluates identical option relevance only once per address update',
    (tester) async {
      final geoService = _FakeGeoService();
      formularSchritt = buildSchritt(
        rootOptionAddressScoped: true,
        additionalAddressScopedRootOptions: 25,
      );
      final form = await pumpForm(tester, geoService: geoService);
      geoService.calls = 0;

      await setAddress(tester, form, _inSalzhemmendorf);

      expect(geoService.calls, 1);
    },
  );

  testWidgets('clears a stale dropdown value when its dynamic options change', (
    tester,
  ) async {
    final formKey = GlobalKey<FormBuilderState>();
    late StateSetter updateOptions;
    var options = [TextFeldOption(key: 'A', value: 'A')];

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                updateOptions = setState;
                return FormBuilder(
                  key: formKey,
                  initialValue: const {'internal_value_dropdown': 'A'},
                  child: FormularTextField(
                    key: const Key('dynamic_dropdown'),
                    feld: _field('dynamic_dropdown', options),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    formKey.currentState!.fields['dynamic_dropdown']!.didChange('A');
    await tester.pumpAndSettle();

    updateOptions(() {
      options = [TextFeldOption(key: 'B', value: 'B')];
    });
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(formKey.currentState!.instantValue['dynamic_dropdown'], isNull);
  });

  testWidgets('does not rebuild a dropdown with a stale internal form value', (
    tester,
  ) async {
    final formKey = GlobalKey<FormBuilderState>();
    late StateSetter updateOptions;
    var options = [TextFeldOption(key: 'A', value: 'A')];

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                updateOptions = setState;
                return FormBuilder(
                  key: formKey,
                  child: FormularTextField(
                    key: const Key('internal_value_dropdown'),
                    feld: _field('internal_value_dropdown', options),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    updateOptions(() {
      options = [TextFeldOption(key: 'B', value: 'B')];
    });
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      formKey.currentState!.instantValue['internal_value_dropdown'],
      isNull,
    );
  });

  testWidgets('marks category fields as dropdowns in the search cascade', (
    tester,
  ) async {
    final form = await pumpForm(tester);

    final rootDropdown = tester.widget<FormBuilderDropdown<String>>(
      find.byType(FormBuilderDropdown<String>),
    );
    final theme = Theme.of(
      tester.element(find.byType(FormBuilderDropdown<String>)),
    );
    expect(
      rootDropdown.decoration.fillColor,
      highlightedFieldBackground(theme),
    );
    expect(
      (rootDropdown.decoration.enabledBorder! as OutlineInputBorder).borderSide,
      BorderSide(color: theme.primaryColor),
    );
    expect(
      (rootDropdown.icon! as Icon).icon,
      Icons.keyboard_arrow_down_rounded,
    );
    expect(rootDropdown.decoration.helperText, isNull);
    final nextLevelHint = tester.widget<Text>(
      find.text('application.antraege.formular_schritt.select_to_continue'),
    );
    expect(nextLevelHint.maxLines, 2);
    expect(nextLevelHint.style?.fontSize, 15);

    form.fields['kategorie']!.didChange('Bürgeranliegen');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    final dropdowns = tester
        .widgetList<FormBuilderDropdown<String>>(
          find.byType(FormBuilderDropdown<String>),
        )
        .toList();
    expect(dropdowns, hasLength(2));
    expect(dropdowns.first.icon, isA<Row>());
    expect(
      (dropdowns.last.icon! as Icon).icon,
      Icons.keyboard_arrow_down_rounded,
    );
  });

  testWidgets('does not show category feedback after changing a category', (
    tester,
  ) async {
    final form = await pumpForm(tester);
    await setAddress(tester, form, _inSalzhemmendorf);
    form.fields['kategorie']!.didChange('Bürgeranliegen');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    form.fields['kategorie_2__buergeranliegen']!.didChange('Geteilt');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    form.fields['kategorie']!.didChange('Andere Kategorie');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(form.instantValue['kategorie_2__buergeranliegen'], isNull);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('allows clearing a highlighted category dropdown', (
    tester,
  ) async {
    final form = await pumpForm(tester);
    form.fields['kategorie']!.didChange('Bürgeranliegen');
    await tester.pump();

    await tester.tap(find.byKey(const Key('kategorie_clear')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(form.instantValue['kategorie'], isNull);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('clears all descendant dropdowns without an intermediate frame', (
    tester,
  ) async {
    formularSchritt = buildSchritt(withThirdLevel: true);
    final form = await pumpForm(tester);
    form.fields['kategorie']!.didChange('Bürgeranliegen');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    form.fields['kategorie_2__buergeranliegen']!.didChange('Geteilt');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    form.fields['kategorie_3__geteilt']!.didChange('Details');
    await tester.pump();

    await tester.tap(find.byKey(const Key('kategorie_clear')));
    await tester.pump();

    expect(form.instantValue['kategorie'], isNull);
    expect(form.instantValue['kategorie_2__buergeranliegen'], isNull);
    expect(form.instantValue['kategorie_3__geteilt'], isNull);
    expect(find.byType(FormBuilderDropdown<String>), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('does not show category feedback for a valid address', (
    tester,
  ) async {
    final form = await pumpForm(tester);

    form.setInternalFieldValue('adresse', _inSalzhemmendorf);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets(
    'does not apply category feedback to a non-searchable dropdown cascade',
    (tester) async {
      formularSchritt = buildSchritt(rootDurchsuchbar: false);
      final form = await pumpForm(tester);
      await setAddress(tester, form, _inSalzhemmendorf);
      form.fields['kategorie']!.didChange('Bürgeranliegen');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      form.fields['kategorie_2__buergeranliegen']!.didChange(
        'Eigene Salzhemmendorf',
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      await setAddress(tester, form, _inHameln);

      expect(form.instantValue['kategorie_2__buergeranliegen'], isNull);
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    'ignores cleanup of an inactive category branch after address change',
    (tester) async {
      final form = await pumpForm(tester);
      await setAddress(tester, form, _inSalzhemmendorf);
      form.fields['kategorie']!.didChange('Bürgeranliegen');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      form.fields['kategorie_2__buergeranliegen']!.didChange('Geteilt');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      form
        ..setInternalFieldValue(
          'kategorie_2__andere',
          'Veralteter Gemeinde-Slot',
        )
        ..setInternalFieldValue('adresse', _inHameln);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(form.instantValue['kategorie'], 'Bürgeranliegen');
      expect(form.instantValue['kategorie_2__buergeranliegen'], 'Geteilt');
      expect(form.instantValue['kategorie_2__andere'], isNull);
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets('explains an automatically adjusted category selection', (
    tester,
  ) async {
    formularSchritt = buildSchritt(
      rootOptionAddressScoped: true,
      rootRequired: true,
    );
    final form = await pumpForm(tester);
    await setAddress(tester, form, _inSalzhemmendorf);
    await search(tester, 'eigene');
    await tester.tap(find.text('Eigene Salzhemmendorf'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    form.setInternalFieldValue('adresse', _inHameln);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.text('application.antraege.formular_schritt.category_adjusted'),
      findsOneWidget,
    );
    expect(find.byType(FormBuilderDropdown<String>), findsOneWidget);

    form.validate();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(FormBuilderDropdown<String>), findsOneWidget);
    expect(find.text('Diese Angabe ist zwingend notwendig'), findsOneWidget);
  });

  testWidgets(
    'compacts a searched path and restores category fields for editing',
    (tester) async {
      final form = await pumpForm(tester);
      await setAddress(tester, form, _inSalzhemmendorf);

      await search(tester, 'eigene');
      await tester.tap(find.text('Eigene Salzhemmendorf'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(
        find.text('Bürgeranliegen › Eigene Salzhemmendorf'),
        findsOneWidget,
      );
      expect(find.byType(CascadeSearchSelection), findsOneWidget);
      expect(find.byType(CascadeSearchField), findsNothing);
      expect(find.byType(DropdownButton<String>), findsNothing);

      await tester.tap(find.byKey(const Key('cascade_search_selection_edit')));
      await tester.pumpAndSettle();

      expect(find.byType(CascadeSearchSelection), findsNothing);
      expect(find.byType(CascadeSearchField), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsNWidgets(2));
      expect(form.instantValue['kategorie'], 'Bürgeranliegen');
      expect(
        form.instantValue['kategorie_2__buergeranliegen'],
        'Eigene Salzhemmendorf',
      );
    },
  );

  testWidgets('restores a compact search selection after rebuilding the step', (
    tester,
  ) async {
    formularSchritt = buildSchritt(rootOptionAddressScoped: true);
    final prefs = await SharedPreferences.getInstance();
    late StateSetter rebuildStep;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          antragProgressProvider.overrideWith(_FixedProgressNotifier.new),
          evaluatingVisitorProvider.overrideWithValue(
            EvaluatingVisitorService(_FakeGeoService()),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuildStep = setState;
                return SingleChildScrollView(
                  child: Consumer(
                    builder: (context, ref, _) =>
                        formularSchritt.build(context, ref),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    var form = tester.state<FormBuilderState>(find.byType(FormBuilder));
    await setAddress(tester, form, _inSalzhemmendorf);
    await search(tester, 'eigene');
    await tester.tap(find.text('Eigene Salzhemmendorf'));
    await tester.pumpAndSettle();
    expect(find.byType(CascadeSearchSelection), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(Consumer)),
    );
    final progressNotifier =
        container.read(antragProgressProvider.notifier)
            as _FixedProgressNotifier;
    final completedSlots = formularSchritt.getSlots().$1;
    expect(
      completedSlots['kategorie_2__buergeranliegen'],
      'Eigene Salzhemmendorf',
    );
    progressNotifier.replaceSlots(completedSlots);
    formularSchritt = buildSchritt(rootOptionAddressScoped: true);
    rebuildStep(() {});
    await tester.pumpAndSettle();

    expect(find.byType(CascadeSearchSelection), findsOneWidget);
    expect(find.text('Bürgeranliegen › Eigene Salzhemmendorf'), findsOneWidget);
    final restoredSlots = formularSchritt.getSlots().$1;
    expect(
      restoredSlots['kategorie_2__buergeranliegen'],
      'Eigene Salzhemmendorf',
    );

    form = tester.state<FormBuilderState>(find.byType(FormBuilder));
    await setAddress(tester, form, _inHameln);

    expect(tester.takeException(), isNull);
    expect(find.byType(CascadeSearchSelection), findsNothing);
    expect(form.instantValue['kategorie_2__buergeranliegen'], isNull);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('clears a compact searched category selection', (tester) async {
    final form = await pumpForm(tester);
    await setAddress(tester, form, _inSalzhemmendorf);
    await search(tester, 'eigene');
    await tester.tap(find.text('Eigene Salzhemmendorf'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cascade_search_selection_clear')));
    await tester.pumpAndSettle();

    expect(form.instantValue['kategorie'], isNull);
    expect(form.instantValue['kategorie_2__buergeranliegen'], isNull);
    expect(find.byType(CascadeSearchSelection), findsNothing);
    expect(find.byType(CascadeSearchField), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('does not offer a Gemeinde-owned category without an address', (
    tester,
  ) async {
    await pumpForm(tester);

    await search(tester, 'eigene');

    expect(find.text('Eigene Salzhemmendorf'), findsNothing);
  });

  testWidgets('refreshes open results when the address changes', (
    tester,
  ) async {
    final form = await pumpForm(tester);
    await setAddress(tester, form, _inSalzhemmendorf);

    await search(tester, 'eigene');
    expect(find.text('Eigene Salzhemmendorf'), findsOneWidget);

    await setAddress(tester, form, _inHameln);

    expect(find.text('Eigene Salzhemmendorf'), findsNothing);
  });

  testWidgets('ignores an older search response after a rebuild', (
    tester,
  ) async {
    final firstResult = Completer<List<CascadeEntry>>();
    final secondResult = Completer<List<CascadeEntry>>();
    var useSecondResult = false;
    late StateSetter rebuild;
    final oldEntry = CascadeEntry([
      CascadeStep(
        _field('root', [TextFeldOption(key: 'Alt', value: 'Alt')]),
        TextFeldOption(key: 'Alt', value: 'Alt'),
      ),
    ]);
    final newEntry = CascadeEntry([
      CascadeStep(
        _field('root', [TextFeldOption(key: 'Neu', value: 'Neu')]),
        TextFeldOption(key: 'Neu', value: 'Neu'),
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return CascadeSearchField(
                loadEntries: () =>
                    useSecondResult ? secondResult.future : firstResult.future,
                onSelected: (_) {},
              );
            },
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'e');
    await tester.pump(const Duration(milliseconds: 200));

    rebuild(() => useSecondResult = true);
    await tester.pump();
    secondResult.complete([newEntry]);
    await tester.pumpAndSettle();
    expect(find.text('Neu'), findsOneWidget);

    firstResult.complete([oldEntry]);
    await tester.pumpAndSettle();
    expect(find.text('Neu'), findsOneWidget);
    expect(find.text('Alt'), findsNothing);
  });

  testWidgets(
    'clears a searched selection once the address leaves its Gemeinde',
    (tester) async {
      final form = await pumpForm(tester);
      await setAddress(tester, form, _inSalzhemmendorf);

      await search(tester, 'eigene');
      await tester.tap(find.text('Eigene Salzhemmendorf'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(
        form.instantValue['kategorie_2__buergeranliegen'],
        'Eigene Salzhemmendorf',
      );

      await setAddress(
        tester,
        form,
        const FormLocation(position: LatLng(51.95, 9.5)),
      );
      expect(
        form.instantValue['kategorie_2__buergeranliegen'],
        'Eigene Salzhemmendorf',
      );

      await setAddress(
        tester,
        form,
        const FormLocation(position: LatLng(52.3, 9.1)),
      );
      expect(form.instantValue['kategorie_2__buergeranliegen'], isNull);
    },
  );

  testWidgets(
    'cancels the pending relevance debounce once disposed, even after the step is unmounted',
    (tester) async {
      final form = await pumpForm(tester);
      form.setInternalFieldValue('adresse', _inSalzhemmendorf);
      await tester.pump(const Duration(milliseconds: 100));

      formularSchritt.dispose();
      await tester.pumpWidget(const SizedBox.shrink());

      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    },
  );
}
