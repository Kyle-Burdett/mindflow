import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/view-models/check_in_view_model.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

class _AppColors {
  static const card = Colors.white;
  static const accent = Color(0xFFE88D3D);
  static const accentSoft = Color(0xFFFFE1C9);
  static const textDark = Color(0xFF2B2B2B);
  static const textMid = Color(0xFF6B6B6B);
  static const divider = Color(0xFFEFE6DE);
}

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

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _AppColors.divider),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: _AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: _AppColors.textMid,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Main Screen Widget
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

// State for the Main Screen Widget
class _HomepageState extends State<Homepage> {
  DateTime today = DateTime.now();
  int weekOffset = 0;
  late DateTime selected;

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

  bool _isDateBeforeOrToday(DateTime date) {
    final now = DateTime.now();
    final aDate = DateTime(date.year, date.month, date.day);
    final bDate = DateTime(now.year, now.month, now.day);
    return aDate.isBefore(bDate) || aDate.isAtSameMomentAs(bDate);
  }

  String _two(int n) => n < 10 ? '0$n' : '$n';

  String _getTopFocusArea() {
    final insights = locator<CheckInViewModel>().weeklyInsights;
    if (insights == null || insights.avgProductivity == 0) {
      return 'Insights';
    }

    final user = locator<UserViewModel>().user;
    double maxScore = 0;
    String topArea = 'Productivity';

    if (user.productivity == true && insights.avgProductivity > maxScore) {
      maxScore = insights.avgProductivity;
      topArea = 'Productivity';
    }
    if (user.balance == true && insights.avgWorkLifeBalance > maxScore) {
      maxScore = insights.avgWorkLifeBalance;
      topArea = 'Work/Life';
    }
    if (user.isolation == true && insights.avgIsolation > maxScore) {
      maxScore = insights.avgIsolation;
      topArea = 'Isolation';
    }
    if (user.energy == true && insights.avgEnergy > maxScore) {
      maxScore = insights.avgEnergy;
      topArea = 'Energy';
    }

    return topArea;
  }

  String _getTopFocusScore() {
    final insights = locator<CheckInViewModel>().weeklyInsights;
    if (insights == null || insights.avgProductivity == 0) {
      return 'View your progress';
    }

    final user = locator<UserViewModel>().user;
    double maxScore = 0;

    if (user.productivity == true) maxScore = insights.avgProductivity;
    if (user.balance == true && insights.avgWorkLifeBalance > maxScore) {
      maxScore = insights.avgWorkLifeBalance;
    }
    if (user.isolation == true && insights.avgIsolation > maxScore) {
      maxScore = insights.avgIsolation;
    }
    if (user.energy == true && insights.avgEnergy > maxScore) {
      maxScore = insights.avgEnergy;
    }

    return 'Score: ${(maxScore * 100).toStringAsFixed(0)}%';
  }

  Color _getTopFocusColor() {
    final insights = locator<CheckInViewModel>().weeklyInsights;
    if (insights == null || insights.avgProductivity == 0) {
      return Colors.grey;
    }

    final user = locator<UserViewModel>().user;
    double maxScore = 0;

    if (user.productivity == true) maxScore = insights.avgProductivity;
    if (user.balance == true && insights.avgWorkLifeBalance > maxScore) {
      maxScore = insights.avgWorkLifeBalance;
    }
    if (user.isolation == true && insights.avgIsolation > maxScore) {
      maxScore = insights.avgIsolation;
    }
    if (user.energy == true && insights.avgEnergy > maxScore) {
      maxScore = insights.avgEnergy;
    }

    if (maxScore > 0.7) return Colors.green;
    if (maxScore > 0.4) return Colors.orange;
    return Colors.red;
  }

  String _getWorkingHoursStatus() {
    final insights = locator<CheckInViewModel>().weeklyInsights;
    if (insights == null) {
      return 'Track your hours';
    }

    if (insights.totalOvertimeHours > 0) {
      return '${insights.totalOvertimeHours.toStringAsFixed(0)}h overtime';
    }

    return 'On track';
  }

  Color _getWorkingHoursColor() {
    final insights = locator<CheckInViewModel>().weeklyInsights;
    if (insights == null) {
      return Colors.grey;
    }

    if (insights.totalOvertimeHours > 5) return Colors.red;
    if (insights.totalOvertimeHours > 0) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final start = _startOfWeek(today.add(Duration(days: 7 * weekOffset)));
    final weekDays = List.generate(7, (i) => start.add(Duration(days: i)));

    return ChangeNotifierProvider<CheckInViewModel>.value(
        value: locator<CheckInViewModel>(),
        child: Consumer<CheckInViewModel>(
            builder: (context, model, child) => Scaffold(
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 6,
                              children: weekDays.map((d) {
                                final isSelected = _isSameDay(d, selected);
                                return _DayPill(
                                  labelTop: _weekdayNameShort(d.weekday),
                                  labelBottom: '${d.day}',
                                  selected: isSelected,
                                  onTap: () => setState(() {
                                    selected = d;
                                    locator<CheckInViewModel>().currentCheckInDate = locator<CheckInViewModel>().formatDate(d);
                                    locator<CheckInViewModel>().currentDate = d;
                                  }),
                                );
                              }).toList(),
                            ),
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
                          const SizedBox(height: 16),
                          if (_isDateBeforeOrToday(selected))
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
                                child: Text(locator<CheckInViewModel>().setCheckInText()),
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
                          if (locator<CheckInViewModel>().weeklyInsights?.avgProductivity == 0 || locator<CheckInViewModel>().weeklyInsights == null)
                            const Center(child: Text("More data needed before we can provide insights", style: TextStyle(fontWeight: FontWeight.w700)),),
                          if (locator<CheckInViewModel>().weeklyInsights != null && locator<CheckInViewModel>().weeklyInsights?.avgProductivity != 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _Metric(icon: Icons.favorite_border, value: (locator<CheckInViewModel>().weeklyInsights!.avgEnergy * 10).toStringAsFixed(0), label: 'Avg Energy'),
                                _Metric(icon: Icons.adjust, value: (locator<CheckInViewModel>().weeklyInsights!.avgProductivity * 10).toStringAsFixed(0), label: 'Avg Productivity'),
                                _Metric(icon: Icons.access_time, value: locator<CheckInViewModel>().weeklyInsights!.avgTotalHours.toStringAsFixed(0), label: 'Total Hours'),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                "Wellness Dashboard",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: _AppColors.textDark),
                              ),
                            ),
                          ),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.1,
                            children: [
                              // Track Card - Daily Check-In Status
                              _DashboardCard(
                                icon: Icons.track_changes,
                                title: 'Daily Check-In',
                                subtitle: locator<CheckInViewModel>().todaysCheckInComplete()
                                    ? 'Completed Today'
                                    : 'Pending',
                                iconColor: locator<CheckInViewModel>().todaysCheckInComplete()
                                    ? Colors.green
                                    : Colors.orange,
                                onTap: () {
                                  setState(() {
                                    selected = DateTime.now();
                                    weekOffset = 0;
                                  });
                                  locator<CheckInViewModel>().currentCheckInDate = locator<CheckInViewModel>().formatDate(selected);
                                  locator<CheckInViewModel>().currentDate = selected;
                                  context.push('/check-in');
                                },
                              ),
                              // Insights Card - Top Focus Area
                              _DashboardCard(
                                icon: Icons.insights,
                                title: _getTopFocusArea(),
                                subtitle: _getTopFocusScore(),
                                iconColor: _getTopFocusColor(),
                                onTap: () {
                                  context.go('/home');
                                  // User will manually navigate to insights tab
                                },
                              ),
                              // Resources Card
                              _DashboardCard(
                                icon: Icons.library_books,
                                title: 'Resources',
                                subtitle: 'Expert wellness tips',
                                iconColor: Colors.blue,
                                onTap: () {
                                  context.go('/home-second');
                                },
                              ),
                              // Working Hours Card
                              _DashboardCard(
                                icon: Icons.schedule,
                                title: 'Working Hours',
                                subtitle: _getWorkingHoursStatus(),
                                iconColor: _getWorkingHoursColor(),
                                onTap: () {
                                  context.push('/check-in-hours');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
