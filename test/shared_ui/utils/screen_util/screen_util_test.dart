import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  void configure(double width, double height) {
    ScreenUtil.I.configureScreen(
      ScreenDetails(
        logicalSize: Size(width, height),
        physicalSize: Size(width, height),
        devicePixelRatio: 1,
      ),
    );
  }

  test('ScreenUtil.I always returns the same singleton instance', () {
    expect(identical(ScreenUtil.I, ScreenUtil.I), isTrue);
  });

  group('screen type and orientation', () {
    test('compact portrait phone', () {
      configure(320, 640);

      expect(ScreenUtil.I.type, ScreenType.compact);
      expect(ScreenUtil.I.orientation, Orientation.portrait);
      expect(ScreenUtil.I.isWithinPhoneView, isTrue);
      expect(ScreenUtil.I.isWithinTabletView, isTrue);
      expect(ScreenUtil.I.isWithinActualPhoneView, isTrue);
      expect(ScreenUtil.I.isDesktopView, isFalse);
    });

    test('phone-sized screen', () {
      configure(400, 800);

      expect(ScreenUtil.I.type, ScreenType.phone);
      expect(ScreenUtil.I.isWithinPhoneView, isTrue);
    });

    test('tablet-sized screen in portrait is not within phone view', () {
      configure(700, 1000);

      expect(ScreenUtil.I.type, ScreenType.tablet);
      expect(ScreenUtil.I.orientation, Orientation.portrait);
      expect(ScreenUtil.I.isWithinPhoneView, isFalse);
      expect(ScreenUtil.I.isWithinTabletView, isTrue);
      // Shortest side (700) exceeds the phone-view threshold (600).
      expect(ScreenUtil.I.isWithinActualPhoneView, isFalse);
    });

    test('large-tablet-sized screen is not within tablet view', () {
      configure(900, 1200);

      expect(ScreenUtil.I.type, ScreenType.largeTablet);
      expect(ScreenUtil.I.isWithinTabletView, isFalse);
    });

    test('desktop-sized screen in landscape is a desktop view', () {
      configure(1920, 1080);

      expect(ScreenUtil.I.type, ScreenType.desktop);
      expect(ScreenUtil.I.orientation, Orientation.landscape);
      expect(ScreenUtil.I.isDesktopView, isTrue);
    });

    test(
      'desktop-sized screen in portrait is not a desktop view natively',
      () {
        configure(1300, 1500);

        expect(ScreenUtil.I.type, ScreenType.desktop);
        expect(ScreenUtil.I.orientation, Orientation.portrait);
        expect(ScreenUtil.I.isDesktopView, isFalse);
      },
    );
  });

  group('valueForCompactOrPhone', () {
    test('returns the mobile value for compact/phone screens', () {
      configure(320, 640);

      expect(
        ScreenUtil.I.valueForCompactOrPhone(base: 20, mobile: 16),
        16,
      );
    });

    test('returns the base value for larger screens', () {
      configure(900, 1200);

      expect(
        ScreenUtil.I.valueForCompactOrPhone(base: 20, mobile: 16),
        20,
      );
    });
  });

  group('grid helpers', () {
    test('gridSpace is smaller on compact/phone screens', () {
      configure(320, 640);
      expect(ScreenUtil.I.gridSpace(), 16);

      configure(900, 1200);
      expect(ScreenUtil.I.gridSpace(), 20);
    });

    test('gridWidth uses 12 columns on desktop, 4 otherwise', () {
      configure(1920, 1080);
      final desktopWidth = ScreenUtil.I.gridWidth();
      final expectedDesktopWidth =
          (ScreenUtil.I.availableWidth() - (ScreenUtil.I.gridSpace() * 11)) /
          12;
      expect(desktopWidth, expectedDesktopWidth);

      configure(700, 1000);
      final tabletWidth = ScreenUtil.I.gridWidth();
      final expectedTabletWidth =
          (ScreenUtil.I.availableWidth() - (ScreenUtil.I.gridSpace() * 3)) / 4;
      expect(tabletWidth, expectedTabletWidth);
    });
  });
}
