import 'package:flutter/material.dart';
import 'package:gohan/components/sample_list/sample_list.dart';

class SavedListView extends StatelessWidget {
  const SavedListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: List.generate(10, (index) {
                  return CardList(
                    onTap: () async {
                      print("Card tapped! Index: $index");
                    },
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
