part of '../suggested_requests_list.dart';

/// Error state displayed when another volunteer page cannot be loaded.
class _VolunteerPaginationError extends StatelessWidget {
  /// Creates a retryable volunteer pagination error state.
  const _VolunteerPaginationError({required this.error, required this.onRetry});

  /// Error raised by the previous loading attempt.
  final Object error;

  /// Callback for retrying the failed page.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorKey = error is OfflineDataUnavailableException
        ? 'application.error.offline_no_cache'
        : 'application.volunteer_database.load_more_error';

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Semantics(
        liveRegion: true,
        child: Column(
          children: [
            Text(
              errorKey.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text('application.error.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
