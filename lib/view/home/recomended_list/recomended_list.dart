import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/components/home_restaurant_list/home_restaurant_list.dart';

class RecomendationListView extends StatefulWidget {
  const RecomendationListView({super.key});

  @override
  _RecomendationListViewState createState() => _RecomendationListViewState();
}

class _RecomendationListViewState extends State<RecomendationListView> {
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
                      if (engagementViewModel.browsingHistory.isNotEmpty) {
                        return Column(
                          children: engagementViewModel.browsingHistory
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
                        return const Text('No browsing history found');
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
