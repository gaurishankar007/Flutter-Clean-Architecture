import 'dart:convert';

import 'package:clean_architecture/core/data/models/encrypted_data.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

abstract interface class EncryptionService {
  /// Takes string and returns encryption data with
  /// encrypted content and initialization vector.
  EncryptedData encrypt(String data);

  /// Takes encrypted data and decrypts the encrypted content
  /// based on the provide initialization vector.
  String decrypt(EncryptedData data);

  /// Encrypts the youtube video url and returns a base64 url encoded string.
  String encryptYoutubeUrl(String videoUrl);

  /// Decrypts the base64 url encoded string and returns the youtube video url.
  String decryptYoutubeUrl(String encodedEncryptedData);
}

@LazySingleton(as: EncryptionService)
final class EncryptionServiceImpl implements EncryptionService {
  final String _encryptionKey = dotenv.get('ENCRYPTION_KEY');

  @override
  EncryptedData encrypt(String data) {
    final key = Key.fromUtf8(_encryptionKey);
    final encrypter = Encrypter(AES(key));

    final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(data, iv: iv);

    return EncryptedData(
      ivBase64: iv.base64,
      encryptedBase64: encrypted.base64,
    );
  }

  @override
  String decrypt(EncryptedData data) {
    final key = Key.fromUtf8(_encryptionKey);
    final encrypter = Encrypter(AES(key));

    return encrypter.decrypt(
      Encrypted.fromBase64(data.encryptedBase64),
      iv: IV.fromBase64(data.ivBase64),
    );
  }

  @override
  String encryptYoutubeUrl(String videoUrl) {
    final encryptedData = encrypt(videoUrl);
    final encryptedJson = encryptedData.toJson();
    final jsonString = jsonEncode(encryptedJson);
    final jsonBytes = utf8.encode(jsonString);
    return base64Url.encode(jsonBytes);
  }

  @override
  String decryptYoutubeUrl(String encodedEncryptedData) {
    final jsonBytes = base64Url.decode(encodedEncryptedData);
    final jsonString = utf8.decode(jsonBytes);
    final encryptedJson = jsonDecode(jsonString) as MapDynamic;
    final encryptedData = EncryptedData.fromJson(encryptedJson);
    return decrypt(encryptedData);
  }
}

/// A util class for accessing [EncryptionService] singleton instance.
abstract final class EncryptionProvider {
  /// Returns the [EncryptionService] singleton instance.
  static EncryptionService get I => GetIt.I<EncryptionService>();
}
