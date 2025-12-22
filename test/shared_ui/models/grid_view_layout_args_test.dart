import 'package:clean_architecture/shared_ui/models/grid_view_layout_args.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GridViewLayoutArgs', () {
    const crossAxisSpacing = 10.0;
    const mainAxisSpacing = 20.0;

    test(
      'should create an instance with default values for optional fields',
      () {
        // Arrange
        const args = GridViewLayoutArgs(
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        );

        // Assert
        expect(args.crossAxisCount, 2);
        expect(args.childAspectRatio, 1);
        expect(args.crossAxisSpacing, crossAxisSpacing);
        expect(args.mainAxisSpacing, mainAxisSpacing);
      },
    );

    test('should create an instance with all provided values', () {
      // Arrange
      const args = GridViewLayoutArgs(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      );

      // Assert
      expect(args.crossAxisCount, 3);
      expect(args.childAspectRatio, 0.8);
      expect(args.crossAxisSpacing, crossAxisSpacing);
      expect(args.mainAxisSpacing, mainAxisSpacing);
    });

    group('copyWith', () {
      const initialArgs = GridViewLayoutArgs(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
        crossAxisSpacing: 15,
        mainAxisSpacing: 25,
      );

      test(
        'should return a copy with the same values when no arguments are provided',
        () {
          final newArgs = initialArgs.copyWith();
          expect(newArgs.crossAxisCount, initialArgs.crossAxisCount);
          expect(newArgs.childAspectRatio, initialArgs.childAspectRatio);
          expect(newArgs.crossAxisSpacing, initialArgs.crossAxisSpacing);
          expect(newArgs.mainAxisSpacing, initialArgs.mainAxisSpacing);
        },
      );

      test('should return a copy with only specified values updated', () {
        final newArgs = initialArgs.copyWith(
          crossAxisCount: 5,
          mainAxisSpacing: 30,
        );
        expect(newArgs.crossAxisCount, 5);
        expect(newArgs.childAspectRatio, initialArgs.childAspectRatio);
        expect(newArgs.crossAxisSpacing, initialArgs.crossAxisSpacing);
        expect(newArgs.mainAxisSpacing, 30.0);
      });

      test('should return a copy with all values updated', () {
        final newArgs = initialArgs.copyWith(
          crossAxisCount: 6,
          childAspectRatio: 1.2,
          crossAxisSpacing: 22,
          mainAxisSpacing: 35,
        );
        expect(newArgs.crossAxisCount, 6);
        expect(newArgs.childAspectRatio, 1.2);
        expect(newArgs.crossAxisSpacing, 22.0);
        expect(newArgs.mainAxisSpacing, 35.0);
      });
    });
  });
}
