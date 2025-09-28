import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  bool pressed = false;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Assess Your Progress",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF834747),
            ),
            ),
        ),
        leading: Text("Left"),
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () {
            setState(() => pressed = !pressed,);
          },),
        ],
        
      ),
      body: Center(child: Text(pressed ? "Pressed!" : "Not yet"),),
      floatingActionButton: GestureDetector(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        ),
      ),
    );
  }
}