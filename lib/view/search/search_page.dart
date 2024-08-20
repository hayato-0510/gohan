import 'package:flutter/material.dart';
import 'package:gohan/components/shop_card/shop_card.dart';
import 'package:gohan/components/check_box/check_box.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedFood;
  String? selectedDistance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130), // 高さを調整
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownMenu(
                        value: selectedFood,
                        items: const ['ラーメン', '寿司', 'カレー', 'ピザ'],
                        hint: const Text('ラーメン'),
                        onChanged: (value) {
                          setState(() {
                            selectedFood = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdownMenu(
                        value: selectedDistance,
                        items: const ['1km以内', '3km以内', '5km以内', '10km以内'],
                        hint: const Text('3km以内'),
                        onChanged: (value) {
                          setState(() {
                            selectedDistance = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                _setCheckBar(),
              ],
            ),
          ),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: ShopCard(
              title: "Shop",
              rating: 4.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownMenu({
    required String? value,
    required List<String> items,
    required Widget hint,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: hint,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _setCheckBar() {
    CheckBox box1 = CheckBox(
      title: '営業中',
      initialValue: false,
      onChanged: (bool? value) {
        print('チェックボックスの状態: $value');
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
    CheckBox box2 = CheckBox(
      title: '営業中2',
      initialValue: false,
      onChanged: (bool? value) {
        print('チェックボックスの状態2: $value');
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: box1),
            Expanded(child: box2),
          ],
        ),
        Container(
          height: 0.5,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}
