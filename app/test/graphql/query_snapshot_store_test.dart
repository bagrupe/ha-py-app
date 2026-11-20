import 'package:app/graphql/query_snapshot_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies stable keys and in-memory query snapshot behavior.
void main() {
  setUp(useInMemoryQuerySnapshotStore);

  test('creates the same key for differently ordered variables', () {
    final first = createQuerySnapshotKey(
      namespace: 'test',
      variables: {
        'second': 2,
        'first': {
          'beta': true,
          'alpha': ['a', 'b'],
        },
      },
    );
    final second = createQuerySnapshotKey(
      namespace: 'test',
      variables: {
        'first': {
          'alpha': ['a', 'b'],
          'beta': true,
        },
        'second': 2,
      },
    );

    expect(first, second);
  });

  test('keeps keys below the Hive string key limit', () {
    final key = createQuerySnapshotKey(
      namespace: 'termine',
      variables: {
        'search': List.filled(1000, 'very-long-value').join(),
        'filters': List.generate(100, (index) => 'filter-$index'),
      },
    );

    expect(key.length, lessThanOrEqualTo(255));
  });

  test('creates different keys for different variables', () {
    final first = createQuerySnapshotKey(
      namespace: 'termine',
      variables: const {'page': 1},
    );
    final second = createQuerySnapshotKey(
      namespace: 'termine',
      variables: const {'page': 2},
    );

    expect(first, isNot(second));
  });

  test('writes and decodes a complete query response', () async {
    const key = 'test:snapshot';
    await writeQuerySnapshot(key, {'__typename': 'Query', 'value': 'cached'});

    final value = readQuerySnapshot(key, (data) => data['value'] as String);

    expect(value, 'cached');
  });

  test('removes a snapshot that cannot be decoded', () async {
    const key = 'test:invalid';
    await writeQuerySnapshot(key, {'value': 1});

    final invalid = readQuerySnapshot(key, (data) => data['value'] as String);
    final removed = readQuerySnapshot(key, (data) => data);

    expect(invalid, isNull);
    expect(removed, isNull);
  });
}
