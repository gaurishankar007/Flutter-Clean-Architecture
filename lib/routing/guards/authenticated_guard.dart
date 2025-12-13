import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/routing/routes.gr.dart';

final class AuthenticatedGuard extends AutoRouteGuard {
  const AuthenticatedGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (SessionUtil.I.isLoggedIn) return resolver.next(true);

    router.replaceAll([const LoginRoute()]);
  }
}
