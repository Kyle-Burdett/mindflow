import 'package:flutter/material.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/models/check-in.dart';
import 'package:mindflow/models/track.dart';
import 'package:mindflow/repositories/check_in_repository.dart';
import 'package:mindflow/view-models/user_view_model.dart';

class CheckInViewModel extends ChangeNotifier {

  List<DailyCheckInModel> dailyCheckInList = [];
  DailyCheckInModel currentDailyCheckIn = DailyCheckInModel(id: '', date: DateTime.now(), energyScore: 5, moodScore: 5, productivityScore: 5, stressScore: 5, notes: '', tags: [], taskHours: {});


  String currentCheckInDate = "";
  DateTime currentDate = DateTime.now();
  List<TrackData> trackData = [];

  int checkInLimit = 7;
  bool loading = false;

  
  final CheckInRepository _checkInRepository = CheckInRepository();

  Future<void> addCheckIn(DailyCheckInModel checkIn) async {
    loading = true;
    notifyListeners();
    String userId = locator<UserViewModel>().user.id!;
    bool success = await _checkInRepository.addCheckIn(userId, checkIn);
    if (success) {
      dailyCheckInList.add(checkIn);
      trackData = dailyCheckInList.map((checkIn) => mapDailyCheckInToTrackData(checkIn)).toList();
      print("Add check In success!");
    } else {
      print("Add check in Failed.");
    }
    loading = false;
    notifyListeners();
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
      trackData = dailyCheckInList.map((checkIn) => mapDailyCheckInToTrackData(checkIn)).toList();
      
    } else {
      print("Fetch users Failed!");
    }
  }

  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DailyCheckInModel? findCheckInById(List<DailyCheckInModel> list, String id) {
  try {
    return list.firstWhere((item) => item.id == id);
  } catch (e) {
    return null;
  }
}

  void setCurrentCheckIn() {
    loading = true;
    notifyListeners();
    try {
      currentDailyCheckIn = dailyCheckInList.firstWhere((checkIn) => checkIn.id == currentCheckInDate, orElse: () => DailyCheckInModel(id: currentCheckInDate, date: currentDate, energyScore: 5, moodScore: 5, productivityScore: 5, stressScore: 5, notes: '', tags: [], taskHours: {}));
      print("Current Check In: ${currentDailyCheckIn.id}");
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      return;
    }
  }

  void setCheckInHours(Map<String, List<TimeRange>> taskHours) {
    currentDailyCheckIn.taskHours = taskHours;
    notifyListeners();
  }
}