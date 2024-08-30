import 'package:flutter/material.dart';
import 'package:gohan/model/user_engagement_model.dart';

class UserEngagementViewModel extends ChangeNotifier {
  final UserEngagementModel _userEngagementModel = UserEngagementModel();

  List<Map<String, dynamic>> _browsingHistory = [];
  List<Map<String, dynamic>> _likedShopCards = [];

  List<Map<String, dynamic>> get browsingHistory => _browsingHistory;
  List<Map<String, dynamic>> get likedShopCards => _likedShopCards;

  // データベースに保存する
  Future<void> saveToEngagementDB(
      String id, String title, double rating, bool isLiked) async {
    await _userEngagementModel.saveToEngagementDB(id, title, rating, isLiked);

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
    _browsingHistory = await _userEngagementModel.loadBrowsingHistory();
    notifyListeners();
  }

  Future<void> loadLikedShopCards() async {
    _likedShopCards = await _userEngagementModel.loadLikedShopCards();
    notifyListeners();
  }
}
