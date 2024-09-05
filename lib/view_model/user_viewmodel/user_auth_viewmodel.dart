import 'package:flutter/material.dart';
import 'package:gohan/model/auth/auth_model.dart';
import 'package:gohan/model/firestore/user_firestore_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gohan/components/error_overlay/error_handler.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthModel _authModel = AuthModel();
  final UserFirestoreModel _userFirestoreModel = UserFirestoreModel();
  User? _currentUser;
  User? get currentUser => _currentUser;

  AuthViewModel(){
    _currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future<void> reloadUser() async {
    try {
      _currentUser = FirebaseAuth.instance.currentUser;
      await _currentUser?.reload();
      debugPrint("Reloaded user: $_currentUser");
      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'ユーザー情報の更新に失敗しました。',
        type: ErrorType.auth,
        additionalActions: {
          '再試行': () => reloadUser(),
        },
      ));
    }
  }

  Future<bool> signUpWithGoogle() async {
    final user = await _authModel.signUpWithGoogle();
    if (user != null) {
      _currentUser = user.user;
      debugPrint("User: $_currentUser");
      await _userFirestoreModel.saveUserToFirestore(_currentUser!, _currentUser!.displayName ?? '');
      notifyListeners();
      return true;
    }
  }

  Future<bool> logInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
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
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'メールアドレスとパスワードでのログインに失敗しました。',
        type: ErrorType.auth,
        additionalActions: {
          '再試行': () => logInWithEmail(email: email, password: password),
        },
      ));
      return false;
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final user = await _authModel.signUpWithEmail(
        email: email,
        password: password,
      );

    if (user != null) {
      _currentUser = user.user;
      await _userFirestoreModel.saveUserToFirestore(_currentUser!, username);
      notifyListeners();
      return true;
    }
  }

  Future<bool> signOut() async {
    try {
      await _authModel.signOut();
      _currentUser = null;
      notifyListeners();
      return true;
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'サインアウトに失敗しました。',
        type: ErrorType.auth,
        additionalActions: {
          '再試行': () => signOut(),
        },
      ));
      return false;
    }
  }
}