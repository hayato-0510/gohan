import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'error_handler.dart';
import 'error_styles.dart';
import 'error_animations.dart';
import 'error_action_buttons.dart';

class ErrorContent extends StatelessWidget {
  final AppError error;
  final Animation<double> animation;
  final VoidCallback onDismiss;

  const ErrorContent({
    Key? key,
    required this.error,
    required this.animation,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Prevent dismissal when tapping on the error box
      child: ErrorAnimatedScale(
        animation: animation,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
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
                _buildErrorHeader(),
                SizedBox(height: 16),
                _buildErrorMessage(),
                SizedBox(height: 24),
                ErrorActionButtons(error: error, onDismiss: onDismiss),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorHeader() {
    return Row(
      children: [
        Icon(
          getIconForErrorType(error.type),
          color: getColorForErrorType(error.type),
          size: 28,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            getTitleForErrorType(error.type),
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Flexible(
      child: SingleChildScrollView(
        child: Semantics(
          label: error.message,
          child: Text(
            error.message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}