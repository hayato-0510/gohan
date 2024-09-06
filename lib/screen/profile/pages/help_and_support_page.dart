import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatefulWidget {
  @override
  _HelpAndSupportPageState createState() => _HelpAndSupportPageState();
}

class _HelpAndSupportPageState extends State<HelpAndSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ヘルプ・お問い合わせ'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'よくある質問',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildFAQItem(
                'Q: アプリの使い方がわかりません', 'A: アプリの基本的な使い方は、ホーム画面の「使い方ガイド」をご覧ください。'),
            _buildFAQItem('Q: アカウントの削除方法を教えてください',
                'A: アカウントの削除は、設定画面から行うことができます。詳細は「アカウント設定」をご確認ください。'),
            _buildFAQItem('Q: パスワードを忘れました',
                'A: ログイン画面の「パスワードを忘れた場合」リンクから、パスワードのリセットを行うことができます。'),
            SizedBox(height: 32),
            Text(
              'お問い合わせ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'お名前'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'お名前を入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'メールアドレス'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'メールアドレスを入力してください';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return '有効なメールアドレスを入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'お問い合わせ内容'),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'お問い合わせ内容を入力してください';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('送信'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // ここでフォームの送信処理を実装
      // 例: メール送信やAPIへのデータ送信など
      String emailBody = 'Name: ${_nameController.text}\n'
          'Email: ${_emailController.text}\n'
          'Message: ${_messageController.text}';

      // ここに送信処理を追加します
      print('送信内容: $emailBody'); // デバッグ用。実際の送信処理に置き換えてください。

      // 送信後の処理（スナックバー表示やフォームクリア）はここでは行いません
    }
  }
}
