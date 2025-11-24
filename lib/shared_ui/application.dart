import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../core/services/navigation/navigation_service.dart';
import 'cubits/screen_observer/screen_observer_cubit.dart';
import 'themes/theme.dart';
import 'utils/screen_util/screen_util.dart';

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
      _screenObserverCubit.update(_getScreenDetails());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Perform initial configuration.
    ScreenUtil.I.configureScreen(_getScreenDetails());
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

  ScreenDetails _getScreenDetails() {
    final view = View.of(context);
    final physicalSize = view.physicalSize;
    final devicePixelRatio = view.devicePixelRatio;
    final logicalSize = Size(
      physicalSize.width / devicePixelRatio,
      physicalSize.height / devicePixelRatio,
    );

    return ScreenDetails(
      logicalSize: logicalSize,
      physicalSize: physicalSize,
      devicePixelRatio: devicePixelRatio,
    );
  }
}
