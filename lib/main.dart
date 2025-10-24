import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/daily_check_in.dart';
import 'package:mindflow/firebase_options.dart';
import 'package:mindflow/forgot_password.dart';
import 'package:mindflow/home-nav.dart';
import 'package:mindflow/onboarding/about_you_page.dart';
import 'package:mindflow/onboarding/planning_page.dart';
import 'package:mindflow/onboarding/welcome_page.dart';
import 'package:mindflow/onboarding/wellness_goals_page.dart';
import 'package:mindflow/signIN-signUP.dart';
import 'package:mindflow/splash.dart';
import 'package:mindflow/working_hours_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindflow/view-models/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();
  runApp(
    ChangeNotifierProvider<UserViewModel>(
      create: (_) => locator<UserViewModel>(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    redirect: (BuildContext context, GoRouterState state) {
      final auth = FirebaseAuth.instance;
      final isAuthenticated = auth.currentUser != null;

      // Check if the user is currently in any onboarding path
      final isOnboardingPath = state.matchedLocation.startsWith('/onboarding');

      // Paths that do NOT require authentication
      const List<String> unauthenticatedPaths = [
        '/',
        '/get-started',
        '/sign-in',
        '/sign-up',
        '/forgot-password',
      ];

      final isGoingToProtectedPath =
          !unauthenticatedPaths.contains(state.matchedLocation) && !isOnboardingPath;
      if (!isAuthenticated && isGoingToProtectedPath) {
        return '/get-started';
      }


      if (isAuthenticated && unauthenticatedPaths.contains(state.matchedLocation) && state.matchedLocation != '/') {

        return '/home';
      }

      return null;
    },
    refreshListenable: ValueNotifier<User?>(FirebaseAuth.instance.currentUser),

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
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
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
      GoRoute(
        path: '/onboarding/welcome',
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/tell-us',
        builder: (context, state) => TellUsScreen(),
      ),
      GoRoute(
        path: '/onboarding/goals',
        builder: (context, state) => WellnessGoalsScreen(),
      ),
      GoRoute(
        path: '/onboarding/planning',
        builder: (context, state) => PlanningScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mindflow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDB863B)),
      ),
      routerConfig: _router,
    );
  }
}
