import 'package:app/common/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Dialog, der anzeigt, dass die Authentifizierung abgeschlossen wird und die App vorbereitet wird.
/// Schließt sich automatisch, sobald persönliche Daten vorhanden sind.
class AuthCompletedGuardDialog extends ConsumerWidget {
  const AuthCompletedGuardDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPersonalDataKey = ref.watch(authProvider).personalDataKey != null;

    if (hasPersonalDataKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.pop());
    }

    return PopScope(
      canPop: hasPersonalDataKey,
      child: const Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Die App wird vorbereitet...'),
            ],
          ),
        ),
      ),
    );
  }
}
