import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared_ui/cubits/screen_observer/screen_observer_cubit.dart';
import '../../../../../shared_ui/utils/screen_util/screen_util.dart';
import '../../cubits/dashboard/dashboard_cubit.dart';
import 'widgets/base_bottom_navigation.dart';
import 'widgets/dashboard_drawer.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<DashboardCubit>()..initialize(),
        ),
      ],
      child: BlocBuilder<ScreenObserverCubit, ScreenObserverState>(
        buildWhen: (previous, current) =>
            previous.desktopLayoutChanges != current.desktopLayoutChanges,
        builder: (context, state) {
          final isDesktopLargeScreen = ScreenUtil.I.isWebDesktopScreen;
          return Row(
            children: [
              if (isDesktopLargeScreen) DashboardDrawer(),
              Flexible(
                child: Container(
                  color: AppColors.surface,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: const AutoRouter(),
                      ),
                      if (!isDesktopLargeScreen)
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: BaseBottomNavigation(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
