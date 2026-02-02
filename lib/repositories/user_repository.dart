import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindflow/models/user.dart';

class UserRepository {
  // Set user both creates and updates users by id obtained from Firebase Auth
  Future<bool> setUser(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print("Cannot add user: $e");
      return false;
    }
    return true;
  }

  // Fetch user details from Firestore
  Future<UserModel?> fetchUserDetails(String userId) async {
      final document = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      // Convert data to usable format
      final userDetails = UserModel.fromDoc(document);
      return userDetails;
  }
}