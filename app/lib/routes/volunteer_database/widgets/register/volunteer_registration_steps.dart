import 'package:app/components/workflow_steps/workflow_step_row.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_notifier.dart';
import 'package:app/routes/volunteer_database/providers/registration/volunteer_registration_step.dart';
import 'package:app/routes/volunteer_database/widgets/register/volunteer_registration_identity_card.dart';
import 'package:app/routes/volunteer_database/widgets/register/volunteer_registration_phone_card.dart';
import 'package:app/routes/volunteer_database/widgets/register/volunteer_registration_sms_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step list for the volunteer registration flow.
class VolunteerRegistrationSteps extends ConsumerWidget {
  /// Creates the volunteer registration step list.
  const VolunteerRegistrationSteps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(volunteerRegistrationProvider);
    final currentStep = registrationState.currentStep;

    return Column(
      children: [
        WorkflowStepRow(
          number: 1,
          title: 'application.volunteer_database.register_page.steps.phone'
              .tr(),
          semanticsLabelKey:
              'application.volunteer_database.register_page.semantics.step',
          isActive: currentStep == VolunteerRegistrationStep.phone,
          isCompleted: registrationState.isPhoneCompleted,
          content: currentStep == VolunteerRegistrationStep.phone
              ? const VolunteerRegistrationPhoneCard()
              : null,
        ),
        const SizedBox(height: 16),
        WorkflowStepRow(
          number: 2,
          title: 'application.volunteer_database.register_page.steps.sms'.tr(),
          semanticsLabelKey:
              'application.volunteer_database.register_page.semantics.step',
          isActive: currentStep == VolunteerRegistrationStep.sms,
          isCompleted: registrationState.isSmsCompleted,
          content: currentStep == VolunteerRegistrationStep.sms
              ? const VolunteerRegistrationSmsCard()
              : null,
        ),
        const SizedBox(height: 18),
        WorkflowStepRow(
          number: 3,
          title: 'application.volunteer_database.register_page.steps.identity'
              .tr(),
          semanticsLabelKey:
              'application.volunteer_database.register_page.semantics.step',
          isActive: currentStep == VolunteerRegistrationStep.identity,
          content: currentStep == VolunteerRegistrationStep.identity
              ? const VolunteerRegistrationIdentityCard()
              : null,
        ),
      ],
    );
  }
}
