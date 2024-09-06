import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';
import 'package:gohan/screen/profile/pages/account_edit_page.dart';
import 'package:gohan/screen/profile/pages/allergy_settings_page.dart';
import 'package:gohan/screen/profile/pages/terms_of_service_page.dart';
import 'package:gohan/screen/profile/pages/help_and_support_page.dart';

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
      body: Stack(
        children: [
          Container(
            height: 250,
            child: Stack(
              children: [
                Positioned(
                  top: 80,
                  right: -20,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.yellow,
                  ),
                ),
                Positioned(
                  top: -50,
                  left: -20,
                  child: CircleAvatar(
                    radius: 140,
                    backgroundColor: Colors.green,
                  ),
                ),
                Positioned(
                  top: -50,
                  right: -10,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 150),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : const AssetImage(
                                    'assets/images/default_avatar.png')
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
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildListTile(
                      icon: Icons.account_circle,
                      title: 'アカウント編集',
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountEditPage())),
                    ),
                    _buildListTile(
                      icon: Icons.warning,
                      title: 'アレルギー設定',
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllergySettingsPage())),
                    ),
                    _buildListTile(
                      icon: Icons.description,
                      title: '利用規約',
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TermsOfServicePage())),
                    ),
                    _buildListTile(
                      icon: Icons.help,
                      title: 'ヘルプ・お問い合わせ',
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpAndSupportPage())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onTap: onTap,
      ),
    );
  }
}
