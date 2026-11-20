import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_notifier.dart';
import 'package:app/routes/volunteer_database/providers/bundid_onboarding/bundid_onboarding_step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const _errorsPrefix =
    'application.volunteer_database.bundid_onboarding_page.errors';

class _FakeLink extends Link {
  _FakeLink(this.response);

  final Response response;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) =>
      Stream.value(response);
}

Response _result(String requestSmsResult) => Response(
  data: {
    '__typename': 'Mutation',
    'requestSmsCode': {
      '__typename': 'RequestSmsCodePayload',
      'requestSmsResult': requestSmsResult,
    },
  },
  response: const {},
);

Response _rateLimited() => const Response(
  errors: [
    GraphQLError(
      message: 'Rate Limit exceeded',
      extensions: {'code': 'RATE_LIMIT'},
    ),
  ],
  response: {},
);

Response _serverError() => const Response(
  errors: [GraphQLError(message: 'boom')],
  response: {},
);

BundIdOnboardingNotifier _notifierFor(ProviderContainer container) {
  return container.read(bundIdOnboardingProvider.notifier)
    ..updatePhoneNumber('15112345678');
}

ProviderContainer _containerReturning(Response response) {
  final container = ProviderContainer(
    overrides: [
      graphqlClientProvider.overrideWithValue(
        GraphQLClient(cache: GraphQLCache(), link: _FakeLink(response)),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('BundIdOnboardingNotifier.sendSmsCode', () {
    test('success moves on to the SMS step', () async {
      final container = _containerReturning(_result('SUCCESS'));
      await _notifierFor(container).sendSmsCode();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.currentStep, BundIdOnboardingStep.sms);
      expect(state.smsCodePhoneNumber, '+4915112345678');
      expect(state.errorMessageKey, isNull);
      expect(state.isLoading, isFalse);
    });

    test(
      'rate limit shows its own message and stays on the phone step',
      () async {
        final container = _containerReturning(_rateLimited());
        await _notifierFor(container).sendSmsCode();

        final state = container.read(bundIdOnboardingProvider);
        expect(state.currentStep, BundIdOnboardingStep.phone);
        expect(state.errorMessageKey, '$_errorsPrefix.rate_limit');
        expect(state.phoneErrorMessageKey, isNull);
        expect(state.isLoading, isFalse);
      },
    );

    test('same number as the verified one shows its own message', () async {
      final container = _containerReturning(
        _result('SAME_AS_CURRENT_PHONE_NUMBER'),
      );
      await _notifierFor(container).sendSmsCode();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.currentStep, BundIdOnboardingStep.phone);
      expect(state.errorMessageKey, '$_errorsPrefix.same_phone_number');
      expect(state.phoneErrorMessageKey, isNull);
    });

    test('an account linked to BundID asks for the BundID login', () async {
      final container = _containerReturning(_result('BUND_ID_LOGIN_REQUIRED'));
      await _notifierFor(container).sendSmsCode();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.currentStep, BundIdOnboardingStep.phone);
      expect(state.errorMessageKey, '$_errorsPrefix.bundid_login_required');
      expect(state.isLoading, isFalse);
    });

    test('failed SMS delivery shows its own message', () async {
      final container = _containerReturning(_result('SMS_DELIVERY_FAILED'));
      await _notifierFor(container).sendSmsCode();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.currentStep, BundIdOnboardingStep.phone);
      expect(state.errorMessageKey, '$_errorsPrefix.sms_delivery_failed');
      expect(state.phoneErrorMessageKey, isNull);
    });

    test('an invalid phone number marks the phone field', () async {
      final container = _containerReturning(_result('INVALID_PHONE'));
      await _notifierFor(container).sendSmsCode();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.currentStep, BundIdOnboardingStep.phone);
      expect(state.errorMessageKey, '$_errorsPrefix.form');
      expect(state.phoneErrorMessageKey, '$_errorsPrefix.invalid_phone');
    });

    test('any other failure shows the generic form error only', () async {
      final container = _containerReturning(_serverError());
      await _notifierFor(container).sendSmsCode();

      final state = container.read(bundIdOnboardingProvider);
      expect(state.currentStep, BundIdOnboardingStep.phone);
      expect(state.errorMessageKey, '$_errorsPrefix.form');
      expect(state.phoneErrorMessageKey, isNull);
    });
  });
}
