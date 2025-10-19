import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF0E1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟡 Title
                Center(
                  child: Text(
                    "Welcome to Mindflow",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // 🟡 Subtitle
                Center(
                  child: Text(
                    "Your personal companion for remote work",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),

                SizedBox(height: 20),

                // 🟡 Progress bar
                LinearProgressIndicator(
                  value: 0.2,
                  color: Color(0xFFEF9C53),
                  backgroundColor: Colors.grey[200],
                ),

                SizedBox(height: 30),

                // 🟢 Heart icon
                Center(
                  child: Icon(Icons.favorite, color: Color(0xFFEF9C53), size: 80),
                ),

                SizedBox(height: 30),

                Center(
                  child: Text(
                      "Track your mental wellness",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)
                  ),
                ),



                // 🟢 Description text
                Center(
                child: Text(
                  "Mindflow helps remote workers to monitor their mental health cycles, energy levels, and productivity to prevent burnout and maintain sustainable work practices.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                ),

                SizedBox(height: 40),

                // 🟢 Continue button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/tellus');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF9C53),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Continue",
                        style: TextStyle(
                            fontSize: 16,
                        color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
