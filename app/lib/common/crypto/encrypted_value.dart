import 'package:app/common/extensions/string.dart';
import 'package:cryptography_plus/cryptography_plus.dart';

/// Repräsentiert einen verschlüsselten Wert mit den zugehörigen Komponenten.
/// Enthält Nonce, Tag und Chiffretext als Base64-kodierte Strings.
class EncryptedValue {
  /// Erstellt eine Instanz mit Nonce, Tag und Chiffretext.
  EncryptedValue(this.nonce, this.tag, this.cipher);
  final String nonce;
  final String tag;
  final String cipher;

  /// Gibt den verschlüsselten Wert als SecretBox zurück, die für die Entschlüsselung genutzt wird.
  SecretBox get asSecretBox => SecretBox(
    cipher.toBase64Bytes(),
    nonce: nonce.toBase64Bytes(),
    mac: Mac(tag.toBase64Bytes()),
  );
}
