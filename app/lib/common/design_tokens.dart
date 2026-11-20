import 'dart:ui';

abstract final class DesignTokens {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0XFFFBFBFB);
  static const Color gray100 = Color(0xFFF1F1F1);
  static const Color gray300 = Color(0xFFD1D1D1);
  static const Color gray500 = Color(0xFF818181);
  static const Color gray700 = Color(0xFF6A6A6A);
  static const Color gray900 = Color(0xFF4E4E4E);

  static const Color green100 = Color(0xFFC9E7AF);
  static const Color green200 = Color(0xFFDAEFA7);
  static const Color green500 = Color(0xFF67A83A);
  static const Color green900 = Color(0xFF2E4621);

  static const Color orange100 = Color(0xFFFEE2AA);
  static const Color orange500 = Color(0xFFF9931B);
  static const Color orange900 = Color(0xFF7C3B12);

  static const Color yellow100 = Color(0xFFFFECB3);
  static const Color yellow500 = Color(0xFFFFC107);
  static const Color yellow900 = Color(0xFF7C5A00);

  static const Color red200 = Color(0xFFFEC1AA);
  static const Color red500 = Color(0xFFF93C1A);
  static const Color red900 = Color(0xFF7C1212);

  /// Status colors specifically for the four danger zones in the sensor gauge
  /// chart. Deliberately differ from green500/red500, since the Figma export
  /// specifies them exactly like this (not identical to the existing accent
  /// color scale).
  static const Color statusGreen500 = Color(0xFF4CAF50);
  static const Color statusYellow500 = yellow500;
  static const Color statusOrange500 = orange500;
  static const Color statusRed500 = Color(0xFFBA1A1A);

  static const Color blue200 = Color(0xFFC1DCF6);
  static const Color blue500 = Color(0xFF15579D);
  static const Color blue900 = Color(0xFF163A64);
}
