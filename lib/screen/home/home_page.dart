import 'package:flutter/material.dart';
import 'package:gohan/screen/home/list/recomended_list/recomended_list.dart';
import 'package:gohan/screen/home/list/favorite_list/favorite_list.dart';
import 'package:gohan/components/screen_transition_button/screen_transition_button.dart';
import 'package:gohan/screen/home/tab/favorite_tab.dart';
import 'package:gohan/screen/home/tab/recomended_tab.dart';
import 'package:gohan/components/category_button/category_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: const Text('ホームページ'),
          ),
      backgroundColor: Colors.white,
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryButton(text: 'ラーメン'),
                  CategoryButton(text: 'うどん'),
                  CategoryButton(text: 'そば'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 16.0),
              child: Row(
                children: [
                  ScreenTransitionButton(
                    destination: FavoriteListView(),
                    text: 'Favorite',
                    icon: Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
            FavoriteTab(),
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 16.0),
              child: Row(
                children: [
                  ScreenTransitionButton(
                    destination: RecomendationListView(),
                    text: 'History',
                    icon: Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
            RecomendationTab(),
          ],
        ),
      ),
    );
  }
}
