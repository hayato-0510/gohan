import 'package:flutter/material.dart';
import 'package:gohan/model/firestore/user_firestore_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gohan/components/error_overlay/error_handler.dart';

class UserInfoViewModel extends ChangeNotifier {
  final UserFirestoreModel _userFirestoreModel = UserFirestoreModel();
  User? _user;

  User? get user => _user;

  UserInfoViewModel(this._user);

  Future<void> loadUser() async {
    try {
      if (_user == null) {
        debugPrint('User is null in loadUser');
        // Firestoreからユーザー情報をロードする場合
        final firebaseAuthUser = FirebaseAuth.instance.currentUser;
        if (firebaseAuthUser != null) {
          _user = firebaseAuthUser;
          notifyListeners();
        } else {
          throw Exception('ユーザーが見つかりません');
        }
      }
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'ユーザー情報の読み込みに失敗しました。',
        type: ErrorType.auth,
        additionalActions: {
          '再試行': () => loadUser(),
        },
      ));
    }
  }

  Future<void> updateUser({
    String? name,
    String? email,
    String? photoURL,
  }) async {
    try {
      if (_user != null) {
        await _userFirestoreModel.updateUser(
          uid: _user!.uid,
          name: name,
          email: email,
          photoURL: photoURL,
        );
        _user = FirebaseAuth.instance.currentUser;
        notifyListeners();
      } else {
        throw Exception('ユーザーが見つかりません');
      }
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('ユーザーが見つかりません')) {
        errorMessage = 'ユーザー情報の更新に失敗しました。ユーザーが見つかりません。';
      } else {
        errorMessage = 'ユーザー情報の更新中にエラーが発生しました。';
      }

      ErrorHandler().handleError(AppError(
        message: errorMessage,
        type: ErrorType.database,
        additionalActions: {
          '再試行': () => updateUser(name: name, email: email, photoURL: photoURL),
        },
      ));
    }
  }

  Future<void> refreshUser() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      ErrorHandler().handleError(AppError(
        message: 'ユーザー情報の更新に失敗しました。',
        type: ErrorType.auth,
        additionalActions: {
          '再試行': () => refreshUser(),
        },
      ));
    }
  }
}