// lib/view/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:gohan/components/map/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gohan/components/error_overlay/error_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  void _showTestError() {
    ErrorHandler().handleError(AppError(
      message: 'これはプロフィールページのテストエラーです。',
      type: ErrorType.unknown,
      action: () {
        print('プロフィールページのエラーアクションが実行されました');
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _showTestError,
              child: Text('テストエラーを表示'),
            ),
          ],
        ),
      ),
    );
  }
}


