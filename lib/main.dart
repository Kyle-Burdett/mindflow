import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:mindflow/view-models/check_in_view_model.dart';
import 'package:mindflow/working_hours_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindflow/view-models/user_view_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Handling firebase messages obtained when app is in a background state
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initializing firebase messaging and requesting permission to use send notifications from the user
  final messaging = FirebaseMessaging.instance;

  print("FCM Token: ${await messaging.getToken()}");
  await messaging.requestPermission();


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
    // Initial redirect logic to check auth status immediately
    redirect: (BuildContext context, GoRouterState state) async {
      final auth = FirebaseAuth.instance;
      final isAuthenticated = auth.currentUser != null;

      // Check if the user is currently in any onboarding path
      final isOnboardingPath = state.matchedLocation.startsWith('/onboarding');

      // Paths that do NOT require authentication
      const List<String> unauthenticatedPaths = [
        '/', // Splash screen
        '/get-started',
        '/sign-in',
        '/sign-up',
        '/forgot-password', // ADDED forgot password path here
      ];

      final isGoingToProtectedPath =
          !unauthenticatedPaths.contains(state.matchedLocation) && !isOnboardingPath;

      // 1. If user is NOT authenticated and tries to access a protected path, redirect to sign-in
      if (!isAuthenticated && isGoingToProtectedPath) {
        return '/get-started';
      }

      // 2. If user IS authenticated and tries to access an unauthenticated path (like sign-in), redirect to home
      // We only redirect to home if they are not already in the middle of onboarding.
      if (isAuthenticated && unauthenticatedPaths.contains(state.matchedLocation) && state.matchedLocation != '/') {
        await locator<UserViewModel>().fetchUserDetails(auth.currentUser!.uid);
        await locator<CheckInViewModel>().fetchAllCheckIns(locator<UserViewModel>().user.id!);
        // When opening the app while authenticated, we route them to the home screen
        return '/home';
      }

      // No redirect needed
      return null;
    },
    // We use the auth state stream to automatically trigger a router refresh
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
        builder: (context, state) => MainHomeScreen(),
      ),
      GoRoute(
        path: '/home-second',
        builder: (context, state) => MainHomeScreen(initialIndex: 3),
      ),
      GoRoute(
        path: '/check-in',
        builder: (context, state) => const DailyCheckIn(),
      ),
      GoRoute(
        path: '/check-in-hours',
        builder: (context, state) => const WorkingHoursPage(),
      ),
      // --- ONBOARDING ROUTES ---
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
      title: 'ClarityDesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDB863B)),
        // Add other theme customizations here if needed
      ),
      routerConfig: _router,
    );
  }
}
