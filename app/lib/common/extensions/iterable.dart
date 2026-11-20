extension IterableExtension<T> on Iterable<T> {
  /// Returns the elements with the given separator inserted between them.
  List<T> joinWithElement(T separator) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return <T>[];

    final result = <T>[iterator.current];
    while (iterator.moveNext()) {
      result
        ..add(separator)
        ..add(iterator.current);
    }
    return result;
  }

  /// Returns pairs of consecutive elements.
  Iterable<(T first, T? second)> generatePairs() sync* {
    final it = iterator;

    while (it.moveNext()) {
      final first = it.current;
      final second = it.moveNext() ? it.current : null;
      yield (first, second);
    }
  }
}
