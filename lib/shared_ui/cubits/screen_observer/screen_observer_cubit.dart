import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'screen_observer_state.dart';

/// A cubit that observes and reports screen layout changes, allowing
/// widgets to rebuild selectively based on the different type of changes.
@injectable
class ScreenObserverCubit extends BaseCubit<ScreenObserverState> {
  ScreenObserverCubit() : super(ScreenObserverState.initial());

  void update() {
    final oldScreenType = ScreenUtil.I.type;
    final wasDesktop = ScreenUtil.I.isWebDesktopScreen;

    // Update screen dimensions and type
    ScreenUtil.I.configureScreen();

    final newScreenType = ScreenUtil.I.type;
    final isDesktop = ScreenUtil.I.isWebDesktopScreen;

    // Determine if a state update is needed
    final hasScreenTypeChanged = oldScreenType != newScreenType;
    final hasDesktopLayoutChanged = wasDesktop != isDesktop;

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
  }
}
