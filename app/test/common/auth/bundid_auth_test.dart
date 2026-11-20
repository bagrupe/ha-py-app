import 'dart:convert';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/bundid_auth.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/localization_helper.dart';

class _RecordingAuthNotifier extends AuthStateNotifier {
  @override
  Future<AuthState> build() async => AuthState.registering();
}

const _wrongLogin = {
  'data': {
    '__typename': 'Mutation',
    'loginBuergerWeak': {
      '__typename': 'LoginBuergerWeakPayload',
      'loginPayload': {
        '__typename': 'LoginPayload',
        'result': 'WRONG_LOGIN',
        'token': null,
      },
    },
  },
};

void main() {
  setUpAll(TestLocalizationHelper.init);

  test('a new link without phone login asks for it', () {
    expect(
      bundIdErrorMessage(
        const BundIdLoginResult(
          BundIdLoginOutcome.error,
          'BUNDID_ACCOUNT_ALREADY_VERIFIED',
        ),
      ),
      'Auf diesem Gerät ist bereits ein Konto angelegt. '
      'Bitte melde dich mit deiner Telefonnummer an.',
    );
  });

  test('a broken token preview never logs the personal data', () {
    const secret = 'Erika Mustermann';
    final payload = base64Url
        .encode(utf8.encode('{"given_name":"$secret"'))
        .replaceAll('=', '');
    final printed = <String>[];
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) => printed.add(message ?? '');
    addTearDown(() => debugPrint = original);

    final suggestion = previewBundIdProfile('header.$payload.signature');

    expect(suggestion.vorname, isNull);
    expect(printed.join('\n'), isNot(contains(secret)));
  });

  testWidgets('a rejected device login while linking ends the identity', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      secureWeakLoginIdPrefsKey: 'first-device',
    });
    FlutterSecureStorage.setMockInitialValues({
      secureWeakLoginTokenPrefsKey: 'weak-login-token',
      secureDerivedServerLoginPasswordKey: 'password',
    });
    final prefs = await SharedPreferences.getInstance();
    late ProviderContainer container;
    BundIdLoginResult? result;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          asyncAuthProvider.overrideWith(_RecordingAuthNotifier.new),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              container = ProviderScope.containerOf(context);
              return TextButton(
                onPressed: () async =>
                    result = await confirmBundIdRegistration(ref, 'keycloak'),
                child: const Text('confirm'),
              );
            },
          ),
        ),
      ),
    );

    await http.runWithClient(
      () async {
        await tester.tap(find.text('confirm'));
        await tester.pumpAndSettle();
      },
      () =>
          MockClient((_) async => http.Response(jsonEncode(_wrongLogin), 200)),
    );

    expect(result?.outcome, BundIdLoginOutcome.error);
    expect(prefs.getString(secureWeakLoginIdPrefsKey), isNull);
    expect(container.read(strongSessionExpiredProvider), isTrue);
  });

  testWidgets('every BundID login asks Keycloak for a fresh sign-in', (
    tester,
  ) async {
    const channel = MethodChannel('crossingthestreams.io/flutter_appauth');
    MethodCall? authorization;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      authorization = call;
      throw PlatformException(code: 'cancelled');
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    late WidgetRef widgetRef;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              widgetRef = ref;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    final result = await loginWithBundIdDirect(widgetRef);

    expect(result.outcome, BundIdLoginOutcome.error);
    expect((authorization?.arguments as Map?)?['promptValues'], ['login']);
  });
}
