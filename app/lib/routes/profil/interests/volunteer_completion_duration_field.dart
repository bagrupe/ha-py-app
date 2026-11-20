import 'package:app/common/util/hour_minute_duration.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_duration_stepper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Captures the actual completion duration with an accessible stepper.
class VolunteerCompletionDurationField extends StatelessWidget {
  /// Creates a completion duration field.
  const VolunteerCompletionDurationField({
    required this.durationMinutes,
    required this.onChanged,
    super.key,
  });

  /// Currently selected actual duration in minutes.
  final int durationMinutes;

  /// Called with the newly selected actual duration.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const basePath =
        'application.profile.volunteer_interests.completion.fields';
    final duration = formatHourMinuteDuration(
      Duration(minutes: durationMinutes),
    );
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('$basePath.duration'.tr()),
        VolunteerDurationStepper(
          durationMinutes: durationMinutes,
          minimumMinutes: 15,
          maximumMinutes: 1440,
          stepMinutes: 15,
          durationSuffix: '$basePath.duration_suffix'.tr(),
          semanticLabel: '$basePath.duration_semantics'.tr(
            namedArgs: {'duration': duration},
          ),
          decreaseTooltip: '$basePath.decrease_duration'.tr(),
          increaseTooltip: '$basePath.increase_duration'.tr(),
          onChanged: onChanged,
        ),
        Text(
          '$basePath.duration_hint'.tr(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
