import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'restaurant.dart';
import 'google_places_parser.dart';

export 'restaurant.dart';

class RestaurantCardViewModel extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  late String _apiKey;
  String? _nextPageToken;

  List<Restaurant> get restaurants => _restaurants;

  RestaurantCardViewModel() {
    _loadApiKey().then((_) {
      GooglePlacesParser.initialize();
    });
  }
  Future<void> initialize() async {
    await _loadApiKey();
    GooglePlacesParser.initialize();
  }
  Future<void> _loadApiKey() async {
    try {
      await dotenv.load(fileName: ".env");
      _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']??'';
      if (_apiKey == null || _apiKey.isEmpty) {
        throw Exception('API key not found in .env file');
      }
      print('API Key loaded successfully: $_apiKey');
    } catch (e) {
      print('Error loading API key: $e');
      rethrow;  // エラーを上位に伝播させる
    }
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

  Future<void> fetchNearbyRestaurants(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1500&type=restaurant&key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        _nextPageToken = data['next_page_token'];

        _restaurants = results.map((place) => GooglePlacesParser.parseRestaurantFromNearbySearch(place)).toList();
        notifyListeners();

        if (_restaurants.length < 20 && _nextPageToken != null) {
          await Future.delayed(Duration(seconds: 2));
          await fetchMoreRestaurants();
        }
      } else {
        throw Exception('Failed to load nearby restaurants');
      }
    } catch (e) {
      print('Error fetching nearby restaurants: $e');
      rethrow;
    }
  }

  Future<void> fetchMoreRestaurants() async {
    if (_nextPageToken == null) {
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=$_nextPageToken&key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        _nextPageToken = data['next_page_token'];

        final newRestaurants = results.map((place) => GooglePlacesParser.parseRestaurantFromNearbySearch(place)).toList();
        _restaurants.addAll(newRestaurants);
        notifyListeners();

        // If we still don't have 20 restaurants and there's another page, fetch more
        if (_restaurants.length < 20 && _nextPageToken != null) {
          await Future.delayed(Duration(seconds: 2));
          await fetchMoreRestaurants();
        }
      } else {
        throw Exception('Failed to load more restaurants');
      }
    } catch (e) {
      print('Error fetching more restaurants: $e');
      rethrow;
    }
  }

  Future<void> fetchRestaurantDetails(String placeId) async {
    if (_apiKey.isEmpty) {
      print('APIキーが設定されていません');
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,user_ratings_total,formatted_address,geometry,formatted_phone_number,website,opening_hours,price_level,photos,types&key=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];

        final restaurant = GooglePlacesParser.parseRestaurantDetails(result, placeId);

        final index = _restaurants.indexWhere((r) => r.id == placeId);
        if (index != -1) {
          _restaurants[index] = restaurant;
        } else {
          _restaurants.add(restaurant);
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load restaurant details');
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      rethrow;
    }
  }
}