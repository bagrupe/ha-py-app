import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_notifier.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_step.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/file_asset_loader.dart';

/// Verifies that SMS recovery actions remain reachable on compact screens.
void main() {
  testWidgets('scrolls to resend and phone review after an invalid code', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    tester.view.physicalSize = const Size(410, 650);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final client = GraphQLClient(
      link: Link.function((request, [forward]) {
        return Stream.value(
          const Response(
            response: {},
            data: {
              '__typename': 'Mutation',
              'requestSmsCode': {
                '__typename': 'RequestSmsCodePayload',
                'requestSmsResult': 'SUCCESS',
              },
            },
          ),
        );
      }),
      cache: GraphQLCache(store: InMemoryStore()),
    );
    final container = ProviderContainer(
      overrides: [graphqlClientProvider.overrideWithValue(client)],
    )..listen(volunteerLoginProvider, (_, _) {});
    final notifier = container.read(volunteerLoginProvider.notifier)
      ..updatePhoneNumber('15123456789');
    await notifier.continueLogin();
    notifier.updateSmsCode('123');
    await notifier.continueLogin();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
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
              home: const Scaffold(body: VolunteerLoginContent()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      container.read(volunteerLoginProvider).smsCodeErrorMessageKey,
      isNotNull,
    );
    await tester.pump(const Duration(seconds: 59));
    await tester.pumpAndSettle();
    final resend = find.text(
      'application.volunteer_database.login_page.sms.resend_available'.tr(),
    );
    await tester.ensureVisible(resend);
    await tester.pumpAndSettle();
    expect(resend.hitTestable(), findsOneWidget);
    await tester.tap(resend);
    await tester.pumpAndSettle();
    expect(
      container.read(volunteerLoginProvider).resendSecondsRemaining,
      greaterThan(0),
    );
    final review = find.text(
      'application.volunteer_database.login_page.sms.check_phone'.tr(),
    );
    await tester.ensureVisible(review);
    await tester.pumpAndSettle();
    await tester.tap(review);
    await tester.pumpAndSettle();
    expect(
      container.read(volunteerLoginProvider).currentStep,
      VolunteerLoginStep.phone,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}
