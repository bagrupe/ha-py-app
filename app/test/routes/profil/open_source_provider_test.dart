import 'package:app/routes/profil/open_source/open_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'bundled dependencies have unique names, complete licenses and sorted order',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final packages = await container.read(openSourcePackagesProvider.future);
      final names = packages.map((package) => package.name).toList();
      expect(
        names,
        containsAll(['flutter', 'flutter_riverpod', 'easy_localization']),
      );
      expect(names, isNot(contains('app')));
      expect(names.toSet(), hasLength(names.length));
      expect(
        packages.every((package) => package.license.trim().isNotEmpty),
        isTrue,
      );
      expect(
        packages
            .firstWhere((package) => package.name == 'flutter_riverpod')
            .version,
        isNotEmpty,
      );
      expect(
        names,
        orderedEquals(
          <String>[...names]
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
        ),
      );
    },
  );
}
