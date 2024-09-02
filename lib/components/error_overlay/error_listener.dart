// lib/components/error_overlay/error_listener.dart
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ErrorHandler().onError.listen((error) {
        _showErrorOverlay(error);
      });
    });
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
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}