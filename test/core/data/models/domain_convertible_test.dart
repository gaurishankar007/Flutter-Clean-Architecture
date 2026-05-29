import 'package:clean_architecture/core/data/models/domain_convertible.dart';
import 'package:flutter_test/flutter_test.dart';

/// A simple domain class for testing purposes.
class TestDomainEntity {
  const TestDomainEntity(this.id);
  final String id;
}

/// A concrete implementation of [DomainConvertible] for testing.
class TestDto implements DomainConvertible<TestDomainEntity> {
  const TestDto(this.id);
  final String id;

  @override
  TestDomainEntity toDomain() {
    return TestDomainEntity(id);
  }
}

void main() {
  group('DomainConvertible', () {
    test('should convert implementing class to expected domain type', () {
      const dto = TestDto('123');
      final result = dto.toDomain();

      expect(result, isA<TestDomainEntity>());
      expect(result.id, '123');
    });
  });
}
