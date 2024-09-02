
import 'package:flutter/material.dart';
import 'error_handler.dart';

class ErrorOverlay extends StatelessWidget {
  final AppError error;
  final VoidCallback onDismiss;

  const ErrorOverlay({Key? key, required this.error, required this.onDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss, // 背景をタップしたときにonDismissを呼び出す
      child: Material(
        color: Colors.black54, // 背景を薄暗くする
        child: Center(
          child: GestureDetector(
            onTap: () {}, // この内側のGestureDetectorは、エラーメッセージボックスのタップを検出し、背景タップと区別する
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(error.message, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      onDismiss();
                      error.action?.call();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}