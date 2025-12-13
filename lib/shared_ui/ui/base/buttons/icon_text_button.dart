import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final Function() onPressed;
  final IconData iconData;
  final String text;
  final Color? iconColor;
  final double? iconSize;
  final Color? textColor;

  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.iconData,
    required this.text,
    this.iconColor,
    this.iconSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Color newIconColor = iconColor ?? AppColors.base;

    return InkWell(
      onTap: onPressed,
      borderRadius: UIHelpers.radiusC4,
      child: Padding(
        padding: UIHelpers.paddingA4,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: newIconColor, size: iconSize),
            UIHelpers.spaceH4,
            BaseText(text, color: textColor),
          ],
        ),
      ),
    );
  }
}
