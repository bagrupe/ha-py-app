import 'package:app/common/auth/auth.dart';
import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Completes session cleanup independently of the initiating widget's lifetime.
final volunteerLogoutProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final auth = ref.read(asyncAuthProvider.notifier);
    ref.read(volunteerAuthProvider.notifier).signOut();
    await auth.signOut();
    if (!ref.mounted) return;
    ref
      ..invalidate(hasStrongSessionProvider)
      ..invalidate(myAccountProfileProvider);
  };
});
