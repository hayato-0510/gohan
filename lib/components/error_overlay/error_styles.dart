import 'package:flutter/material.dart';
import 'error_handler.dart';

IconData getIconForErrorType(ErrorType type) {
  switch (type) {
    case ErrorType.network:
      return Icons.wifi_off;
    case ErrorType.validation:
      return Icons.error_outline;
    case ErrorType.extService:
      return Icons.cloud_off;
    case ErrorType.auth:
      return Icons.lock;
    case ErrorType.database:
      return Icons.storage;
    case ErrorType.location:
      return Icons.location_off;
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
    case ErrorType.extService:
      return Colors.purple;
    case ErrorType.auth:
      return Colors.red;
    case ErrorType.database:
      return Colors.green;
    case ErrorType.location:
      return Colors.teal;
    case ErrorType.unknown:
      return Colors.grey;
  }
}
String getTitleForErrorType(ErrorType type) {
  switch (type) {
    case ErrorType.network:
      return 'ネットワークエラー';
    case ErrorType.validation:
      return '入力エラー';
    case ErrorType.extService:
      return '外部サービスエラー';
    case ErrorType.auth:
      return '認証エラー';
    case ErrorType.database:
      return 'データベースエラー';
    case ErrorType.location:
      return '位置情報エラー';
    case ErrorType.unknown:
    default:
      return '不明なエラー';
  }
}