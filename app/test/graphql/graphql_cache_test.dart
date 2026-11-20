import 'package:app/graphql/graphql_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('shouldClearGraphQLCache', () {
    final now = DateTime.utc(2026, 7, 24);

    test('keeps existing cache when timestamp is missing', () {
      expect(shouldClearGraphQLCache(lastClear: null, now: now), isFalse);
    });

    test('keeps cache when younger than 7 days', () {
      expect(
        shouldClearGraphQLCache(
          lastClear: now.subtract(const Duration(days: 6, hours: 23)),
          now: now,
        ),
        isFalse,
      );
    });

    test('clears when exactly 7 days old', () {
      expect(
        shouldClearGraphQLCache(
          lastClear: now.subtract(const Duration(days: 7)),
          now: now,
        ),
        isTrue,
      );
    });

    test('clears when older than 7 days', () {
      expect(
        shouldClearGraphQLCache(
          lastClear: now.subtract(const Duration(days: 8)),
          now: now,
        ),
        isTrue,
      );
    });
  });

  group('clearGraphQLCacheIfStale', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('preserves store and initializes timestamp when missing', () async {
      final prefs = await SharedPreferences.getInstance();
      var cleared = false;
      final now = DateTime.utc(2026, 7, 24);

      final didClear = await clearGraphQLCacheIfStale(
        prefs,
        clock: () => now,
        clearStore: () async {
          cleared = true;
        },
      );

      expect(didClear, isFalse);
      expect(cleared, isFalse);
      expect(
        prefs.getString(lastGraphQLCacheClearPrefsKey),
        now.toIso8601String(),
      );
    });

    test('preserves store and replaces an invalid timestamp', () async {
      SharedPreferences.setMockInitialValues({
        lastGraphQLCacheClearPrefsKey: 'invalid',
      });
      final prefs = await SharedPreferences.getInstance();
      var cleared = false;
      final now = DateTime.utc(2026, 7, 24);

      final didClear = await clearGraphQLCacheIfStale(
        prefs,
        clock: () => now,
        clearStore: () async {
          cleared = true;
        },
      );

      expect(didClear, isFalse);
      expect(cleared, isFalse);
      expect(
        prefs.getString(lastGraphQLCacheClearPrefsKey),
        now.toIso8601String(),
      );
    });

    test('skips clear when TTL has not expired', () async {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.utc(2026, 7, 24);
      final lastClear = now.subtract(const Duration(days: 3));
      await prefs.setString(
        lastGraphQLCacheClearPrefsKey,
        lastClear.toIso8601String(),
      );
      var cleared = false;

      final didClear = await clearGraphQLCacheIfStale(
        prefs,
        clock: () => now,
        clearStore: () async {
          cleared = true;
        },
      );

      expect(didClear, isFalse);
      expect(cleared, isFalse);
      expect(
        prefs.getString(lastGraphQLCacheClearPrefsKey),
        lastClear.toIso8601String(),
      );
    });

    test('clears and refreshes timestamp when TTL expired', () async {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.utc(2026, 7, 24);
      await prefs.setString(
        lastGraphQLCacheClearPrefsKey,
        now.subtract(const Duration(days: 7)).toIso8601String(),
      );
      var cleared = false;

      final didClear = await clearGraphQLCacheIfStale(
        prefs,
        clock: () => now,
        clearStore: () async {
          cleared = true;
        },
      );

      expect(didClear, isTrue);
      expect(cleared, isTrue);
      expect(
        prefs.getString(lastGraphQLCacheClearPrefsKey),
        now.toIso8601String(),
      );
    });
  });
}
