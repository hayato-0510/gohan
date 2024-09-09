import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/user_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/components/home_restaurant_list/home_restaurant_list.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  _FavoriteTabState createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: Consumer<UserEngagementViewModel>(
              builder: (context, engagementViewModel, child) {
                if (engagementViewModel.likedShopCards.isNotEmpty) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        engagementViewModel.likedShopCards.map((fovliteItem) {
                      return SizedBox(
                        width: 250, // 必要に応じて幅を指定
                        child: HomeRestaurantList(
                          onTap: () async {
                            try {
                              final restaurantDetails =
                                  await engagementViewModel
                                      .getRestaurantById(fovliteItem);
                              debugPrint(
                                  'Fetched restaurant details: $restaurantDetails');

                              if (restaurantDetails != null && mounted) {
                                // モーダルボトムシートを表示
                              } else {
                                debugPrint(
                                    'Restaurant details not found for ID: ${fovliteItem["id"]}');
                              }
                            } catch (e) {
                              debugPrint(
                                  'Error fetching restaurant details: $e');
                            }
                          },
                          mainText: fovliteItem['name'],
                          subText: fovliteItem['rating'].toString(),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(
                      child: Text('No liked restaurants found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
