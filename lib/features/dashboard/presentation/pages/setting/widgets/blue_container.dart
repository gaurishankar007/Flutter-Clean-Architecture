import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class BlueContainer extends StatelessWidget {
  const BlueContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.maxFinite,
      padding: UIHelpers.paddingHSV16,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: UIHelpers.radiusB12,
      ),
      child: BaseText.headline(
        "Settings",
        color: AppColors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
