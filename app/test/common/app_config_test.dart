import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/app_config/legacy/app_config_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const appConfig = AppConfig(
    backendUrl: 'https://testurl.at',
    kommuneId: '12435689',
    prozessPromptOnSkip: false,
    saveFieldValues: false,
  );

  group('AppConfig Migration tests', () {
    test('Test old AppConfig copyWith', () {
      final updated = appConfig.legacyCopyWith(
        saveFieldValues: true,
        prozessPromptOnSkip: true,
        kommuneId: '112233',
        backendUrl: 'https://testchangeurl.at',
      );

      expect(updated.saveFieldValues, true);
      expect(updated.prozessPromptOnSkip, true);
      expect(updated.kommuneId, '112233');
      expect(updated.backendUrl, 'https://testchangeurl.at');
    });

    test('Test new AppConfig copyWith', () {
      final updated = appConfig.copyWith(
        saveFieldValues: true,
        prozessPromptOnSkip: true,
        kommuneId: '112233',
        backendUrl: 'https://testchangeurl.at',
      );

      expect(updated.saveFieldValues, true);
      expect(updated.prozessPromptOnSkip, true);
      expect(updated.kommuneId, '112233');
      expect(updated.backendUrl, 'https://testchangeurl.at');
    });

    test('legacy vs new copyWith should match', () {
      final legacyCopy = appConfig.legacyCopyWith(
        saveFieldValues: true,
        prozessPromptOnSkip: true,
        kommuneId: '112233',
        backendUrl: 'https://testchangeurl.at',
      );
      final newCopy = appConfig.copyWith(
        saveFieldValues: true,
        prozessPromptOnSkip: true,
        kommuneId: '112233',
        backendUrl: 'https://testchangeurl.at',
      );

      _expectAppConfigEqual(newCopy, legacyCopy);
    });
  });
}

void _expectAppConfigEqual(AppConfig a, AppConfig b) {
  expect(a.saveFieldValues, b.saveFieldValues);
  expect(a.prozessPromptOnSkip, b.prozessPromptOnSkip);
  expect(a.kommuneId, b.kommuneId);
  expect(a.backendUrl, b.backendUrl);
}
