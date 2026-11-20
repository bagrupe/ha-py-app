import 'dart:async';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_notifier.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_notifier.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _requested = Response(
  response: {},
  data: {
    '__typename': 'Mutation',
    'requestSmsCode': {
      '__typename': 'RequestSmsCodePayload',
      'requestSmsResult': 'SUCCESS',
    },
  },
);

const _validated = Response(
  response: {},
  data: {
    '__typename': 'Mutation',
    'validateSmsCode': {
      '__typename': 'ValidateSmsCodePayload',
      'result': 'SUCCESS',
      'token': 'sms-token',
      'refreshToken': 'sms-refresh',
      'isNewRegistration': false,
      'remainingAttempts': null,
      'retryAfterSeconds': null,
    },
  },
);

Future<ProviderContainer> _container({Future<Response>? validation}) async {
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({
    secureStrongTokenKey: 'old-token',
    secureStrongRefreshTokenKey: 'old-refresh',
  });
  final client = GraphQLClient(
    link: Link.function((request, [forward]) {
      final input = request.variables['input'] as Map<String, dynamic>;
      if (!input.containsKey('validationCode')) return Stream.value(_requested);
      return validation == null
          ? Stream.value(_validated)
          : Stream.fromFuture(validation);
    }),
    cache: GraphQLCache(store: InMemoryStore()),
  );
  final container = ProviderContainer(
    overrides: [
      graphqlClientProvider.overrideWithValue(client),
      sharedPreferencesProvider.overrideWithValue(
        await SharedPreferences.getInstance(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _expectSmsSessionStored() async {
  const storage = FlutterSecureStorage();
  expect(await storage.read(key: secureStrongTokenKey), 'sms-token');
  expect(await storage.read(key: secureStrongRefreshTokenKey), 'sms-refresh');
}

Future<T> _withoutNetwork<T>(Future<T> Function() body) => http.runWithClient(
  body,
  () => MockClient((_) async => http.Response('', 204)),
);

void main() {
  test(
    'the volunteer login stores the SMS session with its refresh token',
    () async {
      final container = await _container();
      container.listen(volunteerLoginProvider, (_, _) {});
      final notifier = container.read(volunteerLoginProvider.notifier)
        ..updatePhoneNumber('15123456789');
      await notifier.continueLogin();
      notifier.updateSmsCode('123456');

      await _withoutNetwork(notifier.continueLogin);

      await _expectSmsSessionStored();
    },
  );

  test(
    'the volunteer registration stores the SMS session with its refresh token',
    () async {
      final container = await _container();
      container.listen(volunteerRegistrationProvider, (_, _) {});
      final notifier = container.read(volunteerRegistrationProvider.notifier)
        ..updatePhoneNumber('15123456789');
      await notifier.continueRegistration();
      notifier.updateSmsCode('123456');

      await _withoutNetwork(notifier.continueRegistration);

      await _expectSmsSessionStored();
    },
  );

  group('a page closed during the code check keeps the SMS session', () {
    Future<void> closeWhileChecking(
      ProviderSubscription<Object?> page,
      Completer<Response> validation,
      Future<void> Function() confirm,
    ) => _withoutNetwork(() async {
      final confirming = confirm();
      await pumpEventQueue();
      page.close();
      await pumpEventQueue();
      validation.complete(_validated);
      await confirming;
    });

    test('in the volunteer login', () async {
      final validation = Completer<Response>();
      final container = await _container(validation: validation.future);
      final page = container.listen(volunteerLoginProvider, (_, _) {});
      final notifier = container.read(volunteerLoginProvider.notifier)
        ..updatePhoneNumber('15123456789');
      await notifier.continueLogin();
      notifier.updateSmsCode('123456');

      await closeWhileChecking(page, validation, notifier.continueLogin);

      await _expectSmsSessionStored();
    });

    test('in the volunteer registration', () async {
      final validation = Completer<Response>();
      final container = await _container(validation: validation.future);
      final page = container.listen(volunteerRegistrationProvider, (_, _) {});
      final notifier = container.read(volunteerRegistrationProvider.notifier)
        ..updatePhoneNumber('15123456789');
      await notifier.continueRegistration();
      notifier.updateSmsCode('123456');

      await closeWhileChecking(page, validation, notifier.continueRegistration);

      await _expectSmsSessionStored();
    });

    test('in the BundID onboarding', () async {
      final validation = Completer<Response>();
      final container = await _container(validation: validation.future);
      final page = container.listen(bundIdOnboardingProvider, (_, _) {});
      final notifier = container.read(bundIdOnboardingProvider.notifier)
        ..updatePhoneNumber('15123456789');
      await notifier.sendSmsCode();
      notifier.updateSmsCode('123456');

      await closeWhileChecking(
        page,
        validation,
        notifier.confirmAndCompleteProfile,
      );

      await _expectSmsSessionStored();
    });
  });
}
