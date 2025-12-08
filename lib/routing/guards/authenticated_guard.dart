import 'package:auto_route/auto_route.dart';

import '../../core/services/session/session_service.dart';
import '../routes.gr.dart';

final class AuthenticatedGuard extends AutoRouteGuard {
  const AuthenticatedGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (SessionUtil.I.isLoggedIn) return resolver.next(true);

    router.replaceAll([const LoginRoute()]);
  }
}
