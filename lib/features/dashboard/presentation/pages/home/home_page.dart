import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/home/widgets/close_app_dialog.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:clean_architecture/shared_ui/ui/base_title.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      onPopInvokedWithResult: () => showCloseAppDialog(context),
      onRefresh: () async {},
      appBar: const BaseAppBar(
        leading: Icon(AppIcons.user, size: 20, color: AppColors.base),
        title: 'Hello Developers',
        titleFontWeight: FontWeight.w600,
      ),
      isScrollable: false,
      body: const Center(child: BaseTitle(title: 'Home Page')),
    );
  }
}
