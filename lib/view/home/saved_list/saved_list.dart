import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/shop_card_viewmodel/shop_card_viewmodel.dart';
import 'package:gohan/components/shop_card/shop_card.dart';
import 'package:gohan/components/sample_list/sample_list.dart';

class SavedListView extends StatefulWidget {
  const SavedListView({super.key});

  @override
  _SavedListViewState createState() => _SavedListViewState();
}

class _SavedListViewState extends State<SavedListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadShopCard());
  }

  Future<void> _loadShopCard() async {
    ShopCardViewModel viewModel = Provider.of<ShopCardViewModel>(context, listen: false);
    await viewModel.loadShopCard('1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ShopCardViewModel>(
          builder: (context, viewModel, child) {
            return Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical:10),
                  child: Column(
                    children: [
                      if (viewModel.shopCard != null)
                        ShopCard(
                          id: 1,
                          title: viewModel.shopCard!['title'],
                          rating: viewModel.shopCard!['rating'].toDouble(),
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
            );
          },
        ),
      ),
    );
  }
}
