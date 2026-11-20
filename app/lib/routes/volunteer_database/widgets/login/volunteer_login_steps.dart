import 'package:app/components/workflow_steps/workflow_step_row.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_notifier.dart';
import 'package:app/routes/volunteer_database/providers/login/volunteer_login_step.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_identity_card.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_phone_card.dart';
import 'package:app/routes/volunteer_database/widgets/login/volunteer_login_sms_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Step list for the volunteer login flow.
class VolunteerLoginSteps extends ConsumerWidget {
  /// Creates the volunteer login step list.
  const VolunteerLoginSteps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(volunteerLoginProvider);
    final currentStep = loginState.currentStep;

    return Column(
      children: [
        WorkflowStepRow(
          number: 1,
          title: 'application.volunteer_database.login_page.steps.phone'.tr(),
          semanticsLabelKey:
              'application.volunteer_database.login_page.semantics.step',
          isActive: currentStep == VolunteerLoginStep.phone,
          isCompleted: loginState.isPhoneCompleted,
          content: currentStep == VolunteerLoginStep.phone
              ? const VolunteerLoginPhoneCard()
              : null,
        ),
        const SizedBox(height: 18),
        WorkflowStepRow(
          number: 2,
          title: 'application.volunteer_database.login_page.steps.sms'.tr(),
          semanticsLabelKey:
              'application.volunteer_database.login_page.semantics.step',
          isActive: currentStep == VolunteerLoginStep.sms,
          isCompleted: loginState.isSmsCompleted,
          content: currentStep == VolunteerLoginStep.sms
              ? const VolunteerLoginSmsCard()
              : null,
        ),
        const SizedBox(height: 18),
        WorkflowStepRow(
          number: 3,
          title: 'application.volunteer_database.register_page.steps.identity'
              .tr(),
          semanticsLabelKey:
              'application.volunteer_database.login_page.semantics.step',
          isActive: currentStep == VolunteerLoginStep.identity,
          content: currentStep == VolunteerLoginStep.identity
              ? const VolunteerLoginIdentityCard()
              : null,
        ),
      ],
    );
  }
}
