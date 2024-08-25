import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrowsingHistoryViewModel extends ChangeNotifier {
  // 閲覧したショップカードのリスト
  List<Map<String, dynamic>> _browsingHistory = [];

  // 外部からのアクセス用プロパティ
  List<Map<String, dynamic>> get browsingHistory => _browsingHistory;

  // 閲覧したショップカードを保存するメソッド
  Future<void> addToBrowsingHistory(String id, String title, double rating, bool isLiked) async {
    final prefs = await SharedPreferences.getInstance();

    // 各カードのデータを保存
    await prefs.setString(_keyTitle(id), title);
    await prefs.setDouble(_keyRating(id), rating);
    await prefs.setBool(_keyIsLiked(id), isLiked);

    // リストを再読み込み
    await _loadBrowsingHistory();
    notifyListeners(); // 状態変更を通知

    print('ShopCard added to browsing history $id');
  }

  // 全閲覧したショップカードをリストで読み込むプライベートメソッド
  Future<void> _loadBrowsingHistory() async {
    final prefs = await SharedPreferences.getInstance();

    // 保存されているキーのリストを取得
    final keys = prefs.getKeys().where((key) => key.startsWith('browsing_history_')).toList();

    _browsingHistory = [];
    for (var key in keys) {
      final id = key.split('_')[2];
      final title = prefs.getString(_keyTitle(id)) ?? '';
      final rating = prefs.getDouble(_keyRating(id)) ?? 0.0;
      final isLiked = prefs.getBool(_keyIsLiked(id)) ?? false;

      _browsingHistory.add({
        'id': id,
        'title': title,
        'rating': rating,
        'is_liked': isLiked,
      });
    }
  }

  // 閲覧履歴を外部から読み込むための公開メソッド
  Future<void> refreshBrowsingHistory() async {
    await _loadBrowsingHistory();
  }

  // 閲覧したショップカードを削除するメソッド
  Future<void> removeFromBrowsingHistory(String id) async {
    final prefs = await SharedPreferences.getInstance();

    // 各カードのデータを削除
    await prefs.remove(_keyTitle(id));
    await prefs.remove(_keyRating(id));
    await prefs.remove(_keyIsLiked(id));

    // リストを再読み込み
    await _loadBrowsingHistory();
    notifyListeners(); // 状態変更を通知

    print('ShopCard removed from browsing history $id');
  }

  // キー生成メソッド
  String _keyTitle(String id) => 'browsing_history_${id}_title';
  String _keyRating(String id) => 'browsing_history_${id}_rating';
  String _keyIsLiked(String id) => 'browsing_history_${id}_is_liked';
}
