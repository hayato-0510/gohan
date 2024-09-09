import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/user_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/components/home_restaurant_list/home_restaurant_list.dart';

class RecomendationTab extends StatefulWidget {
  const RecomendationTab({super.key});

  @override
  _RecomendationTabState createState() => _RecomendationTabState();
}

class _RecomendationTabState extends State<RecomendationTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadBrowsingHistory());
  }

  Future<void> _loadBrowsingHistory() async {
    final userEngagementViewModel =
        Provider.of<UserEngagementViewModel>(context, listen: false);

    // 閲覧履歴（is_likedがfalseのカード）をロード
    await userEngagementViewModel.loadBrowsingHistory();
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
                if (engagementViewModel.browsingHistory.isNotEmpty) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        engagementViewModel.browsingHistory.map((historyItem) {
                      return SizedBox(
                        width: 250, // 必要に応じて幅を指定
                        child: HomeRestaurantList(
                          onTap: () async {
                            try {
                              final restaurantDetails =
                                  await engagementViewModel
                                      .getRestaurantById(historyItem);
                              debugPrint(
                                  'Fetched restaurant details: $restaurantDetails');

                              if (restaurantDetails != null) {
                                // モーダルボトムシートを表示
                              } else {
                                debugPrint(
                                    'Restaurant details not found for ID: ${historyItem["id"]}');
                              }
                            } catch (e) {
                              debugPrint(
                                  'Error fetching restaurant details: $e');
                            }
                          },
                          mainText: historyItem['name'],
                          subText: historyItem['rating'].toString(),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(child: Text('No browsing history found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
