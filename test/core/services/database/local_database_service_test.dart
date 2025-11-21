import 'package:clean_architecture/core/services/database/local_database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../testing/mocks/external/external_mocks.dart'
    show MockSharedPreferences;

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalDatabaseServiceImpl localDatabaseService;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDatabaseService = LocalDatabaseServiceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('LocalDatabaseServiceImplementation', () {
    test('getString returns value from SharedPreferences', () async {
      when(() => mockSharedPreferences.getString('key')).thenReturn('value');

      final result = localDatabaseService.getString('key');

      expect(result, 'value');
      verify(() => mockSharedPreferences.getString('key')).called(1);
    });

    test('getString returns null if key does not exist', () async {
      when(() => mockSharedPreferences.getString('missing')).thenReturn(null);

      final result = localDatabaseService.getString('missing');

      expect(result, isNull);
      verify(() => mockSharedPreferences.getString('missing')).called(1);
    });

    test('setString calls setString on SharedPreferences', () async {
      when(
        () => mockSharedPreferences.setString('key', 'value'),
      ).thenAnswer((_) async => true);

      await localDatabaseService.setString('key', 'value');

      verify(() => mockSharedPreferences.setString('key', 'value')).called(1);
    });

    test('remove calls remove on SharedPreferences', () async {
      when(
        () => mockSharedPreferences.remove('key'),
      ).thenAnswer((_) async => true);

      await localDatabaseService.remove('key');

      verify(() => mockSharedPreferences.remove('key')).called(1);
    });

    test('clear calls clear on SharedPreferences', () async {
      when(() => mockSharedPreferences.clear()).thenAnswer((_) async => true);

      await localDatabaseService.clear();

      verify(() => mockSharedPreferences.clear()).called(1);
    });
  });
}
