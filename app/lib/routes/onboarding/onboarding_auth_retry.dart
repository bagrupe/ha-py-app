import 'package:app/common/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns whether a failed authentication provider needs to be restarted.
bool shouldRestartOnboardingAuthentication(AsyncValue<AuthState> authState) {
  return authState.hasError && !authState.isLoading;
}
