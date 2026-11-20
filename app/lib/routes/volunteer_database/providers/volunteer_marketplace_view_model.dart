import 'package:app/common/pagination/offset_pagination_state.dart';
import 'package:app/common/volunteer_database/volunteer_repository.dart';
import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';
import 'package:app/routes/volunteer_database/providers/help_type_provider.dart';
import 'package:app/routes/volunteer_database/providers/selected_category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads volunteer marketplace requests based on the active filter state.
class VolunteerMarketplaceViewModel
    extends AsyncNotifier<OffsetPaginationState<VolunteerRequestModel>> {
  /// Creates a marketplace loader with an optional result limit.
  VolunteerMarketplaceViewModel(this.maxItems);

  /// Maximum number of entries to load, or null to load all entries.
  final int? maxItems;

  /// Number of entries requested for each full-list page.
  static const int _pageSize = 50;

  @override
  Future<OffsetPaginationState<VolunteerRequestModel>> build() async {
    final helpType = ref.watch(helpTypeProvider);
    final categoryKey = ref.watch(selectedCategoryProvider);
    final repository = ref.watch(volunteerRepositoryProvider);
    final take = maxItems ?? _pageSize;

    final page = await repository.getRequestsPage(
      helpType: helpType,
      categoryKey: categoryKey,
      skip: 0,
      take: take,
    );
    return OffsetPaginationState(
      items: page.items,
      hasNextPage: maxItems == null && page.hasNextPage,
    );
  }

  /// Loads and appends the next available page.
  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || !current.hasNextPage || current.isLoadingNextPage) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingNextPage: true, clearNextPageError: true),
    );

    try {
      final page = await ref
          .read(volunteerRepositoryProvider)
          .getRequestsPage(
            helpType: ref.read(helpTypeProvider),
            categoryKey: ref.read(selectedCategoryProvider),
            skip: current.items.length,
            take: _pageSize,
          );
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          items: List.unmodifiable([...current.items, ...page.items]),
          hasNextPage: page.hasNextPage,
          isLoadingNextPage: false,
          clearNextPageError: true,
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(isLoadingNextPage: false, nextPageError: error),
      );
    }
  }
}

/// Provider for the volunteer marketplace request list.
final volunteerMarketplaceViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<
      VolunteerMarketplaceViewModel,
      OffsetPaginationState<VolunteerRequestModel>,
      int?
    >(VolunteerMarketplaceViewModel.new);
