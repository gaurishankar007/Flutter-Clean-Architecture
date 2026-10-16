import 'package:clean_architecture/routing/navigation_client.dart';
import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:clean_architecture/shared_ui/utils/toast_util.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../testing/mocks/client_mocks.dart';

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();

  setUpAll(() {
    final mockNavigationClient = MockNavigationClient();
    when(() => mockNavigationClient.navigatorKey).thenReturn(navigatorKey);
    GetIt.I.registerSingleton<NavigationClient>(mockNavigationClient);
  });

  tearDownAll(GetIt.I.reset);

  setUp(ToastUtil.reset);

  Future<void> pumpApp(PatrolTester $) => $.pumpWidget(
    MaterialApp(navigatorKey: navigatorKey, home: const SizedBox()),
  );

  // Lets the shown toast run its display time and close.
  Future<void> expireToast(PatrolTester $) async {
    // Frame by frame (slide in + display + slide out = 4.5s), not
    // pumpAndSettle, which would also run through the next toast.
    for (var i = 0; i < 50; i++) {
      await $.tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> closeToasts(PatrolTester $) async {
    InteractiveToast.closeAllToast();
    await $.pumpAndSettle();
  }

  patrolWidgetTest('skips a toast identical to the one right before it', (
    $,
  ) async {
    await pumpApp($);

    ToastUtil.showError('Failed');
    ToastUtil.showError('Failed');
    await $.pump();
    expect($('Failed'), findsOneWidget);

    // A queued repeat would show here once the first one closes.
    await expireToast($);
    expect($('Failed'), findsNothing);

    await closeToasts($);
  });

  patrolWidgetTest('queues toasts and shows them one at a time', ($) async {
    await pumpApp($);

    ToastUtil.showSuccess('First');
    ToastUtil.showWarning('Second');
    await $.pump();

    expect($('First'), findsOneWidget);
    expect($('Second'), findsNothing);

    await expireToast($);
    expect($('First'), findsNothing);
    expect($('Second'), findsOneWidget);

    await closeToasts($);
  });

  patrolWidgetTest('showStateMessage shows a NormalMessage', ($) async {
    await pumpApp($);

    ToastUtil.showStateMessage(const NormalMessage('Hello'));
    await $.pump();

    expect($('Hello'), findsOneWidget);

    await closeToasts($);
  });
}
