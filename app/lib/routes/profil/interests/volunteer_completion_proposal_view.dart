import 'package:app/common/util/hour_minute_duration.dart';
import 'package:app/components/buttons/app_filled_button.dart';
import 'package:app/routes/profil/interests/volunteer_completion_summary_row.dart';
import 'package:app/routes/profil/interests/volunteer_completion_support_hint.dart';
import 'package:app/routes/volunteer_database/models/volunteer_completion_proposal_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays the current proposal and the actions available to this party.
class VolunteerCompletionProposalView extends StatelessWidget {
  /// Creates a completion proposal view.
  const VolunteerCompletionProposalView({
    required this.proposal,
    required this.isOwnProposal,
    required this.isLoading,
    required this.onConfirm,
    required this.onAdjust,
    super.key,
  });

  /// Current backend completion proposal.
  final VolunteerCompletionProposalModel proposal;

  /// Whether the signed-in person submitted this proposal.
  final bool isOwnProposal;

  /// Whether a completion mutation is running.
  final bool isLoading;

  /// Confirms a proposal submitted by the other party.
  final VoidCallback onConfirm;

  /// Opens the form for a counterproposal.
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    const basePath = 'application.profile.volunteer_interests.completion';
    final durationValue = '$basePath.duration_value'.tr(
      namedArgs: {
        'duration': formatHourMinuteDuration(
          Duration(minutes: proposal.minutes),
        ),
      },
    );
    final dateValue = DateFormat.yMd(
      Intl.getCurrentLocale(),
    ).format(proposal.performedOn);
    final note = proposal.note?.trim();
    final semanticLabel = '$basePath.proposal_semantics'.tr(
      namedArgs: {
        'duration': durationValue,
        'date': dateValue,
        'note': note?.isNotEmpty ?? false ? note! : '$basePath.no_note'.tr(),
      },
    );
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          label: semanticLabel,
          excludeSemantics: true,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$basePath.proposal_title'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              VolunteerCompletionSummaryRow(
                icon: Icons.schedule_outlined,
                label: '$basePath.fields.duration'.tr(),
                value: durationValue,
              ),
              VolunteerCompletionSummaryRow(
                icon: Icons.calendar_month_outlined,
                label: '$basePath.fields.date'.tr(),
                value: dateValue,
              ),
              if (note?.isNotEmpty ?? false)
                VolunteerCompletionSummaryRow(
                  icon: Icons.notes_outlined,
                  label: '$basePath.fields.note_summary'.tr(),
                  value: note!,
                ),
            ],
          ),
        ),
        if (isOwnProposal)
          Semantics(
            liveRegion: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.hourglass_top_outlined, size: 18),
                    Expanded(child: Text('$basePath.waiting'.tr())),
                  ],
                ),
              ),
            ),
          )
        else ...[
          AppFilledButton(
            label: '$basePath.actions.confirm'.tr(),
            isLoading: isLoading,
            onPressed: isLoading ? null : onConfirm,
          ),
          SizedBox(
            height: MediaQuery.textScalerOf(
              context,
            ).scale(48).clamp(48.0, 500.0),
            child: OutlinedButton(
              onPressed: isLoading ? null : onAdjust,
              child: Text('$basePath.actions.adjust'.tr()),
            ),
          ),
        ],
        const VolunteerCompletionSupportHint(),
      ],
    );
  }
}
