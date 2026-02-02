import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

class WellnessGoalsScreen extends StatefulWidget {
  @override
  _WellnessGoalsScreenState createState() => _WellnessGoalsScreenState();
}

class _WellnessGoalsScreenState extends State<WellnessGoalsScreen> {
  bool reduceBurnout = false;
  bool improveBalance = false;
  bool monitorProductivity = false;
  bool trackEnergyLevels = false;
  bool isolation = false;
  bool buildWorkHabits = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserViewModel>.value(
      value: locator<UserViewModel>(),
      child: Consumer<UserViewModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Color(0xFFFFF0E1),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Your wellness goals",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Center(
                  child: Text(
                    "What would you like to focus on?",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),

                LinearProgressIndicator(
                  value: 0.8,
                  color: Color(0xFFEF9C53),
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(height: 30),

                Text(
                  "Select your primary goals(Select all that apply) ",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),

                SizedBox(height: 30),
                buildToggle("Improve work-life balance", improveBalance, (val) {
                  setState(() => improveBalance = val);
                }),
                buildToggle(
                  "Monitor productivity patterns",
                  monitorProductivity,
                  (val) {
                    setState(() => monitorProductivity = val);
                  },
                ),
                buildToggle("Track energy levels", trackEnergyLevels, (val) {
                  setState(() => trackEnergyLevels = val);
                }),
                buildToggle("Reduce Isolation", isolation, (val) {
                  setState(() => isolation = val);
                }),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFFEF9C53),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Back", style: TextStyle(fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (monitorProductivity ||
                            improveBalance ||
                            trackEnergyLevels ||
                            isolation) {
                          model.user.productivity = monitorProductivity;
                          model.user.balance = improveBalance;
                          model.user.energy = trackEnergyLevels;
                          model.user.isolation = isolation;
                          context.push('/onboarding/planning');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            monitorProductivity ||
                                improveBalance ||
                                trackEnergyLevels ||
                                isolation
                            ? Color(0xFFEF9C53)
                            : Color(0xFFEF9C53).withOpacity(0.5),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Color(0xFFEF9C53),
          ),
          SizedBox(width: 10),
          Expanded(child: Text(label, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
