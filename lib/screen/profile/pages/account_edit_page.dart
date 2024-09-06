import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gohan/view_model/user_viewmodel/user_auth_viewmodel.dart';

class AccountEditPage extends StatefulWidget {
  @override
  _AccountEditPageState createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userAuthViewModel = context.read<AuthViewModel>();
    _nameController.text = userAuthViewModel.currentUser?.displayName ?? '';

    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final userAuthViewModel = context.read<AuthViewModel>();
    String? imagePath;

    if (_image != null) {
      final directory = await getApplicationDocumentsDirectory();
      imagePath = '${directory.path}/profile_image.jpg';
      await _image!.copy(imagePath);
    }

    await userAuthViewModel.updateProfile(_nameController.text, imagePath);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント編集'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height - 100, // AppBarの高さを考慮
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40), // 上部に余白を追加
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? Icon(Icons.person, size: 60) : null,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('プロフィール画像を変更'),
                ),
                SizedBox(height: 32),
                Container(
                  width: 300,
                  child: TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: '名前',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100, // ボタンの幅を指定
                  height: 80, // ボタンの高さを指定
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: Text(
                      '保存',
                      style: TextStyle(fontSize: 24), // フォントサイズを大きく
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12), // パディングを追加
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 角を丸くする
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
