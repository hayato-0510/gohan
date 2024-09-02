import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'error_handler.dart';
import 'error_styles.dart';

class ErrorActionButtons extends StatelessWidget {
  final AppError error;
  final VoidCallback onDismiss;

  const ErrorActionButtons({
    Key? key,
    required this.error,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...?error.additionalActions?.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: entry.value,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                entry.key,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onDismiss();
            error.action?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: getColorForErrorType(error.type),
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
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}