import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:flutter/material.dart';

class BaseTextButton extends StatelessWidget {
  const BaseTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.textType,
    this.textFontWeight,
    this.color,
    this.padding,
    this.visualDensity,
    this.elevation,
  });
  final void Function() onPressed;
  final String text;
  final Color? textColor;
  final TextType? textType;
  final FontWeight? textFontWeight;
  final Color? color;
  final EdgeInsets? padding;
  final VisualDensity? visualDensity;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: padding,
        visualDensity: visualDensity,
        elevation: elevation,
      ),
      child: BaseText(
        text,
        color: textColor ?? AppColors.hightLight,
        textType: textType ?? TextType.bodyLarge,
        fontWeight: textFontWeight ?? FontWeight.w400,
      ),
    );
  }
}
