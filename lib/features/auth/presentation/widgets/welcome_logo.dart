import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared_ui/ui/base/text/base_text.dart';
import '../../../../shared_ui/utils/ui_helpers.dart';

class WelcomeLogo extends StatelessWidget {
  final String title;
  const WelcomeLogo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: UIHelpers.paddingT4B32,
          child: const BaseText(
            "Welcome",
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
