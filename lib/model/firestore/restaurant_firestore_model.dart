import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:model/restaurnt/restaurant_model.dart';  

class RestaurantFirestoreModel {
  final CollectionReference _restaurantCollection =
      FirebaseFirestore.instance.collection('restaurants');


  Future<void> saveRestaurantToFirestore(RestaurantModel restaurant) async {
    final restaurantDoc = _restaurantCollection.doc(restaurant.id);
    final restaurantDocData = await restaurantDoc.get();

    if (!restaurantDocData.exists) {
      await restaurantDoc.set(restaurant.toJson());
    }
  }

 
  Future<RestaurantModel?> getRestaurant(String id) async {
    final restaurantDoc = await _restaurantCollection.doc(id).get();
    if (restaurantDoc.exists) {
      final data = restaurantDoc.data() as Map<String, dynamic>;
      return RestaurantModel(
        id: data['id'],
        name: data['name'],
        category: data['category'],
        priceRange: data['priceRange'],
        rating: data['rating'],
        reviewCount: data['reviewCount'],
        userReviews: (data['userReviews'] as List)
            .map((review) => ReviewModel.fromJson(review))
            .toList(),
        mapIconUrl: data['mapIconUrl'],
        address: data['address'],
        location: LatLngModel(
          latitude: data['location']['lat'],
          longitude: data['location']['lng'],
        ),
        phone: data['phone'],
        websiteUrl: data['websiteUrl'],
        businessHours: BusinessHoursModel.fromJson(data['businessHours']),
        businessStatus: data['businessStatus'],
        photos: (data['photos'] as List)
            .map((photo) => PhotoModel.fromJson(photo))
            .toList(),
        isFavorite: data['isFavorite'] ?? false,
      );
    }
    return null;
  }

  
  Future<void> deleteRestaurant(String id) async {
    final restaurantRef = _restaurantCollection.doc(id);
    await restaurantRef.delete();
  }

 
  Future<void> updateRestaurant(RestaurantModel restaurant) async {
    final restaurantRef = _restaurantCollection.doc(restaurant.id);
    await restaurantRef.update(restaurant.toJson());
  }


  Future<void> updateUserEngagement(String userId, String restaurantId, bool isFavorite) async {
    final userRestaurantRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('restaurants')
        .doc(restaurantId);

    await userRestaurantRef.set({
      'isFavorite': isFavorite,
      'lastInteractionAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  
  Stream<List<RestaurantModel>> getUserFavoriteRestaurants(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('restaurants')
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<RestaurantModel> favoriteRestaurants = [];
      for (var doc in snapshot.docs) {
        String restaurantId = doc.id;
        RestaurantModel? restaurant = await getRestaurant(restaurantId);
        if (restaurant != null) {
          favoriteRestaurants.add(restaurant);
        }
      }
      return favoriteRestaurants;
    });
  }
}