import 'package:flutter/material.dart';
import 'package:gohan/screen/home/home_page.dart';
import 'package:gohan/screen/profile/profile_page.dart';
import 'package:gohan/screen/search/search_page.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key});

  @override
  State<StatefulWidget> createState() => _BottomTabPageState();
}

class _BottomTabPageState extends State<BottomTabPage> {
  int _currentIndex = 0;

  final List<Widget> _pageWidgets = [
    HomePage(),
    const SearchPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidgets[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 0.5,
            color: Colors.grey.shade300, 
          ),
          BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _currentIndex == 0 
                    ? const Icon(Icons.home, size: 30.0, color: Colors.black) 
                    : const Icon(Icons.home_outlined, size: 30.0, color: Colors.black),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _currentIndex == 1 
                    ? const Icon(Icons.search_rounded, size: 30.0, color: Colors.black) 
                    : const Icon(Icons.search_outlined, size: 30.0, color: Colors.black),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: _currentIndex == 2 
                    ? const Icon(Icons.person, size: 30.0, color: Colors.black) 
                    : const Icon(Icons.person_outline, size: 30.0, color: Colors.black),
                label: 'Profile',
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
