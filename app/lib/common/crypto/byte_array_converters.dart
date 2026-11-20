// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:app/common/extensions/string.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:cross_file/cross_file.dart';

/// Typdefinition für eine Funktion, die einen Wert in ein Byte-Array konvertiert.
typedef ToByteArrayConverter = FutureOr<Uint8List> Function(dynamic value);

/// Konvertiert einen Wert in ein Byte-Array. Gibt ein leeres Array zurück, wenn der Wert null ist.
FutureOr<Uint8List> convertToByteArray(dynamic value) {
  if (value == null) return Uint8List(0);

  final converter = toByteArrayConverters[value.runtimeType];
  if (converter != null) return converter(value);

  return toByteArrayConverters[String]!('$value');
}

/// Map, die Typen zu ihren jeweiligen Konvertierungsfunktionen in Byte-Arrays zuordnet.
final Map<Type, ToByteArrayConverter> toByteArrayConverters = {
  String: (value) => (value as String).toUtf8Bytes(),
  List<dynamic>: (list) {
    final type = list[0].runtimeType;
    if (type == XFile) return toByteArrayConverters[XFile]!(list[0]);

    throw Exception('No converter for list of type $type');
  },
  XFile: (value) => (value as XFile).readAsBytes().then(
    (bytes) => bytes.toBase64String().toUtf8Bytes(),
  ),
};

/// Typdefinition für eine Funktion, die ein Byte-Array in einen Wert konvertiert.
typedef FromByteArrayConverter = FutureOr<dynamic> Function(Uint8List bytes);

/// Konvertiert ein Byte-Array in einen Wert des Typs T.
FutureOr<T> convertFromByteArray<T>(Uint8List bytes) {
  final converter = fromBytesConverters[T];
  if (converter != null) return converter(bytes) as FutureOr<T>;

  throw Exception('No converter for type $T');
}

/// Map, die Slot-Werttypen zu Dart-Typen zuordnet.
final Map<Enum_SlotValueType, Type> valueTypesToType = {
  Enum_SlotValueType.STRING: String,
  Enum_SlotValueType.UPLOAD: XFile,
};

/// Konvertiert ein Byte-Array entsprechend des angegebenen Slot-Werttyps in einen Wert.
FutureOr<dynamic> convertFromByteArrayToSlot(
  Uint8List bytes,
  Enum_SlotValueType valueType,
) {
  final type = valueTypesToType[valueType];
  final converter = fromBytesConverters[type];
  if (converter != null) return converter(bytes);

  throw Exception('No converter for SlotValueType $valueType');
}

/// Map, die Dart-Typen zu ihren jeweiligen Konvertierungsfunktionen aus Byte-Arrays zuordnet.
final Map<Type, FromByteArrayConverter> fromBytesConverters = {
  String: (bytes) => utf8.decode(bytes),
  XFile: (bytes) => XFile.fromData(bytes.toUtf8String().toBase64Bytes()),
};
