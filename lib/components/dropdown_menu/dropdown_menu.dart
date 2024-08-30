import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final String? value;
  final List<String>? items;
  final Widget hint;
  final ValueChanged<String?> onChanged;
  final bool isSearchable;
  final TextEditingController? controller;

  const CustomDropdownMenu({
    Key? key,
    required this.value,
    this.items,
    required this.hint,
    required this.onChanged,
    this.isSearchable = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSearchable) {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 0.25),
          hintText: (hint as Text).data,
        ),
        onChanged: (value) {
          onChanged(value);
        },
      );
    } else {
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
            ?.map(
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
}
