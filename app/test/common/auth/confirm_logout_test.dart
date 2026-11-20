import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/confirm_logout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/file_asset_loader.dart';

class _FakeAuthNotifier extends AuthStateNotifier {
  _FakeAuthNotifier(this.isBackedUp, {this.fails = false});

  final bool isBackedUp;
  final bool fails;
  int checks = 0;

  @override
  Future<AuthState> build() async => AuthState.registering();

  @override
  Future<bool> ensureKeyBackup() async {
    checks++;
    if (fails) throw StateError('offline');
    return isBackedUp;
  }
}

Future<({bool? result, _FakeAuthNotifier notifier})> _tapLogout(
  WidgetTester tester, {
  required bool isBackedUp,
  String? dialogButton,
  bool fails = false,
  bool everywhere = false,
}) async {
  final notifier = _FakeAuthNotifier(isBackedUp, fails: fails);
  bool? result;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [asyncAuthProvider.overrideWith(() => notifier)],
      child: MaterialApp(
        home: Consumer(
          builder: (context, ref, _) => TextButton(
            onPressed: () async => result = everywhere
                ? await confirmLogoutEverywhere(context, ref)
                : await confirmLogout(context, ref),
            child: const Text('logout'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('logout'));
  await tester.pumpAndSettle();
  if (dialogButton != null) {
    await tester.tap(find.text(dialogButton));
    await tester.pumpAndSettle();
  }
  return (result: result, notifier: notifier);
}

void main() {
  const title = 'application.profil.logout_backup.title';
  const cancel = 'application.profil.logout_backup.cancel';
  const confirm = 'application.profil.logout_backup.confirm';

  testWidgets('logs out without a dialog when the key is backed up', (
    tester,
  ) async {
    final outcome = await _tapLogout(tester, isBackedUp: true);

    expect(outcome.result, isTrue);
    expect(outcome.notifier.checks, 1);
    expect(find.text(title), findsNothing);
  });

  testWidgets('asks first and keeps the session when cancelled', (
    tester,
  ) async {
    final outcome = await _tapLogout(
      tester,
      isBackedUp: false,
      dialogButton: cancel,
    );

    expect(outcome.result, isFalse);
  });

  testWidgets('logs out when the user confirms without a backup', (
    tester,
  ) async {
    final outcome = await _tapLogout(
      tester,
      isBackedUp: false,
      dialogButton: confirm,
    );

    expect(outcome.result, isTrue);
  });

  testWidgets('a failing check closes the spinner and asks the user', (
    tester,
  ) async {
    await _tapLogout(tester, isBackedUp: true, fails: true);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text(title), findsOneWidget);
  });

  testWidgets('shows the warning dialog with both buttons when not backed up', (
    tester,
  ) async {
    await _tapLogout(tester, isBackedUp: false);

    expect(find.text(title), findsOneWidget);
    expect(find.text(cancel), findsOneWidget);
    expect(find.text(confirm), findsOneWidget);
  });

  group('logout on all devices', () {
    const everywhereTitle = 'application.profil.logout_everywhere.title';
    const everywhereCancel = 'application.profil.logout_everywhere.cancel';
    const everywhereConfirm = 'application.profil.logout_everywhere.confirm';

    testWidgets('asks first and checks nothing when cancelled', (tester) async {
      final outcome = await _tapLogout(
        tester,
        isBackedUp: true,
        everywhere: true,
        dialogButton: everywhereCancel,
      );

      expect(outcome.result, isFalse);
      expect(outcome.notifier.checks, 0);
    });

    testWidgets('checks the backup after the confirmation', (tester) async {
      final outcome = await _tapLogout(
        tester,
        isBackedUp: true,
        everywhere: true,
        dialogButton: everywhereConfirm,
      );

      expect(outcome.result, isTrue);
      expect(outcome.notifier.checks, 1);
      expect(find.text(everywhereTitle), findsNothing);
    });

    testWidgets('still warns about a missing backup', (tester) async {
      final outcome = await _tapLogout(
        tester,
        isBackedUp: false,
        everywhere: true,
        dialogButton: everywhereConfirm,
      );

      expect(outcome.result, isNull);
      expect(find.text(title), findsOneWidget);
    });
  });

  testWidgets('explains that the first device keeps its login', (tester) async {
    const keptTitle = 'application.profil.device_login_kept.title';
    const keptConfirm = 'application.profil.device_login_kept.confirm';
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showDeviceLoginKept(context),
            child: const Text('logout'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('logout'));
    await tester.pumpAndSettle();
    expect(find.text(keptTitle), findsOneWidget);
    expect(
      find.text('application.profil.device_login_kept.description'),
      findsOneWidget,
    );

    await tester.tap(find.text(keptConfirm));
    await tester.pumpAndSettle();
    expect(find.text(keptTitle), findsNothing);
  });

  for (final (name, open)
      in <(String, Future<void> Function(BuildContext, WidgetRef))>[
        (
          'the first device text',
          (context, ref) => showDeviceLoginKept(context),
        ),
        ('the logout everywhere question', confirmLogoutEverywhere),
      ]) {
    testWidgets('keeps $name readable with large font sizes', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await EasyLocalization.ensureInitialized();
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            asyncAuthProvider.overrideWith(() => _FakeAuthNotifier(true)),
          ],
          child: EasyLocalization(
            supportedLocales: const [Locale('de')],
            path: 'assets/translations',
            assetLoader: const FileAssetLoader(),
            startLocale: const Locale('de'),
            child: Builder(
              builder: (context) => MaterialApp(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(2)),
                  child: child!,
                ),
                home: Consumer(
                  builder: (context, ref, _) => TextButton(
                    onPressed: () => open(context, ref),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final dialog = find.byType(AlertDialog);
      final text = tester
          .renderObjectList<RenderParagraph>(
            find.descendant(of: dialog, matching: find.byType(RichText)),
          )
          .reduce(
            (a, b) => a.text.toPlainText().length > b.text.toPlainText().length
                ? a
                : b,
          );
      expect(
        text.size.height,
        greaterThanOrEqualTo(text.getMaxIntrinsicHeight(text.size.width)),
      );
      final scrollable = find
          .descendant(of: dialog, matching: find.byType(Scrollable))
          .first;
      await tester.drag(scrollable, const Offset(0, -5000));
      await tester.pumpAndSettle();
      expect(
        text.localToGlobal(Offset(0, text.size.height)).dy,
        lessThanOrEqualTo(tester.getRect(scrollable).bottom + 0.5),
      );
    });
  }
}
