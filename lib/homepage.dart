// lib/test.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

// --- App Colors and Utility Classes (Kept as is) ---
class _AppColors {
  // pulled to resemble your mock (peach + orange)
  static const bg = Color(0xFFF6EADF);            // page background
  static const card = Colors.white;               // cards
  static const accent = Color(0xFFE88D3D);        // orange buttons/icons
  static const accentSoft = Color(0xFFFFE1C9);    // soft orange chip
  static const textDark = Color(0xFF2B2B2B);
  static const textMid = Color(0xFF6B6B6B);
  static const divider = Color(0xFFEFE6DE);
}

// Custom Card Wrapper
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _AppColors.divider),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

// Day Pill Component
class _DayPill extends StatelessWidget {
  final String labelTop;
  final String labelBottom;
  final bool selected;
  final VoidCallback onTap;

  const _DayPill({
    required this.labelTop,
    required this.labelBottom,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? _AppColors.accentSoft : _AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? _AppColors.accent : _AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          Text(labelTop, style: const TextStyle(fontSize: 12, color: _AppColors.textMid)),
          const SizedBox(height: 4),
          Text(labelBottom,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? _AppColors.textDark : _AppColors.textDark,
              )),
        ],
      ),
    );

    return GestureDetector(onTap: onTap, child: pill);
  }
}

// Metric Component
class _Metric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _Metric({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 42, color: _AppColors.accent),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: _AppColors.textMid)),
      ],
    );
  }
}

// Main Screen Widget
class Homepage extends StatefulWidget {
  // Added onComplete to match the original main.dart usage

  // Renamed from HomePage to Homepage
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

// State for the Main Screen Widget (formerly _HomePageState)
class _HomepageState extends State<Homepage> {
  DateTime today = DateTime.now();
  int weekOffset = 0; // use arrows to move this
  late DateTime selected;

  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    selected = today;
  }

  // Start of week = Sunday
  DateTime _startOfWeek(DateTime base) {
    final s = base.subtract(Duration(days: base.weekday % 7));
    return DateTime(s.year, s.month, s.day);
  }

  String _weekdayNameShort(int weekday) {
    const names = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return names[weekday % 7];
    // DateTime.weekday: Mon=1..Sun=7; we mod 7 to map to names[0]=Sun
  }

  String _monthName(int month) {
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    return months[month - 1];
  }

  String _weekdayLong(int weekday) {
    const names = [
      'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'
    ];
    return names[weekday - 1];
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _two(int n) => n < 10 ? '0$n' : '$n';

  @override
  Widget build(BuildContext context) {
    final start = _startOfWeek(today.add(Duration(days: 7 * weekOffset)));
    final weekDays = List.generate(7, (i) => start.add(Duration(days: i)));

    return ChangeNotifierProvider<UserViewModel>(
      create: (_) => locator<UserViewModel>(),
      child: Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Greeting
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Welcome back, ${locator<UserViewModel>().user.name}!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_weekdayLong(today.weekday)}, ${_monthName(today.month)} ${today.day}, ${today.year}',
                  style: const TextStyle(color: _AppColors.textMid),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Week strip
            Container(
              decoration: BoxDecoration(
                color: _AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () => setState(() => weekOffset--),
                      ),
                      const Spacer(),
                      const Text('Today',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                        onPressed: () => setState(() => weekOffset++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekDays.map((d) {
                      final isSelected = _isSameDay(d, selected);
                      return _DayPill(
                        labelTop: _weekdayNameShort(d.weekday),
                        labelBottom: '${d.day}',
                        selected: isSelected,
                        onTap: () => setState(() => selected = d),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Analytics for date
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analytics for ${_two(selected.day)}/${_two(selected.month)}/${selected.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No wellness data recorded for this date',
                    style: TextStyle(color: _AppColors.textMid),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        context.push('/check-in');
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Add Today's Check-in"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // This Week's Analytics
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "This Week's Analytics",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _AppColors.textDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _Metric(icon: Icons.favorite_border, value: '7', label: 'Avg Stress'),
                      _Metric(icon: Icons.adjust, value: '7', label: 'Avg Productivity'),
                      _Metric(icon: Icons.access_time, value: '7', label: 'Total Hours'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // TODO: navigate to tips
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Open wellness tips")),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Wellness Tips'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}