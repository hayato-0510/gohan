import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gohan/model/restaurant/restaurant_model.dart';

class RestaurantFirestoreModel {
  final CollectionReference _restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');

  Future<bool> saveRestaurantToFirestore(RestaurantModel restaurant) async {
    try {
      print('Attempting to save restaurant: ${restaurant.id}');
      print('Restaurant data: ${restaurant.toJson()}');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
            _restaurantCollection.doc(restaurant.id), restaurant.toJson());
      });

      print('Restaurant saved successfully: ${restaurant.id}');

      // 保存直後にデータを読み取ってみる
      DocumentSnapshot docSnap =
          await _restaurantCollection.doc(restaurant.id).get();
      if (docSnap.exists) {
        print('Restaurant data after save: ${docSnap.data()}');
      } else {
        print('Restaurant document does not exist after save');
      }

      return true;
    } catch (e, stackTrace) {
      print('Error saving restaurant: $e');
      print('Stack trace: $stackTrace');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      return false;
    }
  }

  Future<bool> saveManyRestaurants(List<RestaurantModel> restaurants) async {
    final batch = FirebaseFirestore.instance.batch();
    for (var restaurant in restaurants) {
      print('Adding restaurant to batch: ${restaurant.id}');
      batch.set(_restaurantCollection.doc(restaurant.id), restaurant.toJson());
    }
    try {
      await batch.commit();
      print('${restaurants.length} restaurants saved successfully');
      return true;
    } catch (e, stackTrace) {
      print('Error saving restaurants: $e');
      print('Stack trace: $stackTrace');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      return false;
    }
  }

  Future<RestaurantModel?> getRestaurant(String id) async {
    try {
      print('Attempting to get restaurant: $id');
      final restaurantDoc = await _restaurantCollection.doc(id).get();
      if (restaurantDoc.exists) {
        final data = restaurantDoc.data() as Map<String, dynamic>;
        print('Restaurant data retrieved: $data');
        return RestaurantModel.fromJson(data);
      }
      print('Restaurant not found: $id');
      return null;
    } catch (e, stackTrace) {
      print('Error getting restaurant: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      print('Attempting to delete restaurant: $id');
      await _restaurantCollection.doc(id).delete();
      print('Restaurant deleted successfully: $id');
    } catch (e, stackTrace) {
      print('Error deleting restaurant: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> updateRestaurant(RestaurantModel restaurant) async {
    try {
      print('Attempting to update restaurant: ${restaurant.id}');
      await _restaurantCollection
          .doc(restaurant.id)
          .update(restaurant.toJson());
      print('Restaurant updated successfully: ${restaurant.id}');
    } catch (e, stackTrace) {
      print('Error updating restaurant: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> updateUserEngagement(
      String userId, String restaurantId, bool isFavorite) async {
    try {
      print(
          'Updating user engagement: User $userId, Restaurant $restaurantId, Favorite: $isFavorite');
      final userRestaurantRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('restaurants')
          .doc(restaurantId);

      await userRestaurantRef.set({
        'isFavorite': isFavorite,
        'lastInteractionAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('User engagement updated successfully');
    } catch (e, stackTrace) {
      print('Error updating user engagement: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Stream<List<RestaurantModel>> getUserFavoriteRestaurants(String userId) {
    print('Getting favorite restaurants for user: $userId');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('restaurants')
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) async {
      try {
        List<RestaurantModel> favoriteRestaurants = [];
        for (var doc in snapshot.docs) {
          String restaurantId = doc.id;
          print('Fetching favorite restaurant: $restaurantId');
          RestaurantModel? restaurant = await getRestaurant(restaurantId);
          if (restaurant != null) {
            favoriteRestaurants.add(restaurant);
          }
        }
        print('Fetched ${favoriteRestaurants.length} favorite restaurants');
        return favoriteRestaurants;
      } catch (e, stackTrace) {
        print('Error getting user favorite restaurants: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });
  }
}
