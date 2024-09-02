import 'package:flutter/material.dart';
import 'error_handler.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorOverlay extends StatefulWidget {
  final AppError error;
  final VoidCallback onDismiss;

  const ErrorOverlay({Key? key, required this.error, required this.onDismiss}) : super(key: key);

  @override
  _ErrorOverlayState createState() => _ErrorOverlayState();
}

class _ErrorOverlayState extends State<ErrorOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissOverlay() {
    _animationController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: GestureDetector(
            onTap: _dismissOverlay,
            child: Material(
              color: Colors.black.withOpacity(0.6 * _animation.value),
              child: Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent dismissal when tapping on the error box
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * _animation.value),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getIconForErrorType(widget.error.type),
                                color: _getColorForErrorType(widget.error.type),
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                _getTitleForErrorType(widget.error.type),
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            widget.error.message,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () {
                                    _dismissOverlay();
                                    widget.error.action?.call();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: _getColorForErrorType(widget.error.type),
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                child: Text(
                                    'OK',
                                    style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white, // テキストの色を白に設定
                                    ),
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForErrorType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.validation:
        return Icons.error_outline;
      case ErrorType.unknown:
      default:
        return Icons.warning_amber;
    }
  }

  Color _getColorForErrorType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.blue;
      case ErrorType.validation:
        return Colors.orange;
      case ErrorType.unknown:
      default:
        return Colors.red;
    }
  }

  String _getTitleForErrorType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'ネットワークエラー';
      case ErrorType.validation:
        return '入力エラー';
      case ErrorType.unknown:
      default:
        return 'エラー';
    }
  }
}