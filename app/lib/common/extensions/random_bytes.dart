import 'dart:math';
import 'dart:typed_data';

/// Erweiterung für Random zur Erzeugung einer Liste zufälliger Bytes.
extension RandomBytesExtension on Random {
  /// Erzeugt eine Liste von zufälligen Bytes mit der angegebenen Länge.
  ///
  /// [count] gibt die Anzahl der zu erzeugenden Bytes an.
  Uint8List nextBytes(int count) {
    final values = List.generate(count, (_) => nextInt(256));

    return Uint8List.fromList(values);
  }
}
