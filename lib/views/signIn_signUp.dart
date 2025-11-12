import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import 'package:mindflow/view-models/user_view_model.dart';

const double spacing = 4.0;
const Color primaryColor = Color(0xFFB66623); // Existing color constant
const Color backgroundColor = Color(0xFFFFF1E6); // Existing color constant

// ---------------- GET STARTED PAGE ----------------
class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Content remains the same as your previous version.
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(spacing * 8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite_border, color: primaryColor, size: 80),
              const SizedBox(height: spacing * 3),
              const Text('ClarityDesk',
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
                    backgroundColor: primaryColor,
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
    // Wrap the stateful content in the Consumer to access UserViewModel
    return Consumer<UserViewModel>(
      builder: (context, model, child) => _SignInContent(model: model),
    );
  }
}

// Private Stateful Widget to manage password visibility state
class _SignInContent extends StatefulWidget {
  final UserViewModel model;
  const _SignInContent({required this.model});

  @override
  State<_SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<_SignInContent> {
  // form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false; // State to control password visibility

  // Utility validator function for required fields and basic email format
  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    // Basic email format check for email field
    if (fieldName == 'Email') {
      final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address.';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(spacing * 8),
        child: Center(
          child: SingleChildScrollView(
            // WRAPPED: Column in Form
            child: Form(
              key: _formKey,
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
                  // --- Email Field ---
                  // CONVERTED to TextFormField & ADDED validator
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => _requiredValidator(value, 'Email'),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                  ),
                  const SizedBox(height: spacing * 3),
                  // --- Password Field (with eye icon) ---
                  // CONVERTED to TextFormField & ADDED validator
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible, // Use the state variable
                    validator: (value) => _requiredValidator(value, 'Password'),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          // Toggle the state
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: spacing * 1),
                  // --- FORGOT PASSWORD BUTTON ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: spacing * 4),
                  // --- Sign In Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.all(spacing * 3),
                      ),
                      onPressed: widget.model.isLoading ? null : () {
                        // ADDED: Validation check before calling the sign-in method
                        if (_formKey.currentState!.validate()) {
                          // Only attempt sign-in if validation passes
                          widget.model.signIn(context, emailController.text, passwordController.text);
                        }
                      },
                      child: widget.model.isLoading
                          ? const Center(child: SizedBox(
                        height: 24, width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      ))
                          : const Text('Sign In'),
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
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
// ---------------- SIGN UP PAGE ----------------
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapped the stateful content in the Consumer to access UserViewModel
    return Consumer<UserViewModel>(
      builder: (context, model, child) => _SignUpContent(model: model),
    );
  }
}

// Private Stateful Widget to manage password visibility states
class _SignUpContent extends StatefulWidget {
  final UserViewModel model;
  const _SignUpContent({required this.model});

  @override
  State<_SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<_SignUpContent> {
  // form state for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // States to control password visibility for both fields
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Utility regex for email format
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  // Validator function for Email and required fields
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // if (value.length < 8) {
    //   return 'Password must be at least 8 characters.';
    // }
    return null;
  }

  // Validator function for Confirm Password (checks required and match)
  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required.';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(spacing * 8),
        child: Center(
          child: SingleChildScrollView(
            //  WRAPPED: Column in Form
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, color: primaryColor, size: 80),
                  const SizedBox(height: spacing * 3),
                  const Text('ClarityDesk',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: spacing * 2),
                  const Text('Start your wellness journey today',
                      textAlign: TextAlign.center),
                  const SizedBox(height: spacing * 6),
                  // --- Email Field ---
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                  ),
                  const SizedBox(height: spacing * 3),
                  // --- Password Field (with eye icon) ---
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: _passwordValidator,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                      labelText: 'Password',
                      hintText: 'Enter your password (min 8 characters)',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: spacing * 3),
                  // --- Confirm Password Field (with eye icon) ---
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    validator: _confirmPasswordValidator,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: spacing * 6),
                  // --- Create Account Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.all(spacing * 3),
                      ),
                      onPressed: widget.model.isLoading ? null : () {
                        // Checks full form validation first
                        if (_formKey.currentState!.validate()) {
                          // The password match is now handled by the _confirmPasswordValidator
                          widget.model.signUp(context, emailController.text, passwordController.text);
                        }
                        // Note: If validation fails, the TextFormField shows the inline error and blocks the execution here.
                      },
                      child: widget.model.isLoading
                          ? const Center(child: SizedBox(
                        height: 24, width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      ))
                          : const Text('Create Account'),
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
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}