import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:flutter/material.dart';

class BaseTitle extends StatelessWidget {
  final String title;
  final Color? color;

  const BaseTitle({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return BaseText.title(title, color: color ?? AppColors.blackE1);
  }
}
