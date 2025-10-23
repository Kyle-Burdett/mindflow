import 'package:flutter/material.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/models/check-in.dart';
import 'package:mindflow/models/tag.dart';
import 'package:mindflow/models/track.dart';
import 'package:mindflow/models/weekly_insights.dart';
import 'package:mindflow/repositories/check_in_repository.dart';
import 'package:mindflow/view-models/user_view_model.dart';

class CheckInViewModel extends ChangeNotifier {

  List<DailyCheckInModel> dailyCheckInList = [];
  DailyCheckInModel currentDailyCheckIn = DailyCheckInModel(id: '', date: DateTime.now(), energyScore: 5, moodScore: 5, productivityScore: 5, stressScore: 5, notes: '', tags: [], taskHours: {});


  String currentCheckInDate = "";
  DateTime currentDate = DateTime.now();
  List<TrackData> trackData = [];
  WeeklySummary? weeklyInsights; 

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
      weeklyInsights = getWeeklyAverages(dailyCheckInList);
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
      weeklyInsights = getWeeklyAverages(dailyCheckIns);
      
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

  String setCheckInText() {
    final checkIn = dailyCheckInList.firstWhere((checkIn) => checkIn.id == currentCheckInDate, orElse: () => DailyCheckInModel(id: "", date: currentDate, energyScore: 5, moodScore: 5, productivityScore: 5, stressScore: 5, notes: '', tags: [], taskHours: {}));
    if (checkIn.id.isEmpty) {
      return "Add Check-in";
    } else {
      return "Edit Check-in";
    }
  }

  void setCheckInHours(Map<String, List<TimeRange>> taskHours) {
    currentDailyCheckIn.taskHours = taskHours;
    notifyListeners();
  }

  double getTotalWorkHours(DailyCheckInModel checkIn) {
    double totalHours = 0;

    checkIn.taskHours.forEach((_, timeRanges) {
      for (var range in timeRanges) {
        totalHours += range.end.difference(range.start).inHours;
      }
    });

    return totalHours;
  }

  double getOvertimeHours(DailyCheckInModel checkIn) {
    final standardHours = locator<UserViewModel>().user.endTime!.difference(locator<UserViewModel>().user.startTime!).inHours;
    final total = getTotalWorkHours(checkIn);
    return total > standardHours ? total - standardHours : 0;
  }

  Map<String, double> getDailyScores(DailyCheckInModel checkIn) {
 
    final productivityTags = checkIn.tags.where((t) => t.category == "productivity");
    final energyTags = checkIn.tags.where((t) => t.category == "energy");

    double scoreFromTags(Iterable<Tag> tags) {
      if (tags.isEmpty) return 50;
      final total = tags.length;
      final sum = tags.fold<int>(0, (acc, t) => acc + t.value);
      return ((sum / total) * 50) + 50;
    }

    final productivity = scoreFromTags(productivityTags);
    final energy = scoreFromTags(energyTags);

    final overtime = getOvertimeHours(checkIn);
    final workLifeBalance = ((100 - (overtime.clamp(0, 4) / 4) * 100).clamp(0, 100)).toDouble();

    final collaborativeCount = checkIn.tags.where((t) => t.name == "Collaborative").length;
    final blockedCount = checkIn.tags.where((t) => t.name == "Blocked").length;
    final isolationScore = (100 - ((blockedCount - collaborativeCount) * 10))
        .clamp(0, 100)
        .toDouble();

    return {
      "productivity": productivity,
      "energy": energy,
      "workLifeBalance": workLifeBalance,
      "isolation": isolationScore,
    };
  }

  WeeklySummary getWeeklyAverages(List<DailyCheckInModel> checkIns) {
    if (checkIns.isEmpty || checkIns.length < 7) {
      return  WeeklySummary(avgEnergy: 0, avgIsolation: 0, avgProductivity: 0, avgTotalHours: 0, avgWorkLifeBalance: 0, totalOvertimeHours: 0);
    }

    // Sort descending by date
    checkIns.sort((a, b) => b.date.compareTo(a.date));
    final recent = checkIns.take(7).toList();

    double sumProd = 0, sumEnergy = 0, sumWLB = 0, sumIso = 0, sumHours = 0, sumOvertime = 0;

    for (var c in recent) {
      final scores = getDailyScores(c);
      
      sumProd += scores["productivity"]!;
      sumEnergy += scores["energy"]!;
      sumWLB += scores["workLifeBalance"]!;
      sumIso += scores["isolation"]!;

      sumHours += getTotalWorkHours(c);
      sumOvertime += getOvertimeHours(c);
    }

    final count = recent.length;
    return WeeklySummary(avgProductivity: sumProd / count / 100, avgEnergy: sumEnergy / count / 100, avgWorkLifeBalance: sumWLB / count / 100, avgIsolation: sumIso / count / 100, avgTotalHours: sumHours, totalOvertimeHours: sumOvertime);
  }
}