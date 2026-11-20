import 'dart:async';
import 'dart:convert';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/crypto/crypto.dart';
import 'package:app/common/extensions/string.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart'
    show possibleTypesMap;
import 'package:app/graphql/graphql_client.dart';
import 'package:app/graphql/query_snapshot_store.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gql/ast.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pointycastle/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _iterations = 1000;

typedef _Account = ({Map<String, dynamic> my, String privateKey});

String _jwt(String accountId) {
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

Future<_Account> _account({
  required String keyPassword,
  String id = 'remote',
  bool hasKeyEscrow = false,
  bool isVerified = true,
}) async {
  final random = FortunaRandom()..seed(KeyParameter(Crypto.getRandomKey()));
  final keyPair = Crypto.generateRsaKey(random);
  final (encryptedKey, salt) = await Crypto.encryptPersonalKey(
    keyPassword,
    keyPair.privateKey,
    _iterations,
  );
  final publicKey = CryptoUtils.getBytesFromPEMString(
    CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey),
  ).toBase64String();

  return (
    my: {
      '__typename': 'Buerger',
      'id': id,
      'publicKey': publicKey,
      'personalPrivateKey': {
        '__typename': 'EncryptedValue',
        'nonce': encryptedKey.nonce,
        'tag': encryptedKey.tag,
        'cipher': encryptedKey.cipher,
      },
      'personalPrivateKeySalt': salt.toBase64String(),
      'personalDataKey': Crypto.wrapKey(
        Crypto.getRandomKey(),
        keyPair.publicKey,
      ),
      'hasKeyEscrow': hasKeyEscrow,
      'hasBundId': false,
      'phoneVerified': isVerified,
    },
    privateKey: CryptoUtils.getBytesFromPEMString(
      CryptoUtils.encodeRSAPrivateKeyToPem(keyPair.privateKey),
    ).toBase64String(),
  );
}

typedef _Harness = ({
  ProviderContainer container,
  List<String> operations,
  List<String> uploadedKeys,
  void Function(Map<String, dynamic>? my) setRemoteAccount,
});

Future<_Harness> _harness(
  _Account account, {
  bool strongSession = true,
  String? escrowKey,
  bool failUpload = false,
  Map<String, String> extraSecureValues = const {},
}) async {
  SharedPreferences.setMockInitialValues({secureWeakLoginIdPrefsKey: 'local'});
  FlutterSecureStorage.setMockInitialValues({
    secureWeakLoginTokenPrefsKey: 'local-weak-token',
    securePasswordDerivationIterationCountKey: '$_iterations',
    if (strongSession) secureStrongTokenKey: 'strong',
    ...extraSecureValues,
  });
  final operations = <String>[];
  final uploadedKeys = <String>[];
  Map<String, dynamic>? remoteAccount = account.my;
  final client = GraphQLClient(
    cache: GraphQLCache(possibleTypes: possibleTypesMap),
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.cacheAndNetwork),
    ),
    link: Link.function((request, [forward]) async* {
      final name = request.operation.document.definitions
          .whereType<OperationDefinitionNode>()
          .first
          .name!
          .value;
      operations.add(name);
      yield switch (name) {
        'My' when remoteAccount == null => const Response(
          errors: [GraphQLError(message: 'offline')],
          response: {},
        ),
        'My' => Response(
          data: {'__typename': 'Query', 'my': remoteAccount},
          response: const {},
        ),
        'KeyEscrow' => Response(
          data: {'__typename': 'Query', 'keyEscrow': escrowKey},
          response: const {},
        ),
        'StoreKeyEscrow' when failUpload => const Response(
          errors: [GraphQLError(message: 'upload failed')],
          response: {},
        ),
        'StoreKeyEscrow' => () {
          final input = request.variables['input']! as Map<String, dynamic>;
          uploadedKeys.add(input['privateKey'] as String);
          return const Response(
            data: {
              '__typename': 'Mutation',
              'storeKeyEscrow': {
                '__typename': 'StoreKeyEscrowPayload',
                'boolean': true,
              },
            },
            response: {},
          );
        }(),
        'WeakRegister' => const Response(
          data: {
            '__typename': 'Mutation',
            'registerBuergerWeak': {
              '__typename': 'RegisterBuergerWeakPayload',
              'buergerId': 'registered',
            },
          },
          response: {},
        ),
        _ => throw StateError('unexpected operation $name'),
      };
    }),
  );
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(
        await SharedPreferences.getInstance(),
      ),
      graphqlClientProvider.overrideWithValue(client),
    ],
  );
  addTearDown(container.dispose);
  return (
    container: container,
    operations: operations,
    uploadedKeys: uploadedKeys,
    setRemoteAccount: (Map<String, dynamic>? my) => remoteAccount = my,
  );
}

Future<AuthState> _settled(ProviderContainer container) {
  final completer = Completer<AuthState>();
  container
    ..listen(asyncAuthProvider, (_, next) {
      if (next is AsyncError && !completer.isCompleted) {
        completer.completeError(next.error!, next.stackTrace);
      }
    })
    ..listen(authProvider, (_, next) {
      if (next.publicKey != null && !completer.isCompleted) {
        completer.complete(next);
      }
    }, fireImmediately: true);
  return completer.future;
}

Future<AuthState> _settledFor(ProviderContainer container, String accountId) {
  final completer = Completer<AuthState>();
  container.listen(authProvider, (_, next) {
    if (next.publicKey != null &&
        next.buergerId == accountId &&
        !completer.isCompleted) {
      completer.complete(next);
    }
  }, fireImmediately: true);
  return completer.future.timeout(const Duration(seconds: 5));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('account matches the device login', () {
    test(
      'returns all keys and uploads the key when no escrow exists',
      () async {
        final account = await _account(keyPassword: 'local-weak-token');
        final harness = await _harness(account);

        final state = await _settled(harness.container);

        expect(state.privateKey, isNotNull);
        expect(state.personalDataKey, isNotNull);
        expect(state.buergerId, 'remote');
        expect(harness.uploadedKeys, [account.privateKey]);
      },
    );

    test('does not upload again when an escrow already exists', () async {
      final account = await _account(
        keyPassword: 'local-weak-token',
        hasKeyEscrow: true,
      );
      final harness = await _harness(account);

      await _settled(harness.container);

      expect(harness.operations, isNot(contains('StoreKeyEscrow')));
    });

    test('does not upload for an unverified account', () async {
      final account = await _account(
        keyPassword: 'local-weak-token',
        isVerified: false,
      );
      final harness = await _harness(account);

      final state = await _settled(harness.container);

      expect(state.privateKey, isNotNull);
      expect(harness.operations, isNot(contains('StoreKeyEscrow')));
    });

    test('uploads for a verified account without a strong session', () async {
      final account = await _account(keyPassword: 'local-weak-token');
      final harness = await _harness(account, strongSession: false);

      await _settled(harness.container);

      expect(harness.uploadedKeys, [account.privateKey]);
    });
  });

  group('account does not match the device login', () {
    test(
      'restores the key from the escrow and stores it for the account',
      () async {
        final account = await _account(keyPassword: 'other-device-token');
        final harness = await _harness(account, escrowKey: account.privateKey);

        final state = await _settled(harness.container);

        expect(state.privateKey, isNotNull);
        expect(state.personalDataKey, isNotNull);
        expect(state.buergerId, 'remote');
        expect(
          await const FlutterSecureStorage().read(key: secureRestoredKeyKey),
          contains('"accountId":"remote"'),
        );
      },
    );

    test('uses the stored restored key without asking the server', () async {
      final account = await _account(keyPassword: 'other-device-token');
      final harness = await _harness(
        account,
        extraSecureValues: {
          secureRestoredKeyKey:
              '{"accountId":"remote","privateKey":"${account.privateKey}"}',
        },
      );

      final state = await _settled(harness.container);

      expect(state.privateKey, isNotNull);
      expect(harness.operations, isNot(contains('KeyEscrow')));
    });

    test('ignores a restored key that belongs to another account', () async {
      final account = await _account(keyPassword: 'other-device-token');
      final harness = await _harness(
        account,
        escrowKey: account.privateKey,
        extraSecureValues: {
          secureRestoredKeyKey: '{"accountId":"other","privateKey":"AAAA"}',
        },
      );

      final state = await _settled(harness.container);

      expect(state.privateKey, isNotNull);
      expect(harness.operations, contains('KeyEscrow'));
    });

    test('keeps only the public key when no escrow exists', () async {
      final account = await _account(keyPassword: 'other-device-token');
      final harness = await _harness(account);

      final state = await _settled(harness.container);

      expect(state.isLoggedIn, isTrue);
      expect(state.publicKey, isNotNull);
      expect(state.privateKey, isNull);
      expect(state.personalDataKey, isNull);
      expect(state.buergerId, 'remote');
    });

    test('does not ask for an escrow without a strong session', () async {
      final account = await _account(keyPassword: 'other-device-token');
      final harness = await _harness(
        account,
        strongSession: false,
        escrowKey: account.privateKey,
      );

      final state = await _settled(harness.container);

      expect(state.privateKey, isNull);
      expect(harness.operations, isNot(contains('KeyEscrow')));
    });
  });

  group('no key material in logs', () {
    late List<String> logs;
    late DebugPrintCallback originalDebugPrint;

    setUp(() {
      logs = [];
      originalDebugPrint = debugPrint;
      debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
    });

    tearDown(() => debugPrint = originalDebugPrint);

    test('a broken restored key is not printed', () async {
      final account = await _account(keyPassword: 'other-device-token');
      final broken =
          '${account.privateKey.substring(0, 60)}!${account.privateKey.substring(60)}';
      final harness = await _harness(
        account,
        extraSecureValues: {
          secureRestoredKeyKey: jsonEncode({
            'accountId': 'remote',
            'privateKey': broken,
          }),
        },
      );

      final state = await _settled(harness.container);

      expect(state.privateKey, isNull);
      expect(logs, isNotEmpty);
      expect(
        logs.where((log) => log.contains(account.privateKey.substring(0, 40))),
        isEmpty,
      );
    });

    test('a broken key from the escrow is not printed', () async {
      final account = await _account(keyPassword: 'other-device-token');
      final broken =
          '${account.privateKey.substring(0, 60)}!${account.privateKey.substring(60)}';
      final harness = await _harness(account, escrowKey: broken);

      final state = await _settled(harness.container);

      expect(state.privateKey, isNull);
      expect(
        logs.where((log) => log.contains(account.privateKey.substring(0, 40))),
        isEmpty,
      );
    });
  });

  group('cached account', () {
    test('a login replaces the cached anonymous account', () async {
      final anonymous = await _account(
        keyPassword: 'local-weak-token',
        id: 'local',
        isVerified: false,
      );
      final verified = await _account(
        keyPassword: 'other-device-token',
        id: 'verified',
        hasKeyEscrow: true,
      );
      final harness = await _harness(
        anonymous,
        strongSession: false,
        escrowKey: verified.privateKey,
      );
      await _settled(harness.container);

      harness.setRemoteAccount(verified.my);
      await const FlutterSecureStorage().write(
        key: secureStrongTokenKey,
        value: _jwt('verified'),
      );
      harness.container.invalidate(asyncAuthProvider);
      final state = await _settledFor(harness.container, 'verified');

      expect(state.privateKey, isNotNull);
      expect(harness.operations, contains('KeyEscrow'));
      expect(harness.operations, isNot(contains('StoreKeyEscrow')));
    });

    test('a logout replaces the cached verified account', () async {
      final verified = await _account(
        keyPassword: 'other-device-token',
        id: 'verified',
        hasKeyEscrow: true,
      );
      final anonymous = await _account(
        keyPassword: 'local-weak-token',
        id: 'local',
        isVerified: false,
      );
      final harness = await _harness(
        verified,
        escrowKey: verified.privateKey,
        extraSecureValues: {secureStrongTokenKey: _jwt('verified')},
      );
      await _settledFor(harness.container, 'verified');

      harness.setRemoteAccount(anonymous.my);
      await const FlutterSecureStorage().delete(key: secureStrongTokenKey);
      harness.container.invalidate(asyncAuthProvider);
      final state = await _settledFor(harness.container, 'local');

      expect(state.privateKey, isNotNull);
      expect(state.isKeyUnavailable, isFalse);
    });

    test('the cache is used while offline for the same account', () async {
      final account = await _account(
        keyPassword: 'local-weak-token',
        id: 'local',
        hasKeyEscrow: true,
        isVerified: false,
      );
      final harness = await _harness(account, strongSession: false);
      await _settled(harness.container);

      harness.setRemoteAccount(null);
      harness.container.invalidate(asyncAuthProvider);
      final state = await _settledFor(harness.container, 'local');

      expect(state.privateKey, isNotNull);
    });
  });

  group('ensureKeyBackup', () {
    Future<bool> check(_Harness harness) =>
        harness.container.read(asyncAuthProvider.notifier).ensureKeyBackup();

    test('allows logout when this device holds no key', () async {
      final account = await _account(keyPassword: 'other-device-token');
      final harness = await _harness(account, strongSession: false);
      await _settled(harness.container);
      harness.uploadedKeys.clear();

      expect(await check(harness), isTrue);
      expect(harness.uploadedKeys, isEmpty);
    });

    test('allows logout when the key is already backed up', () async {
      final account = await _account(
        keyPassword: 'local-weak-token',
        hasKeyEscrow: true,
      );
      final harness = await _harness(account);
      await _settled(harness.container);

      expect(await check(harness), isTrue);
      expect(harness.operations, isNot(contains('StoreKeyEscrow')));
    });

    test('uploads a missing backup before allowing logout', () async {
      final account = await _account(
        keyPassword: 'local-weak-token',
        isVerified: false,
      );
      final harness = await _harness(account);
      await _settled(harness.container);

      expect(await check(harness), isTrue);
      expect(harness.uploadedKeys, [account.privateKey]);
    });

    test('uploads a key that is only recoverable from the device', () async {
      final account = await _account(
        keyPassword: 'local-weak-token',
        isVerified: false,
      );
      final harness = await _harness(account);
      await _settled(harness.container);
      harness.container.read(asyncAuthProvider.notifier).state =
          AsyncError<AuthState>('offline', StackTrace.current);

      expect(await check(harness), isTrue);
      expect(harness.uploadedKeys, [account.privateKey]);
    });

    test('reports a failed backup so logout can be questioned', () async {
      final account = await _account(
        keyPassword: 'local-weak-token',
        isVerified: false,
      );
      final harness = await _harness(account, failUpload: true);
      await _settled(harness.container);

      expect(await check(harness), isFalse);
    });

    test('reports an unreachable server instead of a safe key', () async {
      final account = await _account(
        keyPassword: 'local-weak-token',
        isVerified: false,
      );
      final harness = await _harness(account);
      await _settled(harness.container);

      harness.setRemoteAccount(null);

      expect(await check(harness), isFalse);
    });
  });

  test('removes a restored key once the strong session has ended', () async {
    final account = await _account(keyPassword: 'local-weak-token');
    final harness = await _harness(
      account,
      strongSession: false,
      extraSecureValues: {secureRestoredKeyKey: '{"accountId":"other"}'},
    );

    await _settled(harness.container);

    expect(
      await const FlutterSecureStorage().read(key: secureRestoredKeyKey),
      isNull,
    );
  });

  group('signOut', () {
    test('removes prefilled values but keeps other settings', () async {
      final account = await _account(keyPassword: 'local-weak-token');
      final harness = await _harness(account);
      await _settled(harness.container);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('field_Vorname', 'Test');
      await prefs.setString('field_image_single_Foto', 'data');
      await prefs.setString('some_setting', 'kept');

      await harness.container.read(asyncAuthProvider.notifier).signOut();

      expect(prefs.getString('field_Vorname'), isNull);
      expect(prefs.getString('field_image_single_Foto'), isNull);
      expect(prefs.getString('some_setting'), 'kept');
    });

    test('also removes the cached responses of the account', () async {
      useInMemoryQuerySnapshotStore();
      final account = await _account(keyPassword: 'local-weak-token');
      final harness = await _harness(account);
      await _settled(harness.container);
      await writeQuerySnapshot('account-data', {'my': 'data'});

      await http.runWithClient(
        () => harness.container.read(asyncAuthProvider.notifier).signOut(),
        () => MockClient((_) async => http.Response('', 204)),
      );

      expect(readQuerySnapshot('account-data', (data) => data), isNull);
    });

    test('revokes the refresh token and removes the session', () async {
      final account = await _account(keyPassword: 'local-weak-token');
      final harness = await _harness(
        account,
        extraSecureValues: {secureStrongRefreshTokenKey: 'strong-refresh'},
      );
      await _settled(harness.container);
      final revoked = <String>[];

      await http.runWithClient(
        () => harness.container.read(asyncAuthProvider.notifier).signOut(),
        () => MockClient((request) async {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          revoked.add(body['refreshToken'] as String);
          return http.Response('', 204);
        }),
      );

      const storage = FlutterSecureStorage();
      expect(revoked, ['strong-refresh']);
      expect(await storage.read(key: secureStrongTokenKey), isNull);
      expect(await storage.read(key: secureStrongRefreshTokenKey), isNull);
    });

    test('keeps the new device login out of the persistent cache', () async {
      final account = await _account(keyPassword: 'local-weak-token');
      final harness = await _harness(account);
      await _settled(harness.container);

      await http.runWithClient(
        () => harness.container.read(asyncAuthProvider.notifier).signOut(),
        () => MockClient((_) async => http.Response('', 204)),
      );

      final cached = jsonEncode(
        harness.container.read(graphqlClientProvider).cache.store.toMap(),
      );
      expect(harness.operations, contains('WeakRegister'));
      expect(cached, isNot(contains('registerBuergerWeak')));
    });

    test('a failed revoke never logs the refresh token', () async {
      final account = await _account(keyPassword: 'local-weak-token');
      final harness = await _harness(
        account,
        extraSecureValues: {secureStrongRefreshTokenKey: 'strong-refresh'},
      );
      await _settled(harness.container);
      final printed = <String>[];
      final original = debugPrint;
      debugPrint = (message, {wrapWidth}) => printed.add(message ?? '');
      addTearDown(() => debugPrint = original);

      await http.runWithClient(
        () => harness.container.read(asyncAuthProvider.notifier).signOut(),
        () => MockClient(
          (request) async => throw http.ClientException(request.body),
        ),
      );

      expect(printed.join('\n'), isNot(contains('strong-refresh')));
    });
  });

  test(
    'a start without device login revokes a leftover refresh token',
    () async {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: 'strong',
        secureStrongRefreshTokenKey: 'strong-refresh',
      });
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(
            await SharedPreferences.getInstance(),
          ),
          graphqlClientProvider.overrideWithValue(
            GraphQLClient(
              cache: GraphQLCache(),
              link: Link.function(
                (request, [forward]) => Stream.value(
                  const Response(
                    errors: [GraphQLError(message: 'offline')],
                    response: {},
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final revoked = <String>[];

      await http.runWithClient(
        () async {
          final sub = container.listen(asyncAuthProvider, (_, _) {});
          addTearDown(sub.close);
          await container
              .read(asyncAuthProvider.future)
              .catchError((_) => AuthState.registering());
          await pumpEventQueue();
        },
        () => MockClient((request) async {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          revoked.add(body['refreshToken'] as String);
          return http.Response('', 204);
        }),
      );

      const storage = FlutterSecureStorage();
      expect(await storage.read(key: secureStrongTokenKey), isNull);
      expect(await storage.read(key: secureStrongRefreshTokenKey), isNull);
      expect(revoked, ['strong-refresh']);
    },
  );

  test(
    'a start without device login removes the previous account data',
    () async {
      useInMemoryQuerySnapshotStore();
      await writeQuerySnapshot('previous-account', {'my': 'data'});
      SharedPreferences.setMockInitialValues({
        'field_Vorname': 'Test',
        'some_setting': 'kept',
      });
      FlutterSecureStorage.setMockInitialValues({});
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(
            await SharedPreferences.getInstance(),
          ),
          graphqlClientProvider.overrideWithValue(
            GraphQLClient(
              cache: GraphQLCache(),
              link: Link.function(
                (request, [forward]) => Stream.value(
                  const Response(
                    errors: [GraphQLError(message: 'offline')],
                    response: {},
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(asyncAuthProvider, (_, _) {});
      addTearDown(sub.close);

      await container
          .read(asyncAuthProvider.future)
          .catchError((_) => AuthState.registering());

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('field_Vorname'), isNull);
      expect(prefs.getString('some_setting'), 'kept');
      expect(readQuerySnapshot('previous-account', (data) => data), isNull);
    },
  );

  test('registrations at the same time share one new identity', () async {
    final account = await _account(keyPassword: 'local-weak-token');
    final harness = await _harness(account);
    await _settled(harness.container);
    final notifier = harness.container.read(asyncAuthProvider.notifier);

    await Future.wait([notifier.register(), notifier.register()]);

    expect(
      harness.operations.where((name) => name == 'WeakRegister'),
      hasLength(1),
    );
  });

  test('reads the account id from a token', () {
    expect(accountIdFromToken(_jwt('abc')), 'abc');
    expect(accountIdFromToken('not-a-token'), isNull);
  });

  test('a state before the public key is loaded is not a missing key', () {
    expect(const AuthState(null, null, null, 'id').isKeyUnavailable, isFalse);
  });
}
