// NumericStarRating の使用例

// NumericStarRating(
//   rating: "評価（必須、double型）",
//   maxRating: "最大評価数（オプション、デフォルト5）",
//   starSize: "星のサイズ（オプション、デフォルト24）",デフォルトは要調整
//   filledColor: "塗りつぶされた星の色（オプション、デフォルトColors.yellow）",
//   unfilledColor: "塗りつぶされていない星の色（オプション、デフォルトColors.grey）",
// ),

import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double starSize;
  final Color filledColor;
  final Color unfilledColor;

  const StarRating({
    Key? key,
    required this.rating,
    this.maxRating = 5,
    this.starSize = 24,
    this.filledColor = Colors.yellow,
    this.unfilledColor = Colors.grey,
  }) : super(key: key);

  // 評価値を0.5刻みで丸める関数
  double _roundToHalf(double value) {
    if (value < 0.3) return 0.0;
    if (value < 0.8) return 0.5;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final roundedRating = _roundToHalf(rating);
    return Semantics(
      label: '$rating out of $maxRating stars',
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
              if (index < roundedRating.floor()) {
                return Icon(Icons.star, color: filledColor, size: starSize);
              } else if (index < roundedRating.ceil() && roundedRating % 1 != 0) {
                return Stack(
                  children: [
                    Icon(Icons.star, color: unfilledColor, size: starSize),
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.5,
                        child: Icon(Icons.star, color: filledColor, size: starSize),
                      ),
                    ),
                  ],
                );
              } else {
                return Icon(Icons.star, color: unfilledColor, size: starSize);
              }
            }),
          ),
        ],
      ),
    );
  }
}