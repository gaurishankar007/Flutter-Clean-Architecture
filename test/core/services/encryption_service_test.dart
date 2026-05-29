import 'package:clean_architecture/core/services/encryption_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Load the .env file before running tests
  setUpAll(() async {
    await dotenv.load();
  });

  group('EncryptionUtils', () {
    const originalText = 'This is a secret message!';
    late EncryptionServiceImpl encryptionService;

    setUp(() {
      encryptionService = EncryptionServiceImpl();
    });

    test('should encrypt and then decrypt data back to its original form', () {
      // Encrypt the data
      final encryptedData = encryptionService.encrypt(originalText);

      // Ensure the encrypted content is not the same as the original
      expect(encryptedData.encryptedBase64, isNot(equals(originalText)));

      // Decrypt the data
      final decryptedText = encryptionService.decrypt(encryptedData);

      // Expect the decrypted text to match the original text
      expect(decryptedText, equals(originalText));
    });

    test('encryption should produce different output for the same input', () {
      final encryptedData1 = encryptionService.encrypt(originalText);
      final encryptedData2 = encryptionService.encrypt(originalText);

      // Because of the random IV, the encrypted output should be different
      expect(
        encryptedData1.encryptedBase64,
        isNot(equals(encryptedData2.encryptedBase64)),
      );
    });
  });
}
