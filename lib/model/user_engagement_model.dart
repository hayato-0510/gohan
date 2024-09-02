import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserEngagementModel {
  Database? _database;

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
            name TEXT,
            rating REAL,
            location TEXT,
            phone TEXT,
            hours TEXT,
            is_liked BOOLEAN
          );
        ''');
      },
      version: 1,
    );
  }

  Future<void> saveToEngagementDB(
      String id, 
      String name,
      double rating, 
      bool isFavorite,
      String location,
      String phone,
      String hours,
  ) async {
    await _initDatabase();

    await _database?.insert(
      'user_engagement',
      {
        'id': id, 
        'name': name, 
        'rating': rating, 
        'location': location,
        'phone': phone,
        'hours': hours,
        'is_liked': isFavorite ? 1 : 0
        },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> loadBrowsingHistory() async {
    await _initDatabase();

    final List<Map<String, dynamic>> maps = await _database!.query(
      'user_engagement',
      where: 'is_liked = ?',
      whereArgs: [0], // is_likedがfalse（0）のものを取得
    );

    return maps;
  }

  Future<List<Map<String, dynamic>>> loadLikedShopCards() async {
    await _initDatabase();

    final List<Map<String, dynamic>> maps = await _database!.query(
      'user_engagement',
      where: 'is_liked = ?',
      whereArgs: [1], // is_likedがtrue（1）のものを取得
    );

    return maps;
  }

  Future<void> loadAndAppendDetails(Map<String, dynamic> shopCard) async {
    await _initDatabase();

    if (shopCard['id'] == null) {
        print("shopCard['id'] is null");
      }
    final List<Map<String, dynamic>> maps = await _database!.query(
      'user_engagement',
      where: 'id = ?',
      whereArgs: [shopCard['id']],
    );

    if (maps.isNotEmpty) {
      final details = maps.first;
      shopCard.addAll({
        'location': details['location'],
        'phone': details['phone'],
        'hours': details['hours'],
        'rating': details['rating'],
      });
    }
  }
}
