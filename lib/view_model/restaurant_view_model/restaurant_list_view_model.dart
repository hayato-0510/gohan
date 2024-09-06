import 'package:flutter/foundation.dart';
import 'package:gohan/model/firestore/restaurant_service.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';

class RestaurantListViewModel extends ChangeNotifier {
  final RestaurantService _restaurantService = RestaurantService();
  List<RestaurantModel> favoriteRestaurants = [];

  void loadFavoriteRestaurants(String userId) {
    _restaurantService.getUserFavoriteRestaurants(userId).listen((restaurants) {
      favoriteRestaurants = restaurants;
      notifyListeners();
    });
  }

  Future<void> toggleFavorite(String userId, RestaurantModel restaurant) async {
    bool newFavoriteStatus = !restaurant.isFavorite;
    await _restaurantService.updateUserEngagement(
        userId, restaurant.id, newFavoriteStatus);
    restaurant.isFavorite = newFavoriteStatus;
    notifyListeners();
  }
}
