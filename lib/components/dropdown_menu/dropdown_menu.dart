import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final String? value;
  final List<String> items;
  final Widget hint;
  final ValueChanged<String?> onChanged;

  const CustomDropdownMenu({
    Key? key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 0.25),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      hint: hint,
      onChanged: onChanged,
    );
  }
}
