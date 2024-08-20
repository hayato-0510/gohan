
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:gohan/components/star_evalution/StarRating.dart';
import 'package:gohan/view_models/shop_card_viewmodel.dart';

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
  
  get is_like => null;

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

  Future<void> save() async {
    ShopCardViewModel viewModel = ShopCardViewModel(); // インスタンスを作成
    await viewModel.saveShopCard('1', 'Shop', 4.5, true); // インスタンスメソッドを呼び出す
  }

  // データを読み込むメソッド
  static Future<Map<String, dynamic>> load(String id) async {
    ShopCardViewModel viewModel = ShopCardViewModel(); // インスタンスを作成
    return await viewModel.loadShopCard(id); // インスタンスメソッドを呼び出す
  }
}
