import 'package:flutter/material.dart';
import 'package:gohan/model/user_engagement_model.dart';
import 'package:gohan/components/error_overlay/error_handler.dart';

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
    try {
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
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'データの保存中にエラーが発生しました。',
        type: ErrorType.database,
        additionalActions: {
          '再試行': () => saveToEngagementDB(
            id: id,
            name: name,
            rating: rating,
            location: location,
            phone: phone,
            hours: hours,
            isFavorite: isFavorite,
          ),
        },
      ));
    }
  }

  Future<void> loadBrowsingHistory() async {
    try {
      final List<Map<String, dynamic>> fetchedShopCards = await _userEngagementModel.loadBrowsingHistory();
      _browsingHistory = fetchedShopCards.map((shopCard) {
        return Map<String, dynamic>.from(shopCard);
      }).toList();

      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: '閲覧履歴の読み込み中にエラーが発生しました。',
        type: ErrorType.database,
        additionalActions: {
          '再試行': () => loadBrowsingHistory(),
        },
      ));
    }
  }

  Future<void> loadLikedShopCards() async {
    try {
      final List<Map<String, dynamic>> fetchedShopCards = await _userEngagementModel.loadLikedShopCards();

      _likedShopCards = fetchedShopCards.map((shopCard) {
        return Map<String, dynamic>.from(shopCard);
      }).toList();

      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'いいねしたショップカードの読み込み中にエラーが発生しました。',
        type: ErrorType.database,
        additionalActions: {
          '再試行': () => loadLikedShopCards(),
        },
      ));
    }
  }

  Future<Map<String, dynamic>?> getRestaurantById(Map<String, dynamic> shopCard) async {
    try {
      await _userEngagementModel.loadAndAppendDetails(shopCard);
      return shopCard;
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'レストラン詳細の読み込み中にエラーが発生しました。',
        type: ErrorType.database,
        additionalActions: {
          '再試行': () => getRestaurantById(shopCard),
        },
      ));
      return null;
    }
  }
}