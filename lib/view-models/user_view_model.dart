import 'package:mindflow/repositories/user_repository.dart';

class UserViewModel {
  String name = '';
  String email = '';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool reminder = false;

  UserRepository _userRepository = UserRepository();

  Future<void> addUser(String email, String name, DateTime startTime, DateTime endTime, bool reminder) async {
    bool success = await _userRepository.addUser(email, name, startTime, endTime, reminder);
    if (success) {
      print("Add user success!");
    } else {
      print("Add user Failed!");
    }
  }

}