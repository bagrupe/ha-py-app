import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/components/common_app_bar/common_app_bar.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_request_details_provider.dart';
import 'package:app/routes/volunteer_database/widgets/details/volunteer_request_details_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detail page for a single volunteer request or offer.
class VolunteerRequestDetailsPage extends ConsumerWidget {
  /// Creates the volunteer request details page for [requestId].
  const VolunteerRequestDetailsPage({required this.requestId, super.key});

  /// Absolute route path template for the details page.
  static const path = '/ehrenamtsdatenbank/details/:id';

  /// ID of the volunteer request to display.
  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(volunteerRequestDetailsProvider(requestId));

    return Scaffold(
      appBar: CommonAppBar(
        title: Text('application.volunteer_database.title'.tr()),
      ),
      body: detailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Semantics(
              liveRegion: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (error is OfflineDataUnavailableException
                            ? 'application.error.offline_no_cache'
                            : 'application.volunteer_database.details.error')
                        .tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(
                      volunteerRequestDetailsProvider(requestId),
                    ),
                    child: Text('application.error.retry'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (details) => VolunteerRequestDetailsContent(details: details),
      ),
    );
  }
}
