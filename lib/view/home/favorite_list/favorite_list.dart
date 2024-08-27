import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/components/home_restaurant_list/home_restaurant_list.dart';

class FavoriteListView extends StatefulWidget {
  const FavoriteListView({super.key});

  @override
  _FavoriteListViewState createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<FavoriteListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadBrowsingHistory());
  }

  Future<void> _loadBrowsingHistory() async {
    final userEngagementViewModel =
        Provider.of<UserEngagementViewModel>(context, listen: false);

    // 保存履歴（is_likedがtrueのカード）をロード
    await userEngagementViewModel.loadLikedShopCards();
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
                  Consumer<UserEngagementViewModel>(
                    builder: (context, engagementViewModel, child) {
                      if (engagementViewModel.likedShopCards.isNotEmpty) {
                        return Column(
                          children: engagementViewModel.likedShopCards
                              .map((historyItem) {
                            return HomeRestaurantList(
                              onTap: () async {
                                print('Tapped ${historyItem["id"]}');
                              },
                              mainText: historyItem['title'],
                              subText: historyItem['rating'].toString(),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No liked restaurants found');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
