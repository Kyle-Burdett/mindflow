// Imports required for Flutter UI widgets and state management.
import 'package:flutter/material.dart';

// IMPORTANT: Import the settings_page.dart file and the UserData model
import 'settings_page.dart';
import 'working_hours_page.dart';

// The main DailyCheckIn widget, which is a stateful widget to manage UI state.
class DailyCheckIn extends StatefulWidget {
  final VoidCallback onComplete;

  const DailyCheckIn({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<DailyCheckIn> createState() => _DailyCheckInState();
}

// The state class for DailyCheckIn, holding all the data and UI logic.
class _DailyCheckInState extends State<DailyCheckIn> {
  // State variable to track the selected navigation bar item.
  int _selectedIndex = 0;

  // Define the index for the Settings button (it's the 5th item, so index 4)
  static const int _settingsIndex = 4;

  // --- Mock User Data for SettingsPage ---
  // In a real app, you would fetch the current user's data from a service.
  final UserData _mockUser = UserData(
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
  );
  // ----------------------------------------

  // Data model for the check-in form.
  final Map<String, dynamic> _checkInData = {
    'moodScore': 7.0,
    'energyScore': 7.0,
    'stressScore': 3.0,
    'productivityScore': 7.0,
    'notes': '',
    'selectedTags': <String>[],
    // List of tasks, where each task is a Map<String, String> like
    // {'name': 'Project 1', 'startTime': '10:00 AM', 'endTime': '01:00 PM'}
    'workTasks': <Map<String, String>>[],
  };

  // List of available tags for the UI.
  final List<String> availableTags = [
    "Focused", "Distracted", "Motivated", "Tired", "Productive", "Overwhelmed",
    "Calm", "Anxious", "Creative", "Blocked", "Collaborative", "Isolated",
    "Energetic", "Drained", "Satisfied", "Frustrated",
  ];

  // The custom color from the hex code EF9C53.
  final Color customAccentColor = const Color(0xFFEF9C53);

  // Function to handle toggling a tag on or off.
  void _handleTagToggle(String tag) {
    setState(() {
      if (_checkInData['selectedTags'].contains(tag)) {
        _checkInData['selectedTags'].remove(tag);
      } else {
        _checkInData['selectedTags'].add(tag);
      }
    });
  }

  // Function to handle form submission.
  void _handleSubmit() {
    // This is where the data is saved.
    debugPrint("Check-in data: $_checkInData");
    widget.onComplete();
  }

  // Function to handle BottomNavigationBar item tap.
  void _onItemTapped(int index) {
    if (index == _settingsIndex) {
      // Navigate to the SettingsPage
      Navigator.push(
        context,
        MaterialPageRoute(
          // Pass the mock user data to the SettingsPage
          builder: (context) => SettingsPage(user: _mockUser),
        ),
      );
    } else {
      // For all other tabs, update the selected index (simulating tab switching)
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  // The main build method where the UI is constructed.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold background color
      backgroundColor: const Color(0xFFFFDBBB),
      appBar: AppBar(
        // AppBar background color
        backgroundColor: const Color(0xFFFFDBBB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onComplete,
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

              // Mood and energy section.
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

              // Work hours section.
              _buildCard(
                title: 'Work Hours',
                icon: Icons.access_time,
                description: 'Track how you spent your work time today',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Push to WorkingHoursPage and wait for a result (the updated tasks)
                        final List<Map<String, String>>? updatedTasks = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkingHoursPage(),
                          ),
                        );

                        // If data was returned, update the state
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
                                // Display task name
                                Text(task['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                // Display time range
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

              // Tags section.
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

              // Notes section.
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

              // Cancel and save buttons.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onComplete,
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

              // Daily Check-in Tips Section.
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
                      // A list of tips in bullet points
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
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: customAccentColor,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        // *** MODIFIED: Use the new handler that checks for the settings index ***
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }


  // Helper methods to build reusable UI components.

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
      elevation: 0, // Minimal elevation for a clean look.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) Icon(icon, size: 20, color: customAccentColor), // Change icon color
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
          // Change the active color of the slider.
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