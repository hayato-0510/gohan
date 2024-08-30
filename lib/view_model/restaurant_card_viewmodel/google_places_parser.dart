
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'restaurant.dart';
import 'restaurant_data/business_hours.dart';
import 'restaurant_data/photo.dart';
import 'restaurant_data/lat_lng.dart';

class GooglePlacesParser {
  static String? _apiKey;

  static void initialize() {
    _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  }
  static Restaurant parseRestaurantFromNearbySearch(Map<String, dynamic> place) {
    return Restaurant(
      id: place['place_id'] ?? '',
      name: place['name'] ?? '',
      category: place['types'] != null && place['types'].isNotEmpty ? place['types'][0] : '',
      priceRange: place['price_level'] != null ? '\$' * place['price_level'] : '',
      rating: (place['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: place['user_ratings_total'] ?? 0,
      userReviews: [],
      mapIconUrl: place['icon'] ?? '',
      address: place['vicinity'] ?? '',
      location: LatLng(
        place['geometry']['location']['lat'],
        place['geometry']['location']['lng'],
      ),
      phone: '',  // Nearby Search doesn't provide phone number
      websiteUrl: '',  // Nearby Search doesn't provide website URL
      businessHours: BusinessHours(weeklyHours: {}, closedDays: []),  // Nearby Search doesn't provide business hours
      businessStatus: place['business_status'] ?? '',
      photos: place['photos'] != null
        ? [Photo(url: _getPlacePhotoUrl(place['photos']))]
        : [],
      isFavorite: false,
    );
  }
  static Restaurant parseRestaurantDetails(Map<String, dynamic> result, String placeId) {
    try {
      final photos = _parsePhotos(result['photos'], placeId);
      return Restaurant(
        id: placeId,
        name: result['name'] ?? '',
        category: result['types'] != null && result['types'].isNotEmpty ? result['types'][0] : '',
        priceRange: result['price_level'] != null ? '\$' * result['price_level'] : '',
        rating: (result['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: result['user_ratings_total'] ?? 0,
        userReviews: [], // 詳細なレビュー情報が必要な場合は、別途処理が必要です
        mapIconUrl: result['icon'] ?? '',
        address: result['formatted_address'] ?? '',
        location: LatLng(
          result['geometry']['location']['lat'],
          result['geometry']['location']['lng'],
        ),
        phone: result['formatted_phone_number'] ?? '',
        websiteUrl: result['website'] ?? '',
        businessHours: _parseBusinessHours(result['opening_hours']),
        businessStatus: result['business_status'] ?? '',
        //photos: _parsePhotos(result['photos'], placeId),
        photos: photos,
        isFavorite: false,
      );
    } catch (e) {
      print('Error parsing restaurant details: $e');
      rethrow;
    }
  }

  static String _getPlacePhotoUrl(List<dynamic>? photos) {
    if (_apiKey == null) {
      throw Exception('API key is not initialized');
    }

    if (photos == null || photos.isEmpty) {
      return ''; // デフォルトのアイコンURLを返すか、空文字列を返す
    }

    final photoReference = photos[0]['photo_reference'];
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$_apiKey';
  }

  static String _parseCategory(List<dynamic>? types) {
    if (types == null || types.isEmpty) return 'Unknown';
    return types[0];
  }

  static String _parsePriceRange(int? priceLevel) {
    if (priceLevel == null) return '';
    return '\$' * priceLevel;
  }

  static LatLng _parseLocation(Map<String, dynamic>? location) {
    if (location == null) return LatLng(0, 0);
    return LatLng(
      location['lat'] as double,
      location['lng'] as double,
    );
  }

  static BusinessHours _parseBusinessHours(Map<String, dynamic>? openingHours) {
    if (openingHours == null) {
      return BusinessHours(weeklyHours: {}, closedDays: []);
    }

    final weeklyHours = <int, DayHours>{};
    final closedDays = <int>[];

    final periods = openingHours['periods'] as List<dynamic>?;
    if (periods != null) {
      for (var period in periods) {
        final open = period['open'];
        final close = period['close'];
        if (open != null && close != null) {
          final day = open['day'] as int;
          final openTime = _parseTimeOfDay(open['time']);
          final closeTime = _parseTimeOfDay(close['time']);
          
          if (weeklyHours.containsKey(day)) {
            weeklyHours[day]!.openRanges.add(TimeRange(start: openTime, end: closeTime));
          } else {
            weeklyHours[day] = DayHours(openRanges: [TimeRange(start: openTime, end: closeTime)]);
          }
        }
      }
    }

    for (int i = 0; i < 7; i++) {
      if (!weeklyHours.containsKey(i)) {
        closedDays.add(i);
      }
    }

    return BusinessHours(weeklyHours: weeklyHours, closedDays: closedDays);
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final hour = int.parse(time.substring(0, 2));
    final minute = int.parse(time.substring(2));
    return TimeOfDay(hour: hour, minute: minute);
  }

  static List<Photo> _parsePhotos(List<dynamic>? photoReferences, String apiKey) {
    if (photoReferences == null) return [];

    try {
      return photoReferences.map((photo) {
        final photoReference = photo['photo_reference'];
        final photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
        print('Generated photo URL: $photoUrl'); // URLをログに出力
        return Photo(
          url: photoUrl,
          attributes: {
            'height': photo['height'],
            'width': photo['width'],
            'html_attributions': photo['html_attributions'],
          },
        );
      }).toList();
    } catch (e) {
      print('Error parsing photos: $e');
      return [];
    }
  }
}