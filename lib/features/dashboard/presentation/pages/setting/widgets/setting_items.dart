import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class SettingItems extends StatelessWidget {
  const SettingItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: UIHelpers.paddingA16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: UIHelpers.radiusC12,
        boxShadow: const [BoxShadow(color: AppColors.black15, blurRadius: 24)],
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [settingItemWidget(AppIcons.lock, "Change Password")],
      ),
    );
  }

  Widget settingItemWidget(IconData iconData, String name) {
    return Material(
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: UIHelpers.radiusC12,
          side: const BorderSide(color: AppColors.border),
        ),
        contentPadding: UIHelpers.paddingH16V8,
        horizontalTitleGap: 8,
        leading: Icon(iconData, size: 22),
        title: BaseText.bodyLarge(name),
        trailing: const Icon(AppIcons.arrow_right, size: 22),
      ),
    );
  }
}
