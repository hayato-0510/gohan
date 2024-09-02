# エラー表示システムの使用方法

## エラー表示

エラーを発生させるには、`ErrorHandler` クラスの `handleError` を使用

```dart
import 'package:gohan/components/error_overlay/error_handler.dart';

void someFunction() {
  try {
    // エラーが起きる可能性のある処理
  } catch (e) {
    ErrorHandler().handleError(AppError(
      message: 'エラーが発生しました: $e',
      type: ErrorType.unknown,//デフォルト
      action: () {//エラー時に実行する処理(オプション)
        print('エラーアクションが実行されました');
      },
      additionalActions: {
        '再試行': () {//これで再試行ボタンが設置される
          print('再試行アクションが実行されました');
          // ここに再試行のロジックを追加
        },
      },
    ));
  }
}
```

## エラータイプの定義

`error_handler.dart` ファイル内の `ErrorType enum`を拡張して、新しいエラータイプを追加

```dart
enum ErrorType { network, validation, unknown, customError }
```

`error_overlay.dart` ファイル内の`_getTitleForErrorType`に追加したエラーのタイトルを追加
```dart
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
```
.
└── front/
    ├── lib/
    │   ├── components/
    │   │   ├── error_overlay/
    │   │   │   ├── error_overlay.dart
    │   │   │   ├── error_handler.dart
    │   │   │   └── error_listener.dart