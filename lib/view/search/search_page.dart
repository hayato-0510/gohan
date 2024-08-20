import 'package:flutter/material.dart';
import 'package:gohan/view_models/shop_card_viewmodel.dart';
import 'package:gohan/components/check_box/check_box.dart';
import 'package:provider/provider.dart';


class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShopCardViewModel(),
      child: Scaffold(
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
          child: Consumer<ShopCardViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: viewModel.shopCard != null
                          ? Text('ShopCard: ${viewModel.shopCard!['title']} - Rating: ${viewModel.shopCard!['rating']} - Liked: ${viewModel.shopCard!['is_like']}')
                          : const Text('No ShopCard loaded'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await viewModel.saveShopCard('1', 'Shop', 4.5, true);
                    },
                    child: const Text('Save ShopCard (is_like: true)'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await viewModel.saveShopCard('1', 'Shop', 4.5, false);
                    },
                    child: const Text('Save ShopCard (is_like: false)'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await viewModel.loadShopCard('1');
                      await viewModel.loadShopCard('2');
                    },
                    child: const Text('Load ShopCard'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await viewModel.deleteShopCard('1');
                    },
                    child: const Text('Delete ShopCard'),
                  ),
                ],
              );
            },
          ),
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
