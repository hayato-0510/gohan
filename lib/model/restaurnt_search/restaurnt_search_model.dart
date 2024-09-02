import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './google_places_pareser.dart';
import 'package:gohan/model/restaurnt/restaurant_model.dart';

class RestaurantSearchModel extends ChangeNotifier {
  RestaurantSearchModel() {
    GooglePlacesParser.initialize();
  }

  Future<List<RestaurantModel>> fetchNearbyRestaurants(
      double lat, 
      double lng, 
      String apiKey
  ) async {
    if (apiKey.isEmpty) {
      throw Exception('APIキーが提供されていません');
    }
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1500&type=restaurant&key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        List<RestaurantModel> restaurants = results
            .map((place) =>
                GooglePlacesParser.parseRestaurantFromNearbySearch(place))
            .toList();
        return restaurants;
      } else {
        throw Exception('Failed to load nearby restaurants');
      }
    } catch (e) {
      print('Error fetching nearby restaurants: $e');
      rethrow;
    }
  }


  Future<RestaurantModel> fetchRestaurantDetails(String placeId, String apiKey) async {
    if (apiKey.isEmpty) {
      throw Exception('APIキーが設定されていません');
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,user_ratings_total,formatted_address,geometry,formatted_phone_number,website,opening_hours,price_level,photos,types&key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];
        return GooglePlacesParser.parseRestaurantDetails(result, placeId);
      } else {
        throw Exception('Failed to load restaurant details');
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      rethrow;
    }
  }
}
