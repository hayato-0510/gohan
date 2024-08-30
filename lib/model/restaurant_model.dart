class RestaurantModel {
  final String id;
  final String restaurantName;
  final String imageUrl;
  final double rating;
  final String location;
  final String phone;
  final String hours;
  bool isOpen;
  bool isFavorite;

  RestaurantModel({
    required this.id,
    required this.restaurantName,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.phone,
    required this.hours,
    this.isOpen = false,
    this.isFavorite = false,
  });
}