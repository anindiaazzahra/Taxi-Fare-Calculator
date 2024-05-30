import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionUtil {
  static final String _keyString = dotenv.env['SECRET_KEY']!.padRight(32, '\0');
  static final encrypt.Key _key = encrypt.Key.fromUtf8(_keyString);
  static final encrypt.IV _iv = encrypt.IV.fromUtf8("1234567890123456");

  static String encryptText(String text) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
