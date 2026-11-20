import 'dart:typed_data';

import 'package:app/common/expressions/evaluating_visitor_service.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:app/graphql/__generated__/prozess.graphql.dart';
import 'package:app/routes/antraege/common/antrag_progress/antrag_progress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeEvaluatingVisitorService extends Fake
    implements EvaluatingVisitorService {}

void main() {
  test(
    'keeps the running Antrag when evaluatingVisitorProvider rebuilds',
    () async {
      final container = ProviderContainer(
        overrides: [
          evaluatingVisitorProvider.overrideWith(
            (ref) => _FakeEvaluatingVisitorService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final prozess = Fragment_ProzessOwnData(id: 'p1', name: 'Test', tags: []);
      final notifier = container.read(antragProgressProvider.notifier)
        ..startProzess(
          kommune: Fragment_KommuneCrypto(),
          prozess: prozess,
          prozessVersion: Fragment_ProzessVersion(
            id: 'pv1',
            ersteSchritte: const [],
            prozess: prozess,
          ),
        );
      await notifier.convertStateToInputs(Uint8List(32));

      container
        ..invalidate(evaluatingVisitorProvider)
        ..read(evaluatingVisitorProvider);

      expect(container.read(antragProgressProvider), isNotNull);
    },
  );
}
