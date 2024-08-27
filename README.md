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

### インストール
- リポジトリをクローンしそのディレクトリに行くこと
    ```bash
    flutter pub get
    ```
- うまくいかないときは基本的に、クリーンすると、うまくいくときがある
    ```bash
    flutter clean
    flutter pub get
    ```

### 環境変数の追加
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

    
