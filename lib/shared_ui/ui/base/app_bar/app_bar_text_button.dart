import 'package:clean_architecture/shared_ui/ui/base/buttons/base_text_button.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:flutter/material.dart';

class AppBarTextButton extends StatelessWidget {
  const AppBarTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.padding,
  });
  final void Function() onPressed;
  final String text;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final Widget child = BaseTextButton(
      onPressed: onPressed,
      text: text,
      textType: TextType.bodyLarge,
      textFontWeight: FontWeight.w500,
      visualDensity: const VisualDensity(horizontal: -3, vertical: -2),
    );

    if (padding != null) {
      return Padding(padding: padding!, child: child);
    }

    return child;
  }
}
