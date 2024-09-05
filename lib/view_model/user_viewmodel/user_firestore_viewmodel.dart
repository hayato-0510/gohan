import 'package:flutter/material.dart';
import 'package:gohan/model/firestore/user_firestore_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoViewModel extends ChangeNotifier {
  final UserFirestoreModel _userFirestoreModel = UserFirestoreModel();
  User? _user;

  User? get user => _user;

  UserInfoViewModel(this._user);

  Future<void> loadUser() async {
    if (_user == null) {
      debugPrint('User is null in loadUser');
      // Firestoreからユーザー情報をロードする場合
      final firebaseAuthUser = FirebaseAuth.instance.currentUser;
      if (firebaseAuthUser != null) {
        _user = firebaseAuthUser;
        notifyListeners();
      }
    }
  }

  Future<void> updateUser({
    String? name,
    String? email,
    String? photoURL,
  }) async {
    if (_user != null) {
      await _userFirestoreModel.updateUser(
        uid: _user!.uid,
        name: name,
        email: email,
        photoURL: photoURL,
      );
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    }
  }
}