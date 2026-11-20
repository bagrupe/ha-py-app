import 'package:app/common/util/text_scaling.dart';
import 'package:app/components/buttons/app_filled_button.dart';
import 'package:app/routes/profil/interests/volunteer_completion_date_field.dart';
import 'package:app/routes/profil/interests/volunteer_completion_duration_field.dart';
import 'package:app/routes/profil/interests/volunteer_completion_form_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Callback used to submit a validated completion proposal.
typedef VolunteerCompletionSubmitCallback =
    Future<void> Function({
      required int minutes,
      required DateTime performedOn,
      required String? note,
    });

/// Displays the duration, date and optional note completion form.
class VolunteerCompletionForm extends ConsumerWidget {
  /// Creates a completion form.
  const VolunteerCompletionForm({
    required this.interestId,
    required this.initialMinutes,
    required this.initialDate,
    required this.submitLabel,
    required this.isLoading,
    required this.onSubmit,
    this.initialNote,
    this.onCancel,
    super.key,
  });

  /// Backend identifier of the interest request.
  final String interestId;

  /// Initial duration when editing a counterproposal.
  final int initialMinutes;

  /// Initial performance date.
  final DateTime initialDate;

  /// Initial optional proposal note.
  final String? initialNote;

  /// Localized primary action label.
  final String submitLabel;

  /// Whether a completion mutation is running.
  final bool isLoading;

  /// Called with validated form values.
  final VolunteerCompletionSubmitCallback onSubmit;

  /// Optional action used to leave counterproposal editing.
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const basePath = 'application.profile.volunteer_interests.completion';
    final normalizedInitialDate = DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
    );
    final parameters = (
      interestId: interestId,
      initialMinutes: initialMinutes,
      initialDate: normalizedInitialDate,
      initialNote: initialNote ?? '',
    );
    final state = ref.watch(volunteerCompletionFormProvider(parameters));
    final notifier = ref.read(
      volunteerCompletionFormProvider(parameters).notifier,
    );
    final formIdentity = [
      interestId,
      initialMinutes,
      normalizedInitialDate.toIso8601String(),
      initialNote,
    ].join('-');
    return Form(
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VolunteerCompletionDurationField(
            durationMinutes: state.durationMinutes,
            onChanged: notifier.setDurationMinutes,
          ),
          VolunteerCompletionDateField(
            value: state.performedOn,
            onChanged: notifier.setPerformedOn,
          ),
          TextFormField(
            key: ValueKey('$formIdentity-note'),
            initialValue: state.note,
            minLines: 2,
            maxLines: TextScaling.maxLines(context, 5),
            textCapitalization: TextCapitalization.sentences,
            onChanged: notifier.setNote,
            decoration: InputDecoration(
              labelText: '$basePath.fields.note'.tr(),
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
            ),
          ),
          Semantics(
            container: true,
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 18),
                Expanded(
                  child: Text(
                    '$basePath.confirmation_hint'.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          AppFilledButton(
            label: submitLabel,
            isLoading: isLoading,
            onPressed: state.hasValidDuration && !isLoading
                ? () => onSubmit(
                    minutes: state.durationMinutes,
                    performedOn: state.performedOn,
                    note: state.normalizedNote,
                  )
                : null,
          ),
          if (onCancel != null)
            SizedBox(
              height: MediaQuery.textScalerOf(
                context,
              ).scale(48).clamp(48.0, 500.0),
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                child: Text('$basePath.actions.cancel_adjustment'.tr()),
              ),
            ),
        ],
      ),
    );
  }
}
