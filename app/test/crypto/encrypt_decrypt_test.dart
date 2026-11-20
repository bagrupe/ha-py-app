import 'package:app/common/crypto/crypto.dart';
import 'package:app/common/extensions/string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Cryto encrypt decrypt cycle', () async {
    final key = Crypto.getRandomKey();

    const payload = 'Hello, world!';
    final payloadBytes = payload.toUtf8Bytes();
    final encrypted = await Crypto.encrypt(payloadBytes, key);
    expect(encrypted.tag.toBase64Bytes().lengthInBytes, 16);

    final decryptedBytes = await Crypto.decrypt(encrypted, key);
    final decryptedPayload = String.fromCharCodes(decryptedBytes);

    expect(decryptedPayload, payload);
  });
}
