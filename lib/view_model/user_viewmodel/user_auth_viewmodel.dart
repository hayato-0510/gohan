import 'package:flutter/material.dart';
import 'package:gohan/model/auth/auth_model.dart';
import 'package:gohan/model/firestore/user_firestore_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthModel _authModel = AuthModel();
  final UserFirestoreModel _userFirestoreModel = UserFirestoreModel();
  User? _currentUser;
  User? get currentUser => _currentUser;

  AuthViewModel() {
    _currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future<void> reloadUser() async {
    await _currentUser?.reload();
    _currentUser = FirebaseAuth.instance.currentUser;
    debugPrint("Reloaded user: $_currentUser");
    notifyListeners();
  }

  Future<bool> signUpWithGoogle() async {
    final user = await _authModel.signUpWithGoogle();
    if (user != null) {
      _currentUser = user.user;
      debugPrint("User: $_currentUser");
      await _userFirestoreModel.saveUserToFirestore(_currentUser!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> logInWithEmail({
    required String email,
    required String password,
  }) async {
    final user = await _authModel.logInWithEmail(
      email: email,
      password: password,
    );

    if (user != null) {
      _currentUser = user.user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final user = await _authModel.signUpWithEmail(
      email: email,
      password: password,
    );

    if (user != null) {
      _currentUser = user.user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signOut() async {
    try {
      await _authModel.signOut();
      _currentUser = null;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> updateProfile(String name, String? imagePath) async {
    try {
      if (_currentUser != null) {
        // 名前を更新
        await _currentUser!.updateDisplayName(name);

        // 画像パスをSharedPreferencesに保存
        if (imagePath != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('profile_image_path', imagePath);
        }

        // ユーザー情報をリロード
        await reloadUser();
      }
    } catch (e) {
      print('プロフィール更新エラー: $e');
      rethrow;
    }
  }
}
