import 'package:app/common/pagination/offset_page.dart';

/// Loads one offset page using [skip] and [take].
typedef OffsetPageLoader<T> =
    Future<OffsetPage<T>> Function({required int skip, required int take});

/// Loads and combines all pages exposed by an offset-based data source.
Future<List<T>> loadAllOffsetPages<T>({
  required OffsetPageLoader<T> loadPage,
  required int pageSize,
}) async {
  if (pageSize <= 0) {
    throw ArgumentError.value(pageSize, 'pageSize');
  }

  final items = <T>[];
  var hasNextPage = true;

  while (hasNextPage) {
    final page = await loadPage(skip: items.length, take: pageSize);
    if (page.hasNextPage && page.items.isEmpty) {
      throw StateError('Pagination did not advance');
    }
    items.addAll(page.items);
    hasNextPage = page.hasNextPage;
  }

  return List.unmodifiable(items);
}
