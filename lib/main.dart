import 'package:flutter/material.dart';
import 'onboarding/welcome_page.dart';
import 'onboarding//about_you_page.dart';
import 'onboarding/wellness_goals_page.dart';
import 'onboarding/planning_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/tellus': (context) => TellUsScreen(),
        '/wellness': (context) => WellnessGoalsScreen(),
        '/planning': (context) => PlanningScreen(),
      },
    );
  }
}