import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserLocationViewModel extends ChangeNotifier {
  Position? _currentPosition;

  // 現在の位置情報を取得する
  Position? get currentPosition => _currentPosition;

  // 位置情報を更新する
  void updatePosition(Position position) {
    _currentPosition = position;
    notifyListeners(); // 更新を通知
  }

  // 現在地の取得処理を追加
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      updatePosition(position);
    } catch (e) {
      print(e);
    }
  }
}
