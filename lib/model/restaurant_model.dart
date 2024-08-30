class RestaurantModel {
  final String id;
  final String name; // 'restaurantName' を 'name' に統一
  final String imageUrl;
  final double rating;
  final String location;
  final String phone;
  final String hours;
  bool isOpen;
  bool isFavorite;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.phone,
    required this.hours,
    this.isOpen = false,
    this.isFavorite = false,
  });

  // MapからRestaurantModelを生成
  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'] ?? '', // imageUrl がない場合のデフォルト処理
      rating: map['rating'],
      location: map['location'],
      phone: map['phone'],
      hours: map['hours'],
      isFavorite: map['is_favorite'] == 1,
    );
  }

  // RestaurantModelをMapに変換
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'location': location,
      'phone': phone,
      'hours': hours,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }
}
