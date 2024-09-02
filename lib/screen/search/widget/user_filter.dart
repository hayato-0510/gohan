import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// コンポーネントのインポート
import 'package:gohan/components/check_box_list_tile/check_box_list_tile.dart';
import 'package:gohan/components/dropdown_menu/dropdown_menu.dart';

// viewmodelのインポート
import 'package:gohan/view_model/user_viewmodel/user_search_settings_viewmodel.dart';

class UserFilter extends StatefulWidget {
  const UserFilter({Key? key}) : super(key: key);

  @override
  _UserFilterState createState() => _UserFilterState();
}

class _UserFilterState extends State<UserFilter> {
  late TextEditingController _foodController;

  @override
  void initState() {
    super.initState();
    _foodController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userSearchSettings = Provider.of<UserSearchSettingsViewModel>(context);
    _foodController.text = userSearchSettings.name;
    _foodController.addListener(() {
      userSearchSettings.updateRestaurantName(_foodController.text);
    });
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
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text("誰かボタン作ってここ")],
            )
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
