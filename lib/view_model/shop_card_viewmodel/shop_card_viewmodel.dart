import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopCardViewModel extends ChangeNotifier {
  Map<String, dynamic>? _shopCard;

  Map<String, dynamic>? get shopCard => _shopCard;

  Future<void> saveShopCard(String id, String title, double rating, bool isLike) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTitle(id), title);
    await prefs.setDouble(_keyRating(id), rating);
    await prefs.setBool(_keyIsLike(id), isLike);
    print('ShopCard saved $id');
  }

  Future<Map<String, dynamic>> loadShopCard(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final title = prefs.getString(_keyTitle(id)) ?? '';
    final rating = prefs.getDouble(_keyRating(id)) ?? 0.0;
    final isLike = prefs.getBool(_keyIsLike(id)) ?? false;

    _shopCard = {
      'title': title,
      'rating': rating,
      'is_like': isLike,
    };
    print('ShopCard loaded $id');
    return _shopCard!;
  }

  Future<void> deleteShopCard(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTitle(id));
    await prefs.remove(_keyRating(id));
    await prefs.remove(_keyIsLike(id));
    _shopCard = null;
    notifyListeners();
    print('ShopCard deleted');
  }

  String _keyTitle(String id) => 'shop_card_${id}_title';
  String _keyRating(String id) => 'shop_card_${id}_rating';
  String _keyIsLike(String id) => 'shop_card_${id}_is_like';
}