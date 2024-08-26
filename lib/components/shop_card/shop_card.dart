import 'package:flutter/material.dart';
import 'package:gohan/components/star_rating/star_rating.dart';
import 'package:gohan/components/LocationButton/LocationButton.dart';

class ShopCard extends StatelessWidget {
  final int id;
  final String title;
  final double rating;

  const ShopCard({
    super.key,
    required this.id,
    required this.title,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 2.0, color: Colors.black)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              StarRating(
                rating: rating,
                starSize: 24,
                filledColor: Colors.yellow,
                unfilledColor: Colors.grey,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: LocationButton(), 
        ),
      ],
    );
  }
}
