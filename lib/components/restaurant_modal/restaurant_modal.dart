// restaurant_modal.dart
import 'package:flutter/material.dart';
import 'package:gohan/components/restaurant_information/restaurant_information.dart';
import 'package:gohan/model/restaurnt/data/business_hours_model.dart';

class RestaurantModal extends StatelessWidget {
  final String name;
  final double rating;
  final String location;
  final String phone;
  final BusinessHoursModel businessHours;

  const RestaurantModal({
    required this.name,
    required this.rating,
    required this.location,
    required this.phone,
    required this.businessHours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
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
              title: Text(name),
              subtitle: Text('Rating: $rating'),
            ),
            RestaurantInformation(
              phone: phone,
              address: location,
              businessHours: businessHours,
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
