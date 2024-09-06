import 'package:flutter/material.dart';

// screenのインポート
import 'package:gohan/view/screen/tab_page.dart';
import 'package:gohan/view/screen/auth/signin.dart';

// viewmodelのインポート
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

// コンポーネントのインポート
import 'package:gohan/components/icon_label_button/icon_label_button.dart';
import 'package:gohan/components/login_component/theme_color.dart';
import 'package:gohan/components/login_component/login_textfield.dart';
import 'package:gohan/components/error_overlay/error_handler.dart';
// import 'package:gohan/components/login_colors/LoginHeader.dart';

// widgetのインポート
import 'package:gohan/view/screen/auth/widget/lottie_animation/lottie_animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

void _showFaltLogin() {
  ErrorHandler().handleError(AppError(
    message: 'ログインに失敗しました。',
    type: ErrorType.unknown,
  ));
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const LottieAnimation(
                      url:
                          'https://lottie.host/13529f94-a921-42de-8043-d4bb8b08e5c1/uf7oSHyuZg.json',
                    ),
                    const SizedBox(height: 5),
                    _emailSigInForm(context),
                    const SizedBox(height: 5),
                    _emailSignInButton(context, authViewModel),
                    const SizedBox(height: 10),
                    _divider(),
                    const SizedBox(height: 10),
                    _googleSignInButton(context, authViewModel),
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

  Widget _emailSigInForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SigninPage(),
              ),
            );
          },
          child: Text(
            "アカウントをお持ちでない方",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 5),
        LoginForm(
            emailController: emailController,
            passwordController: passwordController),
        Text(
          "パスワードを忘れた方",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _emailSignInButton(
      BuildContext context, AuthViewModel _authViewModel) {
    return ElevatedButton(
      onPressed: () async {
        // メールとパスワードを取得
        String email = emailController.text;
        String password = passwordController.text;

        // ログイン処理
        bool success = await _authViewModel.logInWithEmail(
          email: email,
          password: password,
        );

        if (success) {
          // サインアップ成功時の処理
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomTabPage()),
          );
        } else {
          // ログイン失敗時の処理
          _showFaltLogin();
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
          "メールアドレスでログイン",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: <Widget>[
        _diverExpanded(10.0, 15.0),
        const Text("その他のログイン方法"),
        _diverExpanded(15.0, 10.0),
      ],
    );
  }

  Widget _diverExpanded(double left, double right) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: left, right: right),
        child: const Divider(
          color: Colors.black,
          height: 50,
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
          _showFaltLogin();
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
