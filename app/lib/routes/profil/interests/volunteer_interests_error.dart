import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/routes/profil/interests/volunteer_interests_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays a retryable volunteer interest loading failure.
class VolunteerInterestsError extends ConsumerWidget {
  /// Creates an error state for [error].
  const VolunteerInterestsError({required this.error, super.key});

  /// Loading failure used to select the user-facing message.
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const basePath = 'application.profile.volunteer_interests';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Semantics(
          liveRegion: true,
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (error is OfflineDataUnavailableException
                        ? '$basePath.offline'
                        : '$basePath.error')
                    .tr(),
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: ref
                    .read(volunteerInterestsProvider.notifier)
                    .refresh,
                child: Text('$basePath.retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
