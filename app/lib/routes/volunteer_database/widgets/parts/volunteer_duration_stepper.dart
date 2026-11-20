import 'package:app/common/util/hour_minute_duration.dart';
import 'package:flutter/material.dart';

/// Displays an accessible duration value with decrement and increment actions.
class VolunteerDurationStepper extends StatelessWidget {
  /// Creates a duration stepper.
  const VolunteerDurationStepper({
    required this.durationMinutes,
    required this.minimumMinutes,
    required this.maximumMinutes,
    required this.stepMinutes,
    required this.durationSuffix,
    required this.semanticLabel,
    required this.decreaseTooltip,
    required this.increaseTooltip,
    required this.onChanged,
    super.key,
  });

  /// Currently selected duration in minutes.
  final int durationMinutes;

  /// Smallest selectable duration in minutes.
  final int minimumMinutes;

  /// Largest selectable duration in minutes.
  final int maximumMinutes;

  /// Number of minutes changed by each action.
  final int stepMinutes;

  /// Localized suffix displayed after the formatted duration.
  final String durationSuffix;

  /// Accessible label for the currently selected duration.
  final String semanticLabel;

  /// Localized tooltip for decreasing the duration.
  final String decreaseTooltip;

  /// Localized tooltip for increasing the duration.
  final String increaseTooltip;

  /// Called with the newly selected duration.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final duration = formatHourMinuteDuration(
      Duration(minutes: durationMinutes),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: durationMinutes > minimumMinutes
                ? () => onChanged(
                    (durationMinutes - stepMinutes).clamp(
                      minimumMinutes,
                      maximumMinutes,
                    ),
                  )
                : null,
            tooltip: decreaseTooltip,
            icon: const Icon(Icons.remove),
          ),
          Semantics(
            liveRegion: true,
            label: semanticLabel,
            excludeSemantics: true,
            child: RichText(
              text: TextSpan(
                text: duration,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: durationSuffix,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: durationMinutes < maximumMinutes
                ? () => onChanged(
                    (durationMinutes + stepMinutes).clamp(
                      minimumMinutes,
                      maximumMinutes,
                    ),
                  )
                : null,
            tooltip: increaseTooltip,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
