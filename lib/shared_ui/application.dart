import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../core/services/internet/internet_service.dart';

class CleanArchitectureSample extends StatefulWidget {
  const CleanArchitectureSample({super.key});

  @override
  State<CleanArchitectureSample> createState() =>
      _CleanArchitectureSampleState();
}

class _CleanArchitectureSampleState extends State<CleanArchitectureSample>
    with WidgetsBindingObserver {
  late final ScreenObserverCubit _screenObserverCubit;

  @override
  void initState() {
    super.initState();
    _screenObserverCubit = GetIt.I<ScreenObserverCubit>();
    WidgetsBinding.instance.addObserver(this);
    // Listen for internet connectivity changes.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => InternetUtil.I.subscribeConnectivity(),
    );
  }

  @override
  void dispose() {
    _screenObserverCubit.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Schedule the screen size update to happen after the current frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Don't update if this context is already unmounted.
      if (!mounted) return;
      _screenObserverCubit.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Perform initial configuration.
    ScreenUtil.I.configureScreen();
    return BlocProvider.value(
      value: _screenObserverCubit,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConfigUtil.I.appTitle,
        theme: lightTheme,
        routerDelegate: NavigationUtil.I.routerDelegate,
        routeInformationParser: NavigationUtil.I.routeInformationParser,
      ),
    );
  }
}
