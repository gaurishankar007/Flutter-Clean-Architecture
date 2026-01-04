import 'package:flutter/material.dart';

class LoadingCircle extends StatefulWidget {
  const LoadingCircle({
    super.key,
    this.strokeWidth = 4,
    this.height = 30,
    this.width = 30,
    this.color,
    this.centered = true,
  });

  factory LoadingCircle.small([Color? color]) =>
      LoadingCircle(strokeWidth: 2, height: 20, width: 20, color: color);
  final double strokeWidth;
  final double height;
  final double width;
  final Color? color;
  final bool centered;

  @override
  State<LoadingCircle> createState() => _LoadingCircleState();
}

class _LoadingCircleState extends State<LoadingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.color != null) {
      return;
    }

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    colorAnimation = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.deepPurple, end: Colors.indigo),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.indigo, end: Colors.pink),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.pink, end: Colors.teal),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.teal, end: Colors.deepPurple),
        weight: 25,
      ),
    ]).animate(controller);
  }

  @override
  void dispose() {
    // Dispose animation controller only if it is initialized
    // The animation controller is initialized only when the color is null
    if (widget.color == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget child;

    if (widget.color != null) {
      child = CircularProgressIndicator(
        color: widget.color,
        strokeWidth: widget.strokeWidth,
      );
    } else {
      child = AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CircularProgressIndicator(
            color: colorAnimation.value,
            strokeWidth: widget.strokeWidth,
          );
        },
      );
    }

    child = SizedBox(height: widget.height, width: widget.width, child: child);

    if (widget.centered) {
      return Center(child: child);
    }
    return child;
  }
}
