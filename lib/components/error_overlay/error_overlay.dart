import 'package:flutter/material.dart';
import 'error_handler.dart';
import 'error_animations.dart';
import 'error_content.dart';

class ErrorOverlay extends StatefulWidget {
  final AppError error;
  final VoidCallback onDismiss;

  const ErrorOverlay({Key? key, required this.error, required this.onDismiss}) : super(key: key);

  @override
  _ErrorOverlayState createState() => _ErrorOverlayState();
}

class _ErrorOverlayState extends State<ErrorOverlay> with SingleTickerProviderStateMixin {
  late ErrorAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = ErrorAnimationController(vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissOverlay() {
    _animationController.reverse().then((_) => widget.onDismiss());
  }

  @override
  Widget build(BuildContext context) {
    return ErrorAnimatedBuilder(
      animation: _animationController.animation,
      builder: (context, child, animation) {
        return GestureDetector(
          onTap: _dismissOverlay,
          child: Material(
            color: Colors.black.withOpacity(0.6 * animation.value),
            child: Center(
              child: ErrorContent(
                error: widget.error,
                animation: animation,
                onDismiss: _dismissOverlay,
              ),
            ),
          ),
        );
      },
    );
  }
}