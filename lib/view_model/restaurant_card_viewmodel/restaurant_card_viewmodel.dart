import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'restaurant.dart';
import 'restaurant_data/business_hours.dart';
import 'restaurant_data/review.dart';
import 'restaurant_data/photo.dart';

export 'restaurant.dart';

class RestaurantCardViewModel extends ChangeNotifier {
  List<Restaurant> _restaurants = [];

  List<Restaurant> get restaurants => _restaurants;

  RestaurantCardViewModel() {
    print('RestaurantCardViewModel initialized');
    _initializeTestData();
  }

  void removeRestaurant(int index) {
    _restaurants.removeAt(index);
    notifyListeners();
  }

  void updateRestaurants(List<Restaurant> restaurants) {
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

  Future<void> fetchRestaurantDetails() async {
    const uuid = Uuid();
    final String restaurantId = uuid.v4();

    // 模擬的なAPI呼び出し（実際にはAPI呼び出しのコードに置き換え）
    await Future.delayed(const Duration(seconds: 1));

    final restaurant = Restaurant(
      id: restaurantId,
      name: 'サンプルレストラン',
      category: 'Japanese',
      priceRange: r'$$$',
      rating: 4.5,
      reviewCount: 50,
      userReviews: [],
      mapIconUrl: '',
      address: '三重県',
      location: LatLng(34.7303, 136.5086),
      phone: '0000000000000',
      websiteUrl: 'https://sample.com',
      businessHours: BusinessHours(
        weeklyHours: {1: DayHours(openRanges: [TimeRange(start: TimeOfDay(hour: 10, minute: 0), end: TimeOfDay(hour: 20, minute: 0))])},
        closedDays: [],
      ),
      businessStatus: 'OPERATIONAL',
      photos: [],
    );

    updateRestaurants([..._restaurants, restaurant]);
  }
  
  void _initializeTestData() {
  _restaurants = [
    Restaurant(
      id: "aaaa",
      name: 'Sample1 Italian Restaurant',
      category: 'Italian',
      priceRange: r'$$',
      rating: 4.5,
      reviewCount: 100,
      userReviews: [],
      mapIconUrl: '',
      address: 'Location 1, Tokyo',
      location: LatLng(35.6895, 139.6917),
      phone: '123-456-7890',
      websiteUrl: 'https://sample1.com',
      businessHours: BusinessHours(
        weeklyHours: {1: DayHours(openRanges: [TimeRange(start: TimeOfDay(hour: 10, minute: 0), end: TimeOfDay(hour: 20, minute: 0))])},
        closedDays: [],
      ),
      businessStatus: 'OPERATIONAL',
      photos: [],
    ),
    Restaurant(
      id: "bbbb",
      name: 'Sample2 Sushi Bar',
      category: 'Japanese',
      priceRange: r'$$$',
      rating: 4.8,
      reviewCount: 250,
      userReviews: [],
      mapIconUrl: '',
      address: 'Location 2, Osaka',
      location: LatLng(34.6937, 135.5023),
      phone: '987-654-3210',
      websiteUrl: 'https://sample2.com',
      businessHours: BusinessHours(
        weeklyHours: {1: DayHours(openRanges: [TimeRange(start: TimeOfDay(hour: 11, minute: 30), end: TimeOfDay(hour: 22, minute: 0))])},
        closedDays: [7], // 日曜日休業
      ),
      businessStatus: 'OPERATIONAL',
      photos: [],
    ),
    Restaurant(
      id: "cccc",
      name: 'Sample3 Burger Joint',
      category: 'American',
      priceRange: r'$',
      rating: 4.2,
      reviewCount: 180,
      userReviews: [],
      mapIconUrl: '',
      address: 'Location 3, Nagoya',
      location: LatLng(35.1815, 136.9066),
      phone: '555-123-4567',
      websiteUrl: 'https://sample3.com',
      businessHours: BusinessHours(
        weeklyHours: {1: DayHours(openRanges: [
          TimeRange(start: TimeOfDay(hour: 10, minute: 0), end: TimeOfDay(hour: 15, minute: 0)),
          TimeRange(start: TimeOfDay(hour: 17, minute: 0), end: TimeOfDay(hour: 23, minute: 0))
        ])},
        closedDays: [2], // 火曜日休業
      ),
      businessStatus: 'OPERATIONAL',
      photos: [],
    ),
  ];
}
}