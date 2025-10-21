import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/models/user.dart';
import 'package:mindflow/repositories/user_repository.dart';
import 'package:mindflow/view-models/check_in_view_model.dart';

class UserViewModel extends ChangeNotifier {

  UserModel user = UserModel(reminder: false);
  
  final UserRepository _userRepository = UserRepository();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool?> addUser(UserModel user) async {
    bool success = await _userRepository.addUser(user);
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

  Future<User?> authRegisterUser(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user; 
    } on FirebaseAuthException catch (e) {
      debugPrint('Error: ${e.message}');
      return null;
    }
  }

  signUp(BuildContext context, String email, String password, String confirmPassword) async {
    // Signup validation
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter an email address.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w\.\-\+]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Password validation
    String? passwordMessage = validatePassword(password, confirmPassword);
    if (passwordMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    final createdUser = await authRegisterUser(email, password);
    if (createdUser != null) {
      user.id = createdUser.uid;
    }


    // DateTime now = DateTime.now();

    // user.email = email;
    // user.name = "Kyle";
    // user.startTime = DateTime(now.year, now.month, now.day, 9, 0);
    // user.endTime = DateTime(now.year, now.month, now.day, 17, 0);
    // user.balance = true;
    // user.productivity = true;
    // user.reminder = true;
    // user.reminderTime = DateTime(now.year, now.month, now.day, 18, 0);

    if (context.mounted) {
      context.push('/onboarding/welcome');
    }
  }

  Future<void> onboardUser(BuildContext context) async {

    bool? success = await addUser(user);

    if (success == true && context.mounted) {
      context.push('/home');
    }
  }

  Future<User?> authSignIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> signIn(BuildContext context, String email, String password) async {
   // Mock login. Needs firebase auth
  
    // User user = await authSignIn(email, password);
    User? userFetched =  await authSignIn(email, password);
    String userId = "";
    if (userFetched != null) {
      userId = userFetched.uid;
    } else {
      return;
    }
    

    bool? success = await fetchUserDetails(userId);

    locator<CheckInViewModel>().fetchAllCheckIns(userId);

    if (success == true && context.mounted && user.name != null && user.name!.isNotEmpty) {
      context.go('/home');
    } 
  }

  String? validatePassword(String password, String confirmPassword) {
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
    } else if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

}