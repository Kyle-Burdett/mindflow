import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

class PlanningScreen extends StatefulWidget {
  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);

  Future<TimeOfDay?> _selectTime(BuildContext context, TimeOfDay initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    return picked;
  }

  DateTime getDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  @override
  void initState() {
    if (locator<UserViewModel>().user.startTime != null) {
      _startTime = TimeOfDay.fromDateTime(locator<UserViewModel>().user.startTime!);
    }
    if (locator<UserViewModel>().user.endTime != null) {
      _startTime = TimeOfDay.fromDateTime(locator<UserViewModel>().user.endTime!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isValidTimeRange() {
      final startMinutes = _startTime.hour * 60 + _startTime.minute;
      final endMinutes = _endTime.hour * 60 + _endTime.minute;
      return endMinutes > startMinutes;
    }

    return ChangeNotifierProvider<UserViewModel>(
      create: (_) => locator<UserViewModel>(),
      child: Consumer<UserViewModel>(
      builder: (context, model, child) => Scaffold(
      backgroundColor: Color(0xFFFFF0E1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child:Text(
          "Planning",
            style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
        SizedBox(height: 10),

       Center(

       child: Text("Set a baseline", style: TextStyle(fontSize: 18, color: Colors.black)),
           ),
        SizedBox(height: 20),

              LinearProgressIndicator(
                value: 1.0,
                color: Color(0xFFEF9C53),
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 0),

              Text("Enter your desired working hours per day: ", style: TextStyle(fontSize: 18, color: Colors.black)),
              SizedBox(height: 30),

              Row(
                children: [
                  Text("Start time", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await _selectTime(context, _startTime);
                      if (picked != null && picked != _startTime) {
                        setState(() {
                          _startTime = picked;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFEF9C53),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "${_startTime.format(context)}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("End time", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await _selectTime(context, _endTime);
                      if (picked != null && picked != _endTime) {
                        setState(() {
                          _endTime = picked;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFEF9C53),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "${_endTime.format(context)}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
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
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Back", style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: isValidTimeRange()
                        ? () {
                          model.user.startTime = getDateTime(_startTime);
                          model.user.endTime = getDateTime(_endTime);
                          model.onboardUser(context);
                        }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF9C53),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Finish",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
