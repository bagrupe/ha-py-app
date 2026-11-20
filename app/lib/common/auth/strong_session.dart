import 'dart:async';
import 'dart:convert';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/secure_storage_provider.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

part 'strong_session_ended.dart';
part 'strong_session_gone.dart';
part 'strong_session_refresh.dart';
part 'strong_session_refreshed.dart';
part 'strong_session_unreachable.dart';

@visibleForTesting
Duration strongSessionRequestTimeout = const Duration(seconds: 15);

Future<void> _previousOperation = Future.value();

Future<T> _exclusively<T>(Future<T> Function() operation) {
  final previous = _previousOperation;
  final done = Completer<void>();
  _previousOperation = done.future;
  return previous.then((_) => operation()).whenComplete(done.complete);
}

Future<void> storeStrongSession(
  FlutterSecureStorage storage, {
  required String token,
  required String? refreshToken,
  required String Function() backendUrl,
}) async {
  final replaced = await _exclusively(() async {
    final replaced = await storage.read(key: secureStrongRefreshTokenKey);
    await storage.delete(key: secureStrongRefreshTokenKey);
    await storage.write(key: secureStrongTokenKey, value: token);
    if (refreshToken != null) {
      await storage.write(
        key: secureStrongRefreshTokenKey,
        value: refreshToken,
      );
    }
    return replaced;
  });

  if (replaced != null && replaced != refreshToken) {
    unawaited(revokeRefreshToken(backendUrl, replaced));
  }
}

/// Also takes effect when the page that started the login is already closed.
Future<void> activateStrongSession(
  ProviderContainer container, {
  required String token,
  required String? refreshToken,
}) async {
  await storeStrongSession(
    container.read(secureStorageProvider),
    token: token,
    refreshToken: refreshToken,
    backendUrl: () => container.read(appConfigProvider).backendUrl,
  );
  container
    ..invalidate(graphqlClientProvider)
    ..invalidate(asyncAuthProvider);
}

Future<void> revokeRefreshToken(
  String Function() backendUrl,
  String refreshToken,
) async {
  try {
    await http
        .post(
          Uri.parse('${backendUrl()}/api/auth/session/revoke'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        )
        .timeout(strongSessionRequestTimeout);
  } catch (error) {
    debugPrint('Revoking a refresh token failed: ${error.runtimeType}');
  }
}

Future<void> discardStrongSession(
  FlutterSecureStorage storage, {
  required String Function() backendUrl,
  bool waitForRevoke = false,
}) async {
  final refreshToken = await _exclusively(() async {
    final refreshToken = await storage.read(key: secureStrongRefreshTokenKey);
    await storage.delete(key: secureStrongTokenKey);
    await storage.delete(key: secureStrongRefreshTokenKey);
    return refreshToken;
  });
  if (refreshToken == null) return;

  final revoke = revokeRefreshToken(backendUrl, refreshToken);
  if (waitForRevoke) {
    await revoke;
  } else {
    unawaited(revoke);
  }
}

Future<StrongSessionRefresh> refreshStrongSession(
  FlutterSecureStorage storage, {
  required Set<String> staleTokens,
  required String backendUrl,
}) => _exclusively(() async {
  final token = await storage.read(key: secureStrongTokenKey);
  if (token == null) return const StrongSessionGone();
  if (!staleTokens.contains(token)) return StrongSessionRefreshed(token);

  final refreshToken = await storage.read(key: secureStrongRefreshTokenKey);
  if (refreshToken == null) return _endStrongSession(storage);

  final client = http.Client();
  final http.Response response;
  try {
    response = await client
        .post(
          Uri.parse('$backendUrl/api/auth/session/refresh'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        )
        .timeout(strongSessionRequestTimeout);
  } catch (_) {
    return StrongSessionUnreachable(token);
  } finally {
    client.close();
  }

  if (response.statusCode == 401) return _endStrongSession(storage);

  final session = _sessionFrom(response);
  if (session == null) return StrongSessionUnreachable(token);

  if (session.refreshToken case final newRefreshToken?) {
    await storage.write(
      key: secureStrongRefreshTokenKey,
      value: newRefreshToken,
    );
  }
  await storage.write(key: secureStrongTokenKey, value: session.token);
  return StrongSessionRefreshed(session.token);
});

Future<StrongSessionRefresh> _endStrongSession(
  FlutterSecureStorage storage,
) async {
  await storage.delete(key: secureStrongTokenKey);
  await storage.delete(key: secureStrongRefreshTokenKey);
  return const StrongSessionEnded();
}

({String token, String? refreshToken})? _sessionFrom(http.Response response) {
  if (response.statusCode != 200) return null;

  final Object? payload;
  try {
    payload = jsonDecode(response.body);
  } on FormatException {
    return null;
  }
  final token = payload is Map ? payload['token'] : null;
  final refreshToken = payload is Map ? payload['refreshToken'] : null;
  if (token is! String) return null;
  return (
    token: token,
    refreshToken: refreshToken is String ? refreshToken : null,
  );
}
