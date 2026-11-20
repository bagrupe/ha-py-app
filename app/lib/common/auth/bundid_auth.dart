import 'dart:convert';

import 'package:app/common/app_config/app_config.dart';
import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/strong_session.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/graphql/links/auth_link.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

part 'bundid_login_attempt.dart';
part 'bundid_login_attempt_consent_required.dart';
part 'bundid_login_attempt_error.dart';
part 'bundid_login_attempt_success.dart';
part 'bundid_login_outcome.dart';
part 'bundid_login_result.dart';
part 'bundid_profile_suggestion.dart';

const _bundIdClientId = String.fromEnvironment('BUNDID_CLIENT_ID');
const _bundIdOidcIssuer = String.fromEnvironment('BUNDID_OIDC_ISSUER');
const _bundIdRedirectUrl = String.fromEnvironment('BUNDID_REDIRECT_URL');
const _bundIdIdpHint = String.fromEnvironment(
  'BUNDID_IDP_HINT',
  defaultValue: 'bundid',
);

const _unmountedResult = BundIdLoginResult(BundIdLoginOutcome.error);

/// One browser round trip serves both /login and /exchange, because a second
/// ASWebAuthenticationSession right after the first often hangs on iOS.
Future<(String? token, BundIdLoginResult? error)> _authorizeBundId() async {
  final AuthorizationTokenResponse tokenResponse;
  try {
    tokenResponse = await const FlutterAppAuth().authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        _bundIdClientId,
        _bundIdRedirectUrl,
        issuer: _bundIdOidcIssuer,
        scopes: const ['openid', 'email', 'profile'],
        additionalParameters: {'kc_idp_hint': _bundIdIdpHint},
        promptValues: const ['login'],
        externalUserAgent:
            ExternalUserAgent.ephemeralAsWebAuthenticationSession,
      ),
    );
  } catch (e) {
    debugPrint(
      'BundID login: authorizeAndExchangeCode failed: ${e.runtimeType}',
    );
    return (null, BundIdLoginResult(BundIdLoginOutcome.error, e.toString()));
  }

  final keycloakAccessToken = tokenResponse.accessToken;
  if (keycloakAccessToken == null) {
    debugPrint('BundID login: no accessToken in Keycloak token response.');
    return (
      null,
      BundIdLoginResult(
        BundIdLoginOutcome.error,
        'application.common.bundid.errors.no_access_token'.tr(),
      ),
    );
  }

  return (keycloakAccessToken, null);
}

Future<BundIdLoginResult> _exchangeBundIdToken(
  WidgetRef ref,
  String keycloakAccessToken,
) async {
  final container = ProviderScope.containerOf(ref.context, listen: false);
  final backendUrl = ref.read(appConfigProvider).backendUrl;
  final String? weakToken;
  try {
    weakToken = await HttpAuthLink.login('$backendUrl/graphql');
  } on DeviceLoginRejected {
    endRejectedDeviceLogin(container);
    return BundIdLoginResult(
      BundIdLoginOutcome.error,
      'application.common.bundid.errors.generic'.tr(),
    );
  }
  if (weakToken == null) {
    debugPrint(
      'BundID login: HttpAuthLink.login returned null (no weak login yet).',
    );
    return BundIdLoginResult(
      BundIdLoginOutcome.error,
      'application.common.bundid.errors.no_weak_login'.tr(),
    );
  }

  final http.Response response;
  try {
    response = await http.post(
      Uri.parse('$backendUrl/api/auth/bundid/exchange'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $weakToken',
      },
      body: jsonEncode({'accessToken': keycloakAccessToken}),
    );
  } catch (e) {
    debugPrint('BundID login: exchange request failed: ${e.runtimeType}');
    return BundIdLoginResult(BundIdLoginOutcome.error, e.toString());
  }

  if (response.statusCode == 409) {
    final error = _decodeJsonObject(response.body)?['error'];
    debugPrint('BundID login: exchange conflict: $error');
    return BundIdLoginResult(
      BundIdLoginOutcome.error,
      error is String ? error : null,
    );
  }

  if (response.statusCode != 200) {
    debugPrint(
      'BundID login: unexpected exchange status ${response.statusCode}.',
    );
    return BundIdLoginResult(
      BundIdLoginOutcome.error,
      'application.common.bundid.errors.unexpected_status'.tr(),
    );
  }

  final payload = _decodeJsonObject(response.body);
  final strongToken = payload?['token'];
  if (payload == null || strongToken is! String) {
    return BundIdLoginResult(
      BundIdLoginOutcome.error,
      'application.common.bundid.errors.no_token_in_response'.tr(),
    );
  }

  final refreshToken = payload['refreshToken'];
  await activateStrongSession(
    container,
    token: strongToken,
    refreshToken: refreshToken is String ? refreshToken : null,
  );

  final isNewRegistration = payload['isNewRegistration'] as bool? ?? false;
  final profileSuggestionJson =
      payload['profileSuggestion'] as Map<String, dynamic>?;
  final profileSuggestion = profileSuggestionJson != null
      ? BundIdProfileSuggestion.fromJson(profileSuggestionJson)
      : null;
  final phoneNumberCollision =
      payload['phoneNumberCollision'] as bool? ?? false;

  return BundIdLoginResult(
    BundIdLoginOutcome.success,
    null,
    isNewRegistration,
    profileSuggestion,
    phoneNumberCollision,
  );
}

Future<BundIdLoginResult> _loginBundIdToken(
  WidgetRef ref,
  String keycloakAccessToken,
) async {
  final container = ProviderScope.containerOf(ref.context, listen: false);
  final backendUrl = ref.read(appConfigProvider).backendUrl;
  final http.Response response;
  try {
    response = await http.post(
      Uri.parse('$backendUrl/api/auth/bundid/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'accessToken': keycloakAccessToken}),
    );
  } catch (e) {
    debugPrint('BundID direct login: request failed: ${e.runtimeType}');
    return BundIdLoginResult(BundIdLoginOutcome.error, e.toString());
  }

  if (response.statusCode == 409) {
    debugPrint('BundID direct login: registration required.');
    return const BundIdLoginResult(BundIdLoginOutcome.registrationRequired);
  }

  if (response.statusCode != 200) {
    debugPrint(
      'BundID direct login: unexpected status ${response.statusCode}.',
    );
    return BundIdLoginResult(
      BundIdLoginOutcome.error,
      'application.common.bundid.errors.unexpected_status'.tr(),
    );
  }

  final payload = _decodeJsonObject(response.body);
  final strongToken = payload?['token'];
  if (payload == null || strongToken is! String) {
    return BundIdLoginResult(
      BundIdLoginOutcome.error,
      'application.common.bundid.errors.no_token_in_response'.tr(),
    );
  }

  final refreshToken = payload['refreshToken'];
  await activateStrongSession(
    container,
    token: strongToken,
    refreshToken: refreshToken is String ? refreshToken : null,
  );

  return const BundIdLoginResult(BundIdLoginOutcome.success);
}

Future<BundIdLoginResult> loginWithBundIdDirect(WidgetRef ref) async {
  final (token, error) = await _authorizeBundId();
  if (token == null) return error!;
  if (!ref.context.mounted) return _unmountedResult;
  return _loginBundIdToken(ref, token);
}

@visibleForTesting
BundIdProfileSuggestion previewBundIdProfile(String token) =>
    _extractProfileSuggestionFromToken(token);

/// Persists the account, only call after explicit consent.
Future<BundIdLoginResult> confirmBundIdRegistration(
  WidgetRef ref,
  String token,
) => _exchangeBundIdToken(ref, token);

/// On a device linked to a different BundID, starts a fresh local identity and retries
/// with the consented token, so shared devices still work.
Future<BundIdLoginResult> confirmBundIdRegistrationWithRetry(
  WidgetRef ref,
  String token,
) async {
  var result = await confirmBundIdRegistration(ref, token);
  if (result.message == bundIdErrorCodeAccountAlreadyHasDifferentBundId) {
    await ref.read(asyncAuthProvider.notifier).register();
    ref.invalidate(graphqlClientProvider);
    result = await confirmBundIdRegistration(ref, token);
  }
  return result;
}

/// Every entry point uses this, so a new BundID never creates an account without consent.
Future<BundIdLoginAttempt> startBundIdLogin(WidgetRef ref) async {
  final (token, error) = await _authorizeBundId();
  if (token == null) return BundIdLoginAttemptError(error!);
  if (!ref.context.mounted) {
    return const BundIdLoginAttemptError(_unmountedResult);
  }

  final result = await _loginBundIdToken(ref, token);
  if (result.outcome == BundIdLoginOutcome.success) {
    return BundIdLoginAttemptSuccess(result);
  }
  if (result.outcome == BundIdLoginOutcome.registrationRequired) {
    return BundIdLoginAttemptConsentRequired(
      token,
      _extractProfileSuggestionFromToken(token),
    );
  }
  return BundIdLoginAttemptError(result);
}

/// Signature intentionally not verified, only used for the consent preview.
BundIdProfileSuggestion _extractProfileSuggestionFromToken(String jwt) {
  final claims = _decodeJwtPayloadUnverified(jwt);
  String? claim(String key) => claims[key] as String?;
  return BundIdProfileSuggestion(
    vorname: claim('given_name') ?? claim('vorname'),
    nachname: claim('family_name') ?? claim('nachname'),
    email: claim('email'),
    street: claim('street'),
    postalCode: claim('postalCode'),
    city: claim('city'),
    country: claim('country'),
    telephoneNumber: claim('telephoneNumber'),
  );
}

Map<String, dynamic>? _decodeJsonObject(String body) {
  try {
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : null;
  } on FormatException {
    return null;
  }
}

Map<String, dynamic> _decodeJwtPayloadUnverified(String jwt) {
  final parts = jwt.split('.');
  if (parts.length != 3) return {};
  try {
    final normalized = base64Url.normalize(parts[1]);
    final decoded = jsonDecode(utf8.decode(base64Url.decode(normalized)));
    return decoded is Map<String, dynamic> ? decoded : {};
  } catch (e) {
    debugPrint(
      'BundID preview: failed to decode token payload: ${e.runtimeType}',
    );
    return {};
  }
}

const bundIdErrorCodeAlreadyLinkedToAnotherAccount =
    'BUNDID_ALREADY_LINKED_TO_ANOTHER_ACCOUNT';
const bundIdErrorCodeAccountAlreadyHasDifferentBundId =
    'BUNDID_ACCOUNT_ALREADY_HAS_DIFFERENT_BUNDID';
const bundIdErrorCodeAccountAlreadyVerified = 'BUNDID_ACCOUNT_ALREADY_VERIFIED';

String bundIdErrorMessage(BundIdLoginResult result) {
  switch (result.message) {
    case bundIdErrorCodeAlreadyLinkedToAnotherAccount:
      return 'application.common.bundid.errors.already_linked_to_another_account'
          .tr();
    case bundIdErrorCodeAccountAlreadyHasDifferentBundId:
      return 'application.common.bundid.errors.account_already_has_different_bundid'
          .tr();
    case bundIdErrorCodeAccountAlreadyVerified:
      return 'application.common.bundid.errors.phone_login_required'.tr();
    default:
      return 'application.common.bundid.errors.generic'.tr();
  }
}
