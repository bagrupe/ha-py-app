import 'package:app/common/auth/auth.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_notifier.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../helper/localization_helper.dart';

const _errors = 'application.volunteer_database.bundid_onboarding_page.errors';

class _FakeLink extends Link {
  _FakeLink(this.validateResponse);

  final Response validateResponse;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    final input = request.variables['input'] as Map<String, dynamic>?;
    if (input != null && !input.containsKey('validationCode')) {
      return Stream.value(
        const Response(
          data: {
            '__typename': 'Mutation',
            'requestSmsCode': {
              '__typename': 'RequestSmsCodePayload',
              'requestSmsResult': 'SUCCESS',
            },
          },
          response: {},
        ),
      );
    }
    return Stream.value(validateResponse);
  }
}

Response _validateResult(
  String result, {
  int? remainingAttempts,
  int? retryAfterSeconds,
  String? token,
  String? refreshToken,
}) => Response(
  data: {
    '__typename': 'Mutation',
    'validateSmsCode': {
      '__typename': 'ValidateSmsCodePayload',
      'result': result,
      'token': token,
      'refreshToken': refreshToken,
      'isNewRegistration': false,
      'remainingAttempts': remainingAttempts,
      'retryAfterSeconds': retryAfterSeconds,
    },
  },
  response: const {},
);

Future<ProviderContainer> _atCodeStep(Response validateResponse) async {
  final container = ProviderContainer(
    overrides: [
      graphqlClientProvider.overrideWithValue(
        GraphQLClient(cache: GraphQLCache(), link: _FakeLink(validateResponse)),
      ),
    ],
  );
  addTearDown(container.dispose);
  final notifier = container.read(bundIdOnboardingProvider.notifier)
    ..updatePhoneNumber('15112345678');
  await notifier.sendSmsCode();
  notifier.updateSmsCode('000000');
  return container;
}

void main() {
  setUpAll(TestLocalizationHelper.init);

  group('BundIdOnboardingNotifier.confirmAndCompleteProfile', () {
    test(
      'a success replaces the BundID session with the SMS session',
      () async {
        FlutterSecureStorage.setMockInitialValues({
          secureStrongTokenKey: 'bundid-token',
          secureStrongRefreshTokenKey: 'bundid-refresh',
        });
        final container = await _atCodeStep(
          _validateResult(
            'SUCCESS',
            token: 'sms-token',
            refreshToken: 'sms-refresh',
          ),
        );
        await http.runWithClient(
          () => container
              .read(bundIdOnboardingProvider.notifier)
              .confirmAndCompleteProfile(),
          () => MockClient((_) async => http.Response('', 204)),
        );

        const storage = FlutterSecureStorage();
        expect(await storage.read(key: secureStrongTokenKey), 'sms-token');
        expect(
          await storage.read(key: secureStrongRefreshTokenKey),
          'sms-refresh',
        );
        expect(container.read(bundIdOnboardingProvider).isCompleted, isTrue);
      },
    );

    test('a wrong code names the remaining attempts', () async {
      final container = await _atCodeStep(
        _validateResult('INVALID_CODE', remainingAttempts: 2),
      );
      await container
          .read(bundIdOnboardingProvider.notifier)
          .confirmAndCompleteProfile();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.currentStep, BundIdOnboardingStep.sms);
      expect(state.smsCodeErrorMessageKey, '$_errors.code_wrong');
      expect(state.smsCodeErrorArgs, {'attempts': '2'});
      expect(state.isLoading, isFalse);
    });

    test('a locked account shows the lock time', () async {
      final container = await _atCodeStep(
        _validateResult('CODE_LOCKED', retryAfterSeconds: 900),
      );
      await container
          .read(bundIdOnboardingProvider.notifier)
          .confirmAndCompleteProfile();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.smsCodeErrorMessageKey, '$_errors.code_locked');
      expect(state.smsCodeErrorArgs?.keys, ['wait']);
    });

    test('a rate limit shows the wait time', () async {
      final container = await _atCodeStep(
        const Response(
          errors: [
            GraphQLError(
              message: 'Rate Limit exceeded',
              extensions: {'code': 'RATE_LIMIT', 'retryAfterSeconds': 120},
            ),
          ],
          response: {},
        ),
      );
      await container
          .read(bundIdOnboardingProvider.notifier)
          .confirmAndCompleteProfile();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.smsCodeErrorMessageKey, '$_errors.rate_limit_wait');
      expect(state.smsCodeErrorArgs?.keys, ['wait']);
    });

    test('a server error is not reported as a wrong code', () async {
      final container = await _atCodeStep(
        const Response(
          errors: [GraphQLError(message: 'boom')],
          response: {},
        ),
      );
      await container
          .read(bundIdOnboardingProvider.notifier)
          .confirmAndCompleteProfile();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.smsCodeErrorMessageKey, '$_errors.code_check_failed');
    });

    test('an expired code keeps its own message', () async {
      final container = await _atCodeStep(_validateResult('CODE_EXPIRED'));
      await container
          .read(bundIdOnboardingProvider.notifier)
          .confirmAndCompleteProfile();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.smsCodeErrorMessageKey, '$_errors.code_expired');
    });

    test('a too short code is rejected before any request', () async {
      final container = await _atCodeStep(_validateResult('INVALID_CODE'));
      final notifier = container.read(bundIdOnboardingProvider.notifier)
        ..updateSmsCode('123');
      await notifier.confirmAndCompleteProfile();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.smsCodeErrorMessageKey, '$_errors.invalid_code');
    });
  });
}
