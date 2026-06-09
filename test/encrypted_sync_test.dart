import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_law_reference/services/encrypted_sync_service.dart';

void main() {
  test('EncryptedSyncService roundtrip', () {
    const plain = '{"version":1,"locale":"fr","favorites":[1,2]}';
    const pass = 'test-passphrase-123';
    final encrypted = EncryptedSyncService.encrypt(plain, pass);
    final decrypted = EncryptedSyncService.decrypt(encrypted, pass);
    expect(decrypted, plain);
  });

  test('EncryptedSyncService rejects short passphrase', () {
    expect(() => EncryptedSyncService.encrypt('x', 'short'), throwsArgumentError);
  });
}
