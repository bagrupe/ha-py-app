part of '../my_volunteer_requests_list.dart';

/// Displays a localized loading failure with a retry action.
class _MyRequestsError extends ConsumerWidget {
  /// Creates an error message for the failed request.
  const _MyRequestsError({required this.error});

  /// Failure returned by the repository.
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = error is OfflineDataUnavailableException
        ? 'application.error.offline_no_cache'
        : 'application.volunteer_database.my_requests.error';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Semantics(
          liveRegion: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message.tr(), textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.invalidate(myVolunteerRequestsProvider),
                child: Text('application.error.retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
