import 'package:flutter/material.dart';
import 'package:gohan/view/screen/home/list/recomended_list/recomended_list.dart';
import 'package:gohan/view/screen/home/list/favorite_list/favorite_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _tab = <Tab>[
    const Tab(text: 'おすすめ'),
    const Tab(text: '保存リスト'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: TabBar(
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return states.contains(WidgetState.focused)
                      ? null
                      : Colors.transparent;
                },
              ),
              tabs: _tab,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.5, color: Colors.green),
                insets: EdgeInsets.symmetric(horizontal: -30),
              ),
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            RecomendationListView(),
            FavoriteListView(),
          ],
        ),
      ),
    );
  }
}
