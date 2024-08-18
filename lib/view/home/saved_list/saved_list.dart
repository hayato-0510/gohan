import 'package:flutter/material.dart';
import 'package:gohan/components/data_storage/shop_card_storage.dart';
import 'package:gohan/components/sample_list/sample_list.dart';
import 'package:gohan/components/shop_card/shop_card.dart';

class SavedListView extends StatefulWidget {
  const SavedListView({super.key});

  @override
  _SavedListViewState createState() => _SavedListViewState();
}

class _SavedListViewState extends State<SavedListView> {
  Map<String, dynamic>? _shopCard;

  @override
  void initState() {
    super.initState();
    _loadShopCard();
  }

  Future<void> _loadShopCard() async {
    // 保存されたIDを取得してShopCardを読み込む
    Map<String, dynamic> shopCard = await ShopCardStorage.loadShopCard('1');
    setState(() {
      _shopCard = shopCard;
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
                    Text('No ShopCard loaded'),
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
