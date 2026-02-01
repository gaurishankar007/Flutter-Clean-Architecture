import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/routing/helper/navigation_client.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/base_icon_button.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget {
  const BaseAppBar({
    super.key,
    this.showLeading = true,
    this.leading,
    required this.title,
    this.titleFontWeight,
    this.titleStyle,
    this.centerTitle = false,
    this.actions,
  });
  final bool showLeading;
  final Widget? leading;
  final String title;
  final FontWeight? titleFontWeight;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    // AppBar padding
    final double horizontalPadding = ScreenUtil.I.horizontalSpace;
    // AppBar leading height and width
    const double leadingSize = 25;
    // The maximum width of the AppBar leading
    final double leadingWidth = showLeading
        ? horizontalPadding + leadingSize
        : 0;
    // Space between Leading and title
    final double titleSpacing = showLeading ? 8 : horizontalPadding;

    Widget? leadingWidget;
    Widget? titleWidget;

    if (showLeading) {
      leadingWidget = Padding(
        padding: UIHelpers.paddingLS,
        child:
            leading ??
            BaseIconButton(
              onPressed: NavigationUtil.I.maybePopTop,
              icon: const Icon(
                AppIcons.arrowLeft,
                size: 20,
                color: AppColors.base,
              ),
              disableSplash: true,
            ),
      );
    }

    if (title.isNotEmpty) {
      titleWidget = BaseText.bodyLarge(
        title,
        color: AppColors.black,
        fontWeight: titleFontWeight,
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      title: titleWidget,
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
