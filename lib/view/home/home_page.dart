import 'package:flutter/material.dart';
import 'package:gohan/view/home/recomendation_list/recomendation.dart';
import 'package:gohan/view/home/saved_list/saved_list.dart';

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
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return states.contains(MaterialState.focused)
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
            SavedListView(), // 修正済みのSavedListViewを表示
          ],
        ),
      ),
    );
  }
}
