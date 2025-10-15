import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/daily_check_in.dart';
import 'package:mindflow/firebase_options.dart';
import 'package:mindflow/home-nav.dart';
import 'package:mindflow/signIN-signUP.dart';
import 'package:mindflow/splash.dart';
import 'package:mindflow/working_hours_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/get-started',
        builder: (context, state) => const GetStartedPage(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainHomeScreen(),
      ),
      GoRoute(
        path: '/check-in',
        builder: (context, state) => const DailyCheckIn(),
      ),
      GoRoute(
        path: '/check-in-hours',
        builder: (context, state) => const WorkingHoursPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mindflow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFDB863B)),
      ),
      routerConfig: _router,
    );
  }
}