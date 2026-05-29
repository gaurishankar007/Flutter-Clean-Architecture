import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:clean_architecture/core/data/models/encrypted_data.dart';
import 'package:clean_architecture/core/services/encryption_service.dart';
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
  const LocalStorageClientImpl({
    required SharedPreferences sharedPreferences,
    required EncryptionService encryptionService,
  }) : _sharedPreferences = sharedPreferences,
       _encryptionService = encryptionService;

  final SharedPreferences _sharedPreferences;
  final EncryptionService _encryptionService;

  @override
  Future<void> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  @override
  Future<void> setStringWithEncryption(String key, String value) async {
    final encryptedData = _encryptionService.encrypt(value);
    final encodedEncryption = jsonEncode(encryptedData.toJson());
    await _sharedPreferences.setString(key, encodedEncryption);
  }

  @override
  String? getString(String key) => _sharedPreferences.getString(key);

  @override
  String? getEncryptedString(String key) {
    final encodedEncryption = _sharedPreferences.getString(key);
    if (encodedEncryption == null) {
      return null;
    }
    final encryptionMap = jsonDecode(encodedEncryption) as MapDynamic;
    final encryptedData = EncryptedData.fromJson(encryptionMap);
    return _encryptionService.decrypt(encryptedData);
  }

  @override
  bool has(String key) => _sharedPreferences.containsKey(key);

  @override
  Future<void> remove(String key) => _sharedPreferences.remove(key);

  @override
  Future<void> clear() => _sharedPreferences.clear();
}
