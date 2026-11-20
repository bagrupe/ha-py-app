// ignore_for_file: type_annotate_public_apis, unawaited_futures

import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/common/notifications/firebase_push.dart';
import 'package:app/graphql/__generated__/login.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gql_transform_link/gql_transform_link.dart';
import 'package:graphql/client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'device_login_rejected.dart';

class HttpAuthLink extends Link {
  HttpAuthLink(
    this.graphqlUrl, [
    String? initialToken,
    this.onTokenChanged,
    this.onStrongSessionExpired,
    this.onDeviceLoginRejected,
  ]) {
    _link = Link.concat(
      ErrorLink(onException: handleException),
      TransformLink(requestTransformer: transformRequest),
    );

    _token = initialToken;
  }
  late Link _link;
  String? _token;
  Future<void>? _future;
  DateTime? _strongSessionRetryAt;
  String? _unrefreshedStrongToken;
  Duration _strongSessionRetryDelay = _firstStrongSessionRetryDelay;

  static const _firstStrongSessionRetryDelay = Duration(seconds: 30);
  static const _maxStrongSessionRetryDelay = Duration(minutes: 10);

  final String graphqlUrl;

  final void Function(String? token)? onTokenChanged;

  final void Function()? onStrongSessionExpired;

  final void Function()? onDeviceLoginRejected;

  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  void _setToken(String? token) {
    _token = token;
    onTokenChanged?.call(token);
  }

  Future<void> updateToken({
    bool forceWeakLogin = false,
    String? failedToken,
  }) => _runExclusive(() => _fetchAndStoreToken(forceWeakLogin, failedToken));

  Future<void> _runExclusive(Future<void> Function() action) {
    final running = _future;
    if (running != null) return running;

    late final Future<void> operation;
    operation = action().whenComplete(() {
      if (identical(_future, operation)) _future = null;
    });
    _future = operation;
    return operation;
  }

  Future<void> _fetchAndStoreToken(
    bool forceWeakLogin,
    String? failedToken,
  ) async {
    _setToken(
      await fetchToken(
        forceWeakLogin: forceWeakLogin,
        failedToken: failedToken,
      ),
    );
  }

  @visibleForTesting
  Future<String?> fetchToken({
    required bool forceWeakLogin,
    String? failedToken,
  }) async {
    try {
      return await (forceWeakLogin
          ? _weakLoginAfterStrongTokenFailure(failedToken ?? _token)
          : resolveToken(graphqlUrl));
    } on DeviceLoginRejected {
      onDeviceLoginRejected?.call();
      return null;
    }
  }

  Future<String?> _weakLoginAfterStrongTokenFailure(String? failedToken) async {
    final refresh = await refreshStrongSession(
      const FlutterSecureStorage(),
      staleTokens: {?failedToken, ?_unrefreshedStrongToken},
      backendUrl: _backendUrl,
    );
    switch (refresh) {
      case StrongSessionRefreshed(:final token):
        _stopStrongSessionRetry();
        return token;
      case StrongSessionUnreachable(:final token):
        final prefs = await SharedPreferences.getInstance();
        final isDeviceAccount =
            accountIdFromToken(token) ==
            prefs.getString(secureWeakLoginIdPrefsKey);
        if (!isDeviceAccount) return token;

        _scheduleStrongSessionRetry(token);
        return login(graphqlUrl);
      case StrongSessionEnded():
        _stopStrongSessionRetry();
        onStrongSessionExpired?.call();
        return login(graphqlUrl);
      case StrongSessionGone():
        _stopStrongSessionRetry();
        return login(graphqlUrl);
    }
  }

  String get _backendUrl => graphqlUrl.replaceFirst(RegExp(r'/graphql/?$'), '');

  bool get _isStrongSessionRetryDue {
    final retryAt = _strongSessionRetryAt;
    return retryAt != null && !clock().isBefore(retryAt);
  }

  void _scheduleStrongSessionRetry(String unrefreshedToken) {
    _unrefreshedStrongToken = unrefreshedToken;
    final delay = _strongSessionRetryAt == null
        ? _firstStrongSessionRetryDelay
        : _strongSessionRetryDelay * 2;
    _strongSessionRetryDelay = delay > _maxStrongSessionRetryDelay
        ? _maxStrongSessionRetryDelay
        : delay;
    _strongSessionRetryAt = clock().add(_strongSessionRetryDelay);
  }

  void _stopStrongSessionRetry() {
    _strongSessionRetryAt = null;
    _unrefreshedStrongToken = null;
  }

  Future<void> _retryStrongSession() async {
    if (!_isStrongSessionRetryDue) return;

    final refresh = await refreshStrongSession(
      const FlutterSecureStorage(),
      staleTokens: {?_unrefreshedStrongToken},
      backendUrl: _backendUrl,
    );
    switch (refresh) {
      case StrongSessionUnreachable(:final token):
        _scheduleStrongSessionRetry(token);
      case StrongSessionRefreshed(:final token):
        _stopStrongSessionRetry();
        _setToken(token);
      case StrongSessionEnded():
        _stopStrongSessionRetry();
        onStrongSessionExpired?.call();
      case StrongSessionGone():
        _stopStrongSessionRetry();
    }
  }

  Stream<Response> handleException(
    Request request,
    NextLink forward,
    LinkException exception,
  ) async* {
    final isUnauthenticatedStatus =
        exception is HttpLinkServerException &&
        exception.response.statusCode == 401;
    final isUnauthenticatedError =
        exception is HttpLinkServerException &&
        (exception.parsedResponse?.errors?.any(
              (e) =>
                  e.extensions?['code'] == 'UNAUTHENTICATED' ||
                  e.extensions?['code'] == 'AUTH_NOT_AUTHORIZED',
            ) ??
            false);

    if (isUnauthenticatedStatus || isUnauthenticatedError) {
      await updateToken(
        forceWeakLogin: true,
        failedToken: _sentToken(exception),
      );

      yield* forward(request);

      return;
    }

    throw exception;
  }

  /// A late 401 may belong to a token that was already replaced.
  static String? _sentToken(LinkException exception) {
    if (exception is! HttpLinkServerException) return null;
    final header = exception.response.request?.headers['Authorization'];
    return header != null && header.startsWith('Bearer ')
        ? header.substring('Bearer '.length)
        : null;
  }

  Request transformRequest(Request request) {
    var updatedRequest = request.updateContextEntry<HttpLinkHeaders>(
      (headers) => HttpLinkHeaders(
        headers: <String, String>{...headers?.headers ?? <String, String>{}},
      ),
    );
    if (_token != null) {
      updatedRequest = request.updateContextEntry<HttpLinkHeaders>(
        (headers) => HttpLinkHeaders(
          headers: <String, String>{
            ...headers?.headers ?? <String, String>{},
            'Authorization': 'Bearer ${_token!}',
          },
        ),
      );
    }
    return updatedRequest;
  }

  @override
  Stream<Response> request(Request request, [forward]) async* {
    if (!request.isIgnoreAuthOperation) {
      if (_token == null) {
        await updateToken();
      } else if (_isStrongSessionRetryDue) {
        await _runExclusive(_retryStrongSession);
      }
    }

    yield* _link.request(request, forward);
  }

  static Future<String?> resolveToken(String graphqlUrl) async {
    const secureStorage = FlutterSecureStorage();
    final strongToken = await secureStorage.read(key: secureStrongTokenKey);
    if (strongToken != null) return strongToken;

    return login(graphqlUrl);
  }

  static Future<String?> login(String graphqlUrl) async {
    final storage = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage();
    final buergerId = storage.getString(secureWeakLoginIdPrefsKey);
    final derivedPassword = await secureStorage.read(
      key: secureDerivedServerLoginPasswordKey,
    );
    if (buergerId == null || derivedPassword == null) return null;

    final httpLink = HttpLink(graphqlUrl);
    final client = GraphQLClient(link: httpLink, cache: GraphQLCache());

    final loginResult = await client.mutate_WeakLogin(
      Options_Mutation_WeakLogin(
        variables: Variables_Mutation_WeakLogin(
          input: Input_LoginBuergerWeakInput(
            buergerId: buergerId,
            password: derivedPassword,
          ),
        ),
      ),
    );

    if (loginResult.hasException) {
      throw loginResult.exception!;
    }

    final payload = loginResult.parsedData!.loginBuergerWeak.loginPayload;
    if (payload?.result == Enum_LoginResult.WRONG_LOGIN) {
      if (storage.getString(secureWeakLoginIdPrefsKey) != buergerId) {
        return null;
      }
      await storage.remove(secureWeakLoginIdPrefsKey);
      await secureStorage.delete(key: secureWeakLoginTokenPrefsKey);
      await secureStorage.delete(key: secureDerivedServerLoginPasswordKey);
      await secureStorage.delete(
        key: securePasswordDerivationIterationCountKey,
      );
      if (isFirebasePushAvailable) {
        try {
          await FirebaseMessaging.instance.deleteToken();
        } catch (ex) {
          Sentry.captureException(ex);
        }
      }
      throw const DeviceLoginRejected();
    }

    return payload!.token!;
  }
}
