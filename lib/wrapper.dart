import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view/screen/auth/login.dart';
import 'package:gohan/view/screen/tab_page.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authviewmodel = Provider.of<AuthViewModel>(context);
    final user = authviewmodel.currentUser;

    if (user == null) {
      return const LoginPage();
      // デバッグのときうざかったらこっちを使う
      // return const BottomTabPage();
    } else {
      debugPrint('User is signed in');
      return const BottomTabPage();
    }
  }
}
