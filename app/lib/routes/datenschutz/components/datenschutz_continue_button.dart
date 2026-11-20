import 'package:app/common/shared_preferences.dart';
import 'package:app/routes/datenschutz/datenschutz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Continue button for the privacy policy onboarding flow.
class DatenschutzContinueButton extends ConsumerWidget {
  /// Creates a [DatenschutzContinueButton].
  const DatenschutzContinueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            ref.read(sharedPreferencesProvider).setBool(dsgvoGelesenKey, true);
            context.go('/onboarding');
          },
          child: Text('application.legal.next'.tr()),
        ),
      ),
    );
  }
}
