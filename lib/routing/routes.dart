import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/routing/guards/authenticated_guard.dart';
import 'package:clean_architecture/routing/helper/route_data.dart';
import 'package:clean_architecture/routing/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: LoginRoute.page, path: LOGIN_PATH),
    AutoRoute(
      path: DASHBOARD_PATH,
      page: DashboardRoute.page,
      initial: true,
      guards: const [AuthenticatedGuard()],
      children: [
        AutoRoute(path: HOME_PATH, page: HomeRoute.page, initial: true),
        AutoRoute(path: SETTING_PATH, page: SettingRoute.page),
      ],
    ),
  ];
}
