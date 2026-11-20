import 'package:app/common/crypto/encrypted_value.dart';
import 'package:app/graphql/__generated__/fragments.graphql.dart';
import 'package:app/graphql/__generated__/schema.graphql.dart';

/// Erweiterung für EncryptedValue zur Umwandlung in Input-Typen.
extension EncryptedValueExtensions on EncryptedValue {
  /// Wandelt die verschlüsselte Wertinstanz in einen GraphQL Input-Typ um.
  Input_EncryptedValueInput toInput() =>
      Input_EncryptedValueInput(cipher: cipher, nonce: nonce, tag: tag);
}

/// Erweiterung für Fragment_EncryptedValue zur Umwandlung in EncryptedValue.
extension ToEncryptedValueExtensions on Fragment_EncryptedValue {
  /// Erzeugt eine EncryptedValue-Instanz aus dem GraphQL-Fragment.
  EncryptedValue toEncryptedValue() => EncryptedValue(nonce, tag, cipher);
}
