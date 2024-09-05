import 'package:flutter/foundation.dart';
import 'package:gohan/components/error_overlay/error_handler.dart';

class UserSearchSettingsViewModel extends ChangeNotifier {
  String _name = '';
  String _selectedDistance = '5km';
  bool _isOpen = false;

  final List<String> _validDistances = ['1km', '5km', '10km', '20km'];

  String get name => _name;
  String get selectedDistance => _selectedDistance;
  bool get isOpen => _isOpen;

  void updateRestaurantName(String name) {
    try {
      if (name.length > 100) {  // 例: 名前の最大長を100文字に制限
        throw Exception('レストラン名が長すぎます');
      }
      _name = name;
      print(_name);
      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'レストラン名の更新に失敗しました: ${e.toString()}',
        type: ErrorType.validation,
      ));
    }
  }

  void updateSelectedDistance(String distance) {
    try {
      if (!_validDistances.contains(distance)) {
        throw Exception('無効な距離が選択されました');
      }
      _selectedDistance = distance;
      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: '距離の更新に失敗しました: ${e.toString()}',
        type: ErrorType.validation,
      ));
    }
  }

  void toggleIsOpen() {
    _isOpen = !_isOpen;
    notifyListeners();
  }

  // 設定をリセットするメソッド
  void resetSettings() {
    try {
      _name = '';
      _selectedDistance = '5km';
      _isOpen = false;
      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: '設定のリセットに失敗しました',
        type: ErrorType.unknown,
      ));
    }
  }
}