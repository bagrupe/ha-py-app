import 'package:app/common/design_tokens.dart';
import 'package:app/common/volunteer_database/time_credit_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

typedef TimeCreditColors = ({Color background, Color foreground});

/// Formats a [Duration] as `"H:MM Std."` (e.g. `"3:30 Std."`).
///
/// Negative durations keep a leading minus (`"-1:15 Std."`).
String formatTimeCreditDuration(Duration duration) {
  final isNegative = duration.isNegative;
  final absolute = duration.abs();
  final hours = absolute.inHours;
  final minutes = absolute.inMinutes.remainder(60);
  final formatted = '$hours:${minutes.toString().padLeft(2, '0')} Std.';
  return isNegative ? '-$formatted' : formatted;
}

/// Dumb presentation of a [TimeCreditModel] balance and breakdown.
class TimeCreditWidget extends StatelessWidget {
  /// Creates a time-credit display for the given [model].
  const TimeCreditWidget({required this.model, super.key});

  /// Domain model whose derived balance and state drive the UI.
  final TimeCreditModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (:background, :foreground) = _colorsFor(
      theme: theme,
      state: model.state,
    );

    final cardBackground = theme.colorScheme.surfaceContainer;

    return Semantics(
      label:
          '${'application.volunteer_database.time_credit.title'.tr()}: '
          '${formatTimeCreditDuration(model.currentBalance)}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 8,
                    children: [
                      Text(
                        'application.volunteer_database.time_credit.title'.tr(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        formatTimeCreditDuration(model.currentBalance),
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 4,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      _TimeCreditMeta(
                        label:
                            'application.volunteer_database.time_credit.help_provided'
                                .tr(),
                        value: formatTimeCreditDuration(model.helpProvided),
                        color: foreground,
                      ),
                      _TimeCreditMeta(
                        label:
                            'application.volunteer_database.time_credit.help_received'
                                .tr(),
                        value: formatTimeCreditDuration(model.helpReceived),
                        color: foreground,
                      ),
                    ],
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 8,
                    children: [
                      Text(
                        'application.volunteer_database.time_credit.time_blocked'
                            .tr(),
                      ),
                      Text(
                        formatTimeCreditDuration(model.timeBlocked),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'application.volunteer_database.time_credit.hint.${model.state.name}'
                    .tr(),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TimeCreditColors _colorsFor({
    required ThemeData theme,
    required TimeCreditState state,
  }) {
    return switch (state) {
      TimeCreditState.positive => (
        background: theme.colorScheme.primaryContainer,
        foreground: theme.colorScheme.onPrimaryContainer,
      ),
      TimeCreditState.warning => (
        background: DesignTokens.orange100,
        foreground: DesignTokens.orange900,
      ),
      TimeCreditState.negative => (
        background: theme.colorScheme.errorContainer,
        foreground: theme.colorScheme.onErrorContainer,
      ),
    };
  }
}

class _TimeCreditMeta extends StatelessWidget {
  const _TimeCreditMeta({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        runSpacing: 4,
        children: [
          Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(color: color),
          ),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Loading placeholder matching the [TimeCreditWidget] footprint.
class TimeCreditSkeleton extends StatelessWidget {
  /// Creates a shimmering time-credit placeholder.
  const TimeCreditSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      child: TimeCreditWidget(
        model: TimeCreditModel(
          baseCredit: Duration(hours: 8),
          helpProvided: Duration(hours: 3),
          helpReceived: Duration(hours: 1),
          timeBlocked: Duration.zero,
        ),
      ),
    );
  }
}

/// Inline error state with a retry action for failed profile/time-credit loads.
class TimeCreditErrorWidget extends StatelessWidget {
  /// Creates an error card; [onRetry] is called when the user taps retry.
  const TimeCreditErrorWidget({required this.onRetry, super.key, this.message});

  /// Invoked when the retry button is pressed.
  final VoidCallback onRetry;

  /// Optional override for the error message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorMessage =
        message ?? 'application.volunteer_database.time_credit.error'.tr();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: DesignTokens.red200.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignTokens.red500.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: DesignTokens.red900),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                errorMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.red900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                'application.volunteer_database.time_credit.retry'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
