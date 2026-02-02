import 'package:flutter/material.dart';

class TrackViewModel extends ChangeNotifier {
  DateTime? date;
  Map<String, double>? taskHours;
  List<String>? tags; // Will change to tag class object (List<Tag>)
  double? productivityScore;
  double? moodScore;

  // TODO: Add track functions like any aggregation between days/weeks/months.
}
