import 'package:flutter/material.dart';

class ScreenTransitionButton extends StatelessWidget {
  final Widget destination;
  final String text;
  final IconData icon;

  const ScreenTransitionButton({
    super.key,
    required this.destination,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              child: destination,
            );
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
        ],
      ),
    );
  }
}
