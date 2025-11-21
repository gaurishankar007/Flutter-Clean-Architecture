import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import 'themes/theme.dart';
import 'cubits/screen_observer/screen_observer_cubit.dart';
import '../core/services/navigation/navigation_service.dart';

class CleanArchitectureSample extends StatelessWidget {
  const CleanArchitectureSample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ScreenObserverCubit>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          context.read<ScreenObserverCubit>().update(constraints);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppConfigUtil.I.appTitle,
            theme: lightTheme,
            routerDelegate: NavigationUtil.I.routerDelegate,
            routeInformationParser: NavigationUtil.I.routeInformationParser,
          );
        },
      ),
    );
  }
}