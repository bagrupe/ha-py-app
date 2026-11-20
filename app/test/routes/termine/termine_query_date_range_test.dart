import 'package:app/routes/termine/common/termine_query_date_range.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies the stable date boundaries used by the appointment cache key.
void main() {
  test('keeps query boundaries stable throughout the local day', () {
    final morning = defaultTermineQueryDateRange(
      DateTime(2026, 8, 28, 7, 15, 12, 100),
    );
    final evening = defaultTermineQueryDateRange(
      DateTime(2026, 8, 28, 22, 48, 59, 900),
    );

    expect(evening, morning);
    expect(morning.from, DateTime.utc(2026, 8, 28));
    expect(
      morning.until,
      DateTime.utc(2027, 2, 25).subtract(const Duration(microseconds: 1)),
    );
  });

  test('moves query boundaries only when the local calendar day changes', () {
    final firstDay = defaultTermineQueryDateRange(
      DateTime(2026, 8, 28, 23, 59, 59),
    );
    final nextDay = defaultTermineQueryDateRange(DateTime(2026, 8, 29));

    expect(nextDay.from, firstDay.from.add(const Duration(days: 1)));
    expect(nextDay.until, firstDay.until.add(const Duration(days: 1)));
  });
}
