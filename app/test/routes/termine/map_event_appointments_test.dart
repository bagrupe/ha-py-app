import 'package:app/graphql/__generated__/termine.graphql.dart';
import 'package:app/routes/termine/common/map_event_appointments.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a backend occurrence with optional import edge cases.
Query_TermineList_veranstaltungsTermine_docs _document({
  String? id = 'homepage-1',
  String? start = '2026-12-10T18:00:00Z',
  String? end,
  String title = 'Homepage event',
}) => Query_TermineList_veranstaltungsTermine_docs(
  id: id,
  start: start,
  end: end,
  titel: title,
  locationName: 'Kreishaus',
  subtitle: 'Subtitle',
);

void main() {
  test('uses the imported location and start when no end is supplied', () {
    final occurrence = mapEventAppointments([_document()]).single;
    expect(occurrence.subtitel, 'Kreishaus');
    expect(occurrence.start, DateTime.utc(2026, 12, 10, 18));
    expect(occurrence.end, occurrence.start);
  });

  test('rejects missing identity and invalid starts', () {
    expect(
      mapEventAppointments([
        _document(id: null),
        _document(id: ''),
        _document(start: null),
        _document(start: 'invalid'),
      ]),
      isEmpty,
    );
  });

  test('overlapping pages replace an occurrence with the latest data', () {
    final firstPage = mapEventAppointments([_document()]);
    final nextPage = mapEventAppointments([
      _document(title: 'Updated title'),
      _document(start: '2026-12-11T18:00:00Z'),
      _document(id: 'homepage-2'),
    ]);
    final merged = mergeEventAppointments([...firstPage, ...nextPage]);
    expect(merged, hasLength(3));
    expect(merged.first.titel, 'Updated title');
  });

  test('equivalent time zones identify the same occurrence', () {
    final occurrences = mapEventAppointments([
      _document(),
      _document(start: '2026-12-10T19:00:00+01:00'),
    ]);
    expect(occurrences, hasLength(1));
  });
}
