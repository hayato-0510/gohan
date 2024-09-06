import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ログアウト後の画面
import 'package:gohan/screen/auth/login.dart';

// view_model
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

// 遷移先の画面
import 'package:gohan/screen/profile/pages/account_edit_page.dart';
import 'package:gohan/screen/profile/pages/allergy_settings_page.dart';
import 'package:gohan/screen/profile/pages/terms_of_service_page.dart';
import 'package:gohan/screen/profile/pages/help_and_support_page.dart';

// wdget
import 'package:gohan/screen/profile/widget/list_title.dart';
import 'package:gohan/screen/profile/widget/background_object.dart';

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
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Stack(
        children: [
          SizedBox(
            height: 250,
            child: BackgroundObject().build(),
          ),
          Column(
            children: [
              const SizedBox(height: 150),
              _userInfoCard(context, user),
               _signOutButton(context),
              const SizedBox(height: 20),
              Expanded(child: _buildListTile(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _userInfoCard(BuildContext context, user) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 8),
            Text(
              user?.displayName ?? 'ゲストユーザー',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'メールアドレスなし',
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 53, 53, 53),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ListTitle(
          icon: Icons.account_circle,
          title: 'アカウント編集',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccountEditPage())),
        ),
        ListTitle(
          icon: Icons.warning,
          title: 'アレルギー設定',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => AllergySettingsPage())),
        ),
        ListTitle(
          icon: Icons.description,
          title: '利用規約',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => TermsOfServicePage())),
        ),
        ListTitle(
          icon: Icons.help,
          title: 'ヘルプ・お問い合わせ',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => HelpAndSupportPage())),
        ),
      ],
    );
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final userInfoViewModel = context.read<AuthViewModel>();
        await userInfoViewModel.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: const Text('Sign Out'),
    );
  }
}
