import 'package:app/common/auth/auth.dart';
import 'package:app/routes/onboarding/onboarding_auth_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldRestartOnboardingAuthentication', () {
    test('keeps an authentication attempt that is still loading', () {
      const authState = AsyncLoading<AuthState>();

      expect(shouldRestartOnboardingAuthentication(authState), isFalse);
    });

    test('restarts an authentication attempt that failed', () {
      final authState = AsyncError<AuthState>(
        Exception('offline'),
        StackTrace.empty,
      );

      expect(shouldRestartOnboardingAuthentication(authState), isTrue);
    });

    test('keeps a successful authentication result', () {
      final authState = AsyncData<AuthState>(AuthState.loading());

      expect(shouldRestartOnboardingAuthentication(authState), isFalse);
    });
  });
}
