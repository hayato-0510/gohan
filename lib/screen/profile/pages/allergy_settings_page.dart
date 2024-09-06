import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllergySettingsPage extends StatefulWidget {
  @override
  _AllergySettingsPageState createState() => _AllergySettingsPageState();
}

class _AllergySettingsPageState extends State<AllergySettingsPage> {
  List<String> _allergies = [];
  final TextEditingController _allergyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllergies();
  }

  Future<void> _loadAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _allergies = prefs.getStringList('allergies') ?? [];
    });
  }

  Future<void> _saveAllergies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('allergies', _allergies);
  }

  void _addAllergy(String allergy) {
    if (allergy.isNotEmpty && !_allergies.contains(allergy)) {
      setState(() {
        _allergies.add(allergy);
      });
      _saveAllergies();
    }
  }

  void _removeAllergy(String allergy) {
    setState(() {
      _allergies.remove(allergy);
    });
    _saveAllergies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アレルギー設定'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _allergyController,
                    decoration: InputDecoration(
                      labelText: 'アレルギー項目を追加',
                      labelStyle: TextStyle(fontSize: 18), // ラベルのフォントサイズを大きく
                      border: OutlineInputBorder(),
                      hintText: '例: 卵、小麦、そば',
                      hintStyle: TextStyle(fontSize: 16), // ヒントのフォントサイズを大きく
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12), // 内部のパディングを調整
                    ),
                    style: TextStyle(fontSize: 18), // 入力テキストのフォントサイズを大きく
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (value) {
                      _addAllergy(value);
                      _allergyController.clear();
                    },
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _addAllergy(_allergyController.text);
                    _allergyController.clear();
                  },
                  child: Text('追加',
                      style: TextStyle(fontSize: 18)), // ボタンのテキストを大きく
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20), // ボタンのパディングを調整
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allergies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _allergies[index],
                    style: TextStyle(fontSize: 24), // リストアイテムのフォントサイズを大きく
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, size: 28), // アイコンサイズを大きく
                    onPressed: () => _removeAllergy(_allergies[index]),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), // リストアイテムのパディングを調整
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _allergyController.dispose();
    super.dispose();
  }
}
