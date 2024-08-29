import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'restaurant.dart';
import 'restaurant_data/business_hours.dart';
import 'restaurant_data/review.dart';
import 'restaurant_data/photo.dart';
import 'google_places_parser.dart';

export 'restaurant.dart';

class RestaurantCardViewModel extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  late String _apiKey;
  late String _baseUrl;

  List<Restaurant> get restaurants => _restaurants;

  RestaurantCardViewModel() {
    _loadEnvironmentVariables();
    print('RestaurantCardViewModel initialized');
    //_initializeTestData();
  }

  Future<void> _loadEnvironmentVariables() async {
    await dotenv.load(fileName: ".env");
    _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    _baseUrl = dotenv.env['BASE_URL'] ?? '';
    GooglePlacesParser.initialize(); // パーサーを初期化
    print('API Key: $_apiKey');
    print('Base URL: $_baseUrl');
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

  Future<void> fetchRestaurantDetails(String placeId) async {
    if (_apiKey.isEmpty) {
      print('APIキーが設定されていません');
      return;
    }

    final detailsUrl = Uri.parse(
        '$_baseUrl/place/details/json?place_id=$placeId&fields=name,rating,user_ratings_total,formatted_address,geometry,formatted_phone_number,website,opening_hours,price_level,photos,types&key=$_apiKey');

    try {
      final response = await http.get(detailsUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        data['api_key'] = _apiKey; // APIキーをデータに追加

        final restaurant = GooglePlacesParser.parseRestaurantDetails(data, placeId);
        updateRestaurants([..._restaurants, restaurant]);
      } else {
        print('エラー: ${response.statusCode}');
      }
    } catch (e) {
      print('例外が発生しました: $e');
    }
  }
  

  /*
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
  */
}