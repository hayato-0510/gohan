import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// コンポーネントのインポート
import 'package:gohan/components/check_box_list_tile/check_box_list_tile.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';

// viewmodelのインポート
import 'package:gohan/view_model/user_viewmodel/user_search_settings_viewmodel.dart';

class UserFilter extends StatefulWidget {
  final VoidCallback onSearch;

  const UserFilter({super.key, required this.onSearch});
  
  @override
  _UserFilterState createState() => _UserFilterState();
}

class _UserFilterState extends State<UserFilter> {
  late TextEditingController _foodController;

  @override
   void initState() {
    super.initState();
    final userSearchSettings = Provider.of<UserSearchSettingsViewModel>(context, listen: false);
    _foodController = TextEditingController(text: userSearchSettings.name);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userSearchSettings = Provider.of<UserSearchSettingsViewModel>(context);
    // リスナーを一度だけ追加するために、既存のリスナーを削除
    _foodController.removeListener(_updateSearchName);
    _foodController.addListener(_updateSearchName);
  }

  void _updateSearchName() {
    final userSearchSettings = Provider.of<UserSearchSettingsViewModel>(context, listen: false);
    userSearchSettings.updateRestaurantName(_foodController.text);
  }

  @override
  Widget build(BuildContext context) {
    final userSearchSettings = Provider.of<UserSearchSettingsViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _foodController,
                    decoration: const InputDecoration(
                      hintText: '料理名を入力',
                      border: OutlineInputBorder(),
                    ),
                    // onChangedを使用して、入力ごとに更新
                    onChanged: (value) {
                      final userSearchSettings = Provider.of<UserSearchSettingsViewModel>(context, listen: false);
                      userSearchSettings.updateRestaurantName(value);
                    },
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
                ElevatedButton.icon(
                  onPressed: userSearchSettings.hasChanges ? widget.onSearch : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: userSearchSettings.hasChanges ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 角を丸くする
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // パディングを調整
                  ),
                  icon: const Icon(Icons.search, size: 24), // 検索アイコン
                  label: const Text("Search"), // "Search"テキスト
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }
}
