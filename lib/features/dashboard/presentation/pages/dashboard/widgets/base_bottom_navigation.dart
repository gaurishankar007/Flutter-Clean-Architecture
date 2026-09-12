import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/routing/navigation_client.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/base_icon_button.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class BaseBottomNavigation extends StatelessWidget {
  const BaseBottomNavigation({super.key});

  static const List<PageRouteInfo> _routes = [HomeRoute(), SettingRoute()];

  @override
  Widget build(BuildContext context) {
    final icons = [AppIcons.home, AppIcons.setting];

    return Container(
      height: ScreenUtil.I.bottomNavigationHeight,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: UIHelpers.radiusC16,
        boxShadow: const [
          BoxShadow(color: AppColors.black10, spreadRadius: 2, blurRadius: 4),
        ],
      ),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) =>
            previous.activeIndex != current.activeIndex,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              return BaseIconButton(
                onPressed: () {
                  context.read<DashboardCubit>().setIndex(index);
                  NavigationUtil.I.replaceAllRoute(_routes[index]);
                },
                visualDensity: VisualDensity.standard,
                padding: const EdgeInsets.all(10),
                icon: Icon(
                  icons[index],
                  size: 20,
                  color: index == state.activeIndex
                      ? AppColors.primary
                      : AppColors.fade.withAlpha(153),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
