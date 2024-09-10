import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              const SizedBox(height: 70),
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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 7, 7, 7).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildListItem(
            Icons.account_circle,
            'アカウント編集',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AccountEditPage())),
          ),
          _buildListItem(
            Icons.warning,
            'アレルギー設定',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllergySettingsPage())),
          ),
          _buildListItem(
            Icons.description,
            '利用規約',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => TermsOfServicePage())),
          ),
          _buildListItem(
            Icons.help,
            'ヘルプ・お問い合わせ',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => HelpAndSupportPage())),
            isLast: true, // ここで名前付き引数として指定
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title,
      {required VoidCallback onTap, bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon,
              color: const Color.fromARGB(255, 82, 80, 80), size: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing:
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 0.5,
            color: const Color.fromARGB(255, 93, 91, 91),
          ),
      ],
    );
  }
}
