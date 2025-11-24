import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:injectable/injectable.dart';

import '../../utils/screen_util/screen_util.dart';
import '../base/base_cubit.dart';

part 'screen_observer_state.dart';

/// A cubit that observes and reports screen layout changes, allowing widgets
/// to rebuild selectively based on the type of change.
@injectable
class ScreenObserverCubit extends BaseCubit<ScreenObserverState> {
  ScreenObserverCubit() : super(ScreenObserverState.initial());

  /// Tracks build calls to avoid updating state on the initial build.
  int _buildCount = 0;

  void update(ScreenDetails screenDetails) {
    final oldScreenType = ScreenUtil.I.type;
    final wasDesktop = ScreenUtil.I.isWebDesktopScreen;

    // Update screen dimensions and type
    ScreenUtil.I.configureScreen(screenDetails);

    final newScreenType = ScreenUtil.I.type;
    final isDesktop = ScreenUtil.I.isWebDesktopScreen;

    // Determine if a state update is needed
    final hasScreenTypeChanged = oldScreenType != newScreenType;
    final hasDesktopLayoutChanged = wasDesktop != isDesktop;

    // Avoid emitting state during the first build of MaterialApp.
    if (_buildCount++ < 1) return;

    // Delay update to post-frame to avoid rebuilds during a build cycle.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emit(
        state.copyWith(
          width: ScreenUtil.I.width,
          height: ScreenUtil.I.height,
          screenTypeChanges: hasScreenTypeChanged
              ? state.screenTypeChanges + 1
              : null,
          desktopLayoutChanges: hasDesktopLayoutChanged
              ? state.desktopLayoutChanges + 1
              : null,
        ),
      );
    });
  }
}
