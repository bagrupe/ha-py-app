import 'dart:typed_data';

import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

/// Verifies wire compatibility after removing dynamic method calls.
void main() {
  test('serializes form locations through their JSON representation', () async {
    /// Location value emitted by the application form.
    const location = FormLocation(
      position: LatLng(52.1, 9.36),
      addressString: 'Test address',
    );

    expect(await toPlainSlotValue(location), location.toJson());
  });

  test(
    'preserves existing scalar, map, date and attachment encodings',
    () async {
      expect(await toPlainSlotValue({'answer': 42}), '{"answer":42}');
      expect(await toPlainSlotValue(null), 'null');
      expect(
        await toPlainSlotValue(DateTime.utc(2026)),
        '2026-01-01T00:00:00.000Z',
      );
      expect(
        await toPlainSlotValue([
          'text',
          42,
          true,
          XFile.fromData(Uint8List.fromList([1, 2, 3])),
        ]),
        ['text', 42, true, 'AQID'],
      );
    },
  );
}
