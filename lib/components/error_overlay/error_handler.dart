
import 'dart:async';

enum ErrorType { network, validation, unknown }

class AppError {
  final String message;
  final ErrorType type;
  final Function? action;

  AppError({required this.message, required this.type, this.action});
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
}