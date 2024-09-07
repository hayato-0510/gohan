import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gohan/components/login_component/theme_color.dart';

import 'package:gohan/components/error_overlay/error_handler.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

void _Failedsendemail() {
  ErrorHandler().handleError(AppError(
    message: 'パスワードリセットメールを送信できませんでした。',
    type: ErrorType.unknown,
  ));
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email = '';
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme, // ここでテーマを適用
      child: Scaffold(
        appBar: AppBar(
          title: const Text('パスワードリセット'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                EmailInputField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ResetButton(
                  onPressed: () async {
                    await _handlePasswordReset();
                  },
                ),
                const SizedBox(height: 20),
                InfoText(infoText: infoText),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePasswordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        infoText = 'パスワードリセットメールを送信しました。';
      });
    } catch (e) {
      setState(() {
          _Failedsendemail();
      });
    }
  }
}

class EmailInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EmailInputField({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'メールアドレス'),
      onChanged: onChanged,
    );
  }
}

class ResetButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResetButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // ボタンの背景色を黒に設定
        padding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: const Text('パスワードリセット',
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class InfoText extends StatelessWidget {
  final String infoText;

  const InfoText({required this.infoText, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(infoText);
  }
}
