import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _BrokenStorage extends MapBase<String, String> {
  @override
  String? operator [](Object? key) => null;

  @override
  void operator []=(String key, String value) =>
      throw StateError('storage unavailable');

  @override
  void clear() {}

  @override
  Iterable<String> get keys => const [];

  @override
  String? remove(Object? key) => null;
}

void main() {
  const storage = FlutterSecureStorage();
  late List<String> revoked;
  late http.Client client;

  setUp(() {
    revoked = [];
    client = MockClient((request) async {
      if (request.url.path.endsWith('/api/auth/session/revoke')) {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        revoked.add(body['refreshToken'] as String);
      }
      return http.Response('', 204);
    });
  });

  Future<void> store({required String? refreshToken}) =>
      http.runWithClient(() async {
        await storeStrongSession(
          storage,
          token: 'new-token',
          refreshToken: refreshToken,
          backendUrl: () => 'http://localhost',
        );
        await pumpEventQueue();
      }, () => client);

  test('stores the token together with its refresh token', () async {
    FlutterSecureStorage.setMockInitialValues({});

    await store(refreshToken: 'new-refresh');

    expect(await storage.read(key: secureStrongTokenKey), 'new-token');
    expect(await storage.read(key: secureStrongRefreshTokenKey), 'new-refresh');
    expect(revoked, isEmpty);
  });

  test(
    'replaces and revokes the refresh token of the previous session',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: 'old-token',
        secureStrongRefreshTokenKey: 'old-refresh',
      });

      await store(refreshToken: 'new-refresh');

      expect(
        await storage.read(key: secureStrongRefreshTokenKey),
        'new-refresh',
      );
      expect(revoked, ['old-refresh']);
    },
  );

  test('a session without refresh token never keeps the old one', () async {
    FlutterSecureStorage.setMockInitialValues({
      secureStrongTokenKey: 'old-token',
      secureStrongRefreshTokenKey: 'old-refresh',
    });

    await store(refreshToken: null);

    expect(await storage.read(key: secureStrongTokenKey), 'new-token');
    expect(await storage.read(key: secureStrongRefreshTokenKey), isNull);
    expect(revoked, ['old-refresh']);
  });

  test('a failed revoke does not affect the stored session', () async {
    FlutterSecureStorage.setMockInitialValues({
      secureStrongRefreshTokenKey: 'old-refresh',
    });
    client = MockClient((_) async => throw http.ClientException('offline'));

    await store(refreshToken: 'new-refresh');

    expect(await storage.read(key: secureStrongTokenKey), 'new-token');
    expect(await storage.read(key: secureStrongRefreshTokenKey), 'new-refresh');
  });

  test('a failed revoke never logs the token', () async {
    FlutterSecureStorage.setMockInitialValues({
      secureStrongRefreshTokenKey: 'old-refresh-secret',
    });
    client = MockClient(
      (request) async => throw http.ClientException(request.body),
    );
    final printed = <String>[];
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) => printed.add(message ?? '');
    addTearDown(() => debugPrint = original);

    await store(refreshToken: 'new-refresh');

    expect(printed.join('\n'), isNot(contains('old-refresh-secret')));
  });

  test(
    'discarding a session removes it and revokes its refresh token',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: 'old-token',
        secureStrongRefreshTokenKey: 'old-refresh',
      });

      await http.runWithClient(() async {
        await discardStrongSession(
          storage,
          backendUrl: () => 'http://localhost',
        );
        await pumpEventQueue();
      }, () => client);

      expect(await storage.read(key: secureStrongTokenKey), isNull);
      expect(await storage.read(key: secureStrongRefreshTokenKey), isNull);
      expect(revoked, ['old-refresh']);
    },
  );

  test('discarding without a refresh token sends nothing', () async {
    FlutterSecureStorage.setMockInitialValues({
      secureStrongTokenKey: 'old-token',
    });

    await http.runWithClient(() async {
      await discardStrongSession(storage, backendUrl: () => 'http://localhost');
      await pumpEventQueue();
    }, () => client);

    expect(await storage.read(key: secureStrongTokenKey), isNull);
    expect(revoked, isEmpty);
  });

  test('a failed operation does not block the next one', () async {
    FlutterSecureStorage.setMockInitialValues(_BrokenStorage());
    await expectLater(store(refreshToken: 'new-refresh'), throwsStateError);
    FlutterSecureStorage.setMockInitialValues({});

    await store(
      refreshToken: 'new-refresh',
    ).timeout(const Duration(seconds: 2));

    expect(await storage.read(key: secureStrongTokenKey), 'new-token');
  });

  test('a logout waits for the revoke, but only until the timeout', () async {
    final previous = strongSessionRequestTimeout;
    strongSessionRequestTimeout = const Duration(milliseconds: 50);
    addTearDown(() => strongSessionRequestTimeout = previous);
    FlutterSecureStorage.setMockInitialValues({
      secureStrongTokenKey: 'old-token',
      secureStrongRefreshTokenKey: 'old-refresh',
    });
    final noAnswer = Completer<http.Response>();
    var revokeSent = false;

    await http
        .runWithClient(
          () => discardStrongSession(
            storage,
            backendUrl: () => 'http://localhost',
            waitForRevoke: true,
          ),
          () => MockClient((_) {
            revokeSent = true;
            return noAnswer.future;
          }),
        )
        .timeout(const Duration(seconds: 2));

    expect(revokeSent, isTrue);
    expect(await storage.read(key: secureStrongTokenKey), isNull);
    expect(await storage.read(key: secureStrongRefreshTokenKey), isNull);
  });

  test('an activated session is stored and used by a new client', () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          await SharedPreferences.getInstance(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final before = container.read(graphqlClientProvider);

    await activateStrongSession(
      container,
      token: 'new-token',
      refreshToken: 'new-refresh',
    );

    expect(container.read(graphqlClientProvider), isNot(same(before)));
    expect(await storage.read(key: secureStrongTokenKey), 'new-token');
    expect(await storage.read(key: secureStrongRefreshTokenKey), 'new-refresh');
  });

  test('installed apps find their session under the stored names', () {
    expect(secureStrongTokenKey, 'bundid_token');
    expect(secureStrongRefreshTokenKey, 'bundid_refresh_token');
  });

  test('a session is renewed and ended at the session endpoints', () async {
    FlutterSecureStorage.setMockInitialValues({
      secureStrongTokenKey: 'stale-token',
      secureStrongRefreshTokenKey: 'old-refresh',
    });
    final paths = <String>[];

    await http.runWithClient(
      () async {
        await refreshStrongSession(
          storage,
          staleTokens: {'stale-token'},
          backendUrl: 'http://localhost',
        );
        await discardStrongSession(
          storage,
          backendUrl: () => 'http://localhost',
          waitForRevoke: true,
        );
      },
      () => MockClient((request) async {
        paths.add(request.url.path);
        return request.url.path.endsWith('/refresh')
            ? http.Response(
                jsonEncode({
                  'token': 'new-token',
                  'refreshToken': 'new-refresh',
                }),
                200,
              )
            : http.Response('', 204);
      }),
    );

    expect(paths, ['/api/auth/session/refresh', '/api/auth/session/revoke']);
  });
}
