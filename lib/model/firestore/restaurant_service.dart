import 'package:gohan/model/firestore/restaurant_firestore_model.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';

class RestaurantService {
  final RestaurantFirestoreModel _firestoreModel = RestaurantFirestoreModel();

  Future<bool> saveRestaurant(RestaurantModel restaurant) async {
    return await _firestoreModel.saveRestaurantToFirestore(restaurant);
  }

  Future<RestaurantModel?> getRestaurant(String id) async {
    return await _firestoreModel.getRestaurant(id);
  }

  Future<void> updateUserEngagement(
      String userId, String restaurantId, bool isFavorite) async {
    await _firestoreModel.updateUserEngagement(
        userId, restaurantId, isFavorite);
  }

  Stream<List<RestaurantModel>> getUserFavoriteRestaurants(String userId) {
    return _firestoreModel.getUserFavoriteRestaurants(userId);
  }
}
