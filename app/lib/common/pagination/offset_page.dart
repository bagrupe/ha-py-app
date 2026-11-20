/// One page returned by an offset-based data source.
class OffsetPage<T> {
  /// Creates an offset page containing [items].
  const OffsetPage({required this.items, required this.hasNextPage});

  /// Items contained in this page.
  final List<T> items;

  /// Whether another page is available after this page.
  final bool hasNextPage;
}
