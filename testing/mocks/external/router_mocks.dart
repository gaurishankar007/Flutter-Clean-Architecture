import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/routing/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

class MockAppRouter extends Mock implements AppRouter {}

class MockAutoRouterDelegate extends AutoRouterDelegate {
  MockAutoRouterDelegate() : super(AppRouter());

  @override
  Widget build(BuildContext context) => Container();
}

class MockDefaultRouteParser extends Mock implements DefaultRouteParser {}

class MockPageRouteInfo extends PageRouteInfo<dynamic> {
  const MockPageRouteInfo() : super('MockRoute');
}
