// NumericStarRating の使用例

// NumericStarRating(
//   rating: "評価（必須、double型）",
//   maxRating: "最大評価数（オプション、デフォルト5）",
//   starSize: "星のサイズ（オプション、デフォルト24）",デフォルトは要調整
//   filledColor: "塗りつぶされた星の色（オプション、デフォルトColors.yellow）",
//   unfilledColor: "塗りつぶされていない星の色（オプション、デフォルトColors.grey）",
//   position: "表示位置（必須、Alignment型）",
// ),

import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double starSize;
  final Color filledColor;
  final Color unfilledColor;
  final Alignment position;

  const StarRating({
    Key? key,
    required this.rating,
    this.maxRating = 5,
    this.starSize = 24,
    this.filledColor = Colors.yellow,
    this.unfilledColor = Colors.grey,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: position,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(fontSize: starSize, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(maxRating, (index) {
              if (index < rating.floor()) {
                return Icon(Icons.star, color: filledColor, size: starSize);
              } else if (index < rating.ceil() && rating % 1 != 0) {
                return Icon(Icons.star_half, color: filledColor, size: starSize);
              } else {
                return Icon(Icons.star_border, color: unfilledColor, size: starSize);
              }
            }),
          ),
        ],
      ),
    );
  }
}