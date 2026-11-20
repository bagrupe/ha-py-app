import 'dart:convert';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/shared_preferences.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:app/routes/profil/my_account/my_account_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingAuthNotifier extends AuthStateNotifier {
  final deviceLoginAtBuild = <String?>[];

  @override
  Future<AuthState> build() async {
    deviceLoginAtBuild.add(
      ref.read(sharedPreferencesProvider).getString(secureWeakLoginIdPrefsKey),
    );
    return AuthState.registering();
  }
}

void main() {
  test('an outdated client still reports an ended session', () async {
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
      ],
    );
    addTearDown(container.dispose);

    await http.runWithClient(
      () async {
        final outdated = container.read(graphqlClientProvider);
        container
          ..invalidate(graphqlClientProvider)
          ..read(graphqlClientProvider);

        await outdated.query(
          QueryOptions(
            document: gql('query My { my { id } }'),
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );
      },
      () => MockClient((request) async {
        if (request.url.path.endsWith('/refresh')) {
          return http.Response('', 401);
        }
        return http.Response(
          jsonEncode({
            'errors': [
              {
                'message': 'not authorized',
                'extensions': {'code': 'AUTH_NOT_AUTHORIZED'},
              },
            ],
          }),
          401,
        );
      }),
    );

    expect(container.read(strongSessionExpiredProvider), isTrue);
    expect(container.read(authTokenProvider), isNull);
  });

  test(
    'a rejected device login rebuilds the auth state without credentials',
    () async {
      SharedPreferences.setMockInitialValues({
        secureWeakLoginIdPrefsKey: 'first-device',
      });
      FlutterSecureStorage.setMockInitialValues({
        secureStrongTokenKey: 'strong',
        secureStrongRefreshTokenKey: 'strong-refresh',
        secureWeakLoginTokenPrefsKey: 'weak-login-token',
        secureDerivedServerLoginPasswordKey: 'password',
      });
      final auth = _RecordingAuthNotifier();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(
            await SharedPreferences.getInstance(),
          ),
          asyncAuthProvider.overrideWith(() => auth),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(asyncAuthProvider, (_, _) {});
      addTearDown(sub.close);
      await container.read(asyncAuthProvider.future);
      late GraphQLClient client;

      await http.runWithClient(
        () {
          client = container.read(graphqlClientProvider);
          return client.query(
            QueryOptions(
              document: gql('query My { my { id } }'),
              fetchPolicy: FetchPolicy.networkOnly,
            ),
          );
        },
        () => MockClient((request) async {
          if (request.url.path.endsWith('/refresh')) {
            return http.Response('', 401);
          }
          if (request.body.contains('loginBuergerWeak')) {
            return http.Response(
              jsonEncode({
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
              }),
              200,
            );
          }
          return http.Response(
            jsonEncode({
              'errors': [
                {
                  'message': 'not authorized',
                  'extensions': {'code': 'AUTH_NOT_AUTHORIZED'},
                },
              ],
            }),
            401,
          );
        }),
      );
      await container.read(asyncAuthProvider.future);

      expect(auth.deviceLoginAtBuild.last, isNull);
      expect(container.read(strongSessionExpiredProvider), isTrue);
      expect(container.read(graphqlClientProvider), isNot(same(client)));
    },
  );
}
