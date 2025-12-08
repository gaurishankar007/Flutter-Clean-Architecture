import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

final class SlidingAutoRoute extends CustomRoute {
  SlidingAutoRoute({
    required super.page,
    required super.path,
    super.durationInMilliseconds = 350,
    AxisDirection slideToward = AxisDirection.left,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           late Offset beginOffset;

           if (slideToward == AxisDirection.up) {
             beginOffset = const Offset(0, 1);
           } else if (slideToward == AxisDirection.down) {
             beginOffset = const Offset(0, -1);
           } else if (slideToward == AxisDirection.right) {
             beginOffset = const Offset(-1, 0);
           } else if (slideToward == AxisDirection.left) {
             beginOffset = const Offset(1, 0);
           }

           final tween = Tween(
             begin: beginOffset,
             end: Offset.zero,
           ).chain(CurveTween(curve: Curves.easeInOut));

           return SlideTransition(
             position: animation.drive(tween),
             child: child,
           );
         },
       );
}
