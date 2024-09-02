
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'error_overlay.dart';

enum ErrorType { network, validation, unknown }

class AppError {
  final String message;
  final ErrorType type;
  final Function? action;
  final Map<String, VoidCallback>? additionalActions;

  AppError({
    this.message = "不明なエラーが発生しました",
    this.type = ErrorType.unknown, 
    this.action,
    this.additionalActions,
  });
}

class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  final _errorController = StreamController<AppError>.broadcast();
  Stream<AppError> get onError => _errorController.stream;

  void handleError(AppError error) {
    _errorController.add(error);
  }

  void dispose() {
    _errorController.close();
  }
  
  void showErrorOverlay(BuildContext context, AppError error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ErrorOverlay(
          error: error,
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}