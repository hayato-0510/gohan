import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:gohan/model/restaurant_model.dart';
class RestaurantCardViewModel extends ChangeNotifier {
  

  List<RestaurantModel> _restaurants = [];

  List<RestaurantModel> get restaurants => _restaurants;

  // コンストラクタとして、テストデータを初期化
  RestaurantCardViewModel() {
    _initializeTestData();
  }

  void _initializeTestData() {
    _restaurants = [
      RestaurantModel(
        id: "aaaa",
        name: 'Sample1',
        imageUrl: '',
        rating: 4.5,
        location: 'Location 1',
        phone: '123-456-7890',
        hours: '10:00 - 20:00',
      ),
      RestaurantModel(
        id: "bbbb",
        name: 'Sample2 restaurant name',
        imageUrl: '',
        rating: 4.2,
        location: 'Location 2',
        phone: '123-456-7891',
        hours: '09:00 - 18:00',
      ),
      RestaurantModel(
        id: "cccc",
        name: 'Sample3 restaurant name',
        imageUrl: '',
        rating: 1.2,
        location: 'Location 3',
        phone: '123-456-7891',
        hours: '00:00 - 01:00',
      ),
    ];

    // それぞれのレストランのisOpenを計算する
    for (var restaurant in _restaurants) {
      restaurant.isOpen = isOpenFlag(restaurant.hours);
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
    final index =
        _restaurants.indexWhere((restaurant) => restaurant.id == restaurantId);
    if (index != -1) {
      _restaurants[index].isFavorite = !_restaurants[index].isFavorite;
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantDetails() async {
    // UUIDを生成して、レストランIDとする
    const uuid = Uuid();
    final String restaurantId = uuid.v4();

    // 模擬的なAPI呼び出し（実際にはAPI呼び出しのコードに置き換え）
    await Future.delayed(const Duration(seconds: 1));

    final restaurant = RestaurantModel(
      id: restaurantId,
      name: 'サンプルレストラン',
      imageUrl: '',
      rating: 4.5,
      location: '三重県',
      phone: '0000000000000',
      hours: '10:00 - 20:00',
      isOpen: isOpenFlag('10:00 - 20:00'),
    );

    updateRestaurants([..._restaurants, restaurant]);
  }

   bool isOpenFlag(String hours) {
    if (hours.isEmpty) return false;

    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;

    final parts = hours.split(' - ');
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
  // Future<void> search(String restaurantName, String selectedDistance, bool isOpen) async {
  //  search ロジックを実装
  // }
}
