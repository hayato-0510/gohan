import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:gohan/components/restaurant_card/restaurant_card.dart';
import 'package:gohan/components/check_box/check_box.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';
import 'package:gohan/view_model/restaurant_card_viewmodel/restaurant_card_viewmodel.dart';
import 'package:gohan/view_model/user_engagement_viewmodel/user_engagement_viewmodel.dart';
import 'package:gohan/view_model/user_search_settings_viewmodel/user_search_settings_viewmodel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _foodController;
  bool _showUserCheckBar = true; // User Check Bar の表示/非表示を管理するフラグ
  bool _isExpanded = false; // 矢印の向きを管理

  @override
  void initState() {
    super.initState();
    final userSearchSettings =
        Provider.of<UserSearchSettingsViewModel>(context, listen: false);
    _foodController = TextEditingController(text: userSearchSettings.name);

    // Listenerを追加して、TextEditingControllerが変更されたらViewModelも更新するようにします
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

  @override
  Widget build(BuildContext context) {
    // buildメソッドをオーバーライドしてウィジェットを構築
    final screenHeight = MediaQuery.of(context).size.height; // 画面の高さを取得
    final topPosition = screenHeight * 0; // 画面高さの20%

    return Scaffold(
      // Scaffoldウィジェットを返す
      backgroundColor: Colors.white, // 背景色を白に設定
      body: SafeArea(
        // SafeAreaウィジェットで画面の安全領域を確保
        child: Stack(
          // Stackウィジェットで重ね合わせを実現
          children: [
            Column(
              // 縦にウィジェットを並べる
              children: [
                Padding(
                  // パディングを追加
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 10.0,
                    bottom: 1.0,
                  ),
                  child: Column(
                    // コラムウィジェットで縦にウィジェットを並べる
                    children: [
                      GestureDetector(
                        // タップを検出するウィジェット
                        onTap:
                            _toggleUserCheckBar, // タップ時に_toggleUserCheckBarメソッドを呼び出す
                        child: Row(
                          // 横にウィジェットを並べる
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, // 両端に配置
                          children: [
                            Text(_showUserCheckBar
                                ? 'Hide Filters'
                                : 'Show Filters'), // テキストを表示
                            Icon(
                              // アイコンを表示
                              _isExpanded
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_right, // アイコンの種類を切り替え
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        // 区切り線を表示
                        color: Colors.grey, // 線の色
                        thickness: 1.0, // 線の太さ
                        indent: 0.0, // 左側のインデント
                        endIndent: 0.0, // 右側のインデント
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // 残りのスペースを埋める
                  child: Padding(
                    // パディングを追加
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Consumer<RestaurantCardViewModel>(
                      // ConsumerウィジェットでViewModelを取得
                      builder: (context, viewModel, child) {
                        if (viewModel.restaurants.isEmpty) {
                          // レストランが空の場合
                          return ElevatedButton(
                            // ボタンを表示
                            onPressed: () {
                              viewModel
                                  .fetchRestaurantDetails(); // ボタン押下時にレストラン情報を取得
                            },
                            child:
                                const Text('Load More Restaurants'), // ボタンのテキスト
                          );
                        }

                        return AppinioSwiper(
                          // スワイプウィジェットを表示
                          cardCount: viewModel.restaurants.length, // カードの数
                          cardBuilder: (BuildContext context, int index) {
                            return RestaurantCard(
                                restaurant: viewModel
                                    .restaurants[index]); // レストランカードを表示
                          },
                          maxAngle: 15, // スワイプの最大角度
                          onSwipeEnd: (int previousIndex, int targetIndex,
                              SwiperActivity activity) async {
                            // スワイプ終了時の処理
                            if (activity is Swipe) {
                              // スワイプアクティビティの場合
                              final isFavorite = activity.direction ==
                                  AxisDirection.right; // 右スワイプでお気に入り
                              Provider.of<UserEngagementViewModel>(context,
                                      listen: false)
                                  .saveToEngagementDB(
                                // データベースに保存
                                id: viewModel.restaurants[previousIndex].id
                                    .toString(),
                                name: viewModel.restaurants[previousIndex].name,
                                rating:
                                    viewModel.restaurants[previousIndex].rating,
                                location: viewModel
                                    .restaurants[previousIndex].location,
                                phone:
                                    viewModel.restaurants[previousIndex].phone,
                                hours:
                                    viewModel.restaurants[previousIndex].hours,
                                isFavorite: isFavorite,
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                // フレームコールバックを追加
                                if (previousIndex <
                                    viewModel.restaurants.length) {
                                  viewModel.removeRestaurant(
                                      previousIndex); // レストランをリストから削除
                                }
                              });
                            }
                          },
                          onEnd: () {
                            // カードがなくなった時の処理
                            print('No more cards');
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (_showUserCheckBar)
              GestureDetector(
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
                        // アニメーション付きコンテナ
                        duration:
                            const Duration(milliseconds: 300), // アニメーションの時間
                        curve: Curves.easeInOut, // アニメーションのカーブ
                        padding: const EdgeInsets.all(10.0), // パディング
                        color: Colors.white, // 背景色を白に設定
                        child: Column(
                          // コラムウィジェットで縦にウィジェットを並べる
                          children: [
                            GestureDetector(
                              onTap:
                                  _toggleUserCheckBar, // タップ時に_toggleUserCheckBarメソッドを呼び出す
                              child: Row(
                                // 横にウィジェットを並べる
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween, // 両端に配置
                                children: [
                                  Text(_showUserCheckBar
                                      ? 'Hide Filters'
                                      : 'Show Filters'), // テキストを表示
                                  Icon(
                                    // アイコンを表示
                                    _isExpanded
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_right, // アイコンの種類を切り替え
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              // 区切り線を表示
                              color: Colors.grey, // 線の色
                              thickness: 1.0, // 線の太さ
                              indent: 0.0, // 左側のインデント
                              endIndent: 0.0, // 右側のインデント
                            ),
                            _setUserCheckBar(context), // フィルターバーの設定
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
              child: CheckBox(
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
