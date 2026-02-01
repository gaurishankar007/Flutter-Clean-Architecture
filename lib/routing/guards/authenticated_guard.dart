import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/auth/domain/repositories/session_repository.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:get_it/get_it.dart';

final class AuthenticatedGuard extends AutoRouteGuard {
  const AuthenticatedGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (GetIt.I<SessionRepository>().isLoggedIn) {
      return resolver.next();
    }

    router.replaceAll([const LoginRoute()]);
  }
}
