import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays an accessible error dialog when onboarding setup is interrupted.
class OnboardingSetupErrorDialog extends StatelessWidget {
  /// Creates the setup error dialog with a retry action.
  const OnboardingSetupErrorDialog({required this.onRetry, super.key});

  /// Called when the user requests another setup attempt.
  final VoidCallback onRetry;

  /// Opens the onboarding setup error dialog.
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onRetry,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => OnboardingSetupErrorDialog(onRetry: onRetry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = 'application.onboarding.setup.offline_title'.tr();
    final message = 'application.onboarding.setup.offline_message'.tr();

    return Semantics(
      namesRoute: true,
      label: '$title. $message',
      child: AlertDialog(
        icon: const Icon(Icons.wifi_off_outlined),
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            child: Text('application.error.retry'.tr()),
          ),
        ],
      ),
    );
  }
}
