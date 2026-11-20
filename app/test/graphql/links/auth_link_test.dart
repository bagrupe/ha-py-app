import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/graphql/links/auth_link.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Offline implements Exception {}

class _FakeAuthLink extends HttpAuthLink {
  _FakeAuthLink(this.results) : super('http://localhost/graphql');

  final List<Future<String?> Function()> results;
  int calls = 0;

  @override
  Future<String?> fetchToken({
    required bool forceWeakLogin,
    String? failedToken,
  }) {
    return results[calls++]();
  }
}

Future<String?> _fail() => Future<String?>.error(_Offline());

class _HangingClient extends http.BaseClient {
  final _pending = <Completer<http.StreamedResponse>>[];
  bool closed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final answer = Completer<http.StreamedResponse>();
    _pending.add(answer);
    return answer.future;
  }

  @override
  void close() {
    closed = true;
    for (final answer in _pending.where((answer) => !answer.isCompleted)) {
      answer.completeError(http.ClientException('closed'));
    }
  }
}

class _InterruptedTokenWrite extends MapBase<String, String> {
  _InterruptedTokenWrite(Map<String, String> initial) : _data = {...initial};

  final Map<String, String> _data;

  @override
  String? operator [](Object? key) => _data[key];

  @override
  void operator []=(String key, String value) {
    if (key == secureStrongTokenKey && value == 'refreshed') {
      throw StateError('app killed while storing the session');
    }
    _data[key] = value;
  }

  @override
  void clear() => _data.clear();

  @override
  Iterable<String> get keys => _data.keys;

  @override
  String? remove(Object? key) => _data.remove(key);
}

const _weakLoginResponse = {
  'data': {
    '__typename': 'Mutation',
    'loginBuergerWeak': {
      '__typename': 'LoginBuergerWeakPayload',
      'loginPayload': {
        '__typename': 'LoginPayload',
        'result': 'SUCCESS',
        'token': 'weak',
      },
    },
  },
};

const _wrongLoginResponse = {
  'data': {
    '__typename': 'Mutation',
    'loginBuergerWeak': {
      '__typename': 'LoginBuergerWeakPayload',
      'loginPayload': {
        '__typename': 'LoginPayload',
        'result': 'WRONG_LOGIN',
        'token': null,
      },
    },
  },
};

http.Response _refreshed() => http.Response(
  jsonEncode({'token': 'refreshed', 'refreshToken': 'refreshed-r'}),
  200,
);

String jwt(String accountId) {
  final payload = base64Url.encode(
    utf8.encode(
      jsonEncode({
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier':
            accountId,
      }),
    ),
  );
  return 'header.$payload.signature';
}

void main() {
  test('a failed token fetch does not poison later attempts', () async {
    final link = _FakeAuthLink([_fail, () async => 'token']);

    await expectLater(link.updateToken(), throwsA(isA<_Offline>()));
    await link.updateToken();

    expect(link.calls, 2);
  });

  test('a failed forced weak login does not poison later attempts', () async {
    final link = _FakeAuthLink([_fail, () async => 'token']);

    await expectLater(
      link.updateToken(forceWeakLogin: true),
      throwsA(isA<_Offline>()),
    );
    await link.updateToken(forceWeakLogin: true);

    expect(link.calls, 2);
  });

  test('concurrent callers share one fetch and all see its result', () async {
    final completer = Completer<String?>();
    final link = _FakeAuthLink([() => completer.future]);
    final first = link.updateToken();
    final second = link.updateToken();

    completer.complete('token');
    await Future.wait([first, second]);

    expect(link.calls, 1);
  });

  test(
    'concurrent callers all fail with the same error, then recover',
    () async {
      final completer = Completer<String?>();
      final link = _FakeAuthLink([() => completer.future, () async => 'token']);
      final first = expectLater(link.updateToken(), throwsA(isA<_Offline>()));
      final second = expectLater(link.updateToken(), throwsA(isA<_Offline>()));

      completer.completeError(_Offline());
      await Future.wait([first, second]);
      await link.updateToken();

      expect(link.calls, 2);
    },
  );

  group('handleException', () {
    final request = Request(operation: Operation(document: parseString('{a}')));

    HttpLinkServerException serverError(int status, String code) {
      return HttpLinkServerException(
        response: http.Response('', status),
        parsedResponse: Response(
          response: const {},
          errors: [
            GraphQLError(message: 'x', extensions: {'code': code}),
          ],
        ),
      );
    }

    Future<int> forwardedAfter(HttpLinkServerException error) async {
      final link = _FakeAuthLink([() async => 'token']);
      var forwarded = 0;
      try {
        await link.handleException(request, (_) {
          forwarded++;
          return const Stream.empty();
        }, error).toList();
      } on HttpLinkServerException {
        return -link.calls;
      }
      expect(link.calls, 1);
      return forwarded;
    }

    test(
      'AUTH_NOT_AUTHORIZED with HTTP 500 refreshes the token and retries',
      () async {
        expect(
          await forwardedAfter(serverError(500, 'AUTH_NOT_AUTHORIZED')),
          1,
        );
      },
    );

    test('UNAUTHENTICATED still refreshes the token and retries', () async {
      expect(await forwardedAfter(serverError(500, 'UNAUTHENTICATED')), 1);
    });

    test('other server errors are rethrown without refreshing', () async {
      expect(await forwardedAfter(serverError(500, 'SOMETHING_ELSE')), 0);
    });
  });

  group('failed refresh of the strong token', () {
    Future<
      ({
        bool tokenKept,
        bool refreshKept,
        bool expiredReported,
        String? activeToken,
      })
    >
    run(
      http.Client client, {
      String token = 'strong',
      String? deviceAccount,
      bool hasRefreshToken = true,
    }) async {
      SharedPreferences.setMockInitialValues({
        if (deviceAccount != null) secureWeakLoginIdPrefsKey: deviceAccount,
      });
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: token,
        if (hasRefreshToken) secureStrongRefreshTokenKey: 'refresh',
      });
      var expiredReported = false;
      String? activeToken;
      final link = HttpAuthLink(
        'http://localhost/graphql',
        token,
        (value) => activeToken = value,
        () => expiredReported = true,
      );

      await http.runWithClient(
        () => link.updateToken(forceWeakLogin: true).catchError((_) {}),
        () => client,
      );

      const storage = FlutterSecureStorage();
      return (
        tokenKept: await storage.read(key: secureStrongTokenKey) != null,
        refreshKept:
            await storage.read(key: secureStrongRefreshTokenKey) != null,
        expiredReported: expiredReported,
        activeToken: activeToken,
      );
    }

    test('a network error keeps both tokens', () async {
      final result = await run(
        MockClient((_) async => throw http.ClientException('offline')),
      );

      expect(result.tokenKept, isTrue);
      expect(result.refreshKept, isTrue);
      expect(result.expiredReported, isFalse);
    });

    test('a 5xx response keeps both tokens', () async {
      final result = await run(MockClient((_) async => http.Response('', 503)));

      expect(result.tokenKept, isTrue);
      expect(result.refreshKept, isTrue);
      expect(result.expiredReported, isFalse);
    });

    test(
      'a transient failure keeps the session of another account active',
      () async {
        final token = jwt('verified');
        final result = await run(
          MockClient((_) async => http.Response('', 503)),
          token: token,
          deviceAccount: 'anonymous',
        );

        expect(result.activeToken, token);
        expect(result.tokenKept, isTrue);
      },
    );

    test(
      'a session without refresh token reports the account change',
      () async {
        final result = await run(
          MockClient((_) async => http.Response('', 500)),
          token: jwt('verified'),
          deviceAccount: 'anonymous',
          hasRefreshToken: false,
        );

        expect(result.tokenKept, isFalse);
        expect(result.expiredReported, isTrue);
      },
    );

    test('a session of the device account ends with a notice', () async {
      final result = await run(
        MockClient((_) async => http.Response('', 500)),
        token: jwt('device'),
        deviceAccount: 'device',
        hasRefreshToken: false,
      );

      expect(result.tokenKept, isFalse);
      expect(result.expiredReported, isTrue);
    });

    test('a 401 response removes both tokens and reports the expiry', () async {
      final result = await run(MockClient((_) async => http.Response('', 401)));

      expect(result.tokenKept, isFalse);
      expect(result.refreshKept, isFalse);
      expect(result.expiredReported, isTrue);
    });

    test('a refresh without an answer keeps both tokens', () async {
      final previous = strongSessionRequestTimeout;
      strongSessionRequestTimeout = const Duration(milliseconds: 50);
      addTearDown(() => strongSessionRequestTimeout = previous);
      final noAnswer = Completer<http.Response>();

      final result = await run(MockClient((_) => noAnswer.future));

      expect(result.tokenKept, isTrue);
      expect(result.refreshKept, isTrue);
      expect(result.expiredReported, isFalse);
    });

    test('a 400 response keeps both tokens', () async {
      final result = await run(MockClient((_) async => http.Response('', 400)));

      expect(result.tokenKept, isTrue);
      expect(result.refreshKept, isTrue);
      expect(result.expiredReported, isFalse);
    });

    test('a refresh without an answer is aborted', () async {
      final previous = strongSessionRequestTimeout;
      strongSessionRequestTimeout = const Duration(milliseconds: 50);
      addTearDown(() => strongSessionRequestTimeout = previous);
      final client = _HangingClient();

      final result = await run(client);

      expect(
        client.closed,
        isTrue,
        reason: 'a late arrival could look like reuse',
      );
      expect(result.tokenKept, isTrue);
      expect(result.expiredReported, isFalse);
    });
  });

  group('device account after a transient refresh failure', () {
    final request = Request(
      operation: Operation(document: parseString('query My { a }')),
    );
    final start = DateTime(2026, 11, 9, 12);
    final expiredToken = jwt('device');

    late List<http.Response Function()> refreshResponses;
    late int refreshCalls;
    late bool expiredReported;
    late String? activeToken;
    late DateTime now;
    late HttpAuthLink link;

    final client = MockClient((request) async {
      if (request.url.path.endsWith('/refresh')) {
        return refreshResponses[refreshCalls++]();
      }
      return http.Response(jsonEncode(_weakLoginResponse), 200);
    });

    Future<T> withClient<T>(Future<T> Function() body) =>
        http.runWithClient(body, () => client);

    Future<void> sendRequest() => withClient(
      () => link.request(request, (_) => const Stream.empty()).toList(),
    );

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        secureWeakLoginIdPrefsKey: 'device',
      });
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: expiredToken,
        secureStrongRefreshTokenKey: 'refresh',
        secureDerivedServerLoginPasswordKey: 'password',
      });
      refreshCalls = 0;
      expiredReported = false;
      now = start;
      link = HttpAuthLink(
        'http://localhost/graphql',
        expiredToken,
        (value) => activeToken = value,
        () => expiredReported = true,
      )..clock = () => now;
    });

    Future<void> failOnce() async {
      await withClient(() => link.updateToken(forceWeakLogin: true));
      expect(activeToken, 'weak');
    }

    test('it keeps working with the weak session', () async {
      refreshResponses = [() => http.Response('', 503)];
      await failOnce();

      await sendRequest();

      expect(refreshCalls, 1);
      expect(expiredReported, isFalse);
    });

    test('a later request restores the strong session', () async {
      refreshResponses = [
        () => http.Response('', 503),
        () => http.Response(jsonEncode({'token': 'fresh'}), 200),
      ];
      await failOnce();

      now = start.add(const Duration(seconds: 30));
      await sendRequest();

      expect(refreshCalls, 2);
      expect(activeToken, 'fresh');
      expect(expiredReported, isFalse);
      expect(
        await const FlutterSecureStorage().read(key: secureStrongTokenKey),
        'fresh',
      );
    });

    test('no retry once the strong session was removed', () async {
      refreshResponses = [() => http.Response('', 503)];
      await failOnce();
      await const FlutterSecureStorage().delete(key: secureStrongTokenKey);

      now = start.add(const Duration(hours: 1));
      await sendRequest();

      expect(refreshCalls, 1);
      expect(activeToken, 'weak');
      expect(expiredReported, isFalse);
    });

    test('repeated failures wait longer before the next retry', () async {
      refreshResponses = [
        () => http.Response('', 503),
        () => http.Response('', 503),
        () => http.Response(jsonEncode({'token': 'fresh'}), 200),
      ];
      await failOnce();

      now = start.add(const Duration(seconds: 30));
      await sendRequest();
      now = now.add(const Duration(seconds: 30));
      await sendRequest();
      expect(refreshCalls, 2);

      now = now.add(const Duration(seconds: 30));
      await sendRequest();
      expect(refreshCalls, 3);
      expect(activeToken, 'fresh');
    });

    test('a malformed retry response does not break the request', () async {
      refreshResponses = [
        () => http.Response('', 503),
        () => http.Response('not json', 200),
        () => http.Response(jsonEncode({'token': 'fresh'}), 200),
      ];
      await failOnce();

      now = start.add(const Duration(seconds: 30));
      await sendRequest();
      expect(activeToken, 'weak');

      now = now.add(const Duration(minutes: 1));
      await sendRequest();
      expect(activeToken, 'fresh');
    });

    test('a rejected retry ends the session with a notice', () async {
      refreshResponses = [
        () => http.Response('', 503),
        () => http.Response('', 401),
      ];
      await failOnce();

      now = start.add(const Duration(seconds: 30));
      await sendRequest();
      now = now.add(const Duration(hours: 1));
      await sendRequest();

      const storage = FlutterSecureStorage();
      expect(await storage.read(key: secureStrongTokenKey), isNull);
      expect(refreshCalls, 2);
      expect(activeToken, 'weak');
      expect(expiredReported, isTrue);
    });
  });

  test('an interrupted refresh keeps the new refresh token', () async {
    SharedPreferences.setMockInitialValues({});
    final oldToken = jwt('account');
    final storage = _InterruptedTokenWrite({
      secureStrongTokenKey: oldToken,
      secureStrongRefreshTokenKey: 'old-refresh',
    });
    FlutterSecureStorage.setMockInitialValues(storage);
    final link = HttpAuthLink('http://localhost/graphql', oldToken);

    await http.runWithClient(
      () => link.updateToken(forceWeakLogin: true).catchError((_) {}),
      () => MockClient(
        (_) async => http.Response(
          jsonEncode({'token': 'refreshed', 'refreshToken': 'refreshed-r'}),
          200,
        ),
      ),
    );

    expect(storage[secureStrongRefreshTokenKey], 'refreshed-r');
  });

  test('two links refreshing the same session share one request', () async {
    SharedPreferences.setMockInitialValues({});
    final oldToken = jwt('account');
    FlutterSecureStorage.setMockInitialValues({
      secureStrongTokenKey: oldToken,
      secureStrongRefreshTokenKey: 'old-refresh',
    });
    final firstLink = HttpAuthLink('http://localhost/graphql', oldToken);
    final secondLink = HttpAuthLink('http://localhost/graphql', oldToken);
    final response = Completer<http.Response>();
    var refreshRequests = 0;
    final revoked = <String>[];

    await http.runWithClient(
      () async {
        final refreshes = Future.wait([
          firstLink.updateToken(forceWeakLogin: true),
          secondLink.updateToken(forceWeakLogin: true),
        ]);
        await pumpEventQueue();
        response.complete(
          http.Response(
            jsonEncode({'token': 'refreshed', 'refreshToken': 'refreshed-r'}),
            200,
          ),
        );
        await refreshes;
        await pumpEventQueue();
      },
      () => MockClient((request) async {
        if (request.url.path.endsWith('/api/auth/session/revoke')) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          revoked.add(body['refreshToken'] as String);
          return http.Response('', 204);
        }
        refreshRequests++;
        return response.future;
      }),
    );

    const storage = FlutterSecureStorage();
    expect(refreshRequests, 1);
    expect(await storage.read(key: secureStrongRefreshTokenKey), 'refreshed-r');
    expect(await storage.read(key: secureStrongTokenKey), 'refreshed');
    expect(revoked, isEmpty);
  });

  test(
    'a link with an outdated token takes over the refreshed session',
    () async {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: 'old-token',
        secureStrongRefreshTokenKey: 'old-refresh',
      });
      String? secondToken;
      final first = HttpAuthLink('http://localhost/graphql', 'old-token');
      final second = HttpAuthLink(
        'http://localhost/graphql',
        'old-token',
        (token) => secondToken = token,
      );
      var refreshRequests = 0;

      await http.runWithClient(
        () async {
          await first.updateToken(forceWeakLogin: true);
          await second.updateToken(forceWeakLogin: true);
        },
        () => MockClient((_) async {
          refreshRequests++;
          return _refreshed();
        }),
      );

      expect(refreshRequests, 1);
      expect(secondToken, 'refreshed');
    },
  );

  test(
    'a link on the device login takes over a session stored meanwhile',
    () async {
      SharedPreferences.setMockInitialValues({
        secureWeakLoginIdPrefsKey: 'device',
      });
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: 'strong',
        secureStrongRefreshTokenKey: 'strong-refresh',
        secureDerivedServerLoginPasswordKey: 'password',
      });
      String? active;
      final link = HttpAuthLink(
        'http://localhost/graphql',
        'weak',
        (token) => active = token,
      );
      var requests = 0;

      await http.runWithClient(
        () => link.updateToken(forceWeakLogin: true),
        () => MockClient((_) async {
          requests++;
          return http.Response(jsonEncode(_weakLoginResponse), 200);
        }),
      );

      expect(active, 'strong');
      expect(requests, 0);
    },
  );

  test(
    'a removed session falls back to the device login without a notice',
    () async {
      SharedPreferences.setMockInitialValues({
        secureWeakLoginIdPrefsKey: 'device',
      });
      FlutterSecureStorage.setMockInitialValues({
        secureDerivedServerLoginPasswordKey: 'password',
      });
      String? active;
      var expired = false;
      final link = HttpAuthLink(
        'http://localhost/graphql',
        jwt('device'),
        (token) => active = token,
        () => expired = true,
      );

      await http.runWithClient(
        () => link.updateToken(forceWeakLogin: true),
        () => MockClient(
          (_) async => http.Response(jsonEncode(_weakLoginResponse), 200),
        ),
      );

      expect(active, 'weak');
      expect(expired, isFalse);
    },
  );

  group('session changes while a refresh is running', () {
    const storage = FlutterSecureStorage();
    late Completer<http.Response> response;
    late List<String> revoked;
    late http.Client client;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: 'old-token',
        secureStrongRefreshTokenKey: 'old-refresh',
      });
      response = Completer();
      addTearDown(() {
        if (!response.isCompleted) response.complete(http.Response('', 503));
      });
      revoked = [];
      client = MockClient((request) async {
        if (request.url.path.endsWith('/api/auth/session/revoke')) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          revoked.add(body['refreshToken'] as String);
          return http.Response('', 204);
        }
        return response.future;
      });
    });

    Future<void> duringRefresh(
      Future<void> Function() change,
      http.Response answer,
    ) => http.runWithClient(() async {
      final link = HttpAuthLink('http://localhost/graphql', 'old-token');
      final refresh = link.updateToken(forceWeakLogin: true).catchError((_) {});
      await pumpEventQueue();
      var changed = false;
      final changing = change().whenComplete(() => changed = true);
      await pumpEventQueue();

      expect(changed, isFalse, reason: 'must wait for the running refresh');

      response.complete(answer);
      await Future.wait([refresh, changing]);
      await pumpEventQueue();
    }, () => client);

    Future<void> login() => storeStrongSession(
      storage,
      token: 'login-token',
      refreshToken: 'login-refresh',
      backendUrl: () => 'http://localhost',
    );

    test('a login replaces the refreshed session', () async {
      await duringRefresh(login, _refreshed());

      expect(await storage.read(key: secureStrongTokenKey), 'login-token');
      expect(
        await storage.read(key: secureStrongRefreshTokenKey),
        'login-refresh',
      );
      expect(revoked, ['refreshed-r']);
    });

    test('a login is kept when the refresh is rejected', () async {
      await duringRefresh(login, http.Response('', 401));

      expect(await storage.read(key: secureStrongTokenKey), 'login-token');
      expect(
        await storage.read(key: secureStrongRefreshTokenKey),
        'login-refresh',
      );
      expect(revoked, isEmpty);
    });

    test('a logout removes the refreshed session', () async {
      await duringRefresh(
        () =>
            discardStrongSession(storage, backendUrl: () => 'http://localhost'),
        _refreshed(),
      );

      expect(await storage.read(key: secureStrongTokenKey), isNull);
      expect(await storage.read(key: secureStrongRefreshTokenKey), isNull);
      expect(revoked, ['refreshed-r']);
    });
  });

  test('a late 401 for an older token does not refresh again', () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({
      secureStrongTokenKey: 'current',
      secureStrongRefreshTokenKey: 'current-refresh',
    });
    final link = HttpAuthLink('http://localhost/graphql', 'current');
    final sentWithOlderToken = http.Request(
      'POST',
      Uri.parse('http://localhost/graphql'),
    )..headers['Authorization'] = 'Bearer older';
    var refreshes = 0;
    var forwarded = 0;

    await http.runWithClient(
      () => link.handleException(
        Request(operation: Operation(document: parseString('{a}'))),
        (_) {
          forwarded++;
          return const Stream.empty();
        },
        HttpLinkServerException(
          response: http.Response('', 401, request: sentWithOlderToken),
          parsedResponse: const Response(response: {}),
        ),
      ).toList(),
      () => MockClient((_) async {
        refreshes++;
        return _refreshed();
      }),
    );

    expect(refreshes, 0);
    expect(forwarded, 1);
  });

  group('a device login rejected after logging out everywhere', () {
    final rejecting = MockClient(
      (_) async => http.Response(jsonEncode(_wrongLoginResponse), 200),
    );

    setUp(() {
      SharedPreferences.setMockInitialValues({
        secureWeakLoginIdPrefsKey: 'device',
      });
      FlutterSecureStorage.setMockInitialValues({
        secureWeakLoginTokenPrefsKey: 'weak-login-token',
        secureDerivedServerLoginPasswordKey: 'password',
      });
    });

    test('ends the session instead of failing the request', () async {
      var rejected = 0;
      String? active = 'revoked';
      final link = HttpAuthLink(
        'http://localhost/graphql',
        'revoked',
        (token) => active = token,
        null,
        () => rejected++,
      );

      await http.runWithClient(
        () => link.updateToken(forceWeakLogin: true),
        () => rejecting,
      );

      expect(rejected, 1);
      expect(active, isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(secureWeakLoginIdPrefsKey), isNull);
    });

    test('also when the token is resolved without a failed request', () async {
      var rejected = 0;
      final link = HttpAuthLink(
        'http://localhost/graphql',
        null,
        null,
        null,
        () => rejected++,
      );

      await http.runWithClient(link.updateToken, () => rejecting);

      expect(rejected, 1);
    });
  });

  test(
    'a rejection for an identity replaced meanwhile keeps the new one',
    () async {
      SharedPreferences.setMockInitialValues({
        secureWeakLoginIdPrefsKey: 'device',
      });
      FlutterSecureStorage.setMockInitialValues({
        secureWeakLoginTokenPrefsKey: 'weak-login-token',
        secureDerivedServerLoginPasswordKey: 'password',
      });
      var rejected = 0;
      final link = HttpAuthLink(
        'http://localhost/graphql',
        'revoked',
        null,
        null,
        () => rejected++,
      );
      final replacing = MockClient((_) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(secureWeakLoginIdPrefsKey, 'new-device');
        await const FlutterSecureStorage().write(
          key: secureDerivedServerLoginPasswordKey,
          value: 'new-password',
        );
        return http.Response(jsonEncode(_wrongLoginResponse), 200);
      });

      await http.runWithClient(
        () => link.updateToken(forceWeakLogin: true),
        () => replacing,
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(secureWeakLoginIdPrefsKey), 'new-device');
      expect(
        await const FlutterSecureStorage().read(
          key: secureDerivedServerLoginPasswordKey,
        ),
        'new-password',
      );
      expect(rejected, 0);
    },
  );
}
