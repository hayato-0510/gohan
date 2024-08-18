import 'package:flutter/material.dart';
import 'package:gohan/components/data_storage/shop_card_storage.dart';
import 'package:gohan/components/shop_card/shop_card.dart';
import 'package:gohan/components/check_box/check_box.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic>? _shopCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _setCheckBar(),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: _shopCard != null
                    ? ShopCard(
                        id: 1, // IDを指定
                        title: _shopCard!['title'],
                        rating: _shopCard!['rating'],
                      )
                    : const Text('No ShopCard loaded'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // IDを保存する
                await ShopCardStorage.saveShopCard('1', 'Shop', 4.5);
                print('ShopCard saved');
              },
              child: Text('Save ShopCard'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 保存したIDを読み込む
                Map<String, dynamic> shopCard =
                    await ShopCardStorage.loadShopCard('1');
                setState(() {
                  _shopCard = shopCard;
                });
                print('Loaded ShopCard: $shopCard');
              },
              child: Text('Load ShopCard'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 保存したIDを削除する
                await ShopCardStorage.deleteShopCard('1');
                setState(() {
                  _shopCard = null;
                });
                print('ShopCard deleted');
              },
              child: Text('Delete ShopCard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setCheckBar() {
    CheckBox box1 = CheckBox(
      title: '営業中',
      initialValue: false,
      onChanged: (bool? value) {
        print('チェックボックスの状態: $value');
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
    CheckBox box2 = CheckBox(
      title: '営業中2',
      initialValue: false,
      onChanged: (bool? value) {
        print('チェックボックスの状態2: $value');
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
    return Column(
      children: [
        Row(
          children: [
            box1,
            box2,
          ],
        ),
        Container(
          height: 0.5,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}
