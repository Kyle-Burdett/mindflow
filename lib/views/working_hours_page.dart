import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/models/check-in.dart';
import 'package:mindflow/view-models/check_in_view_model.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

class TimeSlot {
  TimeOfDay start;
  TimeOfDay end;

  TimeSlot({required this.start, required this.end});
}

class Activity {
  String id;
  String name;
  Color color;
  Color bgColor;
  List<TimeSlot> timeSlots;

  Activity({
    required this.id,
    required this.name,
    required this.color,
    required this.bgColor,
    required this.timeSlots,
  });
}



class WorkingHoursPage extends StatefulWidget {

  const WorkingHoursPage({super.key});

  @override
  State<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends State<WorkingHoursPage> {
  // Colors to differentiate between tasks
  final colors = [
    Colors.blue.shade400,
      Colors.green.shade400,
      Colors.deepPurple.shade400,
      Colors.red.shade400,
      Colors.pink.shade400,
      Colors.indigo.shade400,
      Colors.orange.shade400,
      Colors.amber.shade400,
      Colors.cyan.shade400,
      Colors.brown.shade400,
      Colors.teal.shade400,
      Colors.yellow.shade400,
      Colors.lime.shade400,
      Colors.blueAccent.shade400,
      Colors.greenAccent.shade400,
      Colors.redAccent.shade400,
      Colors.deepPurpleAccent.shade400,
      Colors.tealAccent.shade400,
      Colors.pinkAccent.shade400,
      Colors.orangeAccent.shade400,
  ];

  final bgColors = [
    Colors.blue.shade200,
      Colors.green.shade200,
      Colors.deepPurple.shade200,
      Colors.red.shade200,
      Colors.pink.shade200,
      Colors.indigo.shade200,
      Colors.orange.shade200,
      Colors.amber.shade200,
      Colors.cyan.shade200,
      Colors.brown.shade200,
      Colors.teal.shade200,
      Colors.yellow.shade200,
      Colors.lime.shade200,
      Colors.blueAccent.shade200,
      Colors.greenAccent.shade200,
      Colors.redAccent.shade200,
      Colors.deepPurpleAccent.shade200,
      Colors.tealAccent.shade200,
      Colors.pinkAccent.shade200,
      Colors.orangeAccent.shade200,
  ];

  // Default tasks when no activities have been added yet.
  List<Activity> activities = [
    Activity(
      id: "1",
      name: "Project 1",
      color: Colors.red.shade400,
      bgColor: Colors.red.shade200,
      timeSlots: [
        TimeSlot(start: const TimeOfDay(hour: 10, minute: 0), end: const TimeOfDay(hour: 13, minute: 0))
      ],
    ),
    Activity(
      id: "2",
      name: "Meeting",
      color: Colors.green.shade400,
      bgColor: Colors.green.shade200,
      timeSlots: [
        TimeSlot(start: const TimeOfDay(hour: 13, minute: 0), end: const TimeOfDay(hour: 14, minute: 0)),
        TimeSlot(start: const TimeOfDay(hour: 16, minute: 0), end: const TimeOfDay(hour: 18, minute: 0)),
      ],
    ),
    Activity(
      id: "3",
      name: "Project 2",
      color: Colors.blue.shade400,
      bgColor: Colors.blue.shade200,
      timeSlots: [
        TimeSlot(start: const TimeOfDay(hour: 14, minute: 0), end: const TimeOfDay(hour: 16, minute: 0))
      ],
    ),
  ];

  void _updateActivityTimeSlot(String activityId, int slotIndex, String field, TimeOfDay value) {
    setState(() {
      final activity = activities.firstWhere((a) => a.id == activityId);
      if (field == 'start') {
        activity.timeSlots[slotIndex].start = value;
      } else {
        activity.timeSlots[slotIndex].end = value;
      }
    });
  }

  void _removeTimeSlot(String activityId, int slotIndex) {
    setState(() {
      final activity = activities.firstWhere((a) => a.id == activityId);
      activity.timeSlots.removeAt(slotIndex);
    });
  }

  void _addTimeSlot(String activityId) {
    setState(() {
      final activity = activities.firstWhere((a) => a.id == activityId);
      activity.timeSlots.add(TimeSlot(
        start: const TimeOfDay(hour: 9, minute: 0),
        end: const TimeOfDay(hour: 10, minute: 0),
      ));
    });
  }

  void _addNewActivity() {
    setState(() {
      activities.add(
        Activity(
          id: DateTime.now().toString(),
          name: "New Task",
          color: activities.length >= 20 ? colors[0] : colors[activities.length],
          bgColor: activities.length >= 20 ? bgColors[0] : bgColors[activities.length],
          timeSlots: [TimeSlot(start: const TimeOfDay(hour: 9, minute: 0), end: const TimeOfDay(hour: 10, minute: 0))],
        ),
      );
    });
  }

  void _deleteActivity(String activityId) {
    setState(() {
      activities.removeWhere((activity) => activity.id == activityId);
    });
  }

  void _updateActivityName(String activityId, String newName) {
    setState(() {
      final activity = activities.firstWhere((a) => a.id == activityId);
      activity.name = newName;
    });
  }

  DateTime getStandardTime(TimeOfDay time) {
    return DateTime(2000, 1, 1, time.hour, time.minute);
  }

  Map<String, List<TimeRange>> mapActivitiesToTaskHours(
    List<Activity> activities) {
  Map<String, List<TimeRange>> taskHours = {};

  for (var activity in activities) {
    taskHours[activity.name] = activity.timeSlots.map((slot) {
      DateTime start = getStandardTime(slot.start);
      DateTime end = getStandardTime(slot.end);
      return TimeRange(start: start, end: end);
    }).toList();
  }

  return taskHours;
}

List<Activity> mapTaskHoursToActivities(Map<String, List<TimeRange>> taskHours, List<Color> colors) {
  List<Activity> activities = [];
  int counter = 1;

  taskHours.forEach((taskName, ranges) {
    List<TimeSlot> timeSlots = ranges.map((range) {
      return TimeSlot(
        start: TimeOfDay(hour: range.start.hour, minute: range.start.minute),
        end: TimeOfDay(hour: range.end.hour, minute: range.end.minute),
      );
    }).toList();

    final color = colors[(counter - 1) % colors.length];
    final bgColor = color.withValues(alpha: 0.2);

    activities.add(
      Activity(
        id: counter.toString(),
        name: taskName,
        color: color,
        bgColor: bgColor,
        timeSlots: timeSlots,
      ),
    );

    counter++;
  });

  return activities;
}

  void _saveAndExit() {
    locator<CheckInViewModel>().setCheckInHours(mapActivitiesToTaskHours(activities));
    context.pop();
  }

  double _getTimelineHeight() {
    const double hourHeight = 60.0;
    final startHour = TimeOfDay.fromDateTime(locator<UserViewModel>().user.startTime!);
    final endHour = TimeOfDay.fromDateTime(locator<UserViewModel>().user.endTime!);

    TimeOfDay earliestTime = startHour;
    TimeOfDay latestTime = endHour;

    final allRanges = activities.expand((a) => a.timeSlots).toList();

    if (allRanges.isNotEmpty) {
      final earliest = allRanges.map((r) => r.start).reduce((a, b) => a.isBefore(b) ? a : b);
      final latest = allRanges.map((r) => r.end).reduce((a, b) => a.isAfter(b) ? a : b);

      final mockEarliestTime = earliest;
      final mockLatestTime = latest;

      if (startHour.isAfter(mockEarliestTime)) {
        earliestTime = mockEarliestTime;
      }

      if (endHour.isBefore(mockLatestTime)) {
        latestTime = mockLatestTime;
      }
    }
    
    final totalHoursToDisplay = (latestTime.hour - earliestTime.hour);

    return (totalHoursToDisplay + 1) * hourHeight + 32;
  }

  @override
  void initState() {
    if (locator<CheckInViewModel>().currentDailyCheckIn.taskHours.isNotEmpty) {
      activities = mapTaskHoursToActivities(locator<CheckInViewModel>().currentDailyCheckIn.taskHours, colors);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    const Color pageBackgroundColor = Color(0xFFFFF3E9);

    return ChangeNotifierProvider<CheckInViewModel>.value(
      value: locator<CheckInViewModel>(),
      child: Consumer<CheckInViewModel>(
      builder: (context, model, child) => Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),

          onPressed: _saveAndExit,
        ),
        title: const Text('Update your hours'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  const SizedBox(height: 8),
                  const Text(
                    'How did your day go compared to your planned working hours?',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),


                  SizedBox(
                    height: _getTimelineHeight(),
                    child: TimelineView(activities: activities),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: activities.map((activity) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ActivityCard(
                            activity: activity,
                            onUpdateTimeSlot: _updateActivityTimeSlot,
                            onRemoveTimeSlot: _removeTimeSlot,
                            onAddTimeSlot: _addTimeSlot,
                            onDeleteActivity: _deleteActivity,
                            onUpdateActivityName: _updateActivityName,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 24,
            child: FloatingActionButton(
              onPressed: _addNewActivity,
              backgroundColor: Colors.orange.shade300,
              foregroundColor: Colors.black,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    )));
  }
}



class TimelineView extends StatelessWidget {
  final List<Activity> activities;

  const TimelineView({super.key, required this.activities});

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  String _formatHour(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    const double hourHeight = 60.0;
    final startHour = TimeOfDay.fromDateTime(locator<UserViewModel>().user.startTime!);
    final endHour = TimeOfDay.fromDateTime(locator<UserViewModel>().user.endTime!);

    TimeOfDay earliestTime = startHour;
    TimeOfDay latestTime = endHour;

    final allRanges = activities.expand((a) => a.timeSlots).toList();

    if (allRanges.isNotEmpty) {
      final earliest = allRanges.map((r) => r.start).reduce((a, b) => a.isBefore(b) ? a : b);
      final latest = allRanges.map((r) => r.end).reduce((a, b) => a.isAfter(b) ? a : b);

      final mockEarliestTime = earliest;
      final mockLatestTime = latest;

      if (startHour.isAfter(mockEarliestTime)) {
        earliestTime = mockEarliestTime;
      }

      if (endHour.isBefore(mockLatestTime)) {
        latestTime = mockLatestTime;
      }
    }

    final totalHoursToDisplay = (latestTime.hour - earliestTime.hour);

    final hoursToDisplay = List.generate(totalHoursToDisplay + 1, (index) {
      return TimeOfDay(hour: earliestTime.hour + index, minute: 0);
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row( // Use Row to separate the time labels and the timeline content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 80, // Fixed width for the time column
            child: Column(
              children: hoursToDisplay.map((hour) {
                return SizedBox(
                  height: hourHeight,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        _formatHour(hour),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),


          Expanded(
            child: Stack(
              children: [

                Column(
                  children: hoursToDisplay.map((_) {
                    return SizedBox(
                      height: hourHeight,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Divider(color: Colors.grey.shade300, thickness: 1),
                      ),
                    );
                  }).toList(),
                ),


                Positioned(
                  left: 30,
                  top: ((_timeToMinutes(startHour) - _timeToMinutes(startHour)) / 60) * hourHeight,
                  height: ((_timeToMinutes(endHour) - _timeToMinutes(startHour)) / 60) * hourHeight,
                  child: Container(
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),


                Positioned(
                  left: 55,
                  top: ((_timeToMinutes(const TimeOfDay(hour: 11, minute: 30)) - _timeToMinutes(earliestTime)) / 60) * hourHeight,
                  child: const Text(
                    'Planned\nworking hours',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),


                ...activities.expand((activity) {
                  return activity.timeSlots.map((slot) {
                    final startMinutes = _timeToMinutes(slot.start);
                    final endMinutes = _timeToMinutes(slot.end);
                    final baseMinutes = _timeToMinutes(earliestTime);

                    final top = ((startMinutes - baseMinutes) / 60) * hourHeight;
                    final height = ((endMinutes - startMinutes) / 60) * hourHeight;


                    if (height <= 0) return Container();



                    const double barWidth = 16.0;
                    const double rightPadding = 16.0;

                    return Positioned.fill(
                      top: top,
                      bottom: (totalHoursToDisplay * hourHeight) - (top + height),
                      child: LayoutBuilder(
                          builder: (context, constraints) {
                            final barLeft = constraints.maxWidth - barWidth - rightPadding;
                            final labelRight = barLeft - 8;

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Activity Bar
                                Positioned(
                                  left: barLeft,
                                  top: 0,
                                  height: height,
                                  child: Container(
                                    width: barWidth,
                                    decoration: BoxDecoration(
                                      color: activity.color,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                // Activity Label
                                Positioned(
                                  right: constraints.maxWidth - labelRight,
                                  top: (height / 2) - (10), // Center vertically
                                  child: Text(
                                    activity.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                    );
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class ActivityCard extends StatefulWidget {
  final Activity activity;
  final Function(String, int, String, TimeOfDay) onUpdateTimeSlot;
  final Function(String, int) onRemoveTimeSlot;
  final Function(String) onAddTimeSlot;
  final Function(String) onDeleteActivity;
  final Function(String, String) onUpdateActivityName;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onUpdateTimeSlot,
    required this.onRemoveTimeSlot,
    required this.onAddTimeSlot,
    required this.onDeleteActivity,
    required this.onUpdateActivityName,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool isExpanded = true;
  bool isEditingName = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.activity.name);
  }

  @override
  void didUpdateWidget(covariant ActivityCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activity.name != _nameController.text) {
      _nameController.text = widget.activity.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void handleNameEdit() {
    if (isEditingName) {
      widget.onUpdateActivityName(widget.activity.id, _nameController.text);
    }
    setState(() {
      isEditingName = !isEditingName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.activity.bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isEditingName)
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1))
                          ),
                          onSubmitted: (value) => handleNameEdit(),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.activity.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.activity.name,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    IconButton(
                      icon: Icon(isEditingName ? Icons.check : Icons.edit, size: 16),
                      onPressed: handleNameEdit,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onDeleteActivity(widget.activity.id),
                    ),
                    IconButton(
                      icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () => setState(() => isExpanded = !isExpanded),
                    ),
                  ],
                ),
              ],
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    ...widget.activity.timeSlots.asMap().entries.map((entry) {
                      final index = entry.key;
                      final slot = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Start', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                  TimePicker(
                                    initialTime: slot.start,
                                    onTimeSelected: (time) => widget.onUpdateTimeSlot(widget.activity.id, index, 'start', time),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('End', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                  TimePicker(
                                    initialTime: slot.end,
                                    onTimeSelected: (time) => widget.onUpdateTimeSlot(widget.activity.id, index, 'end', time),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => widget.onRemoveTimeSlot(widget.activity.id, index),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add time slot'),
                      onPressed: () => widget.onAddTimeSlot(widget.activity.id),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class TimePicker extends StatelessWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (newTime != null) {
      onTimeSelected(newTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showTimePicker(context),
      child: Text(MaterialLocalizations.of(context).formatTimeOfDay(initialTime, alwaysUse24HourFormat: false)),
    );
  }
}