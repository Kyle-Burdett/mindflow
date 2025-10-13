import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/models/track.dart';
import 'package:mindflow/view-models/track_view_model.dart';
import 'package:provider/provider.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {

  String trackView = 'daily';

  Map<String, Color> categoryColors = {};

  final idealHours = 8;

  final trackData = [
    TrackData(
      DateTime(2025, 10, 1),
      {"Project 1": 4, "Meetings": 2, "Project 2": 3},
      [
        "Unexpected meetings", "Feeling good"
      ],
      5,
      2,
      4
    ),
    TrackData(
      DateTime(2025, 10, 2),
      {"Project 1": 4, "Meetings": 2, "Project 2": 3},
      [
        "Urgent deadlines", "Unfocused"
      ],
      8,
      5,
      5
    ),
    TrackData(
      DateTime(2025, 10, 3),
      {"Project 1": 5, "Meetings": 3, "Project 2": 2},
      [
        "emergency work", "Low energy"
      ],
      2,
      5,
      3
    ),
    TrackData(
      DateTime(2025, 10, 4),
      {"Project 1": 7, "Meetings": 0.5, "Project 2": 1},
      [
        "Quiet", "Feeling good"
      ],
      3,
      7,
      8
    ),
    TrackData(
      DateTime(2025, 10, 5),
      {"Project 1": 7, "Meetings": 0.5, "Project 2": 1},
      [
        "Quiet", "Feeling good"
      ],
      7,
      8,
      2
    ),
    TrackData(
      DateTime(2025, 10, 6),
      {"Project 1": 7, "Meetings": 0.5, "Project 2": 1},
      [
        "Quiet", "Feeling good"
      ],
      6,
      10,
      4
    ),
    TrackData(
      DateTime(2025, 10, 7),
      {"Project 1": 7, "Meetings": 0.5, "Project 2": 1},
      [
        "Quiet", "Feeling good"
      ],
      5,
      5,
      2
    ),

  ];


  @override
  void initState() {
    final tasks = {
      for (var d in trackData) ...d.taskHours.keys
    }.toList();

    final graphColors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.pink,
      Colors.indigo,
      Colors.orange,
    ];

    // Mapping colors to different tasks to ensure consistency in Graph data.
    categoryColors = {
      for (int i = 0; i < tasks.length; i++)
        tasks[i]: graphColors[i % graphColors.length],
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrackViewModel>(
      create: (_) => locator<TrackViewModel>(),
      child: SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFF3E9),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 36),
                // Filter for different track views. (Will be last 7 days, last month, and last year)
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
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Stacked bar chart implementation. Shows work hours by task.
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
                                      DateFormat("MMM d").format(date),
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: trackData.asMap().entries.map((entry) {
                              final index = entry.key;
                              final d = entry.value;
                        
                              double fromY = 0;
                              final List<BarChartRodStackItem> stacks = [];
                      
                              d.taskHours.forEach((name, hours) {
                                final toY = fromY + hours;
                                stacks.add(
                                  BarChartRodStackItem(
                                    fromY,
                                    toY,
                                    categoryColors[name],
                                  ),
                                );
                                fromY = toY;
                              });
                        
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: fromY,
                                    rodStackItems: stacks,
                                    borderRadius: BorderRadius.circular(4),
                                    width: 24,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Legend which shows which color corresponds to which work task
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: categoryColors.entries.map((entry) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: entry.value,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontFamily: "merriweather",
                                  fontSize: 13,
                                  color: Color(0xFF2E2E2E),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Mood',
                  style: TextStyle(
                    fontFamily: "merriweather",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: trackData.map((trackItem) {
                    return UserStat(date: trackItem.date, statValue: trackItem.moodScore);
                  }).toList(),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Productivity',
                  style: TextStyle(
                    fontFamily: "merriweather",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: trackData.map((trackItem) {
                    return UserStat(date: trackItem.date, statValue: trackItem.productivityScore);
                  }).toList(),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Context Switching',
                  style: TextStyle(
                    fontFamily: "merriweather",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(enabled: true),
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= trackData.length) return const SizedBox.shrink();
                              final date = trackData[index].date;
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  DateFormat("MMM d").format(date),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: trackData.asMap().entries.map((trackItem) {

                            final index = trackItem.key.toDouble();
                            final switches = trackItem.value.taskSwitches;

                            return FlSpot(index, switches.toDouble());
                          }).toList(),
                          isCurved: true,
                          color: Color(0xFFDB863B),
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                          
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Overflow',
                  style: TextStyle(
                    fontFamily: "merriweather",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
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
                              if (index < 0 || index >= trackData.length) {
                                return const SizedBox.shrink();
                              }
                              final date = trackData[index].date;
                              return Text(
                                DateFormat("MMM d").format(date),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: trackData.asMap().entries.map((trackItem) {
                        final index = trackItem.key;
                        final track = trackItem.value;
                        
                        final overtimeHours = track.taskHours.values.reduce((a, b) => a + b) - idealHours;
                        
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: overtimeHours,
                              color: Colors.red,
                              width: 24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

class UserStat extends StatelessWidget {
  final DateTime date;
  final double statValue;
  
  const UserStat({super.key, required this.statValue, required this.date});

  @override
  Widget build(BuildContext context) {

    final List<String> textOptions = [
      "Very Low",
      "Low",
      "Average",
      "High",
      "Very high",
    ];

    final List<Color> colorOptions = [
      const Color.fromARGB(255, 233, 16, 0),
      const Color.fromARGB(255, 255, 236, 63),
      const Color.fromARGB(255, 0, 216, 7)
    ];

    Color color = Colors.red;
    if (statValue < 5) {
      color = colorOptions[0];
    } else if (statValue == 5) {
      color = colorOptions[1];
    } else {
      color = colorOptions[2];
    }


    String text = "";
    if (statValue < 3) {
      text = textOptions[0];
    } else if (statValue < 5) {
      text = textOptions[1];
    } else if (statValue == 5) {
      text = textOptions[2];
    } else if (statValue < 8) {
      text = textOptions[3];
    } else {
      text = textOptions[4];
    }

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 241, 241, 241),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 64,
                  height: statValue / 10 * 64,
                  decoration: BoxDecoration(
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 8),
        Text(
          DateFormat('MMM d').format(date),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}