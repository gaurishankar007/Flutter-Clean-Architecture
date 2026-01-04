import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/primary_button.dart';
import 'package:clean_architecture/shared_ui/ui/base/connection_failed/network_tower.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class ConnectionFailed extends StatelessWidget {
  const ConnectionFailed({super.key, required this.callBack});
  final Future<void> Function() callBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: UIHelpers.paddingT12B24,
            child: const NetworkTower(),
          ),
          const Text(
            'Whoops!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
          ),
          BaseText.title(
            'Connection Failure 🛰️',
            textAlign: TextAlign.center,
            color: AppColors.black,
          ),
          const Spacer(),
          PrimaryButton(
            expandWidth: true,
            onTap: callBack,
            color: Colors.indigo,
            text: 'Try Again',
          ),
        ],
      ),
    );
  }
}
