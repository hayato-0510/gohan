import 'package:flutter/material.dart';

class ErrorAnimationController {
  final AnimationController controller;
  late final Animation<double> animation;

  ErrorAnimationController({required TickerProvider vsync})
      : controller = AnimationController(
          vsync: vsync,
          duration: Duration(milliseconds: 150),
        ) {
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );
  }

  void forward() => controller.forward();
  Future<void> reverse() => controller.reverse();
  void dispose() => controller.dispose();
}

class ErrorAnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?, Animation<double>) builder;

  const ErrorAnimatedBuilder({
    Key? key,
    required this.animation,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => builder(context, child, animation),
    );
  }
}

class ErrorAnimatedScale extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const ErrorAnimatedScale({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8 + (0.2 * animation.value),
      child: child,
    );
  }
}