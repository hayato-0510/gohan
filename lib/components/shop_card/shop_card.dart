import 'package:flutter/material.dart';
import 'package:gohan/components/StarRating/StarRating.dart';


class ShopCard extends StatelessWidget {
  final String title;
  final double rating;

  const ShopCard({
    super.key,
    required this.title,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
