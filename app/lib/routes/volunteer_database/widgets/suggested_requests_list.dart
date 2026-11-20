import 'package:app/common/connectivity/offline_data_unavailable_exception.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/pagination/offset_pagination_loader.dart';
import 'package:app/components/images/loading_image.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';
import 'package:app/routes/volunteer_database/providers/volunteer_marketplace_view_model.dart';
import 'package:app/routes/volunteer_database/views/volunteer_request_details_page.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_badge.dart';
import 'package:app/routes/volunteer_database/widgets/parts/volunteer_request_creator.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'parts/_suggested_request_card.dart';
part 'parts/_volunteer_pagination_error.dart';
part 'parts/_volunteer_pagination_loading.dart';

/// List of suggested volunteer requests or offers for logged-out users.
class SuggestedRequestsList extends ConsumerWidget {
  /// Creates a suggested requests list for the selected help type and category.
  ///
  /// When [maxItems] is set, only the first [maxItems] entries are shown.
  const SuggestedRequestsList({this.maxItems, super.key});

  /// Maximum number of items to display. When null, all items are shown.
  final int? maxItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final helpType = ref.watch(helpTypeProvider);
    final requestsAsync = ref.watch(
      volunteerMarketplaceViewModelProvider(maxItems),
    );

    final titleKey = helpType == HelpType.offerHelp
        ? 'application.volunteer_database.suggested_requests'
        : 'application.volunteer_database.suggested_offers';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKey.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: DesignTokens.gray500,
          ),
        ),
        const SizedBox(height: 12),
        requestsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Semantics(
              liveRegion: true,
              child: Column(
                children: [
                  Text(
                    (error is OfflineDataUnavailableException
                            ? 'application.error.offline_no_cache'
                            : 'application.volunteer_database.requests_error')
                        .tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(
                      volunteerMarketplaceViewModelProvider(maxItems),
                    ),
                    child: Text('application.error.retry'.tr()),
                  ),
                ],
              ),
            ),
          ),
          data: (pagination) {
            final filteredRequests = pagination.items;
            if (filteredRequests.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'application.volunteer_database.result_not_found'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            final displayRequests = maxItems == null
                ? filteredRequests
                : filteredRequests.take(maxItems!).toList();

            return Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayRequests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _SuggestedRequestCard(
                      request: displayRequests[index],
                    );
                  },
                ),
                if (maxItems == null &&
                    (pagination.hasNextPage ||
                        pagination.nextPageError != null))
                  OffsetPaginationLoader(
                    isLoading: pagination.isLoadingNextPage,
                    hasNextPage: pagination.hasNextPage,
                    loading: const _VolunteerPaginationLoading(),
                    error: pagination.nextPageError == null
                        ? null
                        : _VolunteerPaginationError(
                            error: pagination.nextPageError!,
                            onRetry: () => ref
                                .read(
                                  volunteerMarketplaceViewModelProvider(
                                    maxItems,
                                  ).notifier,
                                )
                                .loadNextPage(),
                          ),
                    onLoadMore: () => ref
                        .read(
                          volunteerMarketplaceViewModelProvider(
                            maxItems,
                          ).notifier,
                        )
                        .loadNextPage(),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
