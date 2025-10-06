import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mindflow/models/track.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {

  String trackView = 'daily';

  final trackData = [
    TrackData(
      DateTime(2025, 10, 1),
      {"Project 1": 4, "Meetings": 2, "Project 2": 3},
      [
        "Unexpected meetings", "Feeling good"
      ],
      2.5,
      5
    ),
    TrackData(
      DateTime(2025, 10, 2),
      {"Project 1": 4, "Meetings": 2, "Project 2": 3},
      [
        "Urgent deadlines", "Unfocused"
      ],
      2.5,
      5
    ),
    TrackData(
      DateTime(2025, 10, 3),
      {"Project 1": 5, "Meetings": 3, "Project 2": 2},
      [
        "emergency work", "Low energy"
      ],
      2.5,
      5
    ),
    TrackData(
      DateTime(2025, 10, 4),
      {"Project 1": 7, "Meetings": 0.5, "Project 2": 1},
      [
        "Quiet", "Feeling good"
      ],
      2.5,
      5
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFF3E9),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => trackView = 'daily'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: trackView == 'daily' ? Color(0xFFDB863B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Daily',
                          style: TextStyle(
                            fontFamily: "merriweather",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: trackView == 'daily' ? Colors.white : Color(0xFF2E2E2E),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => trackView = 'weekly'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: trackView == 'weekly' ? Color(0xFFDB863B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Weekly',
                          style: TextStyle(
                            fontFamily: "merriweather",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: trackView == 'weekly' ? Colors.white : Color(0xFF2E2E2E),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => trackView = 'monthly'),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: trackView == 'monthly' ? Color(0xFFDB863B) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Monthly',
                          style: TextStyle(
                            fontFamily: "merriweather",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: trackView == 'monthly' ? Colors.white : Color(0xFF2E2E2E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'Hourly breakdown',
                  style: TextStyle(
                    fontFamily: "merriweather",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(enabled: true),
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= trackData.length) return const SizedBox.shrink();
                              final date = trackData[index].date;
                              return Text(
                                DateFormat.Md().format(date),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: trackData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: data.taskHours.values.fold(0, (a, b) => a + b),
                              rodStackItems: [
                                BarChartRodStackItem(0, d.runningHours, Colors.orange),
                                BarChartRodStackItem(d.runningHours, d.runningHours + d.codingHours, Colors.blue),
                                BarChartRodStackItem(
                                  d.runningHours + d.codingHours,
                                  d.runningHours + d.codingHours + d.readingHours,
                                  Colors.green,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(4),
                              width: 18,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}