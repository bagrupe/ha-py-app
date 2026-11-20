import 'package:app/components/buttons/app_filled_button.dart';
import 'package:app/components/buttons/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Navigation actions shown below the request workflow.
class VolunteerRequestStepActions extends StatelessWidget {
  /// Creates workflow navigation actions.
  const VolunteerRequestStepActions({
    required this.showBack,
    required this.isSubmitting,
    required this.canContinue,
    required this.isFinalStep,
    required this.onBack,
    required this.onContinue,
    super.key,
  });

  /// Whether the back action is visible.
  final bool showBack;

  /// Whether submission is running.
  final bool isSubmitting;

  /// Whether continuing is allowed.
  final bool canContinue;

  /// Whether the active step is the final step.
  final bool isFinalStep;

  /// Called when the back action is pressed.
  final VoidCallback onBack;

  /// Called when the primary action is pressed.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: isSubmitting,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          if (isSubmitting)
            Text(
              'application.volunteer_database.create_request.submitting'.tr(),
            ),
          if (showBack)
            PrimaryButton(
              onPressed: isSubmitting ? null : onBack,
              label: 'application.volunteer_database.create_request.back'.tr(),
            ),
          AppFilledButton(
            label:
                (isSubmitting
                        ? 'application.volunteer_database.create_request.submitting'
                        : isFinalStep
                        ? 'application.volunteer_database.create_request.submit'
                        : 'application.volunteer_database.create_request.continue')
                    .tr(),
            isLoading: isSubmitting,
            onPressed: canContinue && !isSubmitting ? onContinue : null,
          ),
        ],
      ),
    );
  }
}
