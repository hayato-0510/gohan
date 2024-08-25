import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/shop_card_viewmodel/shop_card_viewmodel.dart';
import 'package:gohan/components/shop_card/shop_card.dart';
import 'package:gohan/components/sample_list/sample_list.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';

class SavedListView extends StatefulWidget {
  const SavedListView({super.key});

  @override
  _SavedListViewState createState() => _SavedListViewState();
}

class _SavedListViewState extends State<SavedListView> {
  late ShopCardViewModel shopCardViewModel;
  late RestaurantCardViewModel restaurantViewModel;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadShopCard());
  }

  Future<void> _loadShopCard() async {
    await shopCardViewModel.loadShopCard('1');
    if (shopCardViewModel.shopCard != null) {
      await restaurantViewModel.fetchRestaurantDetails(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: shopCardViewModel),
            ChangeNotifierProvider.value(value: restaurantViewModel),
          ],
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical:10),
                child: Column(
                  children: [
                    Consumer<ShopCardViewModel>(
                      builder: (context, shopViewModel, child) {
                        if (shopViewModel.shopCard != null) {
                          return ShopCard();
                        } else {
                          return const Text('No ShopCard loaded');
                        }
                      },
                    ),
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
      ),
    );
  }
}
