# Gohan

## Overview
既存のアプリやgoogle mapでは、ユーザーがレストランを探すにはさがしにくいものになっている。そのため写真から探すようなインターフェースを目指す新たなグルメアプリを目指す

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
    - ios/Environment.swiftをxcodeで作成する
    ```swift
    import Foundation

    struct Env {
    static let googleMapApiKey = "api key"
    }
    ```
- androidの場合
    - android/secret.propertiesを作成する
  　```properties
    googleMap.apiKey=各自のapikye  //"　"で囲まない
    ```
    
