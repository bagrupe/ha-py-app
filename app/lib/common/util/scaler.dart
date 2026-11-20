import 'package:flutter/material.dart';

/// Helpers methods on [TextScaler]
extension ScaleExtension on TextScaler {
  /// Gets the current scale factor
  double get scaleFactor {
    return scale(10) / 10.0;
  }

  /// Linearly scales the input value by multiplying it with the implicit `scaleFactor`.
  double linearScale(double value) {
    return value * scaleFactor;
  }

  /// Gets whether the app is in A11Mode or not
  bool get isA11yMode => scaleFactor > 1;

  /// Gets whether the app's scaleFactor is above or equal 1.3
  bool get isAdvancedA11yMode => scaleFactor >= breakFactor;

  /// Break factor for most parts of the application
  double get breakFactor => 1.3;
}
