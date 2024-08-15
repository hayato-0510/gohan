import 'package:flutter/material.dart';
import 'package:gohan/components/sample_list/sample_list.dart'; // 正しいパスに変更
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
// <<<<<<< graybox
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Scrollbar(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Column(
//                     children: [
//                       CardList(
//                         onTap: () async {
//                           // ここに非同期処理を記述します
//                           print("Card tapped!");
//                         },
//                       ),
//                       CardList(
//                         onTap: () async {
//                           // ここに非同期処理を記述します
//                           print("Card tapped!");
//                         },
//                       ),
//                       CardList(
//                         onTap: () async {
//                           // ここに非同期処理を記述します
//                           print("Card tapped!");
//                         },
//                       ),
//                       CardList(
//                         onTap: () async {
//                           // ここに非同期処理を記述します
//                           print("Card tapped!");
//                         },
//                       ),
//                       CardList(
//                         onTap: () async {
//                           // ここに非同期処理を記述します
//                           print("Card tapped!");
//                         },
//                       ),
//                       CardList(
//                         onTap: () async {
//                           // ここに非同期処理を記述します
//                           print("Card tapped!");
//                         },
//                       ),],
//                   ),
//                 ),
//               ],
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                return states.contains(WidgetState.focused) ? null : Colors.transparent;
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
        body: TabBarView(
          children: <Widget>[
            RecomendationListView(),
            SavedListView(),
          ],
        ),
      ),
    );
  }
}
