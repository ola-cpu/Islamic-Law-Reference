import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// Chiffrement AES-256-CBC pour export/import de sauvegarde (sync manuelle cloud).
class EncryptedSyncService {
  static const _minPassphraseLength = 8;

  static String encrypt(String plainText, String passphrase) {
    _validatePassphrase(passphrase);
    final key = Key(Uint8List.fromList(sha256.convert(utf8.encode(passphrase)).bytes));
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return jsonEncode({
      'v': 1,
      'iv': iv.base64,
      'data': encrypted.base64,
    });
  }

  static String decrypt(String payload, String passphrase) {
    _validatePassphrase(passphrase);
    final map = jsonDecode(payload) as Map<String, dynamic>;
    final iv = IV.fromBase64(map['iv'] as String);
    final data = map['data'] as String;
    final key = Key(Uint8List.fromList(sha256.convert(utf8.encode(passphrase)).bytes));
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.fromBase64(data), iv: iv);
  }

  static void _validatePassphrase(String passphrase) {
    if (passphrase.length < _minPassphraseLength) {
      throw ArgumentError('Passphrase too short');
    }
  }
}
