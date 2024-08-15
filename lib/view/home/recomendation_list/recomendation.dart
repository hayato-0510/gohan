import 'package:flutter/material.dart' show BuildContext, Center, Colors, Scaffold, StatelessWidget, Text, TextStyle, Widget;

class RecomendationListView extends StatelessWidget {
  const RecomendationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Text(
          "test",
          style: TextStyle(
            fontSize: 20
          ),
        ),
      ),
    );
  }
}
