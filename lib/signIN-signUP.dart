import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

const double spacing = 4.0;

// ---------------- GET STARTED PAGE ----------------
class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Padding(
        padding: const EdgeInsets.all(spacing * 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite_border, color: Color(0xFFB66623), size: 80),
              const SizedBox(height: spacing * 3),
              const Text('MindFlow',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: spacing * 2),
              const Text(
                'Your personal wellness companion for remote work',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: spacing * 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB66623),
                    padding: const EdgeInsets.all(spacing * 3),
                  ),
                  onPressed: () => context.push('/sign-in'),
                  child: const Text('Sign In'),
                ),
              ),
              const SizedBox(height: spacing * 3),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(spacing * 3),
                  ),
                  onPressed: () => context.push('/sign-up'),
                  child: const Text('Create Account'),
                ),
              ),
              const SizedBox(height: spacing * 5),
              const Text(
                'Join thousands of remote workers improving their wellness',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- SIGN IN PAGE ----------------
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<UserViewModel>(
      create: (_) => locator<UserViewModel>(),
      child: Consumer<UserViewModel>(
      builder: (context, model, child) => Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Padding(
        padding: const EdgeInsets.all(spacing * 8),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: spacing * 3),
                const Text(
                  'Sign in to continue your wellness journey',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacing * 6),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFB66623)),
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: spacing * 3),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFB66623)),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: spacing * 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB66623),
                      padding: const EdgeInsets.all(spacing * 3),
                    ),
                    onPressed: () {
                      model.signIn(context, emailController.text, passwordController.text);
                    },
                    child: const Text('Sign In'),
                  ),
                ),
                const SizedBox(height: spacing * 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => context.replace('/sign-up'),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xFFB66623), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacing * 3),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('← Back to welcome'),
                ),
              ],
            ),
          ),
        ),
      ),
          )));
  }
}

// ---------------- SIGN UP PAGE ----------------
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return ChangeNotifierProvider<UserViewModel>(
      create: (_) => locator<UserViewModel>(), 
      child: Consumer<UserViewModel>(
      builder: (context, model, child) => Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      body: Padding(
        padding: const EdgeInsets.all(spacing * 8),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, color: Color(0xFFB66623), size: 80),
                const SizedBox(height: spacing * 3),
                const Text('MindFlow',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: spacing * 2),
                const Text('Start your wellness journey today',
                    textAlign: TextAlign.center),
                const SizedBox(height: spacing * 6),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFB66623)),
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: spacing * 3),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFB66623)),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: spacing * 3),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFB66623)),
                    labelText: 'Confirm Password',
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: spacing * 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB66623),
                      padding: const EdgeInsets.all(spacing * 3),
                    ),
                    onPressed: () {
                      model.signUp(context, emailController.text, passwordController.text, confirmPasswordController.text);
                    },
                    child: const Text('Create Account'),
                  ),
                ),
                const SizedBox(height: spacing * 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => context.replace('/sign-in'),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Color(0xFFB66623), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacing * 3),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('← Back to welcome'),
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
