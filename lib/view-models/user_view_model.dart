import 'package:mindflow/models/user.dart';
import 'package:mindflow/repositories/user_repository.dart';

class UserViewModel {

  UserDetails? user;
  
  UserRepository _userRepository = UserRepository();

  Future<void> addUser(String email, String name, DateTime startTime, DateTime endTime, bool reminder) async {
    bool success = await _userRepository.addUser(email, name, startTime, endTime, reminder);
    if (success) {
      print("Add user success!");
    } else {
      print("Add user Failed!");
    }
  }

  Future<void> fetchUserDetails(String userId) async {
    UserDetails? userDetails = await _userRepository.fetchUserDetails(userId);
    if (userDetails != null) {
      user = userDetails;
    } else {
      print("Fetch user Failed!");
    }
  }

}