import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gohan/components/sample_list/sample_list.dart'; // 正しいパスに変更

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      CardList(
                        onTap: () async {
                          // ここに非同期処理を記述します
                          print("Card tapped!");
                        },
                      ),
                      CardList(
                        onTap: () async {
                          // ここに非同期処理を記述します
                          print("Card tapped!");
                        },
                      ),
                      CardList(
                        onTap: () async {
                          // ここに非同期処理を記述します
                          print("Card tapped!");
                        },
                      ),
                      CardList(
                        onTap: () async {
                          // ここに非同期処理を記述します
                          print("Card tapped!");
                        },
                      ),
                      CardList(
                        onTap: () async {
                          // ここに非同期処理を記述します
                          print("Card tapped!");
                        },
                      ),
                      CardList(
                        onTap: () async {
                          // ここに非同期処理を記述します
                          print("Card tapped!");
                        },
                      ),],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
