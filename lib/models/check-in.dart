import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindflow/models/tag.dart';

class TimeRange {
  final DateTime start;
  final DateTime end;

  TimeRange({required this.start, required this.end});

  factory TimeRange.fromMap(Map<String, dynamic> map) {
    return TimeRange(
      start: (map['start'] as Timestamp).toDate(),
      end: (map['end'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
    };
  }
}

class DailyCheckInModel {
  String id;
  DateTime date;
  double energyScore;
  double moodScore;
  double productivityScore;
  double stressScore;
  String notes;
  List<Tag> tags;
  Map<String, List<TimeRange>> taskHours;

  DailyCheckInModel({
    required this.id,
    required this.date,
    required this.energyScore,
    required this.moodScore,
    required this.productivityScore,
    required this.stressScore,
    required this.notes,
    required this.tags,
    required this.taskHours,
  });

  factory DailyCheckInModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DailyCheckInModel(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      energyScore: data['energyScore'] ?? 0,
      moodScore: data['moodScore'] ?? 0,
      productivityScore: data['productivityScore'] ?? 0,
      stressScore: data['stressScore'] ?? 0,
      notes: data['notes'] ?? '',
      tags: (data['tags'] as List<dynamic>? ?? [])
          .map((e) => Tag.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      taskHours: (data['taskHours'] as Map<String, dynamic>? ?? {}).map(
        (taskName, list) => MapEntry(
          taskName,
          (list as List<dynamic>)
              .map((range) => TimeRange.fromMap(Map<String, dynamic>.from(range)))
              .toList(),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'energyScore': energyScore,
      'moodScore': moodScore,
      'productivityScore': productivityScore,
      'notes': notes,
      'tags': tags.map((t) => t.toMap()).toList(),
      'taskHours': taskHours.map((taskName, ranges) => MapEntry(
        taskName, ranges.map((r) => r.toMap()).toList())),
    };
  }
}