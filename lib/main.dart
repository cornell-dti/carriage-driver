import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'Home.dart';
import 'Login.dart';
import 'Upcoming.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0)
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carriage',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SlidingUpPanel(
        minHeight: 62.0,
        panelSnapping: false,
        panel: Upcoming(),
        body: Home(),
          borderRadius: radius
      ),
    );
  }
}