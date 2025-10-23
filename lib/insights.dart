import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/view-models/check_in_view_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class InsightsPage extends StatelessWidget {
  // Example data — these would come from your backend in real use.
  final double productivityLevel = 0.9; // 90%
  final double workLifeBalanceLevel = 0.3; // 30%
  final double isolationLevel = 0.4; // 40%
  final double energyLevel = 0.6; // 60%

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckInViewModel>.value(
      value: locator<CheckInViewModel>(),
      child: Consumer<CheckInViewModel>(
      builder: (context, model, child) => Scaffold(
      backgroundColor: Color(0xFFFFF3E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Assess your progress',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Productivity Card
              _buildFocusCard(
                context: context,
                title: "Productivity",
                color: Colors.green,
                percent: productivityLevel,
                description:
                    "Over the past 7 days, you have had excellent productivity levels",
                footer: "No actions recommended",
              ),

              const SizedBox(height: 16),

              // Work/Life Balance
              _buildFocusCard(
                context: context,
                title: "Work/Life Balance",
                color: Colors.redAccent,
                percent: workLifeBalanceLevel,
                description:
                    "Over the past 7 days, you’ve worked an average of 2 hours extra per day than you planned",
                footer: "Check out these tricks for managing working hours",
                showArrow: true,
              ),

              const SizedBox(height: 24),
              const Text(
                "Other fields",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Isolation
              _buildFocusCard(
                context: context,
                title: "Isolation",
                color: Colors.blueAccent,
                percent: isolationLevel,
                description:
                    "Over the past 7 days, you’ve mentioned being isolated 4 times",
                footer:
                    "Read about how to improve that when working from home.",
                showArrow: true,
              ),

              const SizedBox(height: 16),

              // Energy
              _buildFocusCard(
                context: context,
                title: "Energy",
                color: Colors.yellow.shade600,
                percent: energyLevel,
                description:
                    "You’ve had moderate energy levels over the past week",
                footer:
                    "If you feel you need to, check out some additional resources on how you can improve this",
                showArrow: false,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    )));
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
        if (percent < 0.4) {
          context.go('/home-second');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: title == "Productivity" ? Colors.blueAccent : Colors.transparent,
            width: title == "Productivity" ? 2 : 0,
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
                      Text(title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      if (showArrow)
                        const Spacer(),
                      if (showArrow)
                        const Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(description,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black87)),
                  const SizedBox(height: 6),
                  Text(footer,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
