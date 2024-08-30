import 'package:flutter/material.dart';
import 'package:gohan/components/restaurant_information/restaurant_information.dart';

class RestaurantDetailsViewModel {
  void showRestaurantDetails(
    BuildContext context,
    String restaurantName,
    double rating,
    String location,
    String phone,
    String hours,
    bool isOpen,
  ) {
    print('showRestaurantDetails called for $restaurantName');
     print('Rating: $rating, Location: $location, Phone: $phone, Hours: $hours, Is Open: $isOpen');
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return _RestaurantDetailsBottomSheet(
          restaurantName: restaurantName,
          rating: rating,
          location: location,
          phone: phone,
          hours: hours,
          isOpen: isOpen,
        );
      },
    );
  }
}

class _RestaurantDetailsBottomSheet extends StatelessWidget {
  final String restaurantName;
  final double rating;
  final String location;
  final String phone;
  final String hours;
  final bool isOpen;

  const _RestaurantDetailsBottomSheet({
    required this.restaurantName,
    required this.rating,
    required this.location,
    required this.phone,
    required this.hours,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    print('Building bottom sheet for $restaurantName');
    return Container(
      height: 350, // 高さを調整
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(restaurantName),
              subtitle: Text('Rating: $rating'),
            ),
            RestaurantInformation(
              location: location,
              phone: phone,
              hours: hours,
              isOpen: isOpen,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
