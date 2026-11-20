import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Displays a retryable failure while loading an existing interest request.
class VolunteerInterestLoadError extends StatelessWidget {
  /// Creates a loading error for [error] that invokes [onRetry] when retried.
  const VolunteerInterestLoadError({
    required this.error,
    required this.onRetry,
    super.key,
  });

  /// Failure used to choose an offline or generic message.
  final Object error;

  /// Action that reloads the interest request.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    const basePath =
        'application.volunteer_database.details.interest.load_errors';
    final messageKey = error is OfflineDataUnavailableException
        ? '$basePath.offline'
        : '$basePath.generic';
    return Semantics(
      container: true,
      liveRegion: true,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            messageKey.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
