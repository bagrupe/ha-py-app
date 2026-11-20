// ignore_for_file: parameter_assignments

import 'package:flutter/material.dart';

/// Wandelt einen Hex-Farbcode in ein [Color]-Objekt um.
/// [hexColor] ist der Farbcode als String, optional mit führendem '#'.
Color colorFromHex(String hexColor) {
  if (hexColor.startsWith('#')) {
    hexColor = hexColor.substring(1);
  }

  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }

  final asInt = int.parse(hexColor, radix: 16);

  return Color(asInt);
}
