import 'package:app/components/buttons/app_filled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the agreement confirmation action for accepted requests.
class VolunteerAgreementButton extends StatelessWidget {
  /// Creates an agreement confirmation button.
  const VolunteerAgreementButton({
    required this.isVisible,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  /// Whether the current request can be confirmed.
  final bool isVisible;

  /// Whether the status update is currently running.
  final bool isLoading;

  /// Action invoked when either party confirms the agreement.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    const key =
        'application.profile.volunteer_interests.actions.confirm_agreement';
    return AppFilledButton(
      label: key.tr(),
      semanticLabel: key.tr(),
      isLoading: isLoading,
      onPressed: isLoading ? null : onPressed,
    );
  }
}
