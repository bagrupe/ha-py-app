import 'dart:async';

import 'package:app/common/auth/auth.dart';
import 'package:app/common/crypto/byte_array_converters.dart';
import 'package:app/common/crypto/crypto.dart';
import 'package:app/common/crypto/encrypted_value.dart';
import 'package:app/common/extensions/encrypted_value.dart';
import 'package:app/graphql/__generated__/user.graphql.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql/client.dart';

/// Enthält Schlüssel für persönliche Datenfelder.
class PersonalDataKeys {
  static const vorname = 'Vorname';
  static const nachname = 'Nachname';
  static const gemeinde = 'Gemeinde';
}

/// Repräsentiert ein persönliches Datenfeld mit Schlüssel und Wert.
@immutable
class PersonalData {
  /// Erstellt eine Instanz mit Schlüssel und zugehörigem Wert.
  const PersonalData(this.key, this.value);
  final String key;
  final dynamic value;
}

/// Entschlüsselt einen verschlüsselten Wert und gibt die zugehörigen persönlichen Daten zurück.
/// [ref] ist der Riverpod-Ref für den Zugriff auf Provider.
/// [name] ist der Schlüssel der persönlichen Daten.
/// [value] ist der verschlüsselte Wert.
Future<PersonalData> _decryptPersonalData(
  Ref ref,
  String name,
  EncryptedValue value,
) async {
  final dataKey = ref.watch(authProvider).personalDataKey!;
  final decryptedValue = await Crypto.decrypt(value, dataKey);

  final decodedValue = convertFromByteArray<String>(decryptedValue);

  return PersonalData(name, decodedValue);
}

/// Lädt und entschlüsselt persönliche Daten des angemeldeten Benutzers.
/// [ref] ist der Riverpod-Ref für den Zugriff auf Provider.
/// Gibt einen Stream von Futures zurück, die Listen persönlicher Daten enthalten.
Stream<Future<List<PersonalData>>> _loadPersonalData(Ref ref) {
  final client = ref.watch(graphqlClientProvider);
  final buergerId = ref.watch(authProvider).buergerId;

  return client
      .watchQuery_MyPersonalData(
        WatchOptions_Query_MyPersonalData(
          fetchResults: true,
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
      )
      .stream
      .where((res) => res.parsedData != null || res.isNotLoading)
      .map((res) {
        if (res.parsedData == null && res.hasException) {
          throw res.exception!;
        }
        return res.parsedData!.my;
      })
      .map((my) {
        return my is Query_MyPersonalData_my__Buerger && my.id == buergerId
            ? my
            : null;
      })
      .map(
        (b) => b == null
            ? Future.value(<PersonalData>[])
            : Future.wait(
                b.personalData.map(
                  (data) => _decryptPersonalData(
                    ref,
                    data.key,
                    data.value.toEncryptedValue(),
                  ),
                ),
              ),
      );
}

/// StreamProvider, der die entschlüsselten persönlichen Daten des Benutzers bereitstellt.
final asyncPersonalDataProvider = StreamProvider<List<PersonalData>>((
  ref,
) async* {
  final authState = ref.watch(authProvider);

  if (authState.appAuthState == AppAuthState.loggedIn &&
      authState.personalDataKey != null) {
    final personalDataStream = _loadPersonalData(ref);
    await for (final decryptedData in personalDataStream) {
      final list = await decryptedData;
      yield list;
    }
  }
});

/// Provider, der die persönlichen Daten als Map von Schlüssel zu Wert bereitstellt.
final personalDataProvider = Provider<Map<String, dynamic>?>((ref) {
  final asyncPersonalData = ref.watch(asyncPersonalDataProvider);

  return switch (asyncPersonalData) {
    AsyncData(:final value) => {for (final data in value) data.key: data.value},
    AsyncError() => {},
    _ => null,
  };
});
