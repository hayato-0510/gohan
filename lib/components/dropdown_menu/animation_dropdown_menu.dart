import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class AnimatedDropdownMenu extends StatefulWidget {
  final String? value;
  final List<String> items;
  final Widget hint;
  final ValueChanged<String?> onChanged;

  // Optional parameters for customization
  final double dropdownHeight;
  final BoxDecoration dropdownDecoration;
  final TextStyle dropdownItemStyle;
  final double dropdownItemHeight;

  const AnimatedDropdownMenu({
    Key? key,
    this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.dropdownHeight = 200.0,
    this.dropdownDecoration = const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          spreadRadius: 2.0,
        ),
      ],
    ),
    this.dropdownItemStyle = const TextStyle(
      fontSize: 16.0,
      color: Colors.black87,
    ),
    this.dropdownItemHeight = 48.0,
  }) : super(key: key);

  @override
  _AnimatedDropdownMenuState createState() => _AnimatedDropdownMenuState();
}

class _AnimatedDropdownMenuState extends State<AnimatedDropdownMenu> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value ?? widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: CustomDropdown<String>(
        hintText: widget.hint.toString(),
        items: widget.items,
        initialItem: _selectedValue,
        onChanged: (value) {
          setState(() {
            _selectedValue = value ?? widget.items[0];
            widget.onChanged(value);
          });
        },
      ),
    );
  }
}
