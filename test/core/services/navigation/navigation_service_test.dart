import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../testing/mocks/external/router_mocks.dart';

void main() {
  late MockAppRouter mockAppRouter;
  late NavigationServiceImpl navigationService;

  setUpAll(() {
    mockAppRouter = MockAppRouter();
    navigationService = NavigationServiceImpl(appRouter: mockAppRouter);
  });

  test('routerDelegate returns delegate from AppRouter', () {
    final delegate = MockAutoRouterDelegate();
    when(() => mockAppRouter.delegate()).thenReturn(delegate);

    expect(navigationService.routerDelegate, delegate);
    verify(() => mockAppRouter.delegate()).called(1);
  });

  test('routeInformationParser returns parser from AppRouter', () {
    final parser = MockDefaultRouteParser();
    when(() => mockAppRouter.defaultRouteParser()).thenReturn(parser);

    expect(navigationService.routeInformationParser, parser);
    verify(() => mockAppRouter.defaultRouteParser()).called(1);
  });

  test('navigatorKey returns navigatorKey from AppRouter', () {
    final key = GlobalKey<NavigatorState>();
    when(() => mockAppRouter.navigatorKey).thenReturn(key);

    expect(navigationService.navigatorKey, key);
    verify(() => mockAppRouter.navigatorKey).called(1);
  });

  test('maybePop calls maybePop on AppRouter', () async {
    when(
      () => mockAppRouter.maybePop<Object?>(any()),
    ).thenAnswer((_) async => true);

    final result = await navigationService.maybePop<Object?>();

    expect(result, true);
    verify(() => mockAppRouter.maybePop<Object?>()).called(1);
  });

  test('maybePopTop calls maybePopTop on AppRouter', () async {
    when(
      () => mockAppRouter.maybePopTop<Object?>(),
    ).thenAnswer((_) async => true);

    final result = await navigationService.maybePopTop<Object?>();

    expect(result, true);
    verify(() => mockAppRouter.maybePopTop<Object?>()).called(1);
  });

  test('back calls back on AppRouter', () {
    // Arrange
    when(() => mockAppRouter.back()).thenAnswer((_) {});

    // Act
    navigationService.back();

    // Assert
    verify(() => mockAppRouter.back()).called(1);
  });

  test('replaceAllRoute calls replaceAll on AppRouter', () async {
    const route = MockPageRouteInfo();
    when(() => mockAppRouter.replaceAll([route])).thenAnswer((_) async {});

    await navigationService.replaceAllRoute(route);

    verify(() => mockAppRouter.replaceAll([route])).called(1);
  });

  test('pushRoute calls push on AppRouter and returns result', () async {
    const route = LoginRoute();
    when(
      () => mockAppRouter.push<Object?>(route),
    ).thenAnswer((_) async => 'result');

    final result = await navigationService.pushRoute<Object?>(route);

    expect(result, 'result');
    verify(() => mockAppRouter.push<Object?>(route)).called(1);
  });

  test(
    'pushPlatformRoute calls push on AppRouter and returns result',
    () async {
      const route = MockPageRouteInfo();
      const webRoute = MockPageRouteInfo();

      when(
        () => mockAppRouter.push<Object?>(route),
      ).thenAnswer((_) async => 'result');

      final result = await navigationService.pushPlatformRoute<Object?>(
        androidRoute: route,
        iOSRoute: route,
        webRoute: webRoute,
        platform: 'ios',
      );

      expect(result, 'result');
      verify(() => mockAppRouter.push<Object?>(route)).called(1);
    },
  );

  test('pushRoute returns null and logs error if push throws', () async {
    const route = MockPageRouteInfo();
    when(() => mockAppRouter.push<Object?>(route)).thenThrow(Exception('fail'));

    final result = await navigationService.pushRoute<Object?>(route);

    expect(result, null);
    verify(() => mockAppRouter.push<Object?>(route)).called(1);
  });

  test('replaceAllRoute logs error if replaceAll throws', () async {
    const route = MockPageRouteInfo();
    when(() => mockAppRouter.replaceAll([route])).thenThrow(Exception('fail'));

    // Should not throw
    await navigationService.replaceAllRoute(route);

    verify(() => mockAppRouter.replaceAll([route])).called(1);
  });
}
