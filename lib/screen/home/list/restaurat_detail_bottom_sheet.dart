import 'package:flutter/material.dart';
import 'package:gohan/components/restaurant_information/restaurant_information.dart';
import 'package:gohan/model/restaurant/data/business_hours_model.dart';
import 'package:gohan/components/restaurant_modal/restaurant_modal.dart';
import 'package:gohan/model/restaurnt/data/business_hours_model.dart';

class RestaurantDetailsBottomSheet extends StatelessWidget {
  final String name;
  final double rating;
  final String location;
  final String phone;
  final String hours;
  final bool isOpen;
  final BusinessHoursModel businessHours;

  const RestaurantDetailsBottomSheet({
    required this.name,
    required this.rating,
    required this.location,
    required this.phone,
    required this.hours,
    required this.isOpen,
    required this.businessHours,
  });

  @override
  Widget build(BuildContext context) {
    return RestaurantModal(
      name: name,
      rating: rating,
      location: location,
      phone: phone,
      businessHours: businessHours,
    );
  }
}
