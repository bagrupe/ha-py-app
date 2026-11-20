import 'package:app/common/version_compatibility/app_semver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('compareAppReleaseVersions', () {
    test('equal versions', () {
      expect(compareAppReleaseVersions('1.0.2', '1.0.2'), 0);
    });

    test('ignores build metadata after +', () {
      expect(compareAppReleaseVersions('1.0.2+99', '1.0.2+1'), 0);
    });

    test('greater patch', () {
      expect(compareAppReleaseVersions('1.0.3', '1.0.2'), greaterThan(0));
      expect(compareAppReleaseVersions('1.0.2', '1.0.3'), lessThan(0));
    });

    test('missing segments default to zero', () {
      expect(compareAppReleaseVersions('2', '1.9.9'), greaterThan(0));
    });
  });

  group('isAppVersionCompatible', () {
    test('compatible when equal', () {
      expect(isAppVersionCompatible('1.0.2', '1.0.2'), isTrue);
    });

    test('compatible when newer', () {
      expect(isAppVersionCompatible('1.1.0', '1.0.2'), isTrue);
    });

    test('incompatible when older', () {
      expect(isAppVersionCompatible('1.0.1', '1.0.2'), isFalse);
    });

    test('incompatible when older', () {
      expect(isAppVersionCompatible('1.0.1+444', '1.0.2'), isFalse);
    });
  });
}
