/// Immutable state for an incrementally loaded offset-based list.
class OffsetPaginationState<T> {
  /// Creates pagination state for [items].
  const OffsetPaginationState({
    required this.items,
    required this.hasNextPage,
    this.isLoadingNextPage = false,
    this.nextPageError,
  });

  /// All items loaded so far.
  final List<T> items;

  /// Whether another backend page is available.
  final bool hasNextPage;

  /// Whether the next page is currently loading.
  final bool isLoadingNextPage;

  /// Error raised while loading the next page without discarding current data.
  final Object? nextPageError;

  /// Returns updated immutable pagination state.
  OffsetPaginationState<T> copyWith({
    List<T>? items,
    bool? hasNextPage,
    bool? isLoadingNextPage,
    Object? nextPageError,
    bool clearNextPageError = false,
  }) {
    return OffsetPaginationState(
      items: items ?? this.items,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      nextPageError: clearNextPageError
          ? null
          : nextPageError ?? this.nextPageError,
    );
  }
}
