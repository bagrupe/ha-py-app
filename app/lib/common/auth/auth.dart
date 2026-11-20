// ignore_for_file: unawaited_futures, cascade_invocations

import 'dart:convert';

import 'package:app/common/abfall/abfall_filter.dart';
import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/common/crypto/crypto.dart';
import 'package:app/common/extensions/encrypted_value.dart';
import 'package:app/common/extensions/string.dart';
import 'package:app/common/secure_storage_provider.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/key_escrow.graphql.dart';
import 'package:app/graphql/__generated__/register.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/__generated__/user.graphql.dart';
import 'package:app/graphql/graphql_cache.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:app/routes/termine/components/veranstaltung/veranstaltungen_filter_sheet.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql/client.dart';
import 'package:pointycastle/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

const secureWeakLoginTokenPrefsKey = 'weak_login_token';
const secureWeakLoginIdPrefsKey = 'weak_login_id';
const secureDerivedServerLoginPasswordKey = 'derived_server_login_password';
const securePasswordDerivationIterationCountKey =
    'password_derivation_iteration_count';

const secureStrongTokenKey = 'bundid_token';
const secureStrongRefreshTokenKey = 'bundid_refresh_token';

const secureRestoredKeyKey = 'restored_private_key';

const _prefillPrefsPrefix = 'field_';
const _accountIdClaim =
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier';

String? accountIdFromToken(String token) {
  try {
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
    );
    return (payload as Map<String, dynamic>)[_accountIdClaim] as String?;
  } on Object {
    return null;
  }
}

/// The device credentials are already gone, the rebuilt auth state registers a new identity.
void endRejectedDeviceLogin(ProviderContainer container) => container
  ..read(strongSessionExpiredProvider.notifier).set(true)
  ..invalidate(asyncAuthProvider)
  ..invalidate(graphqlClientProvider);

enum AppAuthState { loading, loggedIn, needsLoading, registering }

/// Repräsentiert den Authentifizierungsstatus und zugehörige Schlüssel des Benutzers.
@immutable
class AuthState {
  /// Erstellt einen Authentifizierungsstatus mit Schlüsseln und Bürger-ID, markiert als eingeloggt.
  const AuthState(
    this.publicKey,
    this.privateKey,
    this.personalDataKey,
    this.buergerId,
  ) : appAuthState = AppAuthState.loggedIn;

  /// Erzeugt einen Ladezustand.
  factory AuthState.loading() =>
      const AuthState._fromState(AppAuthState.loading);

  /// Erzeugt einen Zustand, der anzeigt, dass eine Initialisierung erforderlich ist.
  factory AuthState.needsLoading() =>
      const AuthState._fromState(AppAuthState.needsLoading);

  /// Erzeugt einen Zustand während der Registrierung.
  factory AuthState.registering() =>
      const AuthState._fromState(AppAuthState.registering);

  const AuthState._fromState(this.appAuthState)
    : publicKey = null,
      privateKey = null,
      personalDataKey = null,
      buergerId = null;
  final PublicKey? publicKey;
  final PrivateKey? privateKey;
  final Uint8List? personalDataKey;
  final String? buergerId;

  final AppAuthState appAuthState;

  /// Gibt zurück, ob der Benutzer eingeloggt ist.
  bool get isLoggedIn => appAuthState == AppAuthState.loggedIn;

  bool get isKeyUnavailable =>
      isLoggedIn && publicKey != null && personalDataKey == null;
}

/// Verwalter für den Authentifizierungsstatus mit asynchronen Operationen.
class AuthStateNotifier extends AsyncNotifier<AuthState> {
  @override
  /// Baut den aktuellen Authentifizierungsstatus auf, registriert neu falls keine Anmeldedaten vorhanden sind.
  Future<AuthState> build() async {
    ref.listen(strongSessionExpiredProvider, (_, isExpired) {
      if (isExpired) ref.invalidateSelf();
    });

    final prefs = ref.read(sharedPreferencesProvider);
    final hasCredentials = prefs.getString(secureWeakLoginIdPrefsKey) != null;

    if (!hasCredentials) {
      final secureStorage = ref.read(secureStorageProvider);
      final backendUrl = ref.read(appConfigProvider).backendUrl;
      await discardStrongSession(secureStorage, backendUrl: () => backendUrl);
      await secureStorage.delete(key: secureRestoredKeyKey);
      await _removePrefilledValues(prefs);
      await clearPersistentGraphQLCache();
      return register();
    }

    return initialize();
  }

  /// Initialisiert den Authentifizierungsstatus aus sicherem Speicher und Backend.
  Future<AuthState> initialize() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final secureStorage = ref.read(secureStorageProvider);
    final buergerId = prefs.getString(secureWeakLoginIdPrefsKey);
    final weakToken = await secureStorage.read(
      key: secureWeakLoginTokenPrefsKey,
    );

    if (buergerId == null || weakToken == null) {
      throw Exception(
        'initializing failed, missing buergerId or weakLoginToken',
      );
    }
    state = AsyncData(AuthState(null, null, null, buergerId));

    final client = ref.read(graphqlClientProvider);

    final strongToken = await secureStorage.read(key: secureStrongTokenKey);
    if (strongToken != null) {
      ref.read(strongSessionExpiredProvider.notifier).set(false);
    } else {
      await secureStorage.delete(key: secureRestoredKeyKey);
    }
    final expectedAccountId = strongToken == null
        ? buergerId
        : accountIdFromToken(strongToken);

    var my = await client.query_My();
    if (!my.hasException && my.parsedData?.my.id != expectedAccountId) {
      my = await client.query_My(
        Options_Query_My(fetchPolicy: FetchPolicy.networkOnly),
      );
    }
    if (my.hasException) {
      throw my.exception!;
    }

    final myPayload = my.parsedData!.my;
    if (myPayload is! Query_My_my__Buerger) {
      throw Exception('Login is only available for Buerger!');
    }

    final publicKey = CryptoUtils.rsaPublicKeyFromDERBytes(
      myPayload.publicKey!.toBase64Bytes(),
    );
    final accountId = myPayload.id;
    final hasStrongSession = strongToken != null;

    try {
      var privateKey = await _decryptWithDeviceToken(myPayload, weakToken);
      final isVerified = myPayload.hasBundId || myPayload.phoneVerified;
      if (privateKey != null && isVerified && !myPayload.hasKeyEscrow) {
        await _storeKeyEscrow(client, privateKey);
      }
      if (privateKey == null && hasStrongSession) {
        privateKey = await _restoreFromKeyEscrow(client, accountId);
      }
      if (privateKey == null) {
        return AuthState(publicKey, null, null, accountId);
      }

      final personalDataKey = Crypto.unwrapKey(
        myPayload.personalDataKey!,
        privateKey,
      );
      return AuthState(publicKey, privateKey, personalDataKey, accountId);
    } catch (error) {
      debugPrint(
        'AuthStateNotifier.initialize: private key unavailable: ${error.runtimeType}',
      );
      return AuthState(publicKey, null, null, accountId);
    }
  }

  Future<RSAPrivateKey?> _decryptWithDeviceToken(
    Query_My_my__Buerger myPayload,
    String weakToken,
  ) async {
    try {
      const storage = FlutterSecureStorage();
      final hasKnownIterationCount = await storage.containsKey(
        key: securePasswordDerivationIterationCountKey,
      );
      final iterationCount = hasKnownIterationCount
          ? int.parse(
              (await storage.read(
                key: securePasswordDerivationIterationCountKey,
              ))!,
            )
          : 20000;
      return await Crypto.decryptPersonalKey(
        weakToken,
        myPayload.personalPrivateKeySalt!.toBase64Bytes(),
        myPayload.personalPrivateKey!.toEncryptedValue(),
        iterationCount,
      );
    } catch (error) {
      debugPrint(
        'AuthStateNotifier: private key does not belong to this device: ${error.runtimeType}',
      );
      return null;
    }
  }

  Future<bool> _storeKeyEscrow(
    GraphQLClient client,
    RSAPrivateKey privateKey,
  ) async {
    try {
      final result = await client.mutate_StoreKeyEscrow(
        Options_Mutation_StoreKeyEscrow(
          fetchPolicy: FetchPolicy.noCache,
          variables: Variables_Mutation_StoreKeyEscrow(
            input: Input_StoreKeyEscrowInput(
              privateKey: _encodePrivateKey(privateKey),
            ),
          ),
        ),
      );
      return !result.hasException;
    } catch (error) {
      debugPrint(
        'AuthStateNotifier: storing key escrow failed: ${error.runtimeType}',
      );
      return false;
    }
  }

  Future<bool> ensureKeyBackup() async {
    try {
      final client = ref.read(graphqlClientProvider);
      final my = await client.query_My(
        Options_Query_My(fetchPolicy: FetchPolicy.networkOnly),
      );
      final payload = my.parsedData?.my;
      if (my.hasException || payload is! Query_My_my__Buerger) return false;
      if (payload.hasKeyEscrow) return true;

      final privateKey = await _keyOnThisDevice(payload);
      if (privateKey == null) return true;

      return await _storeKeyEscrow(client, privateKey);
    } catch (error) {
      debugPrint(
        'AuthStateNotifier: checking key backup failed: ${error.runtimeType}',
      );
      return false;
    }
  }

  Future<RSAPrivateKey?> _keyOnThisDevice(Query_My_my__Buerger payload) async {
    final currentKey = state.value?.privateKey;
    if (currentKey is RSAPrivateKey) return currentKey;

    final weakToken = await ref
        .read(secureStorageProvider)
        .read(key: secureWeakLoginTokenPrefsKey);
    if (weakToken == null) return null;
    return _decryptWithDeviceToken(payload, weakToken);
  }

  Future<RSAPrivateKey?> _restoreFromKeyEscrow(
    GraphQLClient client,
    String accountId,
  ) async {
    final secureStorage = ref.read(secureStorageProvider);
    final stored = await secureStorage.read(key: secureRestoredKeyKey);
    if (stored != null) {
      final json = jsonDecode(stored) as Map<String, dynamic>;
      if (json['accountId'] == accountId) {
        return _decodePrivateKey(json['privateKey'] as String);
      }
    }

    final result = await client.query_KeyEscrow(
      Options_Query_KeyEscrow(fetchPolicy: FetchPolicy.noCache),
    );
    final restored = result.parsedData?.keyEscrow;
    if (restored == null) return null;

    final privateKey = _decodePrivateKey(restored);
    await secureStorage.write(
      key: secureRestoredKeyKey,
      value: jsonEncode({'accountId': accountId, 'privateKey': restored}),
    );
    return privateKey;
  }

  String _encodePrivateKey(RSAPrivateKey privateKey) =>
      CryptoUtils.getBytesFromPEMString(
        CryptoUtils.encodeRSAPrivateKeyToPem(privateKey),
      ).toBase64String();

  RSAPrivateKey _decodePrivateKey(String value) =>
      CryptoUtils.rsaPrivateKeyFromDERBytes(value.toBase64Bytes());

  Future<AuthState>? _registration;

  /// Registriert einen neuen Benutzer und speichert die Anmeldedaten sicher.
  Future<AuthState> register() => _registration ??= _registerDevice()
      .whenComplete(() => _registration = null);

  Future<AuthState> _registerDevice() async {
    state = AsyncData(AuthState.registering());

    final secureRandom = FortunaRandom()
      ..seed(KeyParameter(Crypto.getRandomKey()));
    final weakLoginToken = secureRandom.nextBytes(32);
    final keyPair = Crypto.generateRsaKey(secureRandom);

    // This point may be used in the future to dynamically determine a more
    //   suitable iteration count for faster / slower devices
    const determinedIterationCount = 100000;
    final derivedPassword = await Crypto.getServerLoginPassword(
      weakLoginToken,
      determinedIterationCount,
    );
    final (encryptedPrivateKey, salt) = await Crypto.encryptPersonalKey(
      weakLoginToken.toHexString(),
      keyPair.privateKey,
      determinedIterationCount,
    );

    final publicKeyString = CryptoUtils.getBytesFromPEMString(
      CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey),
    ).toBase64String();

    final personalDataKey = Crypto.getRandomKey();
    final wrappedPersonalDataKey = Crypto.wrapKey(
      personalDataKey,
      keyPair.publicKey,
    );

    final client = ref.read(graphqlClientProvider);
    final result = await client.mutate_WeakRegister(
      Options_Mutation_WeakRegister(
        fetchPolicy: FetchPolicy.noCache,
        variables: Variables_Mutation_WeakRegister(
          input: Input_RegisterBuergerWeakInput(
            derivedPassword: derivedPassword,
            encryptedPrivateKey: encryptedPrivateKey.toInput(),
            personalDataKeyForBuerger: wrappedPersonalDataKey,
            publicKey: publicKeyString,
            salt: salt.toBase64String(),
          ),
        ),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final registeredId = result.parsedData!.registerBuergerWeak.buergerId!;
    await _storeCredentials(
      registeredId,
      weakLoginToken.toHexString(),
      derivedPassword,
      determinedIterationCount,
    );

    return AuthState(
      keyPair.publicKey,
      keyPair.privateKey,
      personalDataKey,
      registeredId,
    );
  }

  Future<void> signOut() async {
    final secureStorage = ref.read(secureStorageProvider);

    final backendUrl = ref.read(appConfigProvider).backendUrl;
    await discardStrongSession(
      secureStorage,
      backendUrl: () => backendUrl,
      waitForRevoke: true,
    );

    await secureStorage.delete(key: secureWeakLoginTokenPrefsKey);
    await secureStorage.delete(key: secureDerivedServerLoginPasswordKey);
    await secureStorage.delete(key: securePasswordDerivationIterationCountKey);
    await secureStorage.delete(key: secureRestoredKeyKey);

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(secureWeakLoginIdPrefsKey);
    prefs.remove(selectedCategoriesPrefsKey);
    prefs.remove(AbfallFilterKeys.abfallFilter);
    await _removePrefilledValues(prefs);
    await clearPersistentGraphQLCache();

    // Invalidate graphql client to refresh auth link
    ref.invalidate(graphqlClientProvider);

    state = await AsyncValue.guard(register);
    state.whenOrNull(
      error: (error, stackTrace) => debugPrint(
        'AuthStateNotifier.signOut: register() failed: $error\n$stackTrace',
      ),
    );
  }

  Future<void> _removePrefilledValues(SharedPreferences prefs) async {
    final prefillKeys = prefs.getKeys().where(
      (key) => key.startsWith(_prefillPrefsPrefix),
    );
    await Future.wait(prefillKeys.toList().map(prefs.remove));
  }

  Future<void> devOnlyLogout() async {
    if (!kDebugMode) return;
    await signOut();
  }

  /// Speichert die Anmeldedaten: die BürgerID in SharedPreferences,
  /// kryptographische Geheimnisse im sicheren Speicher.
  Future<void> _storeCredentials(
    String id,
    String passwordSource,
    String derivedPassword,
    int iterationCount,
  ) async {
    // Store the non-sensitive user identifier in SharedPreferences so it is
    // cleared on app reinstall (secure storage survives uninstall on Android).
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(secureWeakLoginIdPrefsKey, id);

    // Cryptographic secrets remain in secure storage.
    final storage = ref.read(secureStorageProvider);
    await storage.write(
      key: secureWeakLoginTokenPrefsKey,
      value: passwordSource,
    );
    await storage.write(
      key: secureDerivedServerLoginPasswordKey,
      value: derivedPassword,
    );
    await storage.write(
      key: securePasswordDerivationIterationCountKey,
      value: iterationCount.toString(),
    );
  }
}

/// Secure storage survives an uninstall on Android, so a reinstall would bring back the old identity.
Future<void> migrateFromSecureStorageToSharedPrefs() async {
  const storage = FlutterSecureStorage();

  final buergerId = await storage.read(key: secureWeakLoginIdPrefsKey);
  if (buergerId == null) return;

  // Write the buergerId to SharedPreferences (clears on uninstall).
  final sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString(secureWeakLoginIdPrefsKey, buergerId);

  // Remove the buergerId from secure storage — it no longer belongs there.
  await storage.delete(key: secureWeakLoginIdPrefsKey);
}

/// Provider für den asynchronen Authentifizierungsstatus.
final asyncAuthProvider = AsyncNotifierProvider<AuthStateNotifier, AuthState>(
  AuthStateNotifier.new,
);

/// Provider für den aktuellen Authentifizierungsstatus.
final authProvider = Provider((ref) {
  final auth = ref.watch(asyncAuthProvider);

  return switch (auth) {
    AsyncData(:final value) => value,
    AsyncError() => AuthState.registering(),
    _ => AuthState.loading(),
  };
});

final hasStrongSessionProvider = FutureProvider<bool>((ref) async {
  ref
    ..watch(graphqlClientProvider)
    ..watch(strongSessionExpiredProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return secureStorage.containsKey(key: secureStrongTokenKey);
});
