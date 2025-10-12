import 'package:flutter/material.dart';
import 'package:mindflow/track.dart';

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
      icon: Image.asset('assets/icons/home.png', height: 28),
      activeIcon: Image.asset('assets/icons/home-selected.png', height: 28),
      label: "Home",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.white,
      icon: Image.asset('assets/icons/track.png', height: 28),
      activeIcon: Image.asset('assets/icons/track-selected.png', height: 28),
      label: "Track",
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icons/insights.png', height: 28),
      activeIcon: Image.asset('assets/icons/insights-selected.png', height: 28),
      label: "Insights",
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icons/resources.png', height: 28),
      activeIcon: Image.asset('assets/icons/resources-selected.png', height: 28),
      label: "Resources",
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icons/settings.png', height: 28),
      activeIcon: Image.asset('assets/icons/settings-selected.png', height: 28),
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
    TrackScreen(),
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
    Center(
      child: Text(
        'Settings Placeholder',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    ),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        // Bottom nav bar Styling
        showUnselectedLabels: true,
        selectedItemColor: Color(0xFFEF9C53),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(
          fontFamily: "merriweather",
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        selectedLabelStyle: TextStyle(
          fontFamily: "merriweather",
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}