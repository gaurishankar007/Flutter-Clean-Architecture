import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'helpers/test_app.dart' as app;

void main() {
  patrolTest(
    'logs in, and navigates to setting page',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      // Inputs
      final username = "username";
      final password = "password";

      await app.main();
      await $.pumpAndSettle();

      // Grant notification permission if the dialog is shown
      if (!kIsWeb && await $.platform.mobile.isPermissionDialogVisible()) {
        await $.platform.mobile.grantPermissionWhenInUse();
      }

      // Enter username and password
      await $(TextField).at(0).enterText(username);
      await $(TextField).at(1).enterText(password);

      // Remember login and show password
      await $(Checkbox).tap();
      await $(InkWell).tap();

      // Use the Login cubit's fakeLogin method in the login_button widget.
      // Otherwise the test will fail.
      await $(ElevatedButton).$("LOGIN").tap();

      // Wait until home page is visible
      await $("Home Page").waitUntilVisible();

      // Navigate to setting page
      await $(AppIcons.setting).tap();
      await $("Logout").waitUntilVisible();
    },
  );
}
