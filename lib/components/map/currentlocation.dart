import 'package:geolocator/geolocator.dart';

class LocationProvider {
  // シングルトンパターンでインスタンスを保持する
  static final LocationProvider _instance = LocationProvider._internal();
  factory LocationProvider() => _instance;
  LocationProvider._internal();

  Position? _currentPosition;

  // 現在の位置情報を取得する
  Position? get currentPosition => _currentPosition;

  // 位置情報を更新する
  void updatePosition(Position position) {
    _currentPosition = position;
  }
}
