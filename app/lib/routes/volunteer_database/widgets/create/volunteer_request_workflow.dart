import 'package:app/components/workflow_steps/workflow_step_row.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_form_provider.dart';
import 'package:app/routes/volunteer_database/widgets/create/volunteer_request_active_step.dart';
import 'package:app/routes/volunteer_database/widgets/create/volunteer_request_step_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays all workflow steps and the active step content.
class VolunteerRequestWorkflow extends ConsumerWidget {
  /// Creates the request workflow.
  const VolunteerRequestWorkflow({
    required this.isSubmitting,
    required this.onBack,
    required this.onContinue,
    super.key,
  });

  /// Whether the final submission is running.
  final bool isSubmitting;

  /// Called to navigate to the previous step.
  final VoidCallback onBack;

  /// Called to continue or submit the workflow.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(
      volunteerRequestFormProvider.select((state) => state.step),
    );
    final canContinue = ref.watch(
      volunteerRequestFormProvider.select((state) => state.canContinue),
    );
    final titles = [
      'application.volunteer_database.create_request.steps.help'.tr(),
      'application.volunteer_database.create_request.steps.details'.tr(),
      'application.volunteer_database.create_request.steps.location'.tr(),
      'application.volunteer_database.create_request.steps.photo'.tr(),
    ];

    return SingleChildScrollView(
      restorationId: 'volunteerRequestCreationScrollView',
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'application.volunteer_database.create_request.title'.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < titles.length; index++) ...[
            WorkflowStepRow(
              number: index + 1,
              title: titles[index],
              semanticsLabelKey:
                  'application.volunteer_database.create_request.semantics.step',
              isActive: currentStep == index,
              isCompleted: currentStep > index,
              content: currentStep == index
                  ? const VolunteerRequestActiveStep()
                  : null,
            ),
            const SizedBox(height: 16),
          ],
          VolunteerRequestStepActions(
            showBack: currentStep > 0,
            isSubmitting: isSubmitting,
            canContinue: canContinue,
            isFinalStep: currentStep == 3,
            onBack: onBack,
            onContinue: onContinue,
          ),
        ],
      ),
    );
  }
}
