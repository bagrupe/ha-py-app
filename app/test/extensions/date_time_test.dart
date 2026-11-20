import 'package:app/common/extensions/date_time.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helper/localization_helper.dart';

Future<void> main() async {
  setUpAll(() async {
    await TestLocalizationHelper.init();
  });

  final baseDate = DateTime(2024, 1, 1, 12);
  const defaultDateFormat = 'E dd.MM.';
  const restFormat = "HH:mm 'Uhr'";

  test('relative formatting', () {
    expect(
      baseDate.formatRelative(
        defaultDateFormat,
        restFormat,
        DateTime(2024, 1, 1, 14),
      ),
      equals('Heute 12:00 Uhr'),
    );

    expect(
      baseDate.formatRelative(
        defaultDateFormat,
        restFormat,
        DateTime(2024, 1, 2, 14),
      ),
      equals('Gestern 12:00 Uhr'),
    );

    expect(
      baseDate.formatRelative(
        defaultDateFormat,
        restFormat,
        DateTime(2024, 1, 3, 14),
      ),
      equals('Mo. 12:00 Uhr'),
    );

    expect(
      baseDate.formatRelative(
        defaultDateFormat,
        restFormat,
        DateTime(2024, 1, 10, 14),
      ),
      equals('Mo. 01.01. 12:00 Uhr'),
    );
  });
}
