import 'package:app/common/util/hour_minute_duration.dart';
import 'package:app/common/util/text_scaling.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_form_state.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_form_provider.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_duration_stepper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Description, duration and optional attributes of a request.
class VolunteerRequestStepDetails extends StatelessWidget {
  /// Creates the request details step.
  const VolunteerRequestStepDetails({
    required this.state,
    required this.notifier,
    super.key,
  });

  /// Current request form state.
  final VolunteerRequestFormState state;

  /// Request form notifier.
  final VolunteerRequestFormNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final duration = formatHourMinuteDuration(
      Duration(minutes: state.estimatedDurationMinutes),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: state.description,
          minLines: 4,
          maxLines: TextScaling.maxLines(context, 7),
          onChanged: notifier.setDescription,
          decoration: InputDecoration(
            labelText:
                'application.volunteer_database.create_request.fields.description'
                    .tr(),
            helperText:
                'application.volunteer_database.create_request.hints.description'
                    .tr(),
            helperMaxLines: TextScaling.maxLines(context, 3),
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'application.volunteer_database.create_request.fields.duration'.tr(),
        ),
        const SizedBox(height: 6),
        VolunteerDurationStepper(
          durationMinutes: state.estimatedDurationMinutes,
          minimumMinutes: 30,
          maximumMinutes: 720,
          stepMinutes: 15,
          durationSuffix:
              'application.volunteer_database.create_request.duration_value'
                  .tr(),
          semanticLabel:
              'application.volunteer_database.create_request.semantics.duration'
                  .tr(namedArgs: {'duration': duration}),
          decreaseTooltip:
              'application.volunteer_database.create_request.semantics.decrease_duration'
                  .tr(),
          increaseTooltip:
              'application.volunteer_database.create_request.semantics.increase_duration'
                  .tr(),
          onChanged: (value) =>
              notifier.changeDuration(value - state.estimatedDurationMinutes),
        ),
        const SizedBox(height: 8),
        Text(
          'application.volunteer_database.create_request.hints.duration'.tr(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
