import 'package:carriage/pages/RideHistory.dart';
import 'package:flutter/material.dart';
import '../utils/LocationTracker.dart';
import 'Rides.dart';
import 'Profile.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/app_config.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../utils/NotificationService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int RIDES = 0;
  static const int HISTORY = 1;
  static const int PROFILE = 2;

  int _selectedIndex = RIDES;

  @override
  void initState() {
    super.initState();
    LocationTracker.initialize();
  }

  Future<void> onSelectNotification(String payload) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    return Future<void>.value();
  }

  subscribe(String token) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authToken = await authProvider.secureStorage.read(key: 'token');
    final response = await http.post(
      Uri.parse("${AppConfig.of(context).baseUrl}/notification/subscribe"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },
      body: jsonEncode(<String, String>{
        'userId': authProvider.id,
        'userType': 'Driver',
        'platform': 'android',
        'token': token,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to subscribe.');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getPage(BuildContext context, int index) {
    switch (index) {
      case (RIDES):
        return Rides(interactive: true);
      case (HISTORY):
        return RideHistory();
      case (PROFILE):
        return Profile();
      default:
        return Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: getPage(context, _selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_car, size: 20), label: 'Rides'),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule, size: 20), label: 'History'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 20), label: 'Profile')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
