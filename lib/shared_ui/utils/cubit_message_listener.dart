import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:clean_architecture/shared_ui/utils/toast_util.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Shows [cubit]'s [BaseState.message] via [ToastUtil] as it changes.
///
/// Call once per page, with a [cubit] reference obtained directly (not via
/// `context.read`, which won't see a `BlocProvider` created in the same
/// `build` call) - see `BaseCubit`-using pages for the `HookBuilder` pattern
/// that gets a context below the `BlocProvider` for this.
void useCubitMessageListener(BaseCubit<BaseState> cubit) {
  useEffect(() {
    final subscription = cubit.stream
        .map((state) => state.message)
        .distinct()
        .listen(ToastUtil.showStateMessage);
    return subscription.cancel;
  }, [cubit]);
}
