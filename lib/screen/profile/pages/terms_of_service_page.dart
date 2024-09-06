import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('利用規約'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '利用規約',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildSection('1. はじめに',
                '本利用規約（以下「本規約」といいます）は、当社が提供するアプリケーション（以下「本アプリ」といいます）の利用条件を定めるものです。'),
            _buildSection('2. 利用資格', '本アプリをご利用いただくには、本規約に同意していただく必要があります。'),
            _buildSection('3. プライバシー',
                '当社のプライバシーポリシーは、本規約の一部を構成します。個人情報の取り扱いについては、プライバシーポリシーをご確認ください。'),
            _buildSection(
                '4. 禁止事項',
                '本アプリの利用にあたり、以下の行為を禁止します：\n'
                    '・法令違反行為\n'
                    '・他のユーザーへの迷惑行為\n'
                    '・当社のサービスに支障を与える行為'),
            _buildSection('5. 免責事項', '当社は、本アプリの利用により生じた損害について、一切の責任を負いません。'),
            _buildSection(
                '6. 規約の変更', '当社は、必要と判断した場合には、ユーザーに通知することなく本規約を変更することがあります。'),
            _buildSection(
                '7. お問い合わせ', '本規約に関するお問い合わせは、アプリ内のお問い合わせフォームよりご連絡ください。'),
            SizedBox(height: 20),
            Text(
              '最終更新日: 2024年9月6日',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
