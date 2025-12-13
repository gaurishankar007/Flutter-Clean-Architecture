import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:flutter/material.dart';

enum Space {
  tiny(1),
  xxxSmall(2),
  xxSmall(4),
  xSmall(8),
  small(12),
  sMedium(16),
  medium(20),
  large(24),
  lMedium(28),
  xLarge(32),
  xlMedium(36),
  xxLarge(40),
  xxxLarge(48),
  massive(64);

  const Space(this.value);
  final double value;
}

abstract interface class UIHelpers {
  //<========== Horizontal Spacing ==========>
  static final spaceH2 = SizedBox(width: Space.xxxSmall.value);
  static final spaceH4 = SizedBox(width: Space.xxSmall.value);
  static final spaceH8 = SizedBox(width: Space.xSmall.value);
  static final spaceH12 = SizedBox(width: Space.small.value);
  static final spaceH20 = SizedBox(width: Space.medium.value);
  static final spaceH24 = SizedBox(width: Space.large.value);
  static final spaceH28 = SizedBox(width: Space.lMedium.value);
  static final spaceH32 = SizedBox(width: Space.xLarge.value);
  static final spaceH36 = SizedBox(width: Space.xlMedium.value);
  static SizedBox get spaceHS => SizedBox(width: ScreenUtil.I.horizontalSpace);

  //<========== Vertical Spacing ==========>
  static final spaceV2 = SizedBox(height: Space.xxxSmall.value);
  static final spaceV4 = SizedBox(height: Space.xxSmall.value);
  static final spaceV8 = SizedBox(height: Space.xSmall.value);
  static final spaceV12 = SizedBox(height: Space.small.value);
  static final spaceV16 = SizedBox(height: Space.sMedium.value);
  static final spaceV20 = SizedBox(height: Space.medium.value);
  static final spaceV24 = SizedBox(height: Space.large.value);
  static final spaceV28 = SizedBox(height: Space.lMedium.value);
  static final spaceV32 = SizedBox(height: Space.xLarge.value);
  static final spaceV36 = SizedBox(height: Space.xlMedium.value);
  static final spaceV40 = SizedBox(height: Space.xxLarge.value);
  static final spaceV48 = SizedBox(height: Space.xxxLarge.value);
  static final spaceV64 = SizedBox(height: Space.massive.value);
  static SizedBox get spaceVS => SizedBox(height: ScreenUtil.I.verticalSpace);

  //<========== All Padding ==========>
  static final paddingA2 = EdgeInsets.all(Space.xxxSmall.value);
  static final paddingA4 = EdgeInsets.all(Space.xxSmall.value);
  static final paddingA8 = EdgeInsets.all(Space.xSmall.value);
  static final paddingA12 = EdgeInsets.all(Space.small.value);
  static final paddingA16 = EdgeInsets.all(Space.sMedium.value);
  static final paddingA24 = EdgeInsets.all(Space.large.value);
  static final paddingA32 = EdgeInsets.all(Space.xLarge.value);
  static final paddingA36 = EdgeInsets.all(Space.xlMedium.value);
  static EdgeInsets get paddingAS => EdgeInsets.symmetric(
    horizontal: ScreenUtil.I.horizontalSpace,
    vertical: ScreenUtil.I.verticalSpace,
  );

  //<========== Horizontal Padding ==========>
  static final paddingH8 = EdgeInsets.symmetric(horizontal: Space.xSmall.value);
  static final paddingH12 = EdgeInsets.symmetric(horizontal: Space.small.value);
  static final paddingH24 = EdgeInsets.symmetric(horizontal: Space.large.value);
  static EdgeInsets get paddingHS =>
      EdgeInsets.symmetric(horizontal: ScreenUtil.I.horizontalSpace);

  //<========== Vertical Padding ==========>
  static final paddingV1 = EdgeInsets.symmetric(vertical: Space.tiny.value);
  static final paddingV4 = EdgeInsets.symmetric(vertical: Space.xxSmall.value);
  static final paddingV12 = EdgeInsets.symmetric(vertical: Space.small.value);
  static final paddingV16 = EdgeInsets.symmetric(vertical: Space.sMedium.value);
  static final paddingV20 = EdgeInsets.symmetric(vertical: Space.medium.value);
  static final paddingV24 = EdgeInsets.symmetric(vertical: Space.large.value);
  static final paddingV32 = EdgeInsets.symmetric(vertical: Space.xLarge.value);

  //<========== Symmetric Padding ==========>
  static final paddingH16V8 = EdgeInsets.symmetric(
    horizontal: Space.sMedium.value,
    vertical: Space.xSmall.value,
  );
  static final paddingH16V12 = EdgeInsets.symmetric(
    horizontal: Space.sMedium.value,
    vertical: Space.small.value,
  );
  static final paddingH16V20 = EdgeInsets.symmetric(
    horizontal: Space.sMedium.value,
    vertical: Space.medium.value,
  );
  static final paddingH20V12 = EdgeInsets.symmetric(
    horizontal: Space.medium.value,
    vertical: Space.small.value,
  );
  static final paddingH24V16 = EdgeInsets.symmetric(
    horizontal: Space.large.value,
    vertical: Space.sMedium.value,
  );
  static final paddingH24V20 = EdgeInsets.symmetric(
    horizontal: Space.large.value,
    vertical: Space.medium.value,
  );
  static final paddingH24V36 = EdgeInsets.symmetric(
    horizontal: Space.large.value,
    vertical: Space.xlMedium.value,
  );
  static EdgeInsets get paddingHSV16 => EdgeInsets.symmetric(
    horizontal: ScreenUtil.I.horizontalSpace,
    vertical: Space.sMedium.value,
  );

  //<========== Left Padding ==========>
  static EdgeInsets get paddingLS =>
      EdgeInsets.only(left: ScreenUtil.I.horizontalSpace);

  //<========== Top Padding ==========>
  static final paddingT12 = EdgeInsets.only(top: Space.small.value);
  static final paddingT24 = EdgeInsets.only(top: Space.large.value);
  static final paddingT32 = EdgeInsets.only(top: Space.xLarge.value);

  //<========== Bottom Padding ==========>
  static final paddingB12 = EdgeInsets.only(bottom: Space.small.value);

  //<========== Right Padding ==========>
  /// Right Padding = screen horizontal Padding
  static EdgeInsets get paddingRS =>
      EdgeInsets.only(right: ScreenUtil.I.horizontalSpace);

  //<========== Top Bottom Padding ==========>
  static final paddingT4B32 = EdgeInsets.only(
    top: Space.xxSmall.value,
    bottom: Space.xLarge.value,
  );
  static final paddingT8B4 = EdgeInsets.only(
    top: Space.xSmall.value,
    bottom: Space.xxSmall.value,
  );
  static final paddingT12B24 = EdgeInsets.only(
    top: Space.small.value,
    bottom: Space.large.value,
  );
  static final paddingT12B40 = EdgeInsets.only(
    top: Space.small.value,
    bottom: Space.xxLarge.value,
  );
  static final paddingT20B4 = EdgeInsets.only(
    top: Space.medium.value,
    bottom: Space.xxSmall.value,
  );
  static final paddingT20B24 = EdgeInsets.only(
    top: Space.medium.value,
    bottom: Space.large.value,
  );

  //<========== Only Padding ==========>
  /// Creates an [EdgeInsets] with screen horizontal padding on the left and right,
  /// and customizable [top] and [bottom] paddings, default to `16.0` if not provided.
  static EdgeInsets paddingTB({double? top, double? bottom}) => EdgeInsets.only(
    top: top ?? Space.sMedium.value,
    right: ScreenUtil.I.horizontalSpace,
    bottom: bottom ?? Space.sMedium.value,
    left: ScreenUtil.I.horizontalSpace,
  );

  //<========== Border Radius ==========>
  static final radiusC2 = BorderRadius.circular(Space.xxxSmall.value);
  static final radiusC4 = BorderRadius.circular(Space.xxSmall.value);
  static final radiusC8 = BorderRadius.circular(Space.xSmall.value);
  static final radiusC12 = BorderRadius.circular(Space.small.value);
  static final radiusC16 = BorderRadius.circular(Space.sMedium.value);
  static final radiusC24 = BorderRadius.circular(Space.large.value);
  static final radiusB12 = BorderRadius.only(
    bottomRight: Radius.circular(Space.small.value),
    bottomLeft: Radius.circular(Space.small.value),
  );
  static final radiusTR4BR4 = BorderRadius.only(
    topRight: Radius.circular(Space.xxSmall.value),
    bottomRight: Radius.circular(Space.xxSmall.value),
  );
  static final radiusTL24TR24 = BorderRadius.only(
    topLeft: Radius.circular(Space.large.value),
    topRight: Radius.circular(Space.large.value),
  );
}
