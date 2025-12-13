import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:clean_architecture/core/utils/encryption/encryption_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalDatabaseService {
  Future<void> setString(String key, String value);
  Future<void> setStringWithEncryption(String key, String value);
  String? getString(String key);
  String? getEncryptedString(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

@module
abstract class LocalDatabaseServiceModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}

@LazySingleton(as: LocalDatabaseService)
final class LocalDatabaseServiceImpl implements LocalDatabaseService {
  final SharedPreferences sharedPreferences;

  const LocalDatabaseServiceImpl({required this.sharedPreferences});

  @override
  Future<void> setString(String key, String value) =>
      sharedPreferences.setString(key, value);

  @override
  Future<void> setStringWithEncryption(String key, String value) async {
    final encryptedData = EncryptionUtils.encrypt(value);
    final encodedEncryption = jsonEncode(encryptedData.toJson());
    await sharedPreferences.setString(key, encodedEncryption);
  }

  @override
  String? getString(String key) => sharedPreferences.getString(key);

  @override
  String? getEncryptedString(String key) {
    final encodedEncryption = sharedPreferences.getString(key);
    if (encodedEncryption == null) return null;
    final encryptedData = EncryptedData.fromJson(jsonDecode(encodedEncryption));
    return EncryptionUtils.decrypt(encryptedData);
  }

  @override
  Future<void> remove(String key) => sharedPreferences.remove(key);

  @override
  Future<void> clear() => sharedPreferences.clear();
}
