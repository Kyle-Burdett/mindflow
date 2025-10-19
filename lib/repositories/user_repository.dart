import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindflow/models/user.dart';

class UserRepository {
  Future<bool> addUser(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add(user.toMap());
    } catch (e) {
      print("Cannot add user: $e");
      return false;
    }
    return true;
  }

  Future<UserModel?> fetchUserDetails(String userId) async {
      final document = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userDetails = UserModel.fromDoc(document);
      return userDetails;
  }
  
}