import 'dart:io' show Platform;

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/data/handlers/error_handler.dart';
import 'package:clean_architecture/routing/routes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

abstract interface class NavigationClient {
  AutoRouterDelegate get routerDelegate;
  DefaultRouteParser get routeInformationParser;
  GlobalKey<NavigatorState> get navigatorKey;
  String get currentPath;
  Future<bool> maybePop<T extends Object?>([T? result]);
  Future<bool> maybePopTop<T extends Object?>([T? result]);
  void back();
  Future<void> replaceAllRoute(PageRouteInfo route);
  Future<T?> pushRoute<T>(PageRouteInfo<T> route);
  Future<T?> pushPlatformRoute<T>({
    PageRouteInfo<T>? androidRoute,
    PageRouteInfo<T>? iOSRoute,
    PageRouteInfo<T>? androidIOSRoute,
    PageRouteInfo<T>? webRoute,
  });
  Future<T?> replaceRoute<T>(PageRouteInfo<T> route);
}

@module
abstract class NavigationClientModule {
  @lazySingleton
  AppRouter get appRouter => AppRouter();
}

@LazySingleton(as: NavigationClient)
final class NavigationClientImpl implements NavigationClient {
  NavigationClientImpl({required AppRouter appRouter}) : _appRouter = appRouter;

  final AppRouter _appRouter;

  /// A delegate that configures a widget, typically a [Navigator]
  @override
  AutoRouterDelegate get routerDelegate => _appRouter.delegate();

  /// A delegate to parse the route information
  @override
  DefaultRouteParser get routeInformationParser =>
      _appRouter.defaultRouteParser();

  /// Get Navigator key from auto router
  @override
  GlobalKey<NavigatorState> get navigatorKey => _appRouter.navigatorKey;

  /// Get the name of the currentName
  @override
  String get currentPath => _appRouter.currentPath;

  /// Pops the last route in the current router's stack.
  /// This is 'safe' versions of pop that checks if popping is possible before attempting.
  ///
  /// Example:
  ///
  /// Root Router HomeRoute
  ///
  ///  └─ Nested Router [ProfileRoute, SettingsRoute, AboutRoute]
  ///
  /// maybePop() → Removes AboutRoute (innermost router)
  @override
  Future<bool> maybePop<T extends Object?>([T? result]) =>
      _appRouter.maybePop(result);

  /// Pops from the topmost/root router in the hierarchy.
  /// This is 'safe' versions of popTop that checks if popping is possible before attempting.
  ///
  /// Example:
  ///
  /// Root Router [HomeRoute, DashboardRoute]
  ///
  /// └─ Nested Router [ProfileRoute, SettingsRoute, AboutRoute]
  ///
  /// maybePopTop() → Removes DashboardRoute (root router)
  @override
  Future<bool> maybePopTop<T extends Object?>([T? result]) =>
      _appRouter.maybePopTop(result);

  /// Automatically chooses between pop/popTop based on context.
  /// High-level navigation method that handles both Flutter navigation AND browser history.
  /// On web, it properly syncs with browser back button.
  @override
  void back() => _appRouter.back();

  /// Replace all previous routes the new route
  @override
  Future<void> replaceAllRoute(PageRouteInfo route) =>
      ErrorHandler.executeSafe(() => _appRouter.replaceAll([route]));

  /// Adds the corresponding page to the given route
  @override
  Future<T?> pushRoute<T>(PageRouteInfo<T> route) =>
      ErrorHandler.executeSafeReturn(
        () => _appRouter.push(route),
        valueOnError: null,
      );

  /// Adds the corresponding page to the given route based on the current platform
  @override
  Future<T?> pushPlatformRoute<T>({
    PageRouteInfo<T>? androidRoute,
    PageRouteInfo<T>? iOSRoute,
    PageRouteInfo<T>? androidIOSRoute,
    PageRouteInfo<T>? webRoute,
    String? platform,
  }) {
    return ErrorHandler.executeSafeReturn(() async {
      platform ??= kIsWeb
          ? 'web'
          : Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : null;

      final routeToPush = switch (platform) {
        'web' => webRoute,
        'android' => androidRoute ?? androidIOSRoute,
        'ios' => iOSRoute ?? androidIOSRoute,
        _ => null,
      };

      if (routeToPush == null) {
        return null;
      }
      return _appRouter.push(routeToPush);
    }, valueOnError: null);
  }

  @override
  Future<T?> replaceRoute<T>(PageRouteInfo<T> route) =>
      ErrorHandler.executeSafeReturn(
        () => _appRouter.replace(route),
        valueOnError: null,
      );
}

/// A util class for accessing [NavigationClient]
abstract final class NavigationUtil {
  /// Returns the registered instance of [NavigationClient] which is always the same
  static NavigationClient get I => GetIt.I<NavigationClient>();
}
