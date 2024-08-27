import 'package:flutter/foundation.dart';

class Restaurant {
  final int id;
  final String restaurantName;
  final String imageUrl;
  final double rating;
  final String location;
  final String phone;
  final String hours;
  bool isOpen;
  bool isFavorite;

  Restaurant({
    required this.id,
    required this.restaurantName,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.phone,
    required this.hours,
    this.isOpen = false,
    this.isFavorite = false,
  });
}

class RestaurantCardViewModel extends ChangeNotifier {
  List<Restaurant> _restaurants = [];

  List<Restaurant> get restaurants => _restaurants;

  RestaurantCardViewModel() {
    _initializeTestData();
  }

  void _initializeTestData() {
    _restaurants = [
      Restaurant(
        id: 1,
        restaurantName: 'Sample1',
        imageUrl: '',
        rating: 4.5,
        location: 'Location 1',
        phone: '123-456-7890',
        hours: '10:00 - 20:00',
      ),
      Restaurant(
        id: 2,
        restaurantName: 'Sample2 restaurant name',
        imageUrl: '',
        rating: 4.2,
        location: 'Location 2',
        phone: '123-456-7891',
        hours: '09:00 - 18:00',
      ),
    ];

    // それぞれのレストランのisOpenを計算する
    for (var restaurant in _restaurants) {
      restaurant.isOpen = isOpenFlag(restaurant.id);
    }
  }

  void updateRestaurants(List<Restaurant> restaurants) {
    _restaurants = restaurants;
    notifyListeners();
  }

  void toggleFavorite(int restaurantId) {
    final index =
        _restaurants.indexWhere((restaurant) => restaurant.id == restaurantId);
    if (index != -1) {
      _restaurants[index].isFavorite = !_restaurants[index].isFavorite;
      notifyListeners();
    }
  }

  bool isOpenFlag(int restaurantId) {
    final restaurant =
        _restaurants.firstWhere((restaurant) => restaurant.id == restaurantId);

    if (restaurant.hours.isEmpty) return false;

    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;

    final parts = restaurant.hours.split(' - ');
    if (parts.length != 2) return false;

    final openTime = _parseTime(parts[0]);
    final closeTime = _parseTime(parts[1]);

    if (closeTime < openTime) {
      return currentTime >= openTime || currentTime < closeTime;
    } else {
      return currentTime >= openTime && currentTime < closeTime;
    }
  }

  int _parseTime(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 2) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;

    return hours * 60 + minutes;
  }

  Future<void> fetchRestaurantDetails(int restaurantId) async {
    // todo:API呼び出しを実装する
    await Future.delayed(const Duration(seconds: 1));

    final restaurant = Restaurant(
      id: restaurantId,
      restaurantName: 'サンプルレストラン',
      imageUrl: 'https://example.com/sample.jpg',
      rating: 4.5,
      location: '三重県',
      phone: '0000000000000',
      hours: '10:00 - 20:00',
      isOpen: isOpenFlag(restaurantId),
    );

    updateRestaurants([..._restaurants, restaurant]);
  }
}
