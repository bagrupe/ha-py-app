import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/common/extensions/iterable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

/// Extension for String to convert to various byte representations.
extension StringToBytesExtension on String {
  /// Converts a hex encoded string to a byte list.
  Uint8List toHexBytes() => Uint8List.fromList(
    split('')
        .generatePairs()
        .map((pair) => int.parse(pair.$1 + pair.$2!, radix: 16))
        .toList(),
  );

  /// Encodes the string as UTF-8 and returns the byte list.
  Uint8List toUtf8Bytes() => Uint8List.fromList(utf8.encode(this));

  /// Decodes a base64 encoded string into a byte list.
  Uint8List toBase64Bytes() => base64Decode(this);
}

/// Extension for String to normalize keys (lowercase, umlauts).
extension NormalizeStringExtension on String {
  /// Normalizes the string for comparisons (lowercase, ä -> ae, etc.).
  String normalize() {
    var normalized = toLowerCase();
    for (final entry in {'ä': 'ae', 'ö': 'oe', 'ü': 'ue', 'ß': 'ss'}.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }
    // Special cases for synonym mapping
    if (normalized == 'adresszusatz') {
      return 'zusatz';
    }

    return normalized;
  }

  /// Checks if the string looks like an ISO date (e.g. 2026-02-05...).
  bool get isIsoDate {
    if (DateTime.tryParse(this) == null) return false;
    return contains('-') || contains('T');
  }

  /// Checks if the string looks like a German date (e.g. 05.02.2026).
  bool get isGermanDate {
    try {
      DateFormat('dd.MM.yyyy').parseStrict(this);
      return true;
    } on Exception {
      return false;
    }
  }

  /// Converts a German date string (dd.MM.yyyy) to ISO format (YYYY-MM-DD).
  String toIsoDate() {
    try {
      final date = DateFormat('dd.MM.yyyy').parseStrict(this);
      return DateFormat('yyyy-MM-dd').format(date);
    } on Exception {
      return this;
    }
  }

  /// removes whitespace to allow break in between words.
  /// Useful for one lined texts
  String spaceFreeString() {
    return replaceAll('', '\u200B');
  }

  /// Gets the size of the text with a given text style.
  Size sizeFromStyle(
    TextStyle style, {
    TextScaler? scaler,
    double availableSpace = double.infinity,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      textDirection: TextDirection.ltr,
      textScaler:
          scaler ??
          TextScaler.linear(
            PlatformDispatcher.instance.textScaleFactor.clamp(1, 2),
          ),
    )..layout(maxWidth: availableSpace);

    return textPainter.size;
  }

  /// Return the lines a text fills in a given space
  int linesFromStyle(
    TextStyle style, {
    required double availableSpace,
    TextScaler? scaler,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      textDirection: TextDirection.ltr,
      textScaler:
          scaler ??
          TextScaler.linear(
            PlatformDispatcher.instance.textScaleFactor.clamp(1, 2),
          ),
    )..layout(maxWidth: availableSpace);

    final lines = textPainter.size.height / textPainter.preferredLineHeight;

    return lines.ceil();
  }

  /// Uses Uppercase for the first letter of a String
  String toCapitalize() {
    final s = this;
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

/// Extension on nullable strings
extension NullStringExtension on String? {
  /// Returns true if the String? is whether null or empty
  bool get isNotEmptyOrNull => this != null && this!.isNotEmpty;

  /// Returns an IconCode from a String
  int get iconCodeFromString {
    if (this == null) return 0xf034e;

    return int.parse('0x$this');
  }

  /// Returns
  Color get colorFromHex {
    if (this == null) return Colors.black;

    final buffer = StringBuffer();
    if (this!.length == 6 || this!.length == 7) buffer.write('ff');
    buffer.write(this!.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Extension for Uint8List to convert to various string representations.
extension BytesToStringExtension on Uint8List {
  /// Decodes the byte list as a UTF-8 string.
  String toUtf8String() => utf8.decode(this);

  /// Encodes the byte list as a base64 string.
  String toBase64String() => base64Encode(this);

  /// Converts the byte list to a hexadecimal string.
  String toHexString() =>
      map((e) => e.toRadixString(16).padLeft(2, '0')).join();
}
