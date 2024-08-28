
import 'restaurant_data/review.dart';
import 'restaurant_data/photo.dart';
import 'restaurant_data/business_hours.dart';
import 'restaurant_data/lat_lng.dart';

export 'restaurant.dart';
export 'restaurant_data/business_hours.dart';
export 'restaurant_data/review.dart';
export 'restaurant_data/photo.dart';
export 'restaurant_data/lat_lng.dart';


class Restaurant {
  final String id;                    // レストランの一意識別子
  final String name;                  // レストラン名
  final String category;              // レストランのカテゴリ（例：イタリアン、和食）
  final String priceRange;            // 価格帯　形式がわからないので文字列で表現
  final double rating;                // 評価点数
  final int reviewCount;              // レビュー数
  final List<Review> userReviews;     // ユーザーレビューのリスト
  final String mapIconUrl;            // 地図上のアイコンのURL
  final String address;               // レストランの住所
  final LatLng location;              // 緯度経度
  final String phone;                 // 電話番号
  final String websiteUrl;            // ウェブサイトのURL
  final BusinessHours businessHours;  // 営業時間情報
  final String businessStatus;        // ビジネスステータス（営業中、一時休業、永久閉店など）
  final List<Photo> photos;           // レストランの写真リスト
  bool isFavorite;                    // お気に入りフラグ

  Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.priceRange,
    required this.rating,
    required this.reviewCount,
    required this.userReviews,
    required this.mapIconUrl,
    required this.address,
    required this.location,
    required this.phone,
    required this.websiteUrl,
    required this.businessHours,
    required this.businessStatus,
    required this.photos,
    this.isFavorite = false,
  });

  bool get isOpen => businessHours.isOpenNow();  // 現在営業中かどうか
  
  String get closedDays => businessHours.getClosedDaysString();  // 定休日の文字列を返す
}