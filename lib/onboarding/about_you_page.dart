import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindflow/core/locator.dart';
import 'package:mindflow/view-models/user_view_model.dart';
import 'package:provider/provider.dart';

class TellUsScreen extends StatefulWidget {
  @override
  _TellUsScreenState createState() => _TellUsScreenState();
}

class _TellUsScreenState extends State<TellUsScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNameEntered = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _isNameEntered = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                    "Tell us about yourself",
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
                    "Help us personalize your experience",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),

                SizedBox(height: 20),

                LinearProgressIndicator(
                  value: 0.4,
                  color: Color(0xFFEF9C53),
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(height: 50),

                Text("What is your name?", style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your first name ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
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
                      onPressed: _isNameEntered
                          ? () {
                              model.user.name = _nameController.text;
                              context.push('/onboarding/goals');
                            }
                          : null, // Disabled when no name
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isNameEntered
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
}
