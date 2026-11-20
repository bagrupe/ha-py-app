import 'package:app/common/volunteer_database/volunteer_repository.dart';
import 'package:app/routes/volunteer_database/providers/my_volunteer_requests_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Loads and paginates entries belonging to the authenticated user.
class MyVolunteerRequestsNotifier
    extends AsyncNotifier<MyVolunteerRequestsState> {
  static const int _pageSize = 50;

  @override
  Future<MyVolunteerRequestsState> build() async {
    final page = await ref
        .read(volunteerRepositoryProvider)
        .getMyRequestsPage(skip: 0, take: _pageSize);
    return MyVolunteerRequestsState(
      items: page.items,
      totalCount: page.totalCount,
      hasNextPage: page.hasNextPage,
    );
  }

  /// Loads and appends the next page when one is available.
  Future<void> loadNextPage() async {
    if (state.isLoading) return;
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
          .getMyRequestsPage(skip: current.items.length, take: _pageSize);
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          items: List.unmodifiable([...current.items, ...page.items]),
          totalCount: page.totalCount,
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

/// Provides the authenticated user's volunteer entries and total count.
final myVolunteerRequestsProvider =
    AsyncNotifierProvider<
      MyVolunteerRequestsNotifier,
      MyVolunteerRequestsState
    >(MyVolunteerRequestsNotifier.new);
