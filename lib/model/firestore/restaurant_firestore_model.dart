import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantFirestoreModel {
  final CollectionReference _restaurantCollection =
      FirebaseFirestore.instance.collection('restaurant');

  Future<void> saveRestaurantToFirestore({
    required String id,
    required String name,
    required double rating,
    required bool isLiked,
    required String location,
    required String phone,
    required String hours,
  }) async {
    final restaurantDoc = _restaurantCollection.doc(id);
    final restaurantDocData = await restaurantDoc.get();

    if (!restaurantDocData.exists) {
      await restaurantDoc.set({
        'rid': id,
        'name': name,
        'rating': rating,
        'location': location,
        'phone': phone,
        'hours': hours,
        'is_liked': isLiked,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<Map<String, dynamic>?> getRestaurant(String id) async {
    final restaurantDoc = await _restaurantCollection.doc(id).get();
    if (restaurantDoc.exists) {
      return restaurantDoc.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> deleteRestaurant(String id) async {
    final restaurantRef = _restaurantCollection.doc(id);
    await restaurantRef.delete();
  }

  Future<void> updateRestaurant({
    required String id,
    String? name,
    double? rating,
    String? location,
    String? phone,
    String? hours,
  }) async {
    final restaurantRef = _restaurantCollection.doc(id);
    Map<String, dynamic> updateData = {};
    if (name != null) updateData['name'] = name;
    if (rating != null) updateData['rating'] = rating;
    if (location != null) updateData['location'] = location;
    if (phone != null) updateData['phone'] = phone;
    if (hours != null) updateData['hours'] = hours;
    updateData['updatedAt'] = FieldValue.serverTimestamp();

    await restaurantRef.update(updateData);
  }
}