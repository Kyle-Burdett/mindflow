import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  bool editingCheckIn = false;

  int checkInLimit = 7;
  bool loading = false;

  
  final CheckInRepository _checkInRepository = CheckInRepository();

  Future<void> setCheckIn(BuildContext context, DailyCheckInModel checkIn) async {
    loading = true;
    notifyListeners();
    String userId = locator<UserViewModel>().user.id!;
    bool success = await _checkInRepository.setCheckIn(userId, checkIn);
    if (success) {
      if (editingCheckIn == false) {
        dailyCheckInList.add(checkIn);
      }
      trackData = dailyCheckInList.map((checkIn) => mapDailyCheckInToTrackData(checkIn)).toList();
      trackData.sort((a, b) => a.date.compareTo(b.date));
      weeklyInsights = getWeeklyAverages(dailyCheckInList);
      print("Add check In success!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check in set successfully!')),
      );
    } else {
      print("Add check in Failed.");
    }
    loading = false;
    notifyListeners();
    context.pop();
  }

  Future<void> fetchCheckInDetails(String userId, String checkInId) async {
    DailyCheckInModel? dailyCheckIn = await _checkInRepository.fetchCheckInDetails(userId, checkInId);
    if (dailyCheckIn != null) {
      currentDailyCheckIn = dailyCheckIn;
    } else {
      print("Fetch user Failed!");
    }
  }

  // Function to fetch all user check-in data
  Future<void> fetchAllCheckIns(String userId) async {
    List<DailyCheckInModel>? dailyCheckIns = await _checkInRepository.fetchAllCheckInDetails(userId);

    if (dailyCheckIns != null) {
      dailyCheckInList.addAll(dailyCheckIns);
      // Once we retrieve check-in data from the database we can convert that data to a usable format for the Track screen,
      trackData = dailyCheckInList.map((checkIn) => mapDailyCheckInToTrackData(checkIn)).toList();
      trackData.sort((a, b) => a.date.compareTo(b.date));
      weeklyInsights = getWeeklyAverages(dailyCheckIns);
      
    } else {
      print("Fetch check-ins Failed!");
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
    try {
      currentDailyCheckIn = dailyCheckInList.firstWhere((checkIn) => checkIn.id == currentCheckInDate, orElse: () => DailyCheckInModel(id: currentCheckInDate, date: currentDate, energyScore: 5, moodScore: 5, productivityScore: 5, stressScore: 5, notes: '', tags: [], taskHours: {}));
      print("Current Check In: ${currentDailyCheckIn.id}");
    } catch (e) {
      print("Error settings check-in: $e");
      return;
    }
  }

  String setCheckInText() {
    final checkIn = dailyCheckInList.firstWhere((checkIn) => checkIn.id == currentCheckInDate, orElse: () => DailyCheckInModel(id: "", date: currentDate, energyScore: 5, moodScore: 5, productivityScore: 5, stressScore: 5, notes: '', tags: [], taskHours: {}));
    if (checkIn.id.isEmpty) {
      editingCheckIn = false;
      return "Add Check-in";
    } else {
      editingCheckIn = true;
      return "Edit Check-in";
    }
  }

  void setCheckInHours(Map<String, List<TimeRange>> taskHours) {
    currentDailyCheckIn.taskHours = taskHours;
    notifyListeners();
  }

  // Function to calculate the total hours the user worked in a single day
  double getTotalWorkHours(DailyCheckInModel checkIn) {
    double totalHours = 0;

    checkIn.taskHours.forEach((_, timeRanges) {
      for (var range in timeRanges) {
        totalHours += range.end.difference(range.start).inHours;
      }
    });

    return totalHours;
  }

  // Overtime calculation by day
  double getOvertimeHours(DailyCheckInModel checkIn) {
    // Fetches user preference data and compares the two to get their planned working hours
    final standardHours = locator<UserViewModel>().user.endTime!.difference(locator<UserViewModel>().user.startTime!).inHours;
    final total = getTotalWorkHours(checkIn);
    // We return 0 if the user has no overtime
    return total > standardHours ? total - standardHours : 0;
  }

  Map<String, double> getDailyScores(DailyCheckInModel checkIn) {
 
    // We fetch the tags that are selected by the user that are mapped to a category
    final productivityTags = checkIn.tags.where((t) => t.category == "productivity");
    final energyTags = checkIn.tags.where((t) => t.category == "energy");
    final balanceTags = checkIn.tags.where((t) => t.category == "work_life_balance");
    final isolationTags = checkIn.tags.where((t) => t.category == "isolation");

    // Here we calcuate the contribution tags make on our insight percentage scores
    double scoreFromTags(Iterable<Tag> tags) {
      if (tags.isEmpty) return 50;
      final total = tags.length;
      final sum = tags.fold<int>(0, (acc, t) => acc + t.value);
      return ((sum / total) * 50) + 50;
    }

    // We calcuate the daily scores by combining our check-in data with the user rated scores and the tags they select
    final productivity = scoreFromTags(productivityTags) * 25 / 100 + checkIn.productivityScore * 10 * 75 / 100;
    final energy = scoreFromTags(energyTags) * 25 / 100 + checkIn.energyScore * 10 * 75 / 100;

    final overtime = getOvertimeHours(checkIn);

    // We calculate work/life balance by how many overtime hours are worked from a range of 0-4. Since this is per day the small number is suitable.
    double overtimeLimited = overtime.clamp(0, 4);
    double overtimePercent = (overtimeLimited / 4) * 100;
    double workLifeBalance = (100 - overtimePercent).clamp(0, 100).toDouble();

    final balanceTagScore = scoreFromTags(balanceTags);
    workLifeBalance = (workLifeBalance * 0.8 + balanceTagScore * 0.2).clamp(0, 100);

    final isolationTagScore = scoreFromTags(isolationTags);
    final isolationScore = isolationTagScore;

    return {
      "productivity": productivity,
      "energy": energy,
      "workLifeBalance": workLifeBalance,
      "isolation": isolationScore,
    };
  }


  WeeklySummary getWeeklyAverages(List<DailyCheckInModel> checkIns) {
    // Making sure we have enough data to provide relevant insights
    if (checkIns.isEmpty || checkIns.length < 7) {
      return  WeeklySummary(avgEnergy: 0, avgIsolation: 0, avgProductivity: 0, avgTotalHours: 0, avgWorkLifeBalance: 0, totalOvertimeHours: 0);
    }

    // Sortd dates in descending order
    checkIns.sort((a, b) => b.date.compareTo(a.date));

    // We only use the last 7 days when measuring insights
    final recent = checkIns.take(7).toList();

    double sumProd = 0, sumEnergy = 0, sumWLB = 0, sumIso = 0, sumHours = 0, sumOvertime = 0;

    // Calulating and fetching data for each check in for the week.
    for (var checkin in recent) {
      final scores = getDailyScores(checkin);
      
      sumProd += scores["productivity"]!;
      sumEnergy += scores["energy"]!;
      sumWLB += scores["workLifeBalance"]!;
      sumIso += scores["isolation"]!;

      // Sum hours and overtime are used to display to the user rather than in calculations
      sumHours += getTotalWorkHours(checkin);
      sumOvertime += getOvertimeHours(checkin);
    }

    final count = recent.length;
    return WeeklySummary(
      avgProductivity: sumProd / count / 100,
      avgEnergy: sumEnergy / count / 100,
      avgWorkLifeBalance: sumWLB / count / 100,
      avgIsolation: sumIso / count / 100,
      avgTotalHours: sumHours,
      totalOvertimeHours: sumOvertime);
  }

  void resetCheckins() {
    dailyCheckInList = [];
    currentDailyCheckIn = DailyCheckInModel(id: '', date: DateTime.now(), energyScore: 5, moodScore: 5, productivityScore: 5, stressScore: 5, notes: '', tags: [], taskHours: {});
    currentCheckInDate = "";
    currentDate = DateTime.now();
    trackData = [];
    weeklyInsights; 
    editingCheckIn = false;
    notifyListeners();
  }
}