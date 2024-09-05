import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gohan/components/error_overlay/error_handler.dart';

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
      // 位置情報の権限をチェック
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // 位置情報を取得
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      updatePosition(position);
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('Location permissions are denied')) {
        errorMessage = '位置情報の利用が許可されていません。設定から位置情報の利用を許可してください。';
      } else if (e.toString().contains('Location permissions are permanently denied')) {
        errorMessage = '位置情報の利用が永続的に拒否されています。設定から位置情報の利用を許可してください。';
      } else {
        errorMessage = '現在地の取得中にエラーが発生しました。';
      }

      ErrorHandler().handleError(AppError(
        message: errorMessage,
        type: ErrorType.location,
        additionalActions: {
          '再試行': () => getCurrentLocation(),
          '設定を開く': () async {
            await Geolocator.openAppSettings();
          },
        },
      ));
    }
  }
}