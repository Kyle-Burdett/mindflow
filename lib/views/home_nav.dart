import 'package:flutter/material.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/views/homepage.dart';
import 'package:mindflow/views/insights.dart';
import 'package:mindflow/views/resource_page.dart';
import 'package:mindflow/views/settings_page.dart';
import 'package:mindflow/views/track.dart';
import 'package:mindflow/view-models/check_in_view_model.dart';
import 'package:mindflow/view-models/home_nav_view_model.dart';
import 'package:provider/provider.dart';

class MainHomeScreen extends StatefulWidget {
  final int? initialIndex;
  const MainHomeScreen({super.key, this.initialIndex});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    locator<CheckInViewModel>().currentCheckInDate = locator<CheckInViewModel>()
        .formatDate(DateTime.now());
    locator<HomeNavViewModel>().currentIndex = widget.initialIndex ?? 0;
    super.initState();
  }

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
      activeIcon: Image.asset(
        'assets/icons/resources-selected.png',
        height: 28,
      ),
      label: "Resources",
    ),
    BottomNavigationBarItem(
      icon: Image.asset('assets/icons/settings.png', height: 28),
      activeIcon: Image.asset('assets/icons/settings-selected.png', height: 28),
      label: "Settings",
    ),
  ];

  // Placeholders until screens are developed
  List<Widget> screens = [
    Homepage(),
    TrackScreen(),
    InsightsPage(),
    ResourcesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeNavViewModel>.value(
      value: locator<HomeNavViewModel>(),
      child: Consumer<HomeNavViewModel>(
        builder: (context, model, child) => Scaffold(
          body: screens[model.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavItems,
            currentIndex: model.currentIndex,
            onTap: (value) {
              setState(() {
                model.currentIndex = value;
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
        ),
      ),
    );
  }
}
