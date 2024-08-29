import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/components/home_restaurant_list/home_restaurant_list.dart';
import 'package:gohan/view_model/restrant_details_viewmodel/restaurant_details_viewmodel.dart';

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
                                try {
                                  final restaurantDetails = await engagementViewModel.getRestaurantById(historyItem["id"]);
                                  if (restaurantDetails != null) {
                                    final restaurantDetailsViewModel = Provider.of<RestaurantDetailsViewModel>(context, listen: false);
                                    print('Showing details for ${restaurantDetails["title"]}');
                                    print('Details: $restaurantDetails');
                                    restaurantDetailsViewModel.showRestaurantDetails(
                                      context,
                                      restaurantDetails['title'] ?? 'Unknown',
                                      restaurantDetails['rating'] ?? 0.0,
                                      restaurantDetails['location'] ?? 'Unknown',
                                      restaurantDetails['phone'] ?? 'Unknown',
                                      restaurantDetails['hours'] ?? 'Unknown',
                                      restaurantDetails['is_open']==1,
                                    );
                                  } else {
                                    print('Restaurant details not found for ID: ${historyItem["id"]}');
                                  }
                                } catch (e) {
                                  print('Error fetching restaurant details: $e');
                                }
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
