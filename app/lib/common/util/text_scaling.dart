import 'package:flutter/widgets.dart';

/// Provides reusable calculations for text-scaled layouts.
abstract final class TextScaling {
  /// Scales a line limit and rounds up to avoid hiding text.
  static int maxLines(BuildContext context, int lines) {
    return MediaQuery.textScalerOf(context).scale(lines.toDouble()).ceil();
  }
}
