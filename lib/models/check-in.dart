import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindflow/models/tag.dart';

class DailyCheckInModel {
  String id;
  DateTime date;
  double energyScore;
  double moodScore;
  double productivityScore;
  double stressScore;
  String notes;
  List<Tag> tags;
  Map<String, List<DateTime>> taskHours;

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
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((ts) => (ts as Timestamp).toDate())
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
      'taskHours': taskHours.map(
        (key, value) => MapEntry(
          key,
          value.map((d) => Timestamp.fromDate(d)).toList(),
        ),
      ),
    };
  }
}