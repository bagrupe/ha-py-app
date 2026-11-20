import 'package:app/routes/volunteer_database/models/volunteer_request_model.dart';

/// Immutable state of the authenticated user's volunteer entries.
class MyVolunteerRequestsState {
  /// Creates the state for the user's volunteer entries.
  const MyVolunteerRequestsState({
    required this.items,
    required this.totalCount,
    required this.hasNextPage,
    this.isLoadingNextPage = false,
    this.nextPageError,
  });

  /// Currently loaded entries.
  final List<VolunteerRequestModel> items;

  /// Total entry count reported by the backend.
  final int totalCount;

  /// Whether another page is available.
  final bool hasNextPage;

  /// Whether the next page is currently loading.
  final bool isLoadingNextPage;

  /// Error produced while loading the next page.
  final Object? nextPageError;

  /// Returns an updated immutable state.
  MyVolunteerRequestsState copyWith({
    List<VolunteerRequestModel>? items,
    int? totalCount,
    bool? hasNextPage,
    bool? isLoadingNextPage,
    Object? nextPageError,
    bool clearNextPageError = false,
  }) {
    return MyVolunteerRequestsState(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      nextPageError: clearNextPageError
          ? null
          : nextPageError ?? this.nextPageError,
    );
  }
}
