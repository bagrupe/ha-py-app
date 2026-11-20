import 'package:app/common/app_config/app_config.dart';
import 'package:app/routes/maengel/common/mangel.dart';
import 'package:app/routes/maengel/components/maengel_animated_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedAppConfigNotifier extends AppConfigNotifier {
  @override
  AppConfig build() =>
      const AppConfig(backendUrl: 'http://localhost', kommuneId: 'kommune-1');
}

Mangel _mangel(String id) => Mangel(
  id: id,
  coordinates: null,
  title: 'Titel $id',
  kategorie: 'Kategorie $id',
  beschreibung: '',
);

Future<void> _pump(WidgetTester tester, List<Mangel> items) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [appConfigProvider.overrideWith(_FixedAppConfigNotifier.new)],
      child: MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              MaengelAnimatedSection(title: 'Abschnitt', maengel: items),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 5));
}

void main() {
  testWidgets('keeps a removed item visible while it animates out', (
    tester,
  ) async {
    await _pump(tester, [_mangel('a'), _mangel('b')]);
    expect(find.text('Kategorie a'), findsOneWidget);

    await _pump(tester, [_mangel('b')]);
    await tester.pump(maengelSectionAnimationDuration ~/ 2);

    expect(find.text('Kategorie a'), findsOneWidget);
    expect(find.text('Kategorie b'), findsOneWidget);

    await tester.pump(maengelSectionAnimationDuration);
    await tester.pump();

    expect(find.text('Kategorie a'), findsNothing);
    expect(find.text('Kategorie b'), findsOneWidget);
    expect(find.text('Abschnitt'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('fades a new item in', (tester) async {
    await _pump(tester, [_mangel('a')]);
    await _pump(tester, [_mangel('a'), _mangel('b')]);
    await tester.pump(maengelSectionAnimationDuration ~/ 2);

    final fade = tester.widget<FadeTransition>(
      find
          .ancestor(
            of: find.text('Kategorie b'),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(fade.opacity.value, inExclusiveRange(0, 1));

    await tester.pump(maengelSectionAnimationDuration);
    expect(find.text('Kategorie b'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('hides the heading once the last item has animated out', (
    tester,
  ) async {
    await _pump(tester, [_mangel('a')]);
    await _pump(tester, []);
    await tester.pump(maengelSectionAnimationDuration ~/ 2);
    expect(find.text('Abschnitt'), findsOneWidget);

    await tester.pump(maengelSectionAnimationDuration);
    await tester.pump();
    expect(find.text('Abschnitt'), findsNothing);
    await _unmount(tester);
  });
}
