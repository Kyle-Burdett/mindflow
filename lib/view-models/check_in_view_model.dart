import 'package:flutter/material.dart';
import 'package:mindflow/models/check-in.dart';
import 'package:mindflow/repositories/check_in_repository.dart';

class CheckInViewModel extends ChangeNotifier {

  List<DailyCheckInModel> dailyCheckInList = [];
  DailyCheckInModel currentDailyCheckIn = DailyCheckInModel(id: '', date: DateTime.now(), energyScore: 5, moodScore: 5, productivityScore: 5, stressScore: 5, notes: '', tags: [], taskHours: {});

  String userId = "";
  int checkInLimit = 7;

  
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
      currentDailyCheckIn = dailyCheckIn;
    } else {
      print("Fetch user Failed!");
    }
  }

  Future<void> fetchAllCheckIns(String userId) async {
    List<DailyCheckInModel>? dailyCheckIns = await _checkInRepository.fetchAllCheckInDetails(userId);

    if (dailyCheckIns != null) {
      dailyCheckInList.addAll(dailyCheckIns);
    } else {
      print("Fetch users Failed!");
    }
  }
}