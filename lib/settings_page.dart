import 'package:flutter/material.dart';

const Color _kPrimaryColor = Color(0xFFDB863B);
const Color _kBackgroundColor = Color(0xFFFFDBBB);


class UserData {
  final String? name;
  final String? email;

  UserData({this.name, this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      email: json['email'],
    );
  }
}

class AppSettings {
  String name;
  String email;

  TimeOfDay plannedStartTime;
  TimeOfDay plannedEndTime;

  bool dailyCheckInReminder;
  bool weeklyProgressReport;
  bool achievementNotifications;
  TimeOfDay reminderTime;

  double targetMoodScore;
  double targetProductivityScore;
  double maxStressLevel;
  double targetWorkHours;

  List<String> focusAreas;

  AppSettings({
    required this.name,
    required this.email,
    required this.plannedStartTime,
    required this.plannedEndTime,
    required this.dailyCheckInReminder,
    required this.weeklyProgressReport,
    required this.achievementNotifications,
    required this.reminderTime,
    required this.targetMoodScore,
    required this.targetProductivityScore,
    required this.maxStressLevel,
    required this.targetWorkHours,
    required this.focusAreas,
  });

  AppSettings copyWith({
    String? name,
    String? email,
    TimeOfDay? plannedStartTime,
    TimeOfDay? plannedEndTime,
    bool? dailyCheckInReminder,
    bool? weeklyProgressReport,
    bool? achievementNotifications,
    TimeOfDay? reminderTime,
    double? targetMoodScore,
    double? targetProductivityScore,
    double? maxStressLevel,
    double? targetWorkHours,
    List<String>? focusAreas,
  }) {
    return AppSettings(
      name: name ?? this.name,
      email: email ?? this.email,
      plannedStartTime: plannedStartTime ?? this.plannedStartTime,
      plannedEndTime: plannedEndTime ?? this.plannedEndTime,
      dailyCheckInReminder: dailyCheckInReminder ?? this.dailyCheckInReminder,
      weeklyProgressReport: weeklyProgressReport ?? this.weeklyProgressReport,
      achievementNotifications:
      achievementNotifications ?? this.achievementNotifications,
      reminderTime: reminderTime ?? this.reminderTime,
      targetMoodScore: targetMoodScore ?? this.targetMoodScore,
      targetProductivityScore:
      targetProductivityScore ?? this.targetProductivityScore,
      maxStressLevel: maxStressLevel ?? this.maxStressLevel,
      targetWorkHours: targetWorkHours ?? this.targetWorkHours,
      focusAreas: focusAreas ?? this.focusAreas,
    );
  }
}


class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppSettings _settings;
  UserData user = UserData(name: "Kyle", email: "BE.2023.F1Y5D3");

  final List<Map<String, String>> _focusAreaOptions = const [
    {"id": "productivity", "label": "Improving Productivity"},
    {"id": "work-life-balance", "label": "Work/Life Balance"},
    {"id": "stress-management", "label": "Managing Stress"},
    {"id": "isolation", "label": "Dealing with Isolation"},
    {"id": "focus", "label": "Maintaining Focus"},
    {"id": "burnout-prevention", "label": "Preventing Burnout"},
  ];

  @override
  void initState() {
    super.initState();


    _settings = AppSettings(
      name: user.name ?? "",
      email: user.email ?? "",
      plannedStartTime: const TimeOfDay(hour: 8, minute: 0),
      plannedEndTime: const TimeOfDay(hour: 13, minute: 0),
      dailyCheckInReminder: true,
      weeklyProgressReport: true,
      achievementNotifications: true,
      reminderTime: const TimeOfDay(hour: 9, minute: 0),
      targetMoodScore: 7.0,
      targetProductivityScore: 8.0,
      maxStressLevel: 4.0,
      targetWorkHours: 8.0,
      focusAreas: ["productivity", "work-life-balance", "stress-management"],
    );
  }

  void _handleFocusAreaToggle(String areaId) {
    setState(() {
      if (_settings.focusAreas.contains(areaId)) {
        _settings.focusAreas.remove(areaId);
      } else {
        _settings.focusAreas.add(areaId);
      }
      _settings =
          _settings.copyWith(focusAreas: List.from(_settings.focusAreas));
    });
  }

  void _handleSave() {
    print("Settings saved: ${_settings.name}, ${_settings.email}");

  }

  void _handleBack() {
    print('Back button pressed');

  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: _kPrimaryColor,
        onPrimary: Colors.white,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _kPrimaryColor,
        selectionColor: _kPrimaryColor.withOpacity(0.4),
        selectionHandleColor: _kPrimaryColor,
      ),
    );

    return Theme(
      data: customTheme,
      child: Scaffold(
        backgroundColor: _kBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [

              _buildCustomHeader(),


              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          _buildNotificationsAndRemindersSection(context),
                          const SizedBox(height: 16),


                          _buildPlannedWorkingHoursSection(context),
                          const SizedBox(height: 16),

                          // About Section
                          _buildAboutSection(context),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildCustomHeader() {
    return Container(
      color: _kBackgroundColor,
      padding:
      const EdgeInsets.only(top: 8.0, left: 4.0, right: 16.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: const Center(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    'Customize your MindFlow wellness experience',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // ElevatedButton(
          //   onPressed: _handleSave,
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: _kPrimaryColor,
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          //   ),
          //   child: const Text('Save Changes'),
          // ),
        ],
      ),
    );
  }

  Widget _buildNotificationsAndRemindersSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications & Reminders',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage how and when you receive wellness reminders',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),

          _buildReminderRow(
            context,
            title: 'Daily Check-in Reminders',
            description:
            'Get reminded to complete your daily wellness check-in or finish working.',
            showDivider: true,
            value: _settings.dailyCheckInReminder,
            onChanged: (bool newValue) {
              setState(() {
                _settings =
                    _settings.copyWith(dailyCheckInReminder: newValue);
              });
            },
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Row(
              children: [
                const Icon(Icons.notifications, size: 24, color: _kPrimaryColor),
                const SizedBox(width: 12),
                const Text('Reminder Time',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _settings.reminderTime,
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: _kPrimaryColor,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                            timePickerTheme: _getTimePickerThemeData(),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(
                              () => _settings = _settings.copyWith(reminderTime: picked));
                    }
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _kPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _settings.reminderTime.format(context),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildReminderRow(
            context,
            title: 'Weekly Progress Reports',
            description: 'Receive weekly summaries of your wellness trends',
            showDivider: true,
            value: _settings.weeklyProgressReport,
            onChanged: (bool newValue) {
              setState(() {
                _settings =
                    _settings.copyWith(weeklyProgressReport: newValue);
              });
            },
          ),

          _buildReminderRow(
            context,
            title: 'Achievement Notification',
            description: 'Get notified when you reach wellness milestones',
            showDivider: false,
            value: _settings.achievementNotifications,
            onChanged: (bool newValue) {
              setState(() {
                _settings =
                    _settings.copyWith(achievementNotifications: newValue);
              });
            },
          ),
        ],
      ),
    );
  }


  Widget _buildReminderRow(
      BuildContext context, {
        required String title,
        required String description,
        required bool showDivider,
        required bool value,
        required ValueChanged<bool> onChanged,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(description,
                      style:
                      const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),

            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: _kPrimaryColor,
              inactiveThumbColor: Colors.grey.shade300,
              inactiveTrackColor: Colors.grey.shade400,
            ),
          ],
        ),
        if (showDivider) const Divider(height: 24, thickness: 1),
      ],
    );
  }

  Widget _buildPlannedWorkingHoursSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set your planned working hours for each day',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTimePickerBox(
                  context,
                  'Start Time',
                  _settings.plannedStartTime,
                      (time) => setState(
                          () => _settings = _settings.copyWith(plannedStartTime: time)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimePickerBox(
                  context,
                  'End Time',
                  _settings.plannedEndTime,
                      (time) => setState(
                          () => _settings = _settings.copyWith(plannedEndTime: time)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerBox(
      BuildContext context,
      String label,
      TimeOfDay currentTime,
      Function(TimeOfDay) onTimeSelected,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: currentTime,
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: _kPrimaryColor,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                    timePickerTheme: _getTimePickerThemeData(),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onTimeSelected(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentTime.format(context),
                    style: const TextStyle(fontSize: 16)),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'App Information and support',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildAboutInfoRow('Version', '1.0.0'),
          _buildAboutInfoRow('Last Updated', 'September 2025'),
          const SizedBox(height: 16),
          const Text('Contact Support',
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          const Text(
            'BE.2023.F1Y5D3@VOSSIE.NET',
            style: TextStyle(
                color: _kPrimaryColor,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }


  TimePickerThemeData _getTimePickerThemeData() {
    return TimePickerThemeData(
      hourMinuteColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? _kPrimaryColor
          : Colors.black.withOpacity(0.1)),
      hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.white : Colors.black),
      dialHandColor: _kPrimaryColor,
      dayPeriodColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected) ? _kPrimaryColor : Colors.white),
      dayPeriodBorderSide: BorderSide(
        color: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? _kPrimaryColor
            : Colors.grey.shade400),
      ),
      dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.white : _kPrimaryColor),
    );
  }


}