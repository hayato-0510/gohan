import 'package:flutter/material.dart';
import 'error_handler.dart';

IconData getIconForErrorType(ErrorType type) {
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

Color getColorForErrorType(ErrorType type) {
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

String getTitleForErrorType(ErrorType type) {
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