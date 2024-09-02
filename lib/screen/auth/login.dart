import 'package:flutter/material.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

import 'package:gohan/screen/tab_page.dart';
import 'package:gohan/components/icon_label_button/icon_label_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final authViewModel = AuthViewModel();
    // final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _emailSignIn(context, authViewModel, screenWidth),
                _googleSignInButton(context, authViewModel),
              ],
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black54, // 半透明の背景
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _googleSignInButton(
      BuildContext context, AuthViewModel authViewModel) {
    return IconLabelButton(
      onPressed: () async {
        setState(() {
          _loading = true;
        });

        final result = await authViewModel.signUpWithGoogle();
        debugPrint('result: $result');
        if (result) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomTabPage(),
            ),
          );
        } else {
           setState(() {
          _loading = false;
        });
          debugPrint("Sign in with Google failed");
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