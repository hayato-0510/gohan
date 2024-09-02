import 'data/photo_model.dart';
import 'data/review_model.dart';
import 'data/lat_lng_model.dart';
import 'data/business_hours_model.dart';

class RestaurantModel {
  final String id; // レストランの一意識別子
  final String name; // レストラン名
  final String category; // レストランのカテゴリ（例：イタリアン、和食）
  final String priceRange; // 価格帯　形式がわからないので文字列で表現
  final double rating; // 評価点数
  final int reviewCount; // レビュー数
  final List<ReviewModel> userReviews; // ユーザーレビューのリスト
  final String mapIconUrl; // 地図上のアイコンのURL
  final String address; // レストランの住所
  final LatLngModel location; // 緯度経度
  final String phone; // 電話番号
  final String websiteUrl; // ウェブサイトのURL
  final BusinessHoursModel businessHours; // 営業時間情報
  final String businessStatus; // ビジネスステータス（営業中、一時休業、永久閉店など）
  final List<PhotoModel> photos; // レストランの写真リスト
  bool get isOpen => businessHours.isOpenNow(); // 現在営業中かどうか
  String get closedDays => businessHours.getClosedDaysString(); // 定休日の文字列を返す
  bool isFavorite;

  RestaurantModel({
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

  // toJson メソッド
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'priceRange': priceRange,
      'rating': rating,
      'reviewCount': reviewCount,
      'userReviews': userReviews.map((review) => review.toJson()).toList(),
      'mapIconUrl': mapIconUrl,
      'address': address,
      'location': {'lat': location.latitude, 'lng': location.longitude},
      'phone': phone,
      'websiteUrl': websiteUrl,
      'businessHours': businessHours.toJson(),
      'businessStatus': businessStatus,
      'photos': photos.map((photo) => photo.toJson()).toList(),
      'isFavorite': isFavorite,
    };
  }

  // // MapからRestaurantModelを生成
  // factory RestaurantModel.fromMap(Map<String, dynamic> map) {
  //   return RestaurantModel(
  //     id: map['id'],
  //     name: map['name'],
  //     imageUrl: map['imageUrl'] ?? '', // imageUrl がない場合のデフォルト処理
  //     rating: map['rating'],
  //     location: map['location'],
  //     phone: map['phone'],
  //     hours: map['hours'],

  //     isFavorite: map['is_favorite'] == 1,
  //   );
  // }

  // // RestaurantModelをMapに変換
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'imageUrl': imageUrl,
  //     'rating': rating,
  //     'location': location,
  //     'phone': phone,
  //     'hours': hours,
  //     'is_favorite': isFavorite ? 1 : 0,
  //   };
  // }
}
