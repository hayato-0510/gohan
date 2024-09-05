import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/user_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/components/home_restaurant_list/home_restaurant_list.dart';
import 'package:gohan/screen/home/list/restaurat_detail_bottom_sheet.dart';

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
                              .map((fovliteItem) {
                            return HomeRestaurantList(
                              onTap: () async {
                                try {
                                  final restaurantDetails = await engagementViewModel.getRestaurantById(fovliteItem);
                                  debugPrint('Fetched restaurant details: $restaurantDetails');

                                  if (restaurantDetails != null && mounted) {
                                    // モーダルボトムシートを表示
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return RestaurantDetailsBottomSheet(
                                          businessHours: restaurantDetails['business_hours'] ?? {},
                                          name: restaurantDetails['name'] ?? 'Unknown',
                                          rating: restaurantDetails['rating'] ?? 0.0,
                                          location: restaurantDetails['location'] ?? 'Unknown',
                                          phone: restaurantDetails['phone'] ?? 'Unknown',
                                          hours: restaurantDetails['hours'] ?? 'Unknown',
                                          isOpen: restaurantDetails['is_open'] == 1,
                                        );
                                      },
                                    );
                                  } else {
                                    debugPrint('Restaurant details not found for ID: ${fovliteItem["id"]}');
                                  }
                                } catch (e) {
                                  debugPrint('Error fetching restaurant details: $e');
                                }
                              },
                              mainText: fovliteItem['name'],
                              subText: fovliteItem['rating'].toString(),
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
