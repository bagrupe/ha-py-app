import 'package:app/common/extensions/iterable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('joinWithElement', () {
    test('returns an empty list for an empty iterable', () {
      expect(<int>[].joinWithElement(0), isEmpty);
    });

    test('returns the only element without a separator', () {
      expect(<int>[1].joinWithElement(0), <int>[1]);
    });

    test('inserts the separator only between elements', () {
      expect(<int>[1, 2, 3].joinWithElement(0), <int>[1, 0, 2, 0, 3]);
    });
  });
}
