import 'package:mindflow/models/check-in.dart';
import 'package:mindflow/models/tag.dart';

// Track data class model used in our track/analytics screen
class TrackData {
  final DateTime date;
  final Map<String, double> taskHours;
  final List<Tag> tags;
  final double productivityScore;
  final double moodScore;
  final int taskSwitches;
  TrackData(this.date, this.taskHours, this.tags, this.productivityScore, this.moodScore, this.taskSwitches);
}

// We map the daily check-in data fetched from firestore to be usable in our check-in
TrackData mapDailyCheckInToTrackData(DailyCheckInModel dailyCheckIn) {

  // This retrieves the hours worked by task to be used on the first chart
  final taskHours = <String, double>{};
  dailyCheckIn.taskHours.forEach((task, ranges) {
    double totalHours = 0;
    for (var range in ranges) {
      final duration = range.end.difference(range.start).inMinutes / 60.0;
      totalHours += duration;
    }
    taskHours[task] = totalHours;
  });

  // this sums up the number of tasks the user has in a day
  final taskSwitches = dailyCheckIn.taskHours.values.fold<int>(
    0,
    (sum, ranges) => sum + ranges.length,
  );

  return TrackData(
    dailyCheckIn.date,
    taskHours,
    dailyCheckIn.tags,
    dailyCheckIn.productivityScore,
    dailyCheckIn.moodScore,
    taskSwitches,
  );
}