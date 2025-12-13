import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class BaseCheckbox extends StatelessWidget {
  final double? scale;
  final bool value;
  final Function(bool?)? onChanged;
  final String? title;

  const BaseCheckbox({
    super.key,
    this.scale = .85,
    required this.value,
    this.onChanged,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Transform.scale(
      scale: scale,
      child: Checkbox(
        value: value,
        fillColor: WidgetStateColor.resolveWith(
          (states) => value ? AppColors.hightLight : Colors.transparent,
        ),
        side: value
            ? null
            : const BorderSide(width: 1.2, color: AppColors.black),
        onChanged: onChanged,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    if (title != null) {
      final textColor = value ? AppColors.hightLight : AppColors.base;
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          UIHelpers.spaceH8,
          BaseText(title!, color: textColor, fontWeight: FontWeight.w500),
        ],
      );
    }

    return child;
  }
}
