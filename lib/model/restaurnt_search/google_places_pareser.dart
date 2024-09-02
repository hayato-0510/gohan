import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 型を合わせるためのmodel import(あくまでもmodelの保持はしていない)
import 'package:gohan/model/restaurant/restaurant_model.dart';
import 'package:gohan/model/restaurant/data/lat_lng_model.dart';
import 'package:gohan/model/restaurant/data/business_hours_model.dart';
import 'package:gohan/model/restaurant/data/photo_model.dart';

class GooglePlacesParser {
  static String? _apiKey;

  static void initialize() {
    _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  }

  //簡易的なレストラン情報を取得するメソッド
  static RestaurantModel parseRestaurantFromNearbySearch(
      Map<String, dynamic> place) {
    return RestaurantModel(
      id: place['place_id'] ?? '',
      name: place['name'] ?? '',
      category: place['types']?.isNotEmpty == true ? place['types'][0] : '',
      priceRange:
          place['price_level'] != null ? '\$' * place['price_level'] : '',
      rating: (place['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: place['user_ratings_total'] ?? 0,
      userReviews: [],
      mapIconUrl: place['icon'] ?? '',
      address: place['vicinity'] ?? '',
      location: LatLngModel(
        place['geometry']['location']['lat'],
        place['geometry']['location']['lng'],
      ),
      phone: '',
      websiteUrl: '',
      businessHours: BusinessHoursModel(weeklyHours: {}, closedDays: []),
      businessStatus: place['business_status'] ?? '',
      photos: place['photos'] != null
          ? [PhotoModel(url: _getPlacePhotoUrl(place['photos']))]
          : [],
      isFavorite: false,
    );
  }

  //詳細情報を取得するメソッド
  static RestaurantModel parseRestaurantDetails(
      Map<String, dynamic> result, String placeId) {
    final photos = _parsePhotos(result['photos'], _apiKey);
    final businessHours = _parseBusinessHours(result['opening_hours']);

    return RestaurantModel(
      id: placeId,
      name: result['name'] ?? '',
      category: result['types']?.isNotEmpty == true ? result['types'][0] : '',
      priceRange:
          result['price_level'] != null ? '\$' * result['price_level'] : '',
      rating: (result['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: result['user_ratings_total'] ?? 0,
      userReviews: [],
      mapIconUrl: result['icon'] ?? '',
      address: result['formatted_address'] ?? '',
      location: LatLngModel(
        result['geometry']['location']['lat'],
        result['geometry']['location']['lng'],
      ),
      phone: result['formatted_phone_number'] ?? '',
      websiteUrl: result['website'] ?? '',
      businessHours: businessHours,
      businessStatus: result['business_status'] ?? '',
      photos: photos,
      isFavorite: false,
    );
  }

  static String _getPlacePhotoUrl(List<dynamic>? photos) {
    if (photos == null || photos.isEmpty) return '';
    final photoReference = photos[0]['photo_reference'];
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$_apiKey';
  }

  static BusinessHoursModel _parseBusinessHours(Map<String, dynamic>? openingHours) {
    if (openingHours == null)
      return BusinessHoursModel(weeklyHours: {}, closedDays: []);

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
            weeklyHours[day]!
                .openRanges
                .add(TimeRange(start: openTime, end: closeTime));
          } else {
            weeklyHours[day] = DayHours(
                openRanges: [TimeRange(start: openTime, end: closeTime)]);
          }
        }
      }
    }

    for (int i = 0; i < 7; i++) {
      if (!weeklyHours.containsKey(i)) {
        closedDays.add(i);
      }
    }

    return BusinessHoursModel(weeklyHours: weeklyHours, closedDays: closedDays);
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final hour = int.parse(time.substring(0, 2));
    final minute = int.parse(time.substring(2));
    return TimeOfDay(hour: hour, minute: minute);
  }

  static List<PhotoModel> _parsePhotos(
      List<dynamic>? photoReferences, String? apiKey) {
    if (photoReferences == null) return [];

    return photoReferences.map((photo) {
      final photoReference = photo['photo_reference'];
      final photoUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
      return PhotoModel(
        url: photoUrl,
        attributes: {
          'height': photo['height'],
          'width': photo['width'],
          'html_attributions': photo['html_attributions'],
        },
      );
    }).toList();
  }
}
