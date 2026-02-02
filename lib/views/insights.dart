import 'package:flutter/material.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/view-models/check_in_view_model.dart';
import 'package:mindflow/view-models/home_nav_view_model.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class InsightsPage extends StatefulWidget {
  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckInViewModel>.value(
      value: locator<CheckInViewModel>(),
      child: Consumer<CheckInViewModel>(
        builder: (context, model, child) {
          double productivityLevel =
              locator<CheckInViewModel>().weeklyInsights!.avgProductivity;
          double workLifeBalanceLevel =
              locator<CheckInViewModel>().weeklyInsights!.avgWorkLifeBalance;
          double isolationLevel =
              locator<CheckInViewModel>().weeklyInsights!.avgIsolation;
          double energyLevel =
              locator<CheckInViewModel>().weeklyInsights!.avgEnergy;
          return Scaffold(
            backgroundColor: Color(0xFFFFF3E9),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Assess your progress',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      "Your Focus Areas",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Productivity Card
                    if (locator<UserViewModel>().user.productivity == true)
                      _buildFocusCard(
                        context: context,
                        title: "Productivity",
                        color: productivityLevel > 0.7
                            ? Colors.green
                            : productivityLevel > 0.4
                            ? Colors.yellow
                            : Colors.redAccent,
                        percent: productivityLevel,
                        description:
                            "Over the past 7 days, you have had a productivity score of ${(productivityLevel * 100).toStringAsFixed(0)}%",
                        footer:
                            productivityLevel >= 0.5 || productivityLevel == 0
                            ? "No actions recommended"
                            : "Check out these resources to improve your productivity",
                      ),

                    const SizedBox(height: 16),

                    // Work/Life Balance
                    if (locator<UserViewModel>().user.balance == true)
                      _buildFocusCard(
                        context: context,
                        title: "Work/Life Balance",
                        color: workLifeBalanceLevel > 0.7
                            ? Colors.green
                            : workLifeBalanceLevel > 0.4
                            ? Colors.yellow
                            : Colors.redAccent,
                        percent: workLifeBalanceLevel,
                        description:
                            locator<CheckInViewModel>()
                                    .weeklyInsights!
                                    .totalOvertimeHours >
                                0
                            ? "Over the past 7 days, you’ve worked ${locator<CheckInViewModel>().weeklyInsights?.totalOvertimeHours} hours overtime"
                            : "Over the past 7 days, you have had a Work/Life Balance score of ${(workLifeBalanceLevel * 100).toStringAsFixed(0)}%",
                        footer:
                            workLifeBalanceLevel >= 0.5 ||
                                workLifeBalanceLevel == 0
                            ? "No actions recommended"
                            : "Check out these tricks for managing working hours",
                        showArrow: true,
                      ),

                    const SizedBox(height: 16),

                    // Isolation
                    if (locator<UserViewModel>().user.isolation == true)
                      _buildFocusCard(
                        context: context,
                        title: "Isolation",
                        color: isolationLevel > 0.7
                            ? Colors.green
                            : isolationLevel > 0.4
                            ? Colors.yellow
                            : Colors.redAccent,
                        percent: isolationLevel,
                        description:
                            "Over the past 7 days, you have had an Isolation score of ${(isolationLevel * 100).toStringAsFixed(0)}%",
                        footer: isolationLevel >= 0.5 || isolationLevel == 0
                            ? "No actions recommended"
                            : "Read about how to improve that when working from home.",
                        showArrow: true,
                      ),

                    const SizedBox(height: 16),

                    // Energy
                    if (locator<UserViewModel>().user.energy == true)
                      _buildFocusCard(
                        context: context,
                        title: "Energy",
                        color: energyLevel > 0.7
                            ? Colors.green
                            : energyLevel > 0.4
                            ? Colors.yellow
                            : Colors.redAccent,
                        percent: energyLevel,
                        description:
                            "Over the past 7 days, you have had an energy score of ${(energyLevel * 100).toStringAsFixed(0)}%",
                        footer: energyLevel >= 0.5 || energyLevel == 0
                            ? "No actions recommended"
                            : "If you feel you need to, check out some additional resources on how you can improve this",
                        showArrow: false,
                      ),

                    const SizedBox(height: 24),
                    const Text(
                      "Other fields",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Productivity Card
                    if (locator<UserViewModel>().user.productivity != true)
                      _buildFocusCard(
                        context: context,
                        title: "Productivity",
                        color: productivityLevel > 0.7
                            ? Colors.green
                            : productivityLevel > 0.4
                            ? Colors.yellow
                            : Colors.redAccent,
                        percent: productivityLevel,
                        description:
                            "Over the past 7 days, you have had a productivity score of ${(productivityLevel * 100).toStringAsFixed(0)}%",
                        footer:
                            productivityLevel >= 0.7 || productivityLevel == 0
                            ? "No actions recommended"
                            : productivityLevel >= 0.5
                            ? "No actions recommended. Resources are available"
                            : "Check out these resources to improve your productivity",
                      ),

                    const SizedBox(height: 16),

                    // Work/Life Balance
                    if (locator<UserViewModel>().user.balance != true)
                      _buildFocusCard(
                        context: context,
                        title: "Work/Life Balance",
                        color: workLifeBalanceLevel > 0.7
                            ? Colors.green
                            : workLifeBalanceLevel > 0.4
                            ? Colors.yellow
                            : Colors.redAccent,
                        percent: workLifeBalanceLevel,
                        description:
                            locator<CheckInViewModel>()
                                    .weeklyInsights!
                                    .totalOvertimeHours >
                                0
                            ? "Over the past 7 days, you’ve worked ${locator<CheckInViewModel>().weeklyInsights?.totalOvertimeHours} hours overtime"
                            : "Over the past 7 days, you have had a Work/Life Balance score of ${(workLifeBalanceLevel * 100).toStringAsFixed(0)}%",
                        footer:
                            workLifeBalanceLevel >= 0.7 ||
                                workLifeBalanceLevel == 0
                            ? "No actions recommended"
                            : workLifeBalanceLevel >= 0.5
                            ? "No actions recommended. Resources are available"
                            : "Check out these tricks for managing working hours",
                        showArrow: true,
                      ),

                    const SizedBox(height: 16),

                    // Isolation
                    if (locator<UserViewModel>().user.isolation != true)
                      _buildFocusCard(
                        context: context,
                        title: "Isolation",
                        color: isolationLevel > 0.7
                            ? Colors.green
                            : isolationLevel > 0.4
                            ? Colors.yellow
                            : Colors.redAccent,
                        percent: isolationLevel,
                        description:
                            "Over the past 7 days, you have had an Isolation score of ${(isolationLevel * 100).toStringAsFixed(0)}%",
                        footer: isolationLevel >= 0.7 || isolationLevel == 0
                            ? "No actions recommended"
                            : isolationLevel >= 0.5
                            ? "No actions recommended. Resources are available"
                            : "Read about how to improve that when working from home.",
                        showArrow: true,
                      ),

                    const SizedBox(height: 16),

                    // Energy
                    if (locator<UserViewModel>().user.energy != true)
                      _buildFocusCard(
                        context: context,
                        title: "Energy",
                        color: energyLevel > 0.7
                            ? Colors.green
                            : energyLevel > 0.4
                            ? Colors.yellow
                            : Colors.redAccent,
                        percent: energyLevel,
                        description:
                            "Over the past 7 days, you have had an energy score of ${(energyLevel * 100).toStringAsFixed(0)}%",
                        footer: energyLevel >= 0.7 || energyLevel == 0
                            ? "No actions recommended"
                            : energyLevel >= 0.5
                            ? "No actions recommended. Resources are available"
                            : "If you feel you need to, check out some additional resources on how you can improve this",
                        showArrow: false,
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFocusCard({
    required BuildContext context,
    required String title,
    required Color color,
    required double percent,
    required String description,
    required String footer,
    bool showArrow = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (percent < 0.7) {
          locator<HomeNavViewModel>().setCurrentIndex(3);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: percent > 0.7 ? Colors.blueAccent : Colors.transparent,
            width: percent > 0.7 ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircularPercentIndicator(
              radius: 30.0,
              lineWidth: 8.0,
              percent: percent,
              progressColor: color,
              backgroundColor: Colors.grey.shade200,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (percent < 0.7) const Spacer(),
                      if (percent < 0.7)
                        const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    percent == 0
                        ? "More data needed before we can provide insights"
                        : description,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    footer,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
