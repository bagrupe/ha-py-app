import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:app/routes/antraege/common/antrag_progress/legacy/antrag_progress_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final prozess = Fragment_ProzessOwnData(
    id: 'p1',
    name: 'Test Prozess',
    tags: [],
  );

  final prozessVersion = Fragment_ProzessVersionOwnData(id: 'pv1');

  final kommune = Fragment_KommuneCrypto();

  final baseProgress = AntragProgress(
    prozess: prozess,
    prozessVersion: prozessVersion,
    kommune: kommune,
    schritte: const [],
  );

  group('AntragProgress Migration tests', () {
    test('Test old AntragProgress copyWith', () {
      final updated = baseProgress.legacyCopyWith(
        index: 2,
        clientStatus: AntragClientStatus.confirming,
        slots: {'key': 'value'},
      );

      expect(updated.index, 2);
      expect(updated.clientStatus, AntragClientStatus.confirming);
      expect(updated.slots['key'], 'value');
      expect(updated.prozess.id, 'p1');
      expect(updated.prozessVersion.id, 'pv1');
    });

    test('Test new AntragProgress copyWith', () {
      final updated = baseProgress.copyWith(
        index: 2,
        clientStatus: AntragClientStatus.confirming,
        slots: {'key': 'value'},
      );

      expect(updated.index, 2);
      expect(updated.clientStatus, AntragClientStatus.confirming);
      expect(updated.slots['key'], 'value');
      expect(updated.prozess.id, 'p1');
      expect(updated.prozessVersion.id, 'pv1');
    });

    test('legacy vs new copyWith should match', () {
      final legacyCopy = baseProgress.legacyCopyWith(
        index: 3,
        clientStatus: AntragClientStatus.amending,
        slots: {'name': 'Hans'},
        slotErrors: {'name': null},
      );

      final newCopy = baseProgress.copyWith(
        index: 3,
        clientStatus: AntragClientStatus.amending,
        slots: {'name': 'Hans'},
        slotErrors: {'name': null},
      );

      _expectProgressEqual(newCopy, legacyCopy);
    });

    test('unmodified fields are preserved by both', () {
      final legacyCopy = baseProgress.legacyCopyWith(index: 1);
      final newCopy = baseProgress.copyWith(index: 1);

      expect(newCopy.prozess.id, legacyCopy.prozess.id);
      expect(newCopy.prozessVersion.id, legacyCopy.prozessVersion.id);
      expect(newCopy.clientStatus, legacyCopy.clientStatus);
      expect(newCopy.slots, legacyCopy.slots);
    });
  });
}

void _expectProgressEqual(AntragProgress a, AntragProgress b) {
  expect(a.index, b.index);
  expect(a.clientStatus, b.clientStatus);
  expect(a.slots, b.slots);
  expect(a.slotErrors, b.slotErrors);
  expect(a.prozess.id, b.prozess.id);
  expect(a.prozessVersion.id, b.prozessVersion.id);
}
