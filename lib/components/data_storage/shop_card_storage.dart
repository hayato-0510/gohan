import 'package:shared_preferences/shared_preferences.dart';

class ShopCardStorage {
  static const String _keyPrefix = 'shop_card_';

  // データを保存するメソッド
  static Future<void> saveShopCard(
      String id, String title, double rating) async {
    final prefs = await SharedPreferences.getInstance();
    // 変数を文字列内に正しく埋め込む
    await prefs.setString('$_keyPrefix${id}_title', title);
    await prefs.setDouble('$_keyPrefix${id}_rating', rating);
  }

  // データを読み込むメソッド
  static Future<Map<String, dynamic>> loadShopCard(String id) async {
    final prefs = await SharedPreferences.getInstance();
    // 変数を文字列内に正しく埋め込む
    final title = prefs.getString('$_keyPrefix${id}_title') ?? '';
    final rating = prefs.getDouble('$_keyPrefix${id}_rating') ?? 0.0;
    return {
      'title': title,
      'rating': rating,
    };
  }

  // データを削除するメソッド
  static Future<void> deleteShopCard(String id) async {
    final prefs = await SharedPreferences.getInstance();
    // 変数を文字列内に正しく埋め込む
    await prefs.remove('$_keyPrefix${id}_title');
    await prefs.remove('$_keyPrefix${id}_rating');
  }
}
