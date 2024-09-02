import 'package:flutter/material.dart';

class CheckBoxListTileWidget extends StatefulWidget {
  final String title;
  final bool initialValue;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final Color checkColor;
  final ListTileControlAffinity controlAffinity;

  const CheckBoxListTileWidget({
    super.key,
    required this.title,
    this.initialValue = false,
    required this.onChanged,
    this.activeColor = Colors.green,
    this.checkColor = Colors.white,
    this.controlAffinity = ListTileControlAffinity.trailing,
  });

  @override
  _CheckBoxListTileWidgetState createState() => _CheckBoxListTileWidgetState();
}

class _CheckBoxListTileWidgetState extends State<CheckBoxListTileWidget> {
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
