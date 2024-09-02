import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// apikey model
import 'package:gohan/model/api_key_model.dart';

// resutanrant model(レストランの情報,保持するのはviewmodel)
import 'package:gohan/model/restaurnt/restaurant_model.dart';

// restaurant search model(レストランの情報をapiから取得するモデル)
import 'package:gohan/model/restaurnt_search/restaurnt_search_model.dart';


class RestaurantCardViewModel extends ChangeNotifier {
  late String _apiKey;

  List<RestaurantModel> _restaurants = [];
  List<RestaurantModel> get restaurants => _restaurants;

  RestaurantCardViewModel() {
    ApiKeyModel().loadApiKey().then((apiKey) {
      _apiKey = apiKey;
      if (_apiKey.isEmpty) {
        debugPrint('API key not found');
      }
    });
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

  Future<void> fetchNearbyRestaurants(double lat, double lng) async {
    if (_apiKey.isEmpty) {
      debugPrint('APIキーが設定されていません');
      return;
    }
    try{
      List<RestaurantModel> resultRestaurants = await RestaurantSearchModel().fetchNearbyRestaurants(lat, lng, _apiKey);
      _restaurants.addAll(resultRestaurants);
      notifyListeners();
    } catch(e){
      debugPrint('Error fetching nearby restaurants: $e');
      rethrow;
    }
  }

  Future<void> fetchRestaurantDetails(String placeId) async {
    if (_apiKey.isEmpty) {
      debugPrint('APIキーが設定されていません');
      return;
    }
    try{
       RestaurantModel restaurant = await RestaurantSearchModel().fetchRestaurantDetails(placeId, _apiKey);
      int index = _restaurants.indexWhere((r) => r.id == placeId);
      if (index != -1) {
        _restaurants[index] = restaurant;
      } else {
        _restaurants.add(restaurant);
      }
      notifyListeners();
       
    } catch(e){
      debugPrint('Error fetching restaurant details: $e');
      rethrow;
    }
  }

  initialize() {}
}
