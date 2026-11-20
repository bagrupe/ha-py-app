/// Helpers for [NewsArtikelList] infinite scroll and GraphQL [fetchMore] merging.
/// Returns whether the news list should load the next page (scroll gate only).
///
/// Callers must still ensure [fetchMore] is non-null before invoking it.
bool shouldFetchNewsArtikelListNextPage({
  required bool isLoading,
  required bool isNearBottom,
  required bool? hasNextPage,
}) {
  if (isLoading || !isNearBottom) {
    return false;
  }
  if (hasNextPage == false) {
    return false;
  }
  return true;
}

/// Merges a [fetchMore] payload into the cached `NewsArtikelList` query data.
///
/// Mutates [fetchMoreResult] when merging (same contract as GraphQL [updateQuery]).
/// Returns [previousResult] when the fetch must not change the accumulated list.
Map<String, dynamic>? mergeNewsArtikelListFetchMoreData(
  Map<String, dynamic>? previousResult,
  Map<String, dynamic>? fetchMoreResult,
) {
  final prevMap = previousResult?['newsArtikelList'] as Map?;
  final moreMap = fetchMoreResult?['newsArtikelList'] as Map?;
  if (prevMap == null || moreMap == null) {
    if (prevMap != null && moreMap == null) {
      return previousResult;
    }
    return fetchMoreResult ?? previousResult;
  }

  final prevPage = prevMap['page'] as int?;
  final morePage = moreMap['page'] as int?;

  if (prevPage == null || morePage == null || morePage <= prevPage) {
    return previousResult;
  }

  final prevDocs = prevMap['docs'] as List? ?? const [];
  final moreDocs = moreMap['docs'] as List? ?? const [];

  if (moreDocs.isEmpty) {
    return previousResult;
  }

  final prevIds = prevDocs
      .map((e) => (e as Map?)?['id'] as String?)
      .whereType<String>()
      .toSet();
  final newOnly = moreDocs
      .where((e) => !prevIds.contains((e as Map?)?['id'] as String?))
      .toList();

  if (newOnly.isEmpty) {
    return previousResult;
  }

  moreMap['docs'] = <dynamic>[...prevDocs, ...newOnly];
  if (newOnly.length < moreDocs.length) {
    moreMap['hasNextPage'] = false;
  }

  return fetchMoreResult;
}
