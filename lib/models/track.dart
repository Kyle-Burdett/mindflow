class TrackData {
  final DateTime date;
  final Map<String, double> taskHours;
  final List<String> tags; // Will change to tag class object (List<Tag>)
  final double productivityScore;
  final double moodScore;
  TrackData(this.date, this.taskHours, this.tags, this.productivityScore, this.moodScore);
}