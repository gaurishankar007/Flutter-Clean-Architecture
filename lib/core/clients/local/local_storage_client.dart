import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:clean_architecture/core/utils/encryption/encryption_utils.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalStorageClient {
  Future<void> setString(String key, String value);
  Future<void> setStringWithEncryption(String key, String value);
  String? getString(String key);
  String? getEncryptedString(String key);
  bool has(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

@module
abstract class LocalStorageClientModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}

@LazySingleton(as: LocalStorageClient)
final class LocalStorageClientImpl implements LocalStorageClient {
  const LocalStorageClientImpl({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

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
    if (encodedEncryption == null) {
      return null;
    }
    final encryptionMap = jsonDecode(encodedEncryption) as MapDynamic;
    final encryptedData = EncryptedData.fromJson(encryptionMap);
    return EncryptionUtils.decrypt(encryptedData);
  }

  @override
  bool has(String key) => sharedPreferences.containsKey(key);

  @override
  Future<void> remove(String key) => sharedPreferences.remove(key);

  @override
  Future<void> clear() => sharedPreferences.clear();
}
