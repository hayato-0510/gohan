import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// apikey model
import 'package:gohan/model/api_key_model.dart';

// resutanrant model(レストランの情報,保持するのはviewmodel)
import 'package:gohan/model/restaurant/restaurant_model.dart';

// restaurant search model(レストランの情報をapiから取得するモデル)
import 'package:gohan/model/restaurnt_search/restaurnt_search_model.dart';

//エラーハンドリング
import 'package:gohan/components/error_overlay/error_handler.dart';

class RestaurantCardViewModel extends ChangeNotifier {
  late String _apiKey;

  List<RestaurantModel> _restaurants = [];
  List<RestaurantModel> get restaurants => _restaurants;

  final RestaurantSearchModel _searchModel = RestaurantSearchModel();

  RestaurantCardViewModel() {
    _initializeApiKey();
  }

  Future<void> _initializeApiKey() async {
    try {
      _apiKey = await ApiKeyModel().loadApiKey();
      if (_apiKey.isEmpty) {
        ErrorHandler().handleError(AppError(
          message: 'システム設定の読み込みに失敗しました。',
          type: ErrorType.extService,
        ));
      }
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'システムの初期化中にエラーが発生しました。',
        type: ErrorType.unknown,
      ));
    }
  }

  Future<void> fetchNearbyRestaurants(double lat, double lng) async {
    if (_apiKey.isEmpty) {
      ErrorHandler().handleError(AppError(
        message: '外部サービスへのアクセスに失敗しました。',
        type: ErrorType.extService,
        additionalActions: {
          '再試行': () {
            print('近くのレストラン取得の再試行');
            fetchNearbyRestaurants(lat, lng);
          },
        },
      ));
      return;
    }
    try {
      List<RestaurantModel> resultRestaurants = await _searchModel.fetchNearbyRestaurants(lat, lng, _apiKey);
      _restaurants.addAll(resultRestaurants);
      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: '近くのレストラン情報の取得中にエラーが発生しました。',
        type: ErrorType.network,
        additionalActions: {
          '再試行': () {
            print('近くのレストラン取得の再試行');
            fetchNearbyRestaurants(lat, lng);
          },
        },
      ));
    }
  }

  Future<void> fetchRestaurantDetails(String placeId) async {
    if (_apiKey.isEmpty) {
      ErrorHandler().handleError(AppError(
        message: '外部サービスへのアクセスに失敗しました。',
        type: ErrorType.extService,
        additionalActions: {
          '再試行': () {
            print('レストラン詳細取得の再試行');
            fetchRestaurantDetails(placeId);
          },
        },
      ));
      return;
    }
    try {
      RestaurantModel restaurant = await _searchModel.fetchRestaurantDetails(placeId, _apiKey);
      int index = _restaurants.indexWhere((r) => r.id == placeId);
      if (index != -1) {
        _restaurants[index] = restaurant;
      } else {
        _restaurants.add(restaurant);
      }
      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'レストランの詳細情報の取得中にエラーが発生しました。',
        type: ErrorType.network,
        additionalActions: {
          '再試行': () {
            print('レストラン詳細取得の再試行');
            fetchRestaurantDetails(placeId);
          },
        },
      ));
    }
  }

  Future<void> searchRestaurantsByText(String query, double lat, double lng) async {
    if (_apiKey.isEmpty) {
      ErrorHandler().handleError(AppError(
        message: '外部サービスへのアクセスに失敗しました。',
        type: ErrorType.extService,
        additionalActions: {
          '再試行': () {
            print('テキスト検索の再試行');
            searchRestaurantsByText(query, lat, lng);
          },
        },
      ));
      return;
    }
    try {
      List<RestaurantModel> resultRestaurants = await _searchModel.searchRestaurantsByText(query, lat, lng, _apiKey);
      _restaurants = resultRestaurants;  // 検索結果で上書き
      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'レストランのテキスト検索中にエラーが発生しました。',
        type: ErrorType.network,
        additionalActions: {
          '再試行': () {
            print('テキスト検索の再試行');
            searchRestaurantsByText(query, lat, lng);
          },
        },
      ));
    }
  }

  void removeRestaurant(int index) {
    _restaurants.removeAt(index);
    notifyListeners();
  }

  void updateRestaurants(List<RestaurantModel> restaurants) {
    _restaurants = restaurants;
    notifyListeners();
  }

  void toggleFavorite(String restaurantId) {
    final index = _restaurants.indexWhere((restaurant) => restaurant.id == restaurantId);
    if (index != -1) {
      _restaurants[index].isFavorite = !_restaurants[index].isFavorite;
      notifyListeners();
    }
  }
  initialize() {}
}