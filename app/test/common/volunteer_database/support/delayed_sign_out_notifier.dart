import 'dart:async';

import 'package:app/common/auth/auth.dart';

/// Keeps sign-out pending until a test completes the operation.
class DelayedSignOutNotifier extends AuthStateNotifier {
  /// Controls completion of the simulated sign-out.
  final completion = Completer<void>();

  @override
  Future<AuthState> build() async => AuthState.needsLoading();

  @override
  Future<void> signOut() => completion.future;
}
