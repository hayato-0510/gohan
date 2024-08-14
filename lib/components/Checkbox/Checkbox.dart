import 'package:flutter/material.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final String title;
  final bool initialValue;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final Color checkColor;
  final ListTileControlAffinity controlAffinity;

  CustomCheckboxListTile({
    required this.title,
    this.initialValue = false,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
    this.controlAffinity = ListTileControlAffinity.trailing,
  });

  @override
  _CustomCheckboxListTileState createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: _isChecked,
      onChanged: (bool? value) {
        setState(() {
          _isChecked = value!;
        });
        widget.onChanged(value);
      },
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      controlAffinity: widget.controlAffinity,
    );
  }
}

/* 使う時
import 'package:gohan/components/Checkbox/Checkbox.dart';

CustomCheckboxListTile box1 = CustomCheckboxListTile(
  title: '営業中',
  initialValue: false,
  onChanged: (bool? value) {
    print('チェックボックスの状態: $value');
  },
  activeColor: const Color.fromARGB(255, 54, 238, 244),
  checkColor: const Color.fromARGB(255, 0, 0, 0),
  controlAffinity: ListTileControlAffinity.leading,
);
*/

