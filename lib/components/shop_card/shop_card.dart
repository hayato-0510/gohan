import 'package:flutter/material.dart';
import 'package:gohan/components/star_rating/star_rating.dart';
import 'package:gohan/components/shop-information/shop-information.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 2.0, color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              StarRating(
                rating: rating,
                starSize: 24,
                filledColor: Colors.yellow,
                unfilledColor: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 200, // 画像の高さを設定
            color: Colors.grey[300], // 画像のプレースホルダー
            child: Center(child: Text('画像')),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 100),
          const ShopInformation(
            location: '三重県',
            phone: '0000000000000',
            hours: '営業中 10:00〜20:00',
          ),
        ],
      ),
    );
  }
}