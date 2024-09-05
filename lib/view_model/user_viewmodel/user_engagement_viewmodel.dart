import 'package:flutter/material.dart';
import 'package:gohan/model/user_engagement_model.dart';

class UserEngagementViewModel extends ChangeNotifier {
  final UserEngagementModel _userEngagementModel = UserEngagementModel();

  List<Map<String, dynamic>> _browsingHistory = [];
  List<Map<String, dynamic>> _likedShopCards = [];

  List<Map<String, dynamic>> get browsingHistory => _browsingHistory;
  List<Map<String, dynamic>> get likedShopCards => _likedShopCards;

  // データベースに保存する
  Future<void> saveToEngagementDB({
    required String id,
    required String name,
    required double rating,
    required String location,
    required String phone,
    required String hours,
    required bool isFavorite,
  }) async {
    await _userEngagementModel.saveToEngagementDB(
        id, 
        name, 
        rating,
        isFavorite,
        location,
        phone,
        hours,
    );

    await loadBrowsingHistory();
    await loadLikedShopCards();
    notifyListeners();

    if (isFavorite) {
      print('いいねされたショップカードを保存: $id');
    } else {
      print('閲覧履歴に保存: $id');
    }
  }

  Future<void> loadBrowsingHistory() async {
    final List<Map<String, dynamic>> fetchedShopCards = await _userEngagementModel.loadBrowsingHistory();
    _browsingHistory = fetchedShopCards.map((shopCard) {
      return Map<String, dynamic>.from(shopCard);
    }).toList();

    notifyListeners();
  }

  Future<void> loadLikedShopCards() async {
    final List<Map<String, dynamic>> fetchedShopCards = await _userEngagementModel.loadLikedShopCards();

    _likedShopCards = fetchedShopCards.map((shopCard) {
      return Map<String, dynamic>.from(shopCard);
    }).toList();

    notifyListeners();
  }

  Future<Map<String, dynamic>?> getRestaurantById(Map<String, dynamic> shopCard) async {
    await _userEngagementModel.loadAndAppendDetails(shopCard);
    return shopCard;
  }

}
