import 'package:mindflow/models/check-in.dart';
import 'package:mindflow/repositories/check_in_repository.dart';

class CheckInViewModel {

  DailyCheckInModel? dailyCheckIn;
  String userId = "Gdh8RKMDRHxmKT1pRxE4";
  
  final CheckInRepository _checkInRepository = CheckInRepository();

  Future<void> addCheckIn(DailyCheckInModel checkIn) async {
    bool success = await _checkInRepository.addCheckIn(userId, checkIn);
    if (success) {
      print("Add user success!");
    } else {
      print("Add user Failed!");
    }
  }

  Future<void> fetchCheckInDetails(String userId, String checkInId) async {
    DailyCheckInModel? dailyCheckIn = await _checkInRepository.fetchCheckInDetails(userId, checkInId);
    if (dailyCheckIn != null) {
      dailyCheckIn = dailyCheckIn;
    } else {
      print("Fetch user Failed!");
    }
  }

}