import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'encrypted_data.dart';

abstract final class EncryptionUtils {
  /// Takes string and returns encryption data with
  /// encrypted content and initialization vector.
  static EncryptedData encrypt(String data) {
    final keyString = dotenv.get("ENCRYPTION_KEY"); // 32-byte key string
    final key = Key.fromUtf8(keyString); // 32-byte key for AES-256
    final encrypter = Encrypter(AES(key));

    // 16 bytes initialization vector for AES encryption
    final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(data, iv: iv);

    return EncryptedData(
      ivBase64: iv.base64,
      encryptedBase64: encrypted.base64,
    );
  }

  /// Takes encrypted data and decrypts the encrypted content
  /// based on the provide initialization vector.
  static String decrypt(EncryptedData data) {
    final keyString = dotenv.get("ENCRYPTION_KEY");
    final key = Key.fromUtf8(keyString);
    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt(
      Encrypted.fromBase64(data.encryptedBase64),
      iv: IV.fromBase64(data.ivBase64),
    );
    return decrypted;
  }
}
