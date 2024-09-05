import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;

  const SignUpForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
  });

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: TextField(
            controller: widget.emailController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Email",
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: TextField(
            controller: widget.passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Password",
              suffixIcon: IconButton(
                onPressed: _togglePasswordVisibility,
                icon: Icon(
                  _obscureText
                      ? Icons.remove_red_eye_sharp
                      : Icons.visibility_off,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: TextField(
            controller: widget.usernameController,
            obscureText: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Username",
            ),
          ),
        ),
      ],
    );
  }
}
