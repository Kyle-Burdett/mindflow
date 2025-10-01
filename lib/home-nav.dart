import 'package:flutter/material.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {

  // Index defines what tab we're on from the bottom navigation bar.
  int _currentIndex = 0;

  // Bottom navigation bar icons/items. Defines the icons they use in selected/unselected states.
  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.heart_broken_rounded, color: Colors.black),
      activeIcon: Icon(Icons.heart_broken_rounded, color: Color(0xFFEF9C53)),
      label: "Home",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.white,
      icon: Icon(Icons.auto_graph, color: Colors.black),
      activeIcon: Icon(Icons.auto_graph, color: Color(0xFFEF9C53)),
      label: "Track",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.lightbulb, color: Colors.black),
      activeIcon: Icon(Icons.lightbulb, color: Color(0xFFEF9C53)),
      label: "Insights",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book, color: Colors.black),
      activeIcon: Icon(Icons.book, color: Color(0xFFEF9C53)),
      label: "Resources",
    ),
  ];

  // Placeholders until screens are developed
  List<Widget> screens = [
    Center(
      child: Text(
        'Home Placeholder',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    ),
    Center(
      child: Text(
        'Track Placeholder',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    ),
    Center(
      child: Text(
        'Insights Placeholder',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    ),
    Center(
      child: Text(
        'Resources Placeholder',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    ),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              //Route to settings
            },
            icon: Image.asset('assets/icons/settings.png', width: 24),
            iconSize: 16,
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _currentIndex,
        showUnselectedLabels: true,
        selectedItemColor: Color(0xFFEF9C53),
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}