import 'package:flutter/material.dart';

/// Adds application-specific typography styles to Flutter's [TextTheme].
extension AppTextTheme on TextTheme {
  /// Extra-small body text with a 14-pixel size and compact line height.
  TextStyle get bodyXSmall {
    return (bodySmall ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1,
      letterSpacing: 0,
    );
  }
}

/// Erweiterung für ThemeData zur Bereitstellung eines TextThemes mit angepasster Farbe.
extension ColorTextTheme on ThemeData {
  /// Gibt ein TextTheme zurück, das die Primärfarbe für Textanzeige und Körpertext verwendet.
  TextTheme get colorTextTheme {
    return textTheme.apply(displayColor: primaryColor, bodyColor: primaryColor);
  }
}
