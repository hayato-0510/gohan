import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopCardViewModel extends ChangeNotifier {
  // ショップカードのリスト
  List<Map<String, dynamic>> _shopCards = [];

  // 外部からのアクセス用プロパティ
  List<Map<String, dynamic>> get shopCards => _shopCards;

  // ショップカードを保存するメソッド
  Future<void> saveShopCard(String id, String title, double rating, bool isLike) async {
    final prefs = await SharedPreferences.getInstance();

    // 各カードのデータを保存
    await prefs.setString(_keyTitle(id), title);
    await prefs.setDouble(_keyRating(id), rating);
    await prefs.setBool(_keyIsLike(id), isLike);
    print('Saving ShopCard: ID: $id, Title: $title, Rating: $rating, IsLike: $isLike');

    // リストを再読み込み
    await _loadShopCards();
    notifyListeners(); // 状態変更を通知

    print('ShopCard saved $id');
  }

  // 全ショップカードをリストで読み込むプライベートメソッド
  Future<void> _loadShopCards() async {
    final prefs = await SharedPreferences.getInstance();

    // 保存されているキーのリストを取得
    final keys = prefs.getKeys().where((key) => key.startsWith('shop_card_')).toList();

    _shopCards = [];
    for (var key in keys) {
      final id = key.split('_')[2];
      final title = prefs.getString(_keyTitle(id)) ?? '';
      final rating = prefs.getDouble(_keyRating(id)) ?? 0.0;
      final isLike = prefs.getBool(_keyIsLike(id)) ?? false;

      _shopCards.add({
        'id': id,
        'title': title,
        'rating': rating,
        'is_like': isLike,
      });
    }
  }

  // リストを外部から読み込むための公開メソッド
  Future<void> loadShopCards() async {
    await _loadShopCards();
  }

  // is_likeがtrueのショップカードをリストで読み込むプライベートメソッド
  Future<void> _loadLikedShopCards() async {
    final prefs = await SharedPreferences.getInstance();

    // 保存されているキーのリストを取得
    final keys = prefs.getKeys().where((key) => key.startsWith('shop_card_')).toList();

   _shopCards = [];
    for (var key in keys) {
      final id = key.split('_')[2];
      final title = prefs.getString(_keyTitle(id)) ?? '';
      final rating = prefs.getDouble(_keyRating(id)) ?? 0.0;
      final isLike = prefs.getBool(_keyIsLike(id)) ?? false;

      // is_likeがtrueの場合のみリストに追加
      if (isLike) {
        print('Adding ID: $id, Title: $title, Rating: $rating, IsLike: $isLike');
        _shopCards.add({
          'id': id,
          'title': title,
          'rating': rating,
          'is_like': isLike,
        });
      }
    }
  }

// リストを外部から読み込むための公開メソッド
  Future<void> loadLikedShopCards() async {
    await _loadLikedShopCards();
  }


  // ショップカードを削除するメソッド
  Future<void> deleteShopCard(String id) async {
    final prefs = await SharedPreferences.getInstance();

    // 各カードのデータを削除
    await prefs.remove(_keyTitle(id));
    await prefs.remove(_keyRating(id));
    await prefs.remove(_keyIsLike(id));

    // リストを再読み込み
    await _loadShopCards();
    notifyListeners(); // 状態変更を通知

    print('ShopCard deleted $id');
  }

  // キー生成メソッド
  String _keyTitle(String id) => 'shop_card_${id}_title';
  String _keyRating(String id) => 'shop_card_${id}_rating';
  String _keyIsLike(String id) => 'shop_card_${id}_is_like';
}
