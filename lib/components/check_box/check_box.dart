import 'package:flutter/material.dart';
/* 使う時
import 'package:gohan/components/Checkbox/Checkbox.dart';

CheckBox box1 = CheckBox(
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

class CheckBox extends StatefulWidget {
  final String title;
  final bool initialValue;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final Color checkColor;
  final ListTileControlAffinity controlAffinity;

  const CheckBox({
    super.key, 
    required this.title,
    this.initialValue = false,
    required this.onChanged,
    this.activeColor = Colors.green,
    this.checkColor = Colors.white,
    this.controlAffinity = ListTileControlAffinity.trailing,
  });

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         _buildCheckBox(),
        Text(widget.title),
      ],
    );
  }

  Widget _buildCheckBox() {
    return Checkbox(
      value: _isChecked,
      onChanged: (bool? value) {
        setState(() {
          _isChecked = value!;
        });
        widget.onChanged(value);
      },
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
    );
  }
}

