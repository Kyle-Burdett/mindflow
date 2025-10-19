import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/models/user.dart';
import 'package:mindflow/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {

  UserModel user = UserModel();
  
  final UserRepository _userRepository = UserRepository();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUser(UserModel user) async {
    bool success = await _userRepository.addUser(user);
    if (success) {
      print("Add user success!");
    } else {
      print("Add user Failed!");
    }
  }

  Future<void> fetchUserDetails(String userId) async {
    UserModel? userDetails = await _userRepository.fetchUserDetails(userId);
    if (userDetails != null) {
      user = userDetails;
    } else {
      print("Fetch user Failed!");
    }
  }

  signUp(BuildContext context, String email, String password) {
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

    DateTime now = DateTime.now();

    user.email = email;
    user.name = "Kyle";
    user.startTime = DateTime(now.year, now.month, now.day, 9, 0);
    user.endTime = DateTime(now.year, now.month, now.day, 17, 0);
    user.balance = true;
    user.productivity = true;
    user.reminder = true;
    user.reminderTime = DateTime(now.year, now.month, now.day, 18, 0);

    addUser(user);
    context.go('/home');
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
    String userId = "ZlRM5ycKwfC4joPinO44";

    await fetchUserDetails(userId);

    if (context.mounted && user.email != null && user.email!.isNotEmpty) {
      context.go('/home');
    } 
  }

}