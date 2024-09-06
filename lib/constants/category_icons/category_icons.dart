// lib/constants/category_icons/category_icons.dart

import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryIcons {
  static const Map<String, IconData> icons = {
    'レストラン': Icons.restaurant,
    'イタリア料理店': Icons.local_pizza,
    '中華料理店': Icons.restaurant,
    '日本料理店': Icons.set_meal,
    'フレンチレストラン': Icons.restaurant_menu,
    'メキシカン料理店': Icons.local_dining,
    'インド料理店': Icons.restaurant,
    'ピザレストラン': Icons.local_pizza,
    '寿司屋': Icons.rice_bowl,
    'ステーキハウス': Icons.restaurant_menu,
    'シーフードレストラン': Icons.set_meal,
    'ベジタリアンレストラン': Icons.eco,
    'ファストフード店': Icons.fastfood,
    'カフェ': Icons.local_cafe,
    'バー': Icons.local_bar,
    'パブ': Icons.sports_bar,
    'ファミリーレストラン': Icons.family_restroom,
    '居酒屋': Icons.nightlife,
    'ラーメン屋': Icons.ramen_dining,
    '韓国料理店': Icons.restaurant,
  };

  static IconData getIcon(String category) {
    return icons[category] ?? Icons.restaurant;  // デフォルトアイコン
  }
}