// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gohan/components/sample_list/sample_list.dart';
import 'package:gohan/components/shop_card/shop_card.dart';
import 'package:gohan/view_models/data_storage.dart';

class SavedListView extends StatefulWidget {
  const SavedListView({super.key});

  @override
  _SavedListViewState createState() => _SavedListViewState();
}

class _SavedListViewState extends State<SavedListView> {
  Map<String, dynamic>? _shopCard;
  
  Map<String, dynamic>? shopCard;

  @override
  void initState() {
    super.initState();
    _loadShopCard();
  }

  Future<void> _loadShopCard() async {
    // 保存されたIDを取得してShopCardを読み込む
  ShopCardViewModel viewModel = ShopCardViewModel(); // インスタンスを作成
  await viewModel.loadShopCard('1'); // インスタンスメソッドを呼び出す

    setState(() {
      _shopCard = _shopCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  if (_shopCard != null)
                    ShopCard(
                      id: 1, // IDを指定
                      title: _shopCard!['title'],
                      rating: _shopCard!['rating'],
                    )
                  else
                    const Text('No ShopCard loaded'),
                  ...List.generate(10, (index) {
                    return CardList(
                      onTap: () async {
                        print("Card tapped! Index: $index");
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
