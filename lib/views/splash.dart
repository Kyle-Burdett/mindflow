import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Future<void> routeToHome(BuildContext context) async {
    // Simulating app loading until we implement everything else
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      context.go('/get-started');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    routeToHome(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/heart.png', width: 64),
              SizedBox(height: 16),
              const Text(
                "ClarityDesk",
                style: TextStyle(
                  fontFamily: "merriweather",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF9C53),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
