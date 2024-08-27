import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserEngagementViewModel extends ChangeNotifier {
  Database? _database;

  // 閲覧履歴のリスト
  List<Map<String, dynamic>> _browsingHistory = [];

  // いいねされたショップカードのリスト
  List<Map<String, dynamic>> _likedShopCards = [];

  // 閲覧履歴の外部からのアクセス
  List<Map<String, dynamic>> get browsingHistory => _browsingHistory;

  // いいねされたショップカードの外部からのアクセス
  List<Map<String, dynamic>> get likedShopCards => _likedShopCards;

  Future<void> _initDatabase() async {
    if (_database != null) return;

    String path = join(await getDatabasesPath(), 'user_engagement.db');

    // もしデータベースを削除したい場合
    // 見つからないというエラーが出る場合は試すよいいかも
    // await deleteDatabase(path);

    _database = await openDatabase(
      path,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE user_engagement(
            id TEXT PRIMARY KEY,
            title TEXT,
            rating REAL,
            is_liked BOOLEAN
          );
        ''');
      },
      version: 1,
    );
  }

  // データベースに保存する
  Future<void> saveToEngagementDB(
      String id, String title, double rating, bool isLiked) async {
    await _initDatabase(); // 確実にデータベースが初期化されるようにする

    await _database?.insert(
      'user_engagement',
      {'id': id, 'title': title, 'rating': rating, 'is_liked': isLiked ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await loadBrowsingHistory();
    await loadLikedShopCards();
    notifyListeners();

    if (isLiked) {
      print('いいねされたショップカードを保存: $id');
    } else {
      print('閲覧履歴に保存: $id');
    }
  }

  // 閲覧履歴をリストで読み込む
  Future<void> loadBrowsingHistory() async {
    await _initDatabase(); // 確実にデータベースが初期化されるようにする

    final List<Map<String, dynamic>> maps = await _database!.query(
      'user_engagement',
      where: 'is_liked = ?',
      whereArgs: [0], // is_likedがfalse（0）のものを取得
    );

    _browsingHistory = maps.map((shopCard) {
      return {
        'id': shopCard['id'],
        'title': shopCard['title'],
        'rating': shopCard['rating'],
      };
    }).toList();

    print('最終的な閲覧履歴リスト: $_browsingHistory');
  }

  // いいねされたカードをリストで読み込む
  Future<void> loadLikedShopCards() async {
    await _initDatabase(); // 確実にデータベースが初期化されるようにする

    final List<Map<String, dynamic>> maps = await _database!.query(
      'user_engagement',
      where: 'is_liked = ?',
      whereArgs: [1], // is_likedがtrue（1）のものを取得
    );

    _likedShopCards = maps.map((shopCard) {
      return {
        'id': shopCard['id'],
        'title': shopCard['title'],
        'rating': shopCard['rating'],
        'is_liked': shopCard['is_liked'] == 1,
      };
    }).toList();

    print('最終的ないいねされたショップカードリスト: $_likedShopCards');
  }
}
