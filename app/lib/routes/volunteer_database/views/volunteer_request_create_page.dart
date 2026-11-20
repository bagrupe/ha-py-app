import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_submission.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_submission_error.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_form_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_submission_provider.dart';
import 'package:app/routes/volunteer_database/widgets/create/volunteer_request_workflow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Four-step workflow for creating a volunteer help request.
class VolunteerRequestCreatePage extends ConsumerWidget {
  /// Creates the volunteer request workflow page.
  const VolunteerRequestCreatePage({super.key});

  /// Absolute route path of the request creation workflow.
  static const path = '/ehrenamtsdatenbank/marketplace/create';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(
      volunteerRequestFormProvider.select((state) => state.step),
    );
    final submissionState = ref.watch(volunteerRequestSubmissionProvider);
    final formNotifier = ref.read(volunteerRequestFormProvider.notifier);

    ref.listen(volunteerRequestSubmissionProvider, (previous, next) {
      if (previous?.isLoading != true ||
          next.isLoading ||
          context.mounted == false) {
        return;
      }
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              VolunteerRequestSubmissionError.translationKey(next.error!).tr(),
            ),
          ),
        );
        return;
      }
      formNotifier.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'application.volunteer_database.create_request.success'.tr(),
          ),
        ),
      );
      context.pop();
    });

    return PopScope(
      canPop: !submissionState.isLoading && currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !submissionState.isLoading) {
          formNotifier.previousStep();
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: Text('application.volunteer_database.title'.tr()),
          logo: true,
          menu: false,
        ),
        body: Semantics(
          label: 'application.volunteer_database.create_request.semantics.page'
              .tr(),
          explicitChildNodes: true,
          child: SafeArea(
            child: AbsorbPointer(
              absorbing: submissionState.isLoading,
              child: VolunteerRequestWorkflow(
                isSubmitting: submissionState.isLoading,
                onBack: formNotifier.previousStep,
                onContinue: () {
                  final formState = ref.read(volunteerRequestFormProvider);
                  if (formState.step < 3) {
                    formNotifier.nextStep();
                    return;
                  }
                  ref
                      .read(volunteerRequestSubmissionProvider.notifier)
                      .submit(
                        VolunteerRequestSubmission(
                          title: formState.title.trim(),
                          description: formState.description.trim(),
                          categoryId: formState.categoryId!,
                          municipalityId: formState.municipalityId!,
                          urgency: Enum_EhrenamtsbankDringlichkeit.MITTEL,
                          estimatedDurationMinutes:
                              formState.estimatedDurationMinutes,
                          tags: [
                            if (formState.hasBarrierFreeAccess)
                              'application.volunteer_database.create_request.tags.barrier_free'
                                  .tr(),
                            if (formState.isRemotePossible)
                              'application.volunteer_database.create_request.tags.remote'
                                  .tr(),
                            if (formState.hasPetFreeHousehold)
                              'application.volunteer_database.create_request.tags.pet_free'
                                  .tr(),
                          ],
                          photoPath: formState.photoPath,
                        ),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
