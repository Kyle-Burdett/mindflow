import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:go_router/go_router.dart';

import 'package:mindflow/core/locator.dart';

import 'package:mindflow/models/user.dart';

import 'package:mindflow/repositories/user_repository.dart';

import 'package:mindflow/view-models/check_in_view_model.dart';


class UserViewModel extends ChangeNotifier {

  UserModel user = UserModel(reminder: false);

  final UserRepository _userRepository = UserRepository();

  final FirebaseAuth _auth = FirebaseAuth.instance;

// --- UI State Management ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
// --- END UI State Management ---

  Future<bool?> setUser(UserModel user) async {
    bool success = await _userRepository.setUser(user);
    if (success) {
      print("Add user success!");
      return true;
    } else {
      print("Add user Failed!");
      return false;
    }
  }

  Future<bool?> fetchUserDetails(String userId) async {
    UserModel? userDetails = await _userRepository.fetchUserDetails(userId);
    if (userDetails != null) {
      user = userDetails;
      return true;
    } else {
      print("Fetch user Failed!");
      return false;
    }
  }

  // *** MODIFIED: Added BuildContext to show SnackBar on error ***
  Future<User?> authRegisterUser(BuildContext context, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
// Show Firebase specific errors to the user
      String message;
      if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else {
        message = 'Registration failed: ${e.message}';
      }
      _showErrorSnackBar(context, message); // *** MODIFIED: Pass context ***
      return null;
    }
  }

  // --- SIGN UP METHOD ---
  signUp(BuildContext context, String email, String password) async {
    _setLoading(true);

    // Email validation
    if (email.isEmpty) {
      _showErrorSnackBar(context, 'Please enter an email address.');
      _setLoading(false);
      return;
    }

    final emailRegex = RegExp(r'^[\w\.\-\+]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showErrorSnackBar(context, 'Please enter a valid email address.');
      _setLoading(false);
      return;
    }

    // Password validation check
    final passwordError = validatePassword(password);
    if (passwordError != null) {
      _showErrorSnackBar(context, passwordError);
      _setLoading(false);
      return;
    }

    // Register user using firebase auth if passing validation checks
    final createdUser = await authRegisterUser(context, email, password);

    // Setting the user id to the one obtained from Firebase auth
    if (createdUser != null) {
      user.id = createdUser.uid;
      // Navigate to onboarding success, replacing the sign-up page
      if (context.mounted) {
        context.go('/onboarding/welcome');
      }
    }

    _setLoading(false);
  }

// --- NEW METHOD FOR FORGOT PASSWORD ---
  Future<bool> sendPasswordResetEmail(BuildContext context, String email) async {
    _setLoading(true);

    if (email.isEmpty) {
      _showErrorSnackBar(context, 'Please enter an email address.'); // *** MODIFIED: Pass context ***
      _setLoading(false);
      return false;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());

// Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent to your email!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _setLoading(false);
      return true;

    } on FirebaseAuthException catch (e) {
// Show error message
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else {
        message = 'Error sending reset email: ${e.message}';
      }
      _showErrorSnackBar(context, message); // *** MODIFIED: Pass context ***
      _setLoading(false);
      return false;
    } catch (e) {
      _showErrorSnackBar(context, 'An unexpected error occurred: ${e.toString()}'); // *** MODIFIED: Pass context ***
      _setLoading(false);
      return false;
    }
  }

  // Onboard user used after onboarding flow is complete
  Future<void> onboardUser(BuildContext context) async {
    _setLoading(true);

    // creating user
    bool? success = await setUser(user);

    if (success == true && context.mounted) {
      await locator<CheckInViewModel>().fetchAllCheckIns(user.id!);
      context.go('/home');
    }

    _setLoading(false);
  }

  Future<User?> authSignIn(BuildContext context, String email, String password) async {
    try {
      // firebase auth sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Show Firebase specific errors to the user
      String message;
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Invalid email or password.';
      } else {
        message = 'Sign in failed: ${e.message}';
      }
      _showErrorSnackBar(context, message);
      return null;
    } catch (e) {
      _showErrorSnackBar(context, 'An unexpected error occurred: ${e.toString()}');
      return null;
    }
  }

// --- SIGN IN METHOD ---
  Future<void> signIn(BuildContext context, String email, String password) async {
    _setLoading(true);

// Email validation
    if (email.isEmpty) {
      _showErrorSnackBar(context, 'Please enter an email address.'); // *** MODIFIED: Pass context ***
      _setLoading(false);
      return;
    }

// Password validation check
    final passwordError = validatePassword(password);
    if (passwordError != null) {
      _showErrorSnackBar(context, passwordError); // *** MODIFIED: Pass context ***
      _setLoading(false);
      return;
    }

    // *** MODIFIED: Pass context to authSignIn ***
    User? userFetched = await authSignIn(context, email, password);

    if (userFetched == null) {
      _setLoading(false);
      return; // Failed auth is handled in authSignIn
    }

    String userId = userFetched.uid;

    bool? success = await fetchUserDetails(userId);

// Assuming CheckInViewModel is correctly set up
    locator<CheckInViewModel>().fetchAllCheckIns(userId);

// User is signed in. The GoRouter redirect handles moving to /home,
// BUT we manually check if onboarding is needed here (if name is missing)
    if (success == true && context.mounted && user.name != null && user.name!.isNotEmpty) {
// If user details are found and onboarding seems complete, go to home
      context.go('/home');
    } else if (context.mounted) {
// User signed in but details not found or name is empty, send them to onboarding!
      context.go('/onboarding/welcome');
    }

    _setLoading(false);
  }

  // Password validation function
  String? validatePassword(String password) {
    final hasUpperCase = RegExp(r'[A-Z]');
    final hasLowerCase = RegExp(r'[a-z]');
    final hasDigits = RegExp(r'\d');
    final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (password.isEmpty) {
      return 'Please enter a password';
    } else if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!hasUpperCase.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!hasLowerCase.hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    } else if (!hasDigits.hasMatch(password)) {
      return 'Password must contain at least one digit';
    } else if (!hasSpecialCharacters.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

// Helper to show SnackBar (now requires a BuildContext)
  // *** MODIFIED: This method now requires and uses BuildContext directly ***
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

}