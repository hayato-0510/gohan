import 'package:flutter/material.dart';
import 'dart:async';
import 'error_handler.dart';
import 'error_overlay.dart';

class ErrorListener extends StatefulWidget {
  final Widget child;

  const ErrorListener({Key? key, required this.child}) : super(key: key);

  @override
  _ErrorListenerState createState() => _ErrorListenerState();
}

class _ErrorListenerState extends State<ErrorListener> {
  OverlayEntry? _overlayEntry;
  late StreamSubscription<AppError> _errorSubscription;

  @override
  void initState() {
    super.initState();
    _errorSubscription = ErrorHandler().onError.listen(_showErrorOverlay);
  }

  @override
  void dispose() {
    _errorSubscription.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showErrorOverlay(AppError error) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => ErrorOverlay(
        error: error,
        onDismiss: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Overlay.of(context)?.insert(_overlayEntry!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}