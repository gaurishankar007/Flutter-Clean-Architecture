import 'package:clean_architecture/core/utils/extensions/map_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const map = <String, dynamic>{
    'flag': true,
    'name': 'John',
    'count': 3,
    'empty': null,
  };

  group('MapDynamicExtension', () {
    test('hasKey checks the key even when its value is null', () {
      expect(map.hasKey('empty'), isTrue);
      expect(map.hasKey('missing'), isFalse);
    });

    test('hasValue is false for a null or missing value', () {
      expect(map.hasValue('name'), isTrue);
      expect(map.hasValue('empty'), isFalse);
      expect(map.hasValue('missing'), isFalse);
    });

    test('getBool falls back to false', () {
      expect(map.getBool('flag'), isTrue);
      expect(map.getBool('missing'), isFalse);
    });

    test('getString falls back to an empty string', () {
      expect(map.getString('name'), 'John');
      expect(map.getString('missing'), '');
    });

    test('getValue returns the typed value or the default', () {
      expect(map.getValue<int>(key: 'count'), 3);
      expect(map.getValue<int>(key: 'missing', defaultValue: 7), 7);
      expect(map.getValue<int>(key: 'missing'), isNull);
    });
  });
}
