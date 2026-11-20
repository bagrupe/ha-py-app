import 'package:flutter/widgets.dart';

/// Extension on [ScrollMetrics] to provide helper methods for scroll positions.
extension ScrollMetricsExtension on ScrollMetrics {
  /// Returns true if the current scroll position is at or beyond 70% of the maximum scroll extent.
  bool get isNearBottom => pixels >= maxScrollExtent * 0.7;
}
