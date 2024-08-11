import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 151, 147, 147),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text('Search', style: TextStyle(color: Color.fromARGB(255, 151, 147, 147),))
                      ],
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          )),
        ),
      ),
    );
  }
}