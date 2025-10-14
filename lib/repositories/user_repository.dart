import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  Future<bool> addUser(String email, String name, DateTime startTime, DateTime endTime, bool reminder) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'email': email,
        'name': name,
        'startTime': startTime,
        'endTime': endTime,
        'reminder': reminder
      });
    } catch (e) {
      print("Cannot add user: $e");
      return false;
    }
    return true;
  }
}