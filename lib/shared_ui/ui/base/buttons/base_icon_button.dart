import 'package:flutter/material.dart';

class BaseIconButton extends StatelessWidget {
  const BaseIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.splashRadius,
    this.padding,
    this.boxConstraints,
    this.visualDensity,
    this.targetSize,
    this.disableSplash = false,
  });
  final void Function() onPressed;
  final Icon icon;
  final double? splashRadius;
  final EdgeInsets? padding;
  final BoxConstraints? boxConstraints;
  final VisualDensity? visualDensity;
  final double? targetSize;
  final bool disableSplash;

  @override
  Widget build(BuildContext context) {
    Widget child = IconButton(
      splashRadius: splashRadius,
      onPressed: onPressed,
      padding: padding ?? EdgeInsets.zero,
      constraints: boxConstraints ?? const BoxConstraints(),
      visualDensity:
          visualDensity ?? const VisualDensity(horizontal: -4, vertical: -4),
      highlightColor: disableSplash ? Colors.transparent : null,
      icon: icon,
    );

    if (disableSplash) {
      child = Theme(
        data: ThemeData(splashFactory: NoSplash.splashFactory),
        child: child,
      );
    }

    if (targetSize != null) {
      child = SizedBox(height: targetSize, width: targetSize, child: child);
    }

    return child;
  }
}
