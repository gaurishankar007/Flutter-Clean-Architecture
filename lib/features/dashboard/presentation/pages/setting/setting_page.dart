import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/setting/widgets/blue_container.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/setting/widgets/setting_items.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/primary_button.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();
    return BaseScaffold(
      onPopInvokedWithResult: () => dashboardCubit.setIndex(0),
      isScrollable: false,
      usePadding: false,
      body: Stack(
        children: [
          const BlueContainer(),
          Padding(
            padding: UIHelpers.paddingTB(top: 130, bottom: 12),
            child: Column(
              children: [
                const SettingItems(),
                const Spacer(),
                PrimaryButton(
                  onTap: dashboardCubit.logOut,
                  text: 'Logout',
                  color: AppColors.error,
                  expandWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
