import 'package:flutter/material.dart';
import 'package:gohan/components/login_component/sign_up_textfield.dart';
import 'package:gohan/screen/tab_page.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

import 'package:gohan/components/login_component/theme_color.dart';
import 'package:gohan/screen/tab_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SigninPage> {
  bool _loading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
            "新しいアカウント",
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
                    Text("アカウント作成",
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontSize: size.width * 0.1,
                                )),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SignUpForm(
                            emailController: emailController,
                            passwordController: passwordController,
                            usernameController: usernameController)
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                            });
                            // メールとパスワードを取得
                            String email = emailController.text;
                            String password = passwordController.text;
                            String displayName = usernameController.text;

                            try {
                              // サインアップ処理
                              bool success =
                                  await authViewModel.signUpWithEmail(
                                email: email,
                                password: password,
                                displayName: displayName,
                              );

                              setState(() {
                                _loading = false;
                              });

                              if (success) {
                                // サインアップ成功時の処理
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BottomTabPage()),
                                );
                              } else {
                                // サインアップ失敗時の処理
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("サインアップに失敗しました")),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                _loading = false;
                              });
                              // エラーメッセージを表示
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("エラーが発生しました: $e")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // ボタンの背景色を黒に設定
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "アカウント作成",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
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
}
