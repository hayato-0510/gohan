import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopCardViewModel extends ChangeNotifier {
  Map<String, dynamic>? _shopCard;

  Map<String, dynamic>? get shopCard => _shopCard;

  Future<void> saveShopCard(String id, String title, double rating, bool isLike) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shop_card_${id}_title', title);
    await prefs.setDouble('shop_card_${id}_rating', rating);
    await prefs.setBool('shop_card_${id}_is_like', isLike);
    print('ShopCard saved');
  }

Future<Map<String, dynamic>> loadShopCard(String id) async {
  final prefs = await SharedPreferences.getInstance();
  final title = prefs.getString('shop_card_${id}_title') ?? '';
  final rating = prefs.getDouble('shop_card_${id}_rating') ?? 0.0;
  final isLike = prefs.getBool('shop_card_${id}_is_like') ?? false;
  return {
    'title': title,
    'rating': rating,
    'is_like': isLike,
  };
}

  Future<void> deleteShopCard(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('shop_card_${id}_title');
    await prefs.remove('shop_card_${id}_rating');
    await prefs.remove('shop_card_${id}_is_like');
    _shopCard = null;
    notifyListeners();
    print('ShopCard deleted');
  }
}
