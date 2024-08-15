import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String hintText;

  const SearchInput({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Color.fromARGB(255, 151, 147, 147),
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            hintText,
            style: const TextStyle(color: Color.fromARGB(255, 151, 147, 147)),
          ),
        ],
      ),
    );
  }
}
