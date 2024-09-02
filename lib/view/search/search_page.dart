import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/check_box_list_tile/check_box_list_tile.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_search_settings_viewmodel/user_search_settings_viewmodel.dart';
import 'package:gohan/components/toggle_button/toggle_button.dart';
import 'package:gohan/components/map_card/map_card.dart'; // 追加

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _foodController;
  bool _showUserCheckBar = false; // User Check Bar の表示/非表示を管理するフラグ
  bool _isExpanded = false; // 矢印の向き管理
  bool _isPhotoSelected = true;

  @override
  void initState() {
    super.initState();
    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context, listen: false);
    _foodController = TextEditingController(text: userSearchSettings.name);

    _foodController.addListener(() {
      userSearchSettings.updateRestaurantName(_foodController.text);
    });
  }

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  // チェックバーの表示/非表示と矢印の向きを切り替えるメソッド
  void _toggleUserCheckBar() {
    setState(() {
      _showUserCheckBar = !_showUserCheckBar;
      _isExpanded = !_isExpanded;
    });
  }

  Widget _buildFilterAndBarrier(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPosition = screenHeight * 0; // 画面高さの0%

    return _showUserCheckBar
        ? GestureDetector(
            onTap: _toggleUserCheckBar, // タップ時にフィルターバーを非表示にする
            child: Stack(
              children: [
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5), // 半透明の黒
                  dismissible: true, // バリアを解除できるようにする
                  onDismiss: _toggleUserCheckBar, // バリアが解除されたときに呼び出すメソッド
                ),
                Positioned(
                  top: topPosition, // 上からの位置
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300), // アニメーションの時間
                    curve: Curves.easeInOut, // アニメーションのカーブ
                    padding: const EdgeInsets.all(10.0), // パディング
                    color: Colors.white, // 背景色を白に設定
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap:
                              _toggleUserCheckBar, // タップ時に_toggleUserCheckBarメソッドを呼び出す
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween, // 両端に配置
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap:
                                          _toggleUserCheckBar, // タップ時に_toggleUserCheckBarメソッドを呼び出す
                                      child: Text(_showUserCheckBar
                                          ? '閉じる'
                                          : '絞り込み条件を変更'), // テキストを表示
                                    ),
                                  ),
                                  Icon(
                                    _isExpanded
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down, // アイコンの種類を切り替え
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey, // 区切り線の色
                                thickness: 1.0, // 線の太さ
                              ),
                            ],
                          ),
                        ),
                        _setUserCheckBar(context), // フィルターバーの設定
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink(); // フィルターバーが表示されていないときは空のウィジェットを返す
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 背景色を白に設定
      body: SafeArea(
        child: Stack(
          children: [
// <<<<<<< RestaurantDetails-miki
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 10.0,
//                     right: 10.0,
//                     top: 10.0,
//                     bottom: 1.0,
//                   ),
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap:
//                             _toggleUserCheckBar, // タップ時に_toggleUserCheckBarメソッドを呼び出す
//                         child: Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween, // 両端に配置
//                           children: [
//                             Expanded(
//                               child: Text(_showUserCheckBar
//                                   ? '閉じる'
//                                   : '絞り込み条件を変更'), // テキストを表示
//                             ),
//                             Icon(
//                               _isExpanded
//                                   ? Icons.arrow_drop_up
//                                   : Icons.arrow_drop_down, // アイコンの種類を切り替え
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Divider(
//                         color: Colors.grey, // 区切り線の色
//                         thickness: 1.0, // 線の太さ
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 15, vertical: 20),
//                     child: Consumer<RestaurantCardViewModel>(
//                       builder: (context, viewModel, child) {
//                         if (viewModel.restaurants.isEmpty) {
//                           return ElevatedButton(
//                             onPressed: () {
//                               viewModel
//                                   .fetchRestaurantDetails(); // ボタン押下時にレストラン情報を取得
//                             },
//                             child:
//                                 const Text('Load More Restaurants'), // ボタンのテキスト
//                           );
//                         }

//                         return AppinioSwiper(
//                           cardCount: viewModel.restaurants.length, // カードの数
//                           cardBuilder: (BuildContext context, int index) {
//                             return RestaurantCard(
//                               restaurant:
//                                   viewModel.restaurants[index], // レストランカードを表示
//                             );
//                           },
//                           maxAngle: 15, // スワイプの最大角度
//                           onSwipeEnd: (int previousIndex, int targetIndex,
//                               SwiperActivity activity) async {
//                             if (activity is Swipe) {
//                               final isFavorite = activity.direction ==
//                                   AxisDirection.right; // 右スワイプでお気に入り
//                               Provider.of<UserEngagementViewModel>(context,
//                                       listen: false)
//                                   .saveToEngagementDB(
//                                 id: viewModel.restaurants[previousIndex].id
//                                     .toString(),
//                                 name: viewModel.restaurants[previousIndex].name,
//                                 rating:
//                                     viewModel.restaurants[previousIndex].rating,
//                                 location: viewModel
//                                     .restaurants[previousIndex].location,
//                                 phone:
//                                     viewModel.restaurants[previousIndex].phone,
//                                 hours:
//                                     viewModel.restaurants[previousIndex].hours,
//                                 isFavorite: isFavorite,
//                               );
//                               WidgetsBinding.instance.addPostFrameCallback((_) {
//                                 if (previousIndex <
//                                     viewModel.restaurants.length) {
//                                   viewModel.removeRestaurant(
//                                       previousIndex); // レストランをリストから削除
//                                 }
//                               });
//                             }
//                           },
//                           onEnd: () {
//                             print('No more cards'); // カードがなくなった時の処理
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
// =======
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Center(
//                 child: ToggleButton(
//                   toggleText: const ['写真', '地図'],
//                   isSelected: _isPhotoSelected,
//                   onToggle: (isSelected) { // 表で状態を管理するためのコールバック
//                     setState(() {
//                       _isPhotoSelected = isSelected;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 10.0,
//                 right: 10.0,
//                 top: 10.0,
//                 bottom: 1.0,
//               ),
//               child: _setUserCheckBar(context),
//             ),
//             const Divider(),
//             Expanded(
//               child: _isPhotoSelected
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//                       child: Consumer<RestaurantCardViewModel>(
//                         builder: (context, viewModel, child) {
//                           if (viewModel.restaurants.isEmpty) {
//                             return ElevatedButton(
//                               onPressed: () {
//                                 viewModel.fetchRestaurantDetails();
//                               },
//                               child: const Text('Load More Restaurants'),
//                             );
//                           }

//                           return AppinioSwiper(
//                             cardCount: viewModel.restaurants.length,
//                             cardBuilder: (BuildContext context, int index) {
//                               return RestaurantCard(
//                                   restaurant: viewModel.restaurants[index]);
//                             },
//                             maxAngle: 15,
//                             onSwipeEnd: (int previousIndex, int targetIndex,
//                                 SwiperActivity activity) async {
//                               if (activity is Swipe) {
//                                 final isFavorite =
//                                     activity.direction == AxisDirection.right;
//                                 Provider.of<UserEngagementViewModel>(context, listen: false)
//                                     .saveToEngagementDB(
//                                     id: viewModel.restaurants[previousIndex].id.toString(),
//                                     name: viewModel.restaurants[previousIndex].name,
//                                     rating: viewModel.restaurants[previousIndex].rating,
//                                     location: viewModel.restaurants[previousIndex].location,
//                                     phone: viewModel.restaurants[previousIndex].phone,
//                                     hours: viewModel.restaurants[previousIndex].hours,
//                                     isFavorite: isFavorite,
//                                 );
//                                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                                   if (previousIndex < viewModel.restaurants.length) {
//                                     viewModel.removeRestaurant(previousIndex);
//                                   }
//                                 });
//                               }
//                             },
//                             onEnd: () {
//                               print('No more cards');
//                             },
//                           );
//                         },
//                       ),
//                     )
//                   : MapCard(), // マップ表示
// >>>>>>> dev-kai-merge
            ),
            _buildFilterAndBarrier(context), // フィルターバーとモーダルバリアを表示
          ],
        ),
      ),
    );
  }

  Widget _setUserCheckBar(BuildContext context) {
    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context);

    return Column(
      children: [
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomDropdownMenu(
                value: userSearchSettings.name,
                hint: const Text('料理名を入力'),
                onChanged: (value) {
                  userSearchSettings.updateRestaurantName(value ?? '');
                },
                isSearchable: true,
                controller: _foodController,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CustomDropdownMenu(
                value: userSearchSettings.selectedDistance,
                items: const ['1km', '3km', '5km', '10km'],
                hint: const Text('距離を選択'),
                onChanged: (value) {
                  userSearchSettings.updateSelectedDistance(value ?? '5km');
                },
                isSearchable: false,
              ),
            ),
          ),
        ]),
        Row(
          children: [
            Expanded(
              child: CheckBoxListTileWidget(
                title: '営業中',
                initialValue: userSearchSettings.isOpen,
                onChanged: (bool? value) {
                  userSearchSettings.toggleIsOpen();
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}