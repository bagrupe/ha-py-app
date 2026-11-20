import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/routes/termine/common/model/termin_list/legacy/termin_list_legacy.dart';
import 'package:app/routes/termine/common/model/termin_list/termin_list.dart';
import 'package:app/routes/termine/veranstaltungs_termin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final abfallTermin = Fragment_AbfallkalenderTermin(
    datum: '2024-01-15',
    fraktionId: 'f1',
    fraktion: 'Restmüll',
    turnus: 'weekly',
  );

  final veranstaltungsTermin = VeranstaltungsTermin(
    veranstaltungsId: 'v1',
    start: DateTime(2024, 1, 15, 10),
    end: DateTime(2024, 1, 15, 12),
    titel: 'Test Veranstaltung',
    subtitel: 'Subtitel',
    imageUrl: null,
    thumbnailImageUrl: null,
    termineOnSameDay: [],
  );

  final baseList = TermineList(
    veranstaltungen: [veranstaltungsTermin],
    abfallkalenderTermine: [abfallTermin],
  );

  group('TermineList Migration tests', () {
    test('Test old TermineList copyWith', () {
      final updated = baseList.legacyCopyWith(
        currentPage: 2,
        hasNextPage: true,
      );

      expect(updated.currentPage, 2);
      expect(updated.hasNextPage, true);
      expect(updated.veranstaltungen.length, 1);
      expect(updated.abfallkalenderTermine.length, 1);
    });

    test('Test new TermineList copyWith', () {
      final updated = baseList.copyWith(currentPage: 2, hasNextPage: true);

      expect(updated.currentPage, 2);
      expect(updated.hasNextPage, true);
      expect(updated.veranstaltungen.length, 1);
      expect(updated.abfallkalenderTermine.length, 1);
    });

    test('legacy vs new copyWith should match', () {
      final legacyCopy = baseList.legacyCopyWith(
        currentPage: 3,
        hasNextPage: true,
        veranstaltungen: [],
      );

      final newCopy = baseList.copyWith(
        currentPage: 3,
        hasNextPage: true,
        veranstaltungen: [],
      );

      _expectTermineListEqual(newCopy, legacyCopy);
    });
  });
}

void _expectTermineListEqual(TermineList a, TermineList b) {
  expect(a.currentPage, b.currentPage);
  expect(a.hasNextPage, b.hasNextPage);
  expect(a.veranstaltungen.length, b.veranstaltungen.length);
  expect(a.abfallkalenderTermine.length, b.abfallkalenderTermine.length);
}
