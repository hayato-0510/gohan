# Gohan

## Overview
既存のアプリやgoogle mapでは、ユーザーがレストランを探すにはさがしにくいものになっている。そのため写真から探すようなインターフェースを目指す新たなグルメアプリを目指す

## flow
`flow.drawio`から[drawio](https://app.diagrams.net/)で最新版が確認できる
![alt text](docs/img/image.png)

## Git 命名規則
### コミットルール
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.4/)　に従います

| type     |内容                                                           | 
| -------- | -------------------------------------------------------------- | 
| chore    | ビルドプロセスの変更など、補助ツールやライブラリーの追加・変更 | 
| ci       | CIの設定やスクリプトの変更                                     | 
| docs     | ドキュメントのみの変更                                         | 
| feat     | 新機能の追加                                                   | 
| fix      | バグ修正                                                       | 
| refactor | リファクタリング                                               | 
| style    | コードのフォーマット等の変更                                   | 
| test     | テストコードの追加、リファクタリング                           | 
| perf     | パフォーマスンスの向上コード                      | 


Example: `feat ログイン機能の実装`


## アプリの初期設定
- 環境構築がされている前提

## インストール
- リポジトリをクローンしそのディレクトリに行くこと
    ```bash
    flutter pub get
    ```
- うまくいかないときは基本的に、クリーンすると、うまくいくときがある
    ```bash
    flutter clean
    flutter pub get
    ```

## 環境変数の追加

### Firebase
> ログイン，firestoreへの書き込みの実装をしています．毎度でバッグにログインが求められてうざいときは，[wrapper.dart](lib/wrapper.dart)を参照して変更をしてください．
- 全員
  - [lig/config](lib/config)に `firebase_options.dart`をドラッグアンドドロップ
- iosの場合
    - [ios/Runner/](ios/Runner/)に `GoogleService-Info`をドラッグアンドドロップ
    - このとき，Xcodeでビルドが通らないときは`Bundle Identifier`を見直すと良い
- androidの場合
    1. [android/app/](android/app/)に`google-services.json`をドラッグアンドドロップ
    2. 以下のコマンドを打つ
    ```bash
    cd \android
    .\gradlew signingReport
    ```
    3. 以下のように出るから，**SHA1**をコピペで教える or 自分でfirebaseに追加する(プロジェクtの設定/gonah(android)/SHA 証明書フィンガープリント)
    ```
    > Task :app:signingReport
    Variant: 
    Config: 
    Store:
    Alias:
    MD5:
    SHA1:
    SHA-256:
    ```
    参考記事: https://zenn.dev/tsukatsuka1783/articles/flutter_firebase_auth_google_sign_in

### レストランデータ取得用(kairi)
    - ルートディレクトリに`.env`を追加
    ```
    GOOGLE_MAPS_API_KEY=`APIキー`
    ```
    - .envの変更が認識されていないことを確認する(`.gitignore`に指定してあることを確認)
    ```
    .
    └── gohan/
        ├── android/
        ├── ios/
        ├── lib/
        ├── .env
        └── .gitignore
    ```
- iosの場合 
    - ios/runner/Environment.swiftをxcodeで作成する
    ```swift
    import Foundation

    struct Env {
    static let googleMapApiKey = "api key"
    }
    ```
- androidの場合
    - android/secret.propertiesを作成する
    ```
    googleMap.apiKey=各自のapikye
    ```
    
    " "で囲まない
  ### 注意
 kotlinのversionを明記していないとエラーが起きる可能性があるので
 android/app/build.gradleの最初に
 ```md
plugins {
    id "com.android.application"
    id "kotlin-android"
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id "dev.flutter.flutter-gradle-plugin"
    id "org.jetbrains.kotlin.android" version "1.9.0" apply // ここを追加してください
}
```
kotlinのversion明記すれば通ると思います。
JDKはわからないんですけどインストールしたほうがいいのかな
また時間あるときに知らべマス

    
## エラー表示システムの使用方法

### エラー表示

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

### エラータイプの定義

`error_handler.dart` ファイル内の `ErrorType enum`を拡張して、新しいエラータイプを追加

```dart
enum ErrorType { network, validation, unknown, customError }
```

`error_styles.dart` ファイル内の`_getTitleForErrorType`に追加したエラーのタイトルを追加
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
