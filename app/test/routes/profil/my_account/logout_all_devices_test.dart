import 'dart:convert';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingAuthNotifier extends AuthStateNotifier {
  bool signedOut = false;

  @override
  Future<AuthState> build() async => AuthState.registering();

  @override
  Future<void> signOut() async => signedOut = true;
}

Response _answer(String result) => Response(
  data: {
    '__typename': 'Mutation',
    'logoutAllDevices': {
      '__typename': 'LogoutAllDevicesPayload',
      'logoutAllDevicesResult': result,
    },
  },
  response: const {},
);

String _tokenFor(String accountId) {
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

GraphQLClient _clientAnswering(Stream<Response> Function() answer) =>
    GraphQLClient(
      cache: GraphQLCache(),
      link: Link.function((request, [forward]) => answer()),
    );

void main() {
  test('passes on the result of the backend', () async {
    for (final result in Enum_LogoutAllDevicesResult.values) {
      final client = _clientAnswering(
        () => Stream.value(_answer(result.toJson())),
      );

      expect(await logoutAllDevices(client), result);
    }
  });

  test('fails on an error of the backend', () async {
    final client = _clientAnswering(
      () => Stream.value(
        const Response(
          errors: [GraphQLError(message: 'not allowed')],
          response: {},
        ),
      ),
    );

    expect(await logoutAllDevices(client), isNull);
  });

  test('fails without a connection', () async {
    final client = _clientAnswering(
      () => Stream.error(const ServerException()),
    );

    expect(await logoutAllDevices(client), isNull);
  });

  group('logging out everywhere', () {
    Future<
      ({
        Enum_LogoutAllDevicesResult? result,
        _RecordingAuthNotifier auth,
        ProviderContainer app,
      })
    >
    logOutWith(
      Response answer, {
      String? deviceAccount,
      String? signedInAccount,
    }) async {
      SharedPreferences.setMockInitialValues({
        if (deviceAccount != null) secureWeakLoginIdPrefsKey: deviceAccount,
      });
      FlutterSecureStorage.setMockInitialValues({
        if (signedInAccount != null)
          secureStrongTokenKey: _tokenFor(signedInAccount),
      });
      final auth = _RecordingAuthNotifier();
      final app = ProviderContainer(
        overrides: [
          graphqlClientProvider.overrideWithValue(
            _clientAnswering(() => Stream.value(answer)),
          ),
          asyncAuthProvider.overrideWith(() => auth),
          sharedPreferencesProvider.overrideWithValue(
            await SharedPreferences.getInstance(),
          ),
        ],
      );
      addTearDown(app.dispose);
      final result = await logOutEverywhere(app);
      return (result: result, auth: auth, app: app);
    }

    test('signs out here once the backend confirmed, without a page', () async {
      final outcome = await logOutWith(_answer('LOGGED_OUT'));

      expect(outcome.result, Enum_LogoutAllDevicesResult.LOGGED_OUT);
      expect(outcome.auth.signedOut, isTrue);
      expect(outcome.app.read(justLoggedOutProvider), isTrue);
    });

    test('also signs out when the first device keeps its login', () async {
      final outcome = await logOutWith(_answer('DEVICE_LOGIN_KEPT'));

      expect(outcome.result, Enum_LogoutAllDevicesResult.DEVICE_LOGIN_KEPT);
      expect(outcome.auth.signedOut, isTrue);
    });

    test('the first device itself reports a full logout', () async {
      final outcome = await logOutWith(
        _answer('DEVICE_LOGIN_KEPT'),
        deviceAccount: 'account',
        signedInAccount: 'account',
      );

      expect(outcome.result, Enum_LogoutAllDevicesResult.LOGGED_OUT);
      expect(outcome.auth.signedOut, isTrue);
    });

    test('treats a result unknown to this app as signed out', () async {
      final outcome = await logOutWith(_answer('SOMETHING_NEW'));

      expect(outcome.result, Enum_LogoutAllDevicesResult.$unknown);
      expect(outcome.auth.signedOut, isTrue);
    });

    test('stays signed in when the backend did not confirm', () async {
      final outcome = await logOutWith(
        const Response(
          errors: [GraphQLError(message: 'not allowed')],
          response: {},
        ),
      );

      expect(outcome.result, isNull);
      expect(outcome.auth.signedOut, isFalse);
    });
  });
}
