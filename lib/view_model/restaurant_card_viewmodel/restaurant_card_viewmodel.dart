import 'package:flutter/foundation.dart';

class RestaurantCardViewModel extends ChangeNotifier {
  int _id = 0;
  String _restaurantName = '';
  String _imageUrl = '';
  double _rating = 0.0;
  String _location = '';
  String _phone = '';
  String _hours = '';
  bool _isFavorite = false;

  int get id => _id;
  String get restaurantName => _restaurantName;
  String get imageUrl => _imageUrl;
  double get rating => _rating;
  String get location => _location;
  String get phone => _phone;
  String get hours => _hours;
  bool get isFavorite => _isFavorite;

  void updateRestaurantInfo({
    required int id,
    required String restaurantName,
    required String imageUrl,
    required double rating,
    required String location,
    required String phone,
    required String hours,
  }) {
    _id = id;
    _restaurantName = restaurantName;
    _imageUrl = imageUrl;
    _rating = rating;
    _location = location;
    _phone = phone;
    _hours = hours;
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  Future<void> fetchRestaurantDetails(int restaurantId) async {
    // todo:API呼び出しを実装する
    await Future.delayed(Duration(seconds: 1));
    updateRestaurantInfo(
      id: restaurantId,
      restaurantName: 'サンプルレストラン',
      imageUrl: 'https://example.com/sample.jpg',
      rating: 4.5,
      location: '三重県',
      phone: '0000000000000',
      hours: '営業中 10:00〜20:00',
    );
  }
}