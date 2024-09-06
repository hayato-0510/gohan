import 'package:flutter/material.dart';
import 'package:gohan/model/auth/auth_model.dart';
import 'package:gohan/model/firestore/user_firestore_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    _currentUser = FirebaseAuth.instance.currentUser;
    debugPrint("Reloaded user: $_currentUser");
    notifyListeners();
  }

  Future<bool> signUpWithGoogle() async {
    final user = await _authModel.signUpWithGoogle();
    if (user != null) {
      _currentUser = user.user;
      debugPrint("User: $_currentUser");
      await _userFirestoreModel.saveUserToFirestore(
          _currentUser!, _currentUser!.displayName ?? '');
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
    required String displayName,
  }) async {
    final user = await _authModel.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName
    );

    if (user != null) {
      _currentUser = user.user;
      await _userFirestoreModel.saveUserToFirestore(_currentUser!, displayName);
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
}