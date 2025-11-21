part of 'encryption_utils.dart';

class EncryptedData {
  /// Initialization Vector (IV) in base64
  final String ivBase64;

  /// Encrypted base64 data
  final String encryptedBase64;

  const EncryptedData({required this.ivBase64, required this.encryptedBase64});

  const EncryptedData.empty() : ivBase64 = "", encryptedBase64 = "";

  EncryptedData copyWith({String? initializationVector, String? encryption}) {
    return EncryptedData(
      ivBase64: initializationVector ?? ivBase64,
      encryptedBase64: encryption ?? encryptedBase64,
    );
  }

  factory EncryptedData.fromJson(Map<String, dynamic> map) {
    return EncryptedData(
      ivBase64: map['initializationVector'] ?? "",
      encryptedBase64: map['encryption'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'initializationVector': ivBase64,
    'encryption': encryptedBase64,
  };
}
