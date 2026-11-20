import 'package:app/routes/aktuelles/common/legacy/text_sizer_legacy.dart';
import 'package:app/routes/aktuelles/common/text_sizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const textSize = TextSizeState(2);

  group('TextSizeState Migration tests', () {
    test('Test old TextSizeState copyWith', () {
      final updated = textSize.legacyCopyWith(textSizeModifier: 2.5);

      expect(updated.textSizeModifier, 2.5);
    });

    test('Test new TextSizeState copyWith', () {
      final updated = textSize.copyWith(textSizeModifier: 2.5);

      expect(updated.textSizeModifier, 2.5);
    });

    test('legacy vs new copyWith should match', () {
      final legacyCopy = textSize.legacyCopyWith(textSizeModifier: 2.5);
      final newCopy = textSize.copyWith(textSizeModifier: 2.5);

      expect(newCopy.textSizeModifier, legacyCopy.textSizeModifier);
    });
  });
}
