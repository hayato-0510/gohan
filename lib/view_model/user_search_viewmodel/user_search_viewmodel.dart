import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  String _selectedFood = '';

  String get selectedFood => _selectedFood;

  void updateSelectedFood(String food) {
    _selectedFood = food;
    notifyListeners();
  }

  void resetSearch() {
    _selectedFood = '';
    notifyListeners();
  }

  void performSearch() {
    if (_selectedFood.isNotEmpty) {
      print('Searching for $_selectedFood');
    }
  }
}
