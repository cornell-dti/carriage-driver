import 'package:flutter/material.dart';
import 'Home.dart';
import 'Login.dart';
import 'Upcoming.dart';
import 'CurrentRide.dart';
import 'Schedule.dart';
import 'BottomMenu.dart';
import 'Map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carriage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Carriage'))
      ),
    );
  }
}