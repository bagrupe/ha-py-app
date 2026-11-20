import 'package:app/common/crypto/crypto.dart';
import 'package:app/common/extensions/string.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('encrypt personal key', () async {
    const privateKey =
        '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';
    final importedKey = CryptoUtils.rsaPrivateKeyFromDERBytes(
      privateKey.toBase64Bytes(),
    );
    final testSalt =
        '1234567890123456789012345678901234567890123456789012345678901234'
            .toUtf8Bytes();

    final (encryptedKey, salt) = await Crypto.encryptPersonalKey(
      'password',
      importedKey,
      100000,
      testSalt,
    );

    final decryptedKey = await Crypto.decryptPersonalKey(
      'password',
      salt,
      encryptedKey,
      100000,
    );

    expect(decryptedKey.p, importedKey.p);
    expect(decryptedKey.q, importedKey.q);
  });

  test('server login password', () async {
    expect(
      await Crypto.getServerLoginPassword('password'.toUtf8Bytes(), 20000),
      equals(
        '+oQf/c6QPgXEmi8KjrnoqZxATphG7Mep/bSdebUbalPuIR1zWaUfXoVtoT3QXWdzZxGwoqUrIr7d1lw9dcZH1w==',
      ),
    );

    expect(
      await Crypto.getServerLoginPassword('password'.toUtf8Bytes(), 100000),
      equals(
        '+XfIIKeTppEvvK8yRMQY9cKFXBLkHCYzkj8bErrenjNLC3zuj4+3/FIgRrITrFI72Jen5q9Q9thXkhuX+rjDpg==',
      ),
    );
  });
}
