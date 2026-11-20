import 'dart:async';
import 'dart:typed_data';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/auth/personal_data.dart';
import 'package:app/common/crypto/byte_array_converters.dart';
import 'package:app/common/crypto/crypto.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart'
    show possibleTypesMap;
import 'package:app/graphql/__generated__/user.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

/// Verifies encrypted profile cache availability while network requests fail.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'cached personal data remains available after an offline refresh',
    () async {
      final key = Uint8List.fromList(List<int>.generate(32, (index) => index));
      final encrypted = await Crypto.encrypt(
        await convertToByteArray('Marie'),
        key,
      );
      final networkFailed = Completer<void>();
      final cache = GraphQLCache(possibleTypes: possibleTypesMap)
        ..writeQuery(
          const Request(
            operation: Operation(document: documentNodeQueryMyPersonalData),
          ),
          data: {
            '__typename': 'Query',
            'my': {
              '__typename': 'Buerger',
              'id': 'citizen',
              'personalData': [
                {
                  '__typename': 'BuergerPersonalData',
                  'id': 'first-name',
                  'key': PersonalDataKeys.vorname,
                  'value': {
                    '__typename': 'EncryptedValue',
                    'nonce': encrypted.nonce,
                    'tag': encrypted.tag,
                    'cipher': encrypted.cipher,
                  },
                },
              ],
            },
          },
        );
      final client = GraphQLClient(
        cache: cache,
        link: Link.function((request, [forward]) async* {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          networkFailed.complete();
          throw const ServerException(originalException: 'offline');
        }),
      );
      final container = ProviderContainer(
        overrides: [
          graphqlClientProvider.overrideWithValue(client),
          authProvider.overrideWithValue(AuthState(null, null, key, 'citizen')),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        asyncPersonalDataProvider,
        (_, next) {},
      );
      addTearDown(subscription.close);

      final data = await container.read(asyncPersonalDataProvider.future);
      expect(data.single.value, 'Marie');
      await networkFailed.future;
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(container.read(personalDataProvider), {
        PersonalDataKeys.vorname: 'Marie',
      });
    },
  );
}
