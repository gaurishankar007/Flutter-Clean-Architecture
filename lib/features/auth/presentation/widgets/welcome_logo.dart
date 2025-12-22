import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: UIHelpers.paddingT4B32,
          child: const BaseText(
            'Welcome',
            color: AppColors.primary,
            textType: TextType.headlineLarge,
            fontWeight: FontWeight.w900,
          ),
        ),
        UIHelpers.spaceV20,
        Align(
          alignment: Alignment.centerLeft,
          child: BaseText.titleMedium(title, color: AppColors.blackE1),
        ),
      ],
    );
  }
}
