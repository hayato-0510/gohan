import 'package:flutter/foundation.dart';

class UserSearchSettingsViewModel extends ChangeNotifier {
  String _restaurantName = '';
  String _selectedDistance = '5km';
  bool _isOpen = false;

  String get restaurantName => _restaurantName;
  String get selectedDistance => _selectedDistance;
  bool get isOpen => _isOpen;

  void updateRestaurantName(String name) {
    _restaurantName = name;
    notifyListeners();
  }

  void updateSelectedDistance(String distance) {
    _selectedDistance = distance;
    notifyListeners();
  }

  void toggleIsOpen() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}
