import 'dart:convert';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/startup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('a reinstall discards and revokes a leftover session', () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({
      secureStrongTokenKey: 'leftover-token',
      secureStrongRefreshTokenKey: 'leftover-refresh',
    });
    final revoked = <String>[];

    await http.runWithClient(
      () async {
        await getInitialAuthToken();
        await pumpEventQueue();
      },
      () => MockClient((request) async {
        if (request.url.path.endsWith('/api/auth/session/revoke')) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          revoked.add(body['refreshToken'] as String);
        }
        return http.Response('', 204);
      }),
    );

    const storage = FlutterSecureStorage();
    expect(await storage.read(key: secureStrongTokenKey), isNull);
    expect(await storage.read(key: secureStrongRefreshTokenKey), isNull);
    expect(revoked, ['leftover-refresh']);
  });

  test('a normal start keeps the stored session', () async {
    SharedPreferences.setMockInitialValues({
      secureWeakLoginIdPrefsKey: 'device',
    });
    FlutterSecureStorage.setMockInitialValues({
      secureStrongTokenKey: 'token',
      secureStrongRefreshTokenKey: 'refresh',
    });

    await getInitialAuthToken();

    const storage = FlutterSecureStorage();
    expect(await storage.read(key: secureStrongTokenKey), 'token');
    expect(await storage.read(key: secureStrongRefreshTokenKey), 'refresh');
  });
}
