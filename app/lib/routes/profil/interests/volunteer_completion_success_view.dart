import 'package:app/common/util/hour_minute_duration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays confirmation that a completion was booked to the time account.
class VolunteerCompletionSuccessView extends StatelessWidget {
  /// Creates a completion success view.
  const VolunteerCompletionSuccessView({
    required this.minutes,
    required this.isDebit,
    super.key,
  });

  /// Booked duration in minutes, if returned by the backend.
  final int? minutes;

  /// Whether the booked time is deducted from the current user’s account.
  final bool isDebit;

  @override
  Widget build(BuildContext context) {
    const basePath = 'application.profile.volunteer_interests.completion';
    final bookedMinutes = minutes;
    final bookingKey = isDebit ? 'success_debit' : 'success_credit';
    final message = bookedMinutes == null
        ? '$basePath.${bookingKey}_without_duration'.tr()
        : '$basePath.$bookingKey'.tr(
            namedArgs: {
              'duration': formatHourMinuteDuration(
                Duration(minutes: bookedMinutes),
              ),
            },
          );
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      liveRegion: true,
      label: message,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline, color: colorScheme.primary),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
