/// Indicates that a network request failed and no cached data was available.
class OfflineDataUnavailableException implements Exception {
  /// Creates an offline data error caused by [cause].
  const OfflineDataUnavailableException(this.cause);

  /// Original network failure.
  final Object cause;
}
