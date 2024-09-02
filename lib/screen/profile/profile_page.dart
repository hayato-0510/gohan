// lib/view/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userAuthViewModel = context.read<AuthViewModel>();
      if (userAuthViewModel.currentUser == null) {
        userAuthViewModel.reloadUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAuthViewModel = Provider.of<AuthViewModel>(context);
    final user = userAuthViewModel.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              CircleAvatar(
                radius: 50,
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName ?? 'No Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email ?? 'No Email',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ] ,
            _signOutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _signOutButton(BuildContext context) {

    return ElevatedButton(
      onPressed: () async {
        final userInfoViewModel = context.read<AuthViewModel>();
        await userInfoViewModel.signOut();
      },
      child: const Text('Sign Out'),
    );
  }
}


