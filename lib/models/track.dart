import 'package:mindflow/models/check-in.dart';
import 'package:mindflow/models/tag.dart';

class TrackData {
  final DateTime date;
  final Map<String, double> taskHours;
  final List<Tag> tags;
  final double productivityScore;
  final double moodScore;
  final int taskSwitches;
  TrackData(this.date, this.taskHours, this.tags, this.productivityScore, this.moodScore, this.taskSwitches);
}

TrackData mapDailyCheckInToTrackData(DailyCheckInModel dailyCheckIn) {

  final taskHours = <String, double>{};
  dailyCheckIn.taskHours.forEach((task, ranges) {
    double totalHours = 0;
    for (var range in ranges) {
      final duration = range.end.difference(range.start).inMinutes / 60.0;
      totalHours += duration;
    }
    taskHours[task] = totalHours;
  });

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