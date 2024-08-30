import 'package:flutter/material.dart';
import 'package:gohan/model/user_engagement_model.dart';

class UserEngagementViewModel extends ChangeNotifier {
  final UserEngagementModel _userEngagementModel = UserEngagementModel();

  List<Map<String, dynamic>> _browsingHistory = [];
  List<Map<String, dynamic>> _likedShopCards = [];

  List<Map<String, dynamic>> get browsingHistory => _browsingHistory;
  List<Map<String, dynamic>> get likedShopCards => _likedShopCards;

// <<<<<<< RestaurantDetails-miki
//   Future<void> _initDatabase() async {
//     if (_database != null) return;

//     String path = join(await getDatabasesPath(), 'user_engagement.db');

//     // データベースを削除して再作成
//     await deleteDatabase(path);

//     _database = await openDatabase(
//       path,
//       onCreate: (Database db, int version) async {
//         await db.execute('''
//           CREATE TABLE user_engagement(
//             id TEXT PRIMARY KEY,
//             title TEXT,
//             rating REAL,
//             location TEXT,
//             phone TEXT,
//             hours TEXT,
//             is_open BOOLEAN,
//             is_liked BOOLEAN
//           );
//         ''');
//       },
//       version: 1,
//     );
//   }

//   // データベースに保存する
//   Future<void> saveToEngagementDB(
//       String id, String title, double rating, String location, String phone, String hours, bool isOpen, bool isLiked) async {
//     await _initDatabase(); // 確実にデータベースが初期化されるようにする

//     await _database?.insert(
//       'user_engagement',
//       {
//         'id': id,
//         'title': title,
//         'rating': rating,
//         'location': location,
//         'phone': phone,
//         'hours': hours,
//         'is_open': isOpen ? 1 : 0,
//         'is_liked': isLiked ? 1 : 0
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
// =======
  // データベースに保存する
  Future<void> saveToEngagementDB(
      String id, String title, double rating, bool isLiked) async {
    await _userEngagementModel.saveToEngagementDB(id, title, rating, isLiked);
// >>>>>>> dev-kai

    await loadBrowsingHistory();
    await loadLikedShopCards();
    notifyListeners();

    if (isLiked) {
      print('いいねされたショップカードを保存: $id');
    } else {
      print('閲覧履歴に保存: $id');
    }
  }

  Future<void> loadBrowsingHistory() async {
// <<<<<<< RestaurantDetails-miki
//     await _initDatabase(); // 確実にデータベースが初期化されるようにする

//     final List<Map<String, dynamic>> maps = await _database!.query(
//       'user_engagement',
//       where: 'is_liked = ?',
//       whereArgs: [0], // is_likedがfalse（0）のものを取得
//     );

//     _browsingHistory = maps.map((shopCard) {
//       return {
//         'id': shopCard['id'],
//         'title': shopCard['title'],
//         'rating': shopCard['rating'],
//         'location': shopCard['location'],
//         'phone': shopCard['phone'],
//         'hours': shopCard['hours'],
//         'is_open': shopCard['is_open'] == 1,
//       };
//     }).toList();

//     print('最終的な閲覧履歴リスト: $_browsingHistory');
// =======
    _browsingHistory = await _userEngagementModel.loadBrowsingHistory();
    notifyListeners();
// >>>>>>> dev-kai
  }

  Future<void> loadLikedShopCards() async {
// <<<<<<< RestaurantDetails-miki
//     await _initDatabase(); // 確実にデータベースが初期化されるようにする

//     final List<Map<String, dynamic>> maps = await _database!.query(
//       'user_engagement',
//       where: 'is_liked = ?',
//       whereArgs: [1], // is_likedがtrue（1）のものを取得
//     );

//     _likedShopCards = maps.map((shopCard) {
//       return {
//         'id': shopCard['id'],
//         'title': shopCard['title'],
//         'rating': shopCard['rating'],
//         'location': shopCard['location'],
//         'phone': shopCard['phone'],
//         'hours': shopCard['hours'],
//         'is_open': shopCard['is_open'] == 1,
//         'is_liked': shopCard['is_liked'] == 1,
//       };
//     }).toList();

//     print('最終的ないいねされたショップカードリスト: $_likedShopCards');
// =======
    _likedShopCards = await _userEngagementModel.loadLikedShopCards();
    notifyListeners();
// >>>>>>> dev-kai
  }

  // 特定のIDに対応するレストランの詳細情報を取得する
  Future<Map<String, dynamic>?> getRestaurantById(String id) async {
    await _initDatabase(); // 確実にデータベースが初期化されるようにする

    final List<Map<String, dynamic>> maps = await _database!.query(
      'user_engagement',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }
}
