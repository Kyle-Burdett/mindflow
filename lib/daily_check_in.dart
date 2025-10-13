
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import 'settings_page.dart';
import 'working_hours_page.dart';


class DailyCheckIn extends StatefulWidget {

  const DailyCheckIn({Key? key}) : super(key: key);

  @override
  State<DailyCheckIn> createState() => _DailyCheckInState();
}


class _DailyCheckInState extends State<DailyCheckIn> {
  int _selectedIndex = 0;


  static const int _settingsIndex = 4;


  final UserData _mockUser = UserData(
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
  );

  final Map<String, dynamic> _checkInData = {
    'moodScore': 7.0,
    'energyScore': 7.0,
    'stressScore': 3.0,
    'productivityScore': 7.0,
    'notes': '',
    'selectedTags': <String>[],

    'workTasks': <Map<String, String>>[],
  };


  final List<String> availableTags = [
    "Focused", "Distracted", "Motivated", "Tired", "Productive", "Overwhelmed",
    "Calm", "Anxious", "Creative", "Blocked", "Collaborative", "Isolated",
    "Energetic", "Drained", "Satisfied", "Frustrated",
  ];


  final Color customAccentColor = const Color(0xFFEF9C53);

  void _handleTagToggle(String tag) {
    setState(() {
      if (_checkInData['selectedTags'].contains(tag)) {
        _checkInData['selectedTags'].remove(tag);
      } else {
        _checkInData['selectedTags'].add(tag);
      }
    });
  }


  void _handleSubmit() {

    debugPrint("Check-in data: $_checkInData");
  }


  void _onItemTapped(int index) {
    if (index == _settingsIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(

          builder: (context) => SettingsPage(),
        ),
      );
    } else {

      setState(() {
        _selectedIndex = index;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFFFDBBB),
      appBar: AppBar(

        backgroundColor: const Color(0xFFFFDBBB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Daily Check-in'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [


              _buildScoreCard(
                title: 'How are you feeling?',
                description: 'Rate your current state on a scale of 1-10',
                children: [
                  _buildSlider(
                    label: 'Mood',
                    value: _checkInData['moodScore'],
                    onChanged: (value) => setState(() => _checkInData['moodScore'] = value),
                    min: 1,
                    max: 10,
                    startLabel: 'Very Low',
                    endLabel: 'Excellent',
                  ),
                  _buildSlider(
                    label: 'Energy Level',
                    value: _checkInData['energyScore'],
                    onChanged: (value) => setState(() => _checkInData['energyScore'] = value),
                    min: 1,
                    max: 10,
                    startLabel: 'Exhausted',
                    endLabel: 'Energized',
                  ),
                  _buildSlider(
                    label: 'Stress Level',
                    value: _checkInData['stressScore'],
                    onChanged: (value) => setState(() => _checkInData['stressScore'] = value),
                    min: 1,
                    max: 10,
                    startLabel: 'Very Calm',
                    endLabel: 'Very Stressed',
                  ),
                  _buildSlider(
                    label: 'Productivity',
                    value: _checkInData['productivityScore'],
                    onChanged: (value) => setState(() => _checkInData['productivityScore'] = value),
                    min: 1,
                    max: 10,
                    startLabel: 'Unproductive',
                    endLabel: 'Very Productive',
                  ),
                ],
              ),
              const SizedBox(height: 16),


              _buildCard(
                title: 'Work Hours',
                icon: Icons.access_time,
                description: 'Track how you spent your work time today',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final List<Map<String, String>>? updatedTasks = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkingHoursPage(),
                          ),
                        );


                        if (updatedTasks != null) {
                          setState(() {
                            _checkInData['workTasks'] = updatedTasks;
                          });
                        }
                      },

                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: Text(
                        _checkInData['workTasks'].isNotEmpty
                            ? 'Edit Work Hours (${_checkInData['workTasks'].length} slots tracked)'
                            : 'Add Work Hours',
                        style: const TextStyle(color: Colors.white),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: customAccentColor,
                      ),
                    ),
                    if (_checkInData['workTasks'].isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Column(
                        children: _checkInData['workTasks'].map<Widget>((task) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text(task['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),

                                Text('${task['startTime']} - ${task['endTime']}'),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),


              _buildCard(
                title: 'How would you describe today?',
                description: 'Select tags that describe your workday',
                content: Wrap(
                  spacing: 8.0, // horizontal spacing
                  runSpacing: 8.0, // vertical spacing
                  children: availableTags.map((tag) {
                    final isSelected = _checkInData['selectedTags'].contains(tag);
                    return ActionChip(
                      label: Text(tag),
                      onPressed: () => _handleTagToggle(tag),
                      backgroundColor: isSelected ? customAccentColor : null,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),


              _buildCard(
                title: 'Additional Notes',
                description: 'Any thoughts or observations about your day?',
                content: TextField(
                  maxLines: 4,

                  cursorColor: customAccentColor,
                  decoration: InputDecoration(
                    hintText: 'How did your day go? Any challenges or wins?',
                    border: const OutlineInputBorder(),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: customAccentColor, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => _checkInData['notes'] = value,
                ),
              ),
              const SizedBox(height: 16),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: customAccentColor, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Cancel', style: TextStyle(color: customAccentColor, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: customAccentColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text('Save Check-in', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),


              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Check-in Tips',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      _buildTipPoint('Be honest with your rating - this data is for your benefit.'),
                      _buildTipPoint('Try to check in at the same time each day for consistency.'),
                      _buildTipPoint('Use the notes section to track patterns and triggers.'),
                      _buildTipPoint('Set realistic intentions that align with your energy levels.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildTipPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    String? description,
    required Widget content,
    IconData? icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) Icon(icon, size: 20, color: customAccentColor),
                if (icon != null) const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard({
    required String title,
    String? description,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
    required String startLabel,
    required String endLabel,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text('${value.toInt()}/10', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: customAccentColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(startLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(endLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}