import 'package:flutter/material.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:gohan/screen/tab_page.dart';
import 'package:gohan/components/icon_label_button/icon_label_button.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPage createState() => _SigninPage();
}

class _SigninPage extends State<SigninPage> {
  
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _googleSignInButton(context, authViewModel),
          ],
        ),
      ),
    );
  }

  Widget _googleSignInButton(
      BuildContext context, AuthViewModel authViewModel) {
    return IconLabelButton(
      onPressed: () async {
        final result = await authViewModel.signUpWithGoogle();
        if (result) {
          debugPrint('Sign in with Google succeeded');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomTabPage(),
            ),
          );
        } else {
          print('Sign in with Google failed');
        }
      },
      icon: Image.asset(
        'assets/logo/google_icon.png',
        height: 24.0,
        width: 24.0,
      ),
      label: 'Googleで続ける',
    );
  }
}