import 'package:flutter/material.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

import 'package:gohan/screen/tab_page.dart';
import 'package:gohan/components/icon_label_button/icon_label_button.dart';
import 'package:gohan/components/login_colors/theme_color.dart';

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
    final Size size = MediaQuery.of(context).size;

    return Theme(
      data: lightTheme, // ここでテーマを適用
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Login",
            style: TextStyle(color: Colors.grey[900]), // ここでshade900を使用
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: size.width,
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: size.height * 0.2,
                    top: size.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello, \nWelcome Back",
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: size.width * 0.1,
                                )),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _googleSignInButton(context, authViewModel),
                            const SizedBox(width: 40),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200], // 背景色をグレーに設定
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: const TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email or Phone number"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200], // 背景色をグレーに設定
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Password"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Forgot Password?",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // ボタンの背景色を黒に設定
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text("Create account",
                            style: Theme.of(context).textTheme.bodyLarge)
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (_loading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ),
          ],
        ),
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
