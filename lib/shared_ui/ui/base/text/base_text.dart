import 'package:flutter/material.dart';

part 'text_type.dart';

class BaseText extends StatelessWidget {
  const BaseText(
    this.text, {
    super.key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.color,
    this.textType = TextType.bodyMedium,
    this.fontWeight = FontWeight.normal,
    this.decoration,
    this.decorationColor,
  });

  factory BaseText.caption(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    Color? color,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    Color? decorationColor,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    color: color,
    textType: TextType.caption,
    fontWeight: fontWeight ?? FontWeight.w400,
    decoration: decoration,
    decorationColor: decorationColor,
  );

  factory BaseText.bodySmall(
    String text, {
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    FontWeight? fontWeight,
    TextDecoration? decoration,
    Color? decorationColor,
  }) => BaseText(
    text,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    color: color,
    textType: TextType.bodySmall,
    fontWeight: fontWeight ?? FontWeight.w400,
    decoration: decoration,
    decorationColor: decorationColor,
  );

  factory BaseText.bodyLarge(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
  }) => BaseText(
    text,
    textAlign: textAlign,
    color: color,
    textType: TextType.bodyLarge,
    fontWeight: fontWeight ?? FontWeight.w400,
  );

  factory BaseText.title(
    String text, {
    TextAlign? textAlign,
    Color? color,
  }) => BaseText(
    text,
    textAlign: textAlign,
    color: color,
    textType: TextType.titleSmall,
    fontWeight: FontWeight.w600,
  );

  factory BaseText.titleMedium(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
  }) => BaseText(
    text,
    textAlign: textAlign,
    color: color,
    textType: TextType.titleMedium,
    fontWeight: fontWeight ?? FontWeight.w600,
  );

  factory BaseText.headline(
    String text, {
    Color? color,
    FontWeight? fontWeight,
  }) => BaseText(
    text,
    color: color,
    textType: TextType.headline,
    fontWeight: fontWeight ?? FontWeight.w600,
  );

  factory BaseText.headlineLarge(String text, {Color? color}) => BaseText(
    text,
    color: color,
    textType: TextType.headlineLarge,
    fontWeight: FontWeight.w600,
  );
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final Color? color;
  final TextType textType;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  final Color? decorationColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: textType.size,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
      ),
    );
  }
}
