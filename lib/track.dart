import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/models/track.dart';
import 'package:mindflow/view-models/check_in_view_model.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {

  String trackView = 'lastWeek';

  Map<String, Color> categoryColors = {};

  // Fetching user preferences when they start and finish work.
  final endHours = DateTime(2000, 1, 1, locator<UserViewModel>().user.endTime!.hour, locator<UserViewModel>().user.endTime!.minute);
  final startHours = DateTime(2000, 1, 1, locator<UserViewModel>().user.startTime!.hour, locator<UserViewModel>().user.startTime!.minute);

  int idealHours = 8;

  final graphColors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.pink,
      Colors.indigo,
      Colors.orange,
    ];

  List<TrackData> displayingTrackData = [];

  List<TrackData> trackDataList = locator<CheckInViewModel>().trackData;


  List<TrackData> filterByDays(List<TrackData> data, int days) {
    final now = DateTime.now();
    final filterLimit = now.subtract(Duration(days: days));
    return data.where((item) => item.date.isAfter(filterLimit)).toList();
  }

  List<TrackData> averageForMonth(List<TrackData> data) {
    if (data.isEmpty) return [];

    data.sort((a, b) => a.date.compareTo(b.date));

    final int daysPerGroup = 7;
    final List<TrackData> monthAverages = [];

    for (int i = 0; i < data.length; i += daysPerGroup) {
      final group = data.sublist(i, (i + daysPerGroup).clamp(0, data.length));

      final Map<String, double> avgTaskHours = {};
      for (final d in group) {
        d.taskHours.forEach((task, hours) {
          avgTaskHours[task] = (avgTaskHours[task] ?? 0) + hours;
        });
      }

      final avgDate = group[group.length ~/ 2].date;

      monthAverages.add(TrackData(
        avgDate,
        avgTaskHours,
        [],
        group.map((e) => e.moodScore).reduce((a, b) => a + b) / group.length,
        group.map((e) => e.productivityScore).reduce((a, b) => a + b) / group.length,
      (group.map((e) => e.taskSwitches).reduce((a, b) => a + b) / group.length).round(),
      ));
    }

    return monthAverages;
  }

  List<TrackData> groupByMonth(List<TrackData> data) {
    if (data.isEmpty) return [];

    // Sort data by date
    data.sort((a, b) => a.date.compareTo(b.date));

    // Group entries by year-month key
    final Map<String, List<TrackData>> groupedByMonth = {};
    for (final d in data) {
      final key = '${d.date.year}-${d.date.month.toString().padLeft(2, '0')}';
      groupedByMonth.putIfAbsent(key, () => []).add(d);
    }

    final List<TrackData> monthlyData = [];

    for (final entry in groupedByMonth.entries) {
      final group = entry.value;

      // Sum up total task hours for that month
      final Map<String, double> totalTaskHours = {};
      for (final d in group) {
        d.taskHours.forEach((task, hours) {
          totalTaskHours[task] = (totalTaskHours[task] ?? 0) + hours;
        });
      }

      // Average the other scores
      final avgMood = group.map((e) => e.moodScore).reduce((a, b) => a + b) / group.length;
      final avgProductivity = group.map((e) => e.productivityScore).reduce((a, b) => a + b) / group.length;
      final avgSwitches = (group.map((e) => e.taskSwitches).reduce((a, b) => a + b) / group.length).round();

      // Representative date for labeling (middle of month)
      final firstDate = group.first.date;
      final midMonthDate = DateTime(firstDate.year, firstDate.month, 15);

      monthlyData.add(TrackData(
        midMonthDate,
        totalTaskHours,
        [],
        avgMood,
        avgProductivity,
        avgSwitches,
      ));
    }

    // Ensure chronological order in the result
    monthlyData.sort((a, b) => a.date.compareTo(b.date));
    return monthlyData;
  }

  String getDateLabel(DateTime date, int index, List<TrackData> data, String trackView) {
    if (trackView == 'lastMonth') {
      final start = data[index == 0 ? 0 : index - 0].date;
      final end = start.add(const Duration(days: 6));

      final sameMonth = start.month == end.month;
      final monthLabel = DateFormat('MMM').format(start);
      final startDay = DateFormat('d').format(start);
      final endDay = DateFormat('d').format(end);

      return sameMonth
          ? '$monthLabel $startDay–$endDay'
          : '${DateFormat('MMM d').format(start)}–${DateFormat('MMM d').format(end)}';
    }

    if (trackView == 'lastThreeMonths') {
      return DateFormat('MMM').format(date);
    }

    return DateFormat('MMM d').format(date);
  }

  @override
  void initState() {
    idealHours = endHours.difference(startHours).inHours;
    displayingTrackData = filterByDays(trackDataList, 6);
    final tasks = {
      for (var d in displayingTrackData) ...d.taskHours.keys
    }.toList();

    // Mapping colors to different tasks to ensure consistency in Graph data.
    categoryColors = {
      for (int i = 0; i < tasks.length; i++)
        tasks[i]: graphColors[i % graphColors.length],
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckInViewModel>.value(
      value: locator<CheckInViewModel>(),
      child: Consumer<CheckInViewModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Color(0xFFFFF3E9),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 36),
                // Filter for different track views. (Will be last 7 days, last month, and last 3 months)
                SafeArea(
                  top: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          trackView = 'lastWeek';
                          idealHours = endHours.difference(startHours).inHours;
                          displayingTrackData = filterByDays(trackDataList, 7);
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: trackView == 'lastWeek' ? Color(0xFFDB863B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Last Week',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: trackView == 'lastWeek' ? Colors.white : Color(0xFF2E2E2E),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          trackView = 'lastMonth';
                          setState(() {
                            idealHours = endHours.difference(startHours).inHours * 5;
                            displayingTrackData = averageForMonth(trackDataList);
                          });
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: trackView == 'lastMonth' ? Color(0xFFDB863B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Last Month',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: trackView == 'lastMonth' ? Colors.white : Color(0xFF2E2E2E),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          trackView = 'lastThreeMonths';
                          idealHours = endHours.difference(startHours).inHours * 20;
                          displayingTrackData = groupByMonth(trackDataList);
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: trackView == 'lastThreeMonths' ? Color(0xFFDB863B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Last 3 Months',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: trackView == 'lastThreeMonths' ? Colors.white : Color(0xFF2E2E2E),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Hourly breakdown',
                  style: TextStyle(
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
                                    if (index < 0 || index >= displayingTrackData.length) return const SizedBox.shrink();
                                    final date = displayingTrackData[index].date;

                                    return Text(
                                      getDateLabel(date, index, displayingTrackData, trackView),
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
                            barGroups: displayingTrackData.asMap().entries.map((entry) {
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
                                    categoryColors[name] ?? graphColors[categoryColors.length + 1 % graphColors.length],
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
                    children: displayingTrackData.map((trackItem) {
                    return UserStat(date: trackItem.date, statValue: trackItem.moodScore, data: trackItem, trackView: trackView,);
                  }).toList(),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Productivity',
                  style: TextStyle(
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
                    children: displayingTrackData.map((trackItem) {
                    return UserStat(date: trackItem.date, statValue: trackItem.productivityScore, data: trackItem, trackView: trackView,);
                  }).toList(),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Context Switching',
                  style: TextStyle(
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
                            showTitles: false,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= displayingTrackData.length) return const SizedBox.shrink();
                              final date = displayingTrackData[index].date;
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
                          spots: displayingTrackData.asMap().entries.map((trackItem) {

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
                  'Overtime',
                  style: TextStyle(
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
                              if (index < 0 || index >= displayingTrackData.length) {
                                return const SizedBox.shrink();
                              }
                              final date = displayingTrackData[index].date;
                              return Text(
                                getDateLabel(date, index, displayingTrackData, trackView),
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
                      barGroups: displayingTrackData.asMap().entries.map((trackItem) {
                        final index = trackItem.key;
                        final track = trackItem.value;
                        print("Ideal hours: $idealHours");
                        double overtimeHours = track.taskHours.values.reduce((a, b) => a + b) - idealHours;
                        if (overtimeHours < 0) {
                          overtimeHours = 0;
                        }

                        
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
  final TrackData data;
  final String trackView;
  final double statValue;
  
  const UserStat({super.key, required this.statValue, required this.date, required this.data, required this.trackView});

  String getDateLabel(DateTime date, TrackData data, String trackView) {
    if (trackView == 'lastMonth') {
      final start = data.date;
      final end =  start.add(const Duration(days: 6));

      final sameMonth = start.month == end.month;
      final monthLabel = DateFormat('MMM').format(start);
      final startDay = DateFormat('d').format(start);
      final endDay = DateFormat('d').format(end);

      return sameMonth
          ? '$monthLabel $startDay–$endDay'
          : '${DateFormat('MMM d').format(start)}–${DateFormat('MMM d').format(end)}';
    }

    if (trackView == 'lastThreeMonths') {
      return DateFormat('MMM').format(date);
    }

    return DateFormat('MMM d').format(date);
  }

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
          getDateLabel(date, data, trackView),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}