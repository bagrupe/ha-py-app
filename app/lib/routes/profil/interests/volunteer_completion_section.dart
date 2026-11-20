import 'package:app/common/volunteer_database/volunteer_auth_provider.dart';
import 'package:app/common/volunteer_database/volunteer_interest_submission_exception.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/routes/profil/interests/volunteer_completion_action_provider.dart';
import 'package:app/routes/profil/interests/volunteer_completion_editing_provider.dart';
import 'package:app/routes/profil/interests/volunteer_completion_form.dart';
import 'package:app/routes/profil/interests/volunteer_completion_proposal_view.dart';
import 'package:app/routes/profil/interests/volunteer_completion_success_view.dart';
import 'package:app/routes/profil/interests/volunteer_completion_support_hint.dart';
import 'package:app/routes/volunteer_database/models/volunteer_interest_overview_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays completion proposal, confirmation and booking states.
class VolunteerCompletionSection extends ConsumerWidget {
  /// Creates the completion section for [interest].
  const VolunteerCompletionSection({required this.interest, super.key});

  /// Interest request whose completion is managed.
  final VolunteerInterestOverviewModel interest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!interest.isAgreed && !interest.isCompleted) {
      return const SizedBox.shrink();
    }
    const basePath = 'application.profile.volunteer_interests.completion';
    final actionProvider = volunteerCompletionActionProvider(interest.id);
    final actionState = ref.watch(actionProvider);
    ref.listen(actionProvider, (_, next) {
      if (!next.hasError) return;
      final error = next.error;
      final messageKey = error is VolunteerInterestSubmissionException
          ? error.messageKey
          : '$basePath.errors.generic';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(messageKey.tr())));
    });
    final proposal = interest.completionProposal;
    final currentUserId = ref.watch(volunteerAuthProvider);
    final isOwnProposal = proposal?.wasProposedBy(currentUserId) ?? false;
    final editingProvider = volunteerCompletionEditingProvider(interest.id);
    final isEditing = ref.watch(editingProvider);
    final initialDate =
        interest.agreementConfirmedAt?.toLocal() ?? DateTime.now();
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1),
        if (!interest.isCompleted)
          Text(
            '$basePath.title'.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        if (interest.isCompleted)
          VolunteerCompletionSuccessView(
            minutes: interest.completionBooking?.minutes,
            isDebit:
                interest.type ==
                Enum_EhrenamtsbankAnfrageTyp.EMPFANGENE_ANFRAGE,
          )
        else if (proposal == null) ...[
          Text('$basePath.introduction'.tr()),
          VolunteerCompletionForm(
            interestId: interest.id,
            initialMinutes: interest.plannedDurationMinutes ?? 60,
            initialDate: initialDate,
            submitLabel: '$basePath.actions.propose'.tr(),
            isLoading: actionState.isLoading,
            onSubmit:
                ({required minutes, required performedOn, required note}) => ref
                    .read(actionProvider.notifier)
                    .propose(
                      minutes: minutes,
                      performedOn: performedOn,
                      note: note,
                    ),
          ),
        ] else if (!isOwnProposal && isEditing) ...[
          Text('$basePath.counterproposal_introduction'.tr()),
          VolunteerCompletionForm(
            interestId: interest.id,
            initialMinutes: proposal.minutes,
            initialDate: proposal.performedOn,
            initialNote: proposal.note,
            submitLabel: '$basePath.actions.counterproposal'.tr(),
            isLoading: actionState.isLoading,
            onCancel: ref.read(editingProvider.notifier).cancel,
            onSubmit:
                ({required minutes, required performedOn, required note}) => ref
                    .read(actionProvider.notifier)
                    .propose(
                      minutes: minutes,
                      performedOn: performedOn,
                      note: note,
                    ),
          ),
          const VolunteerCompletionSupportHint(),
        ] else
          VolunteerCompletionProposalView(
            proposal: proposal,
            isOwnProposal: isOwnProposal,
            isLoading: actionState.isLoading,
            onConfirm: ref.read(actionProvider.notifier).confirm,
            onAdjust: ref.read(editingProvider.notifier).begin,
          ),
      ],
    );
  }
}
