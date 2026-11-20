// ignore_for_file: cascade_invocations

import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/common/crypto/encrypted_value.dart';
import 'package:app/common/extensions/random_bytes.dart';
import 'package:app/common/extensions/string.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cryptography_flutter_plus/cryptography_flutter_plus.dart';
import 'package:cryptography_plus/cryptography_plus.dart'
    hide PublicKey, SecureRandom;
import 'package:cryptography_plus/dart.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';

/// Statische Klasse mit kryptographischen Hilfsmethoden für Schlüsselgenerierung, Verschlüsselung und Entschlüsselung.
abstract final class Crypto {
  /// Erzeugt einen zufälligen Schlüssel mit 32 Bytes Länge.
  static Uint8List getRandomKey() {
    const keySize = 32;

    return Random.secure().nextBytes(keySize);
  }

  /// Verschlüsselt einen gemeinsamen Schlüssel mit einem öffentlichen Schlüssel im Base64-Format.
  static String wrapKeyWithBase64(Uint8List sharedKey, String base64PublicKey) {
    final publicKey = CryptoUtils.rsaPublicKeyFromDERBytes(
      base64PublicKey.toBase64Bytes(),
    );

    return wrapKey(sharedKey, publicKey);
  }

  /// Verschlüsselt einen gemeinsamen Schlüssel mit einem RSA-öffentlichen Schlüssel.
  static String wrapKey(Uint8List sharedKey, PublicKey publicKey) {
    final encryptor = OAEPEncoding.withCustomDigest(
      SHA512Digest.new,
      RSAEngine(),
    )..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    return encryptor.process(sharedKey).toBase64String();
  }

  /// Entschlüsselt einen verschlüsselten Schlüssel mit einem privaten RSA-Schlüssel.
  static Uint8List unwrapKey(String encryptedKey, PrivateKey privateKey) {
    final decryptor = OAEPEncoding.withCustomDigest(
      SHA512Digest.new,
      RSAEngine(),
    )..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    return decryptor.process(encryptedKey.toBase64Bytes());
  }

  /// Generiert ein RSA-Schlüsselpaar mit 2048 Bit und Exponent 65537.
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRsaKey(
    SecureRandom random,
  ) {
    final keyGen = RSAKeyGenerator();
    keyGen.init(
      ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
        random,
      ),
    );
    final pair = keyGen.generateKeyPair();

    // keys must be cast separately, casting the pair throws
    return AsymmetricKeyPair(pair.publicKey, pair.privateKey);
  }

  /// Verschlüsselt Daten mit AES-GCM und einem 256-Bit-Schlüssel.
  static Future<EncryptedValue> encrypt(Uint8List plain, Uint8List key) async {
    final aes = FlutterAesGcm.with256bits();
    final nonce = Random.secure().nextBytes(aes.nonceLength);

    final encrypted = await aes.encrypt(
      plain,
      nonce: nonce,
      secretKey: SecretKey(key),
    );

    final tag = Uint8List.fromList(encrypted.mac.bytes);
    final cipherBytes = Uint8List.fromList(encrypted.cipherText);

    return EncryptedValue(
      nonce.toBase64String(),
      tag.toBase64String(),
      cipherBytes.toBase64String(),
    );
  }

  /// Entschlüsselt AES-GCM-verschlüsselte Daten mit dem gegebenen Schlüssel.
  static Future<Uint8List> decrypt(
    EncryptedValue encryptedValue,
    Uint8List key,
  ) async {
    final aes = FlutterAesGcm.with256bits();

    final decrypted = await aes.decrypt(
      encryptedValue.asSecretBox,
      secretKey: SecretKey(key),
    );

    return Uint8List.fromList(decrypted);
  }

  /// Verschlüsselt den privaten Schlüssel mit einem Passwort und gibt den verschlüsselten Wert sowie das verwendete Salt zurück.
  static Future<(EncryptedValue, Uint8List salt)> encryptPersonalKey(
    String password,
    RSAPrivateKey privateKey,
    int iterations, [
    Uint8List? externalSalt,
  ]) async {
    final salt = externalSalt ?? Random.secure().nextBytes(64);
    final derived = await Crypto.deriveKeyInIsolate(
      password.toUtf8Bytes(),
      salt: salt,
      bits: 256,
      iterations: iterations,
    );

    final keyBytes = CryptoUtils.getBytesFromPEMString(
      CryptoUtils.encodeRSAPrivateKeyToPem(privateKey),
    );
    final encryptedKey = await Crypto.encrypt(keyBytes, derived);

    return (encryptedKey, salt);
  }

  /// Entschlüsselt den privaten Schlüssel mit Passwort, Salt und verschlüsseltem Schlüssel.
  static Future<RSAPrivateKey> decryptPersonalKey(
    String password,
    Uint8List salt,
    EncryptedValue encryptedKey,
    int iterations,
  ) async {
    final derived = await Crypto.deriveKeyInIsolate(
      password.toUtf8Bytes(),
      salt: salt,
      bits: 256,
      iterations: iterations,
    );
    final privateKeyBytes = await Crypto.decrypt(encryptedKey, derived);

    return CryptoUtils.rsaPrivateKeyFromDERBytes(privateKeyBytes);
  }

  /// Leitet einen Schlüssel in einem Isolat ab, um die UI nicht zu blockieren.
  static Future<Uint8List> deriveKeyInIsolate(
    Uint8List source, {
    required int bits,
    required Uint8List salt,
    int iterations = 100000,
  }) async {
    return Isolate.run(() async {
      return deriveKey(source, bits: bits, salt: salt, iterations: iterations);
    });
  }

  /// Leitet einen Schlüssel mit PBKDF2 unter Verwendung von HMAC-SHA512 ab.
  static Future<Uint8List> deriveKey(
    Uint8List source, {
    required int bits,
    required Uint8List salt,
    int iterations = 100000,
  }) async {
    final flutterKdf = FlutterPbkdf2(
      macAlgorithm: Hmac(Sha512()),
      bits: bits,
      iterations: iterations,
      fallback: DartPbkdf2(
        macAlgorithm: Hmac(Sha512()),
        bits: bits,
        iterations: iterations,
      ),
    );
    final derivedPasswordKey = await flutterKdf.deriveKey(
      secretKey: SecretKey(source),
      nonce: salt,
    );

    return Uint8List.fromList(await derivedPasswordKey.extractBytes());
  }

  /// Erzeugt ein sicheres Server-Login-Passwort aus einem schwachen Token und Iterationsanzahl.
  static Future<String> getServerLoginPassword(
    Uint8List weakToken,
    int iterations,
  ) async {
    final derivedPassword = await Crypto.deriveKeyInIsolate(
      weakToken,
      bits: 512,
      salt: weakToken,
      iterations: iterations,
    );

    return derivedPassword.toBase64String();
  }
}
